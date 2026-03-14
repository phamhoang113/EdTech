package com.edtech.backend.auth.service.impl;

import com.edtech.backend.auth.dto.LoginRequest;
import com.edtech.backend.auth.dto.RegisterRequest;
import com.edtech.backend.auth.dto.TokenRefreshRequest;
import com.edtech.backend.auth.dto.TokenResponse;
import com.edtech.backend.auth.dto.VerifyOtpRequest;
import com.edtech.backend.auth.entity.OtpCode;
import com.edtech.backend.auth.entity.RefreshToken;
import com.edtech.backend.auth.entity.User;
import com.edtech.backend.auth.entity.UserDevice;
import com.edtech.backend.auth.repository.OtpCodeRepository;
import com.edtech.backend.auth.repository.RefreshTokenRepository;
import com.edtech.backend.auth.repository.UserDeviceRepository;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.auth.service.AuthService;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.security.jwt.JwtService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;
import java.util.Random;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final OtpCodeRepository otpCodeRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final UserDeviceRepository userDeviceRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final int LOCKOUT_EXPIRATION_MINUTES = 15;
    private static final int OTP_EXPIRATION_MINUTES = 5;

    @Override
    @Transactional
    public void register(RegisterRequest request) {
        log.info("Registering user with phone: {}", request.getPhone());
        
        if (request.getPhone() != null && userRepository.existsByPhoneAndIsDeletedFalse(request.getPhone())) {
            throw new BusinessRuleException("Phone number already exists.");
        }
        if (request.getUsername() != null && userRepository.existsByUsernameAndIsDeletedFalse(request.getUsername())) {
            throw new BusinessRuleException("Username already exists.");
        }
        if (request.getPhone() == null && request.getUsername() == null) {
            throw new BusinessRuleException("Either phone or username must be provided.");
        }

        User user = User.builder()
                .phone(request.getPhone())
                .username(request.getUsername())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .role(request.getRole())
                .isActive(false) // Needs OTP verification
                .isDeleted(false)
                .failedAttempts(0)
                .build();
        userRepository.save(user);

        if (request.getPhone() != null) {
            generateAndSendOtp(request.getPhone(), "REGISTER");
        } else {
            // For students without phone, auto-activate for now, or require parent to activate.
            user.setIsActive(true);
            userRepository.save(user);
        }
    }

    @Override
    @Transactional
    public TokenResponse verifyOtp(VerifyOtpRequest request) {
        OtpCode otp = otpCodeRepository.findTopByPhoneAndPurposeAndIsUsedFalseOrderByCreatedAtDesc(request.getPhone(), "REGISTER")
                .orElseThrow(() -> new BusinessRuleException("No active OTP found."));

        if (otp.getExpiresAt().isBefore(Instant.now())) {
            throw new BusinessRuleException("OTP has expired.");
        }

        if (!otp.getCode().equals(request.getCode())) {
            throw new BusinessRuleException("Invalid OTP code.");
        }

        // Mark OTP as used
        otp.setIsUsed(true);
        otpCodeRepository.save(otp);

        // Activate User
        User user = userRepository.findByPhoneAndIsDeletedFalse(request.getPhone())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        user.setIsActive(true);
        userRepository.save(user);

        return generateTokenResponse(user, null);
    }

    @Override
    @Transactional
    public TokenResponse login(LoginRequest request) {
        String identifier = request.getPhone() != null ? request.getPhone() : request.getUsername();
        log.info("Logging in user: {}", identifier);

        User user = userRepository.findByPhoneAndIsDeletedFalse(identifier)
                .orElseGet(() -> userRepository.findByUsernameAndIsDeletedFalse(identifier)
                        .orElseThrow(() -> new BusinessRuleException("Invalid credentials.")));

        // Check lock status
        if (user.getLockedUntil() != null && user.getLockedUntil().isAfter(Instant.now())) {
            throw new BusinessRuleException("Account is temporarily locked due to too many failed attempts.");
        }

        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(identifier, request.getPassword()));
        } catch (Exception ex) {
            // Handle failed attempt
            int newAttempts = user.getFailedAttempts() + 1;
            user.setFailedAttempts(newAttempts);
            if (newAttempts >= MAX_FAILED_ATTEMPTS) {
                user.setLockedUntil(Instant.now().plus(LOCKOUT_EXPIRATION_MINUTES, ChronoUnit.MINUTES));
            }
            userRepository.save(user);
            throw new BusinessRuleException("Invalid credentials.");
        }

        // Reset failed attempts on success
        user.setFailedAttempts(0);
        user.setLockedUntil(null);
        userRepository.save(user);

        // Handle Device FCM Token
        if (request.getFcmToken() != null && !request.getFcmToken().isBlank()) {
            saveUserDevice(user, request.getFcmToken());
        }

        return generateTokenResponse(user, null); // Provide actual Spring security user details below
    }

    @Override
    @Transactional
    public TokenResponse refreshToken(TokenRefreshRequest request) {
        RefreshToken token = refreshTokenRepository.findByTokenHash(request.getRefreshToken())
                .orElseThrow(() -> new BusinessRuleException("Invalid refresh token."));

        if (token.getExpiresAt().isBefore(Instant.now())) {
            refreshTokenRepository.delete(token);
            throw new BusinessRuleException("Refresh token has expired.");
        }

        User user = token.getUser();
        return generateTokenResponse(user, null);
    }

    private TokenResponse generateTokenResponse(User user, String fcmToken) {
        org.springframework.security.core.userdetails.User userDetails = new org.springframework.security.core.userdetails.User(
                user.getPhone() != null ? user.getPhone() : user.getUsername(),
                user.getPasswordHash(),
                java.util.Collections.emptyList() // Normally map authorities
        );

        String jwt = jwtService.generateToken(userDetails);
        String refreshTokenStr = jwtService.generateRefreshToken(userDetails);

        // Save refresh token
        RefreshToken rt = RefreshToken.builder()
                .user(user)
                .tokenHash(refreshTokenStr)
                .expiresAt(Instant.now().plusMillis(604800000)) // 7 days from JwtService
                .build();
        refreshTokenRepository.save(rt);

        return TokenResponse.builder()
                .accessToken(jwt)
                .refreshToken(refreshTokenStr)
                .role(user.getRole())
                .fullName(user.getFullName())
                .isActive(user.getIsActive())
                .build();
    }

    private void generateAndSendOtp(String phone, String purpose) {
        String code = String.format("%06d", new Random().nextInt(999999));
        OtpCode otp = OtpCode.builder()
                .phone(phone)
                .code(code)
                .purpose(purpose)
                .expiresAt(Instant.now().plus(OTP_EXPIRATION_MINUTES, ChronoUnit.MINUTES))
                .build();
        otpCodeRepository.save(otp);
        log.info("Generated OTP {} for phone {}", code, phone); // Simulate SMS send
    }

    private void saveUserDevice(User user, String fcmToken) {
        Optional<UserDevice> existing = userDeviceRepository.findByFcmToken(fcmToken);
        if (existing.isEmpty()) {
            UserDevice device = UserDevice.builder()
                    .user(user)
                    .fcmToken(fcmToken)
                    .build();
            userDeviceRepository.save(device);
        }
    }
}
