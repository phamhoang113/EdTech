package com.edtech.backend.auth.service.impl;

import com.edtech.backend.auth.dto.request.LoginRequest;
import com.edtech.backend.auth.dto.request.RegisterRequest;
import com.edtech.backend.auth.dto.request.TokenRefreshRequest;
import com.edtech.backend.auth.dto.request.VerifyOtpRequest;
import com.edtech.backend.auth.dto.response.RegisterResponse;
import com.edtech.backend.auth.dto.response.TokenResponse;
import com.edtech.backend.auth.entity.OtpCodeEntity;
import com.edtech.backend.auth.entity.RefreshTokenEntity;
import com.edtech.backend.auth.entity.UserDeviceEntity;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.OtpPurpose;
import com.edtech.backend.auth.enums.UserRole;
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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;

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

    /** Nếu không phải PRODUCTION → OTP mặc định là 123456 */
    @Value("${app.environment:development}")
    private String appEnvironment;

    // ─────────── Constants ───────────
    private static final String DEV_OTP_CODE        = "123456";
    private static final int    MAX_FAILED_ATTEMPTS  = 5;
    private static final int    LOCKOUT_MINUTES      = 15;
    private static final int    OTP_EXPIRY_MINUTES   = 5;
    private static final long   REFRESH_TOKEN_TTL_MS = 604_800_000L; // 7 days
    private static final String PROD_ENV             = "production";

    // ─────────── Auth API ───────────

    @Override
    @Transactional
    public RegisterResponse register(RegisterRequest request) {
        log.info("Registering user with phone: {}", request.getPhone());

        if (request.getPhone() != null && userRepository.existsByPhoneAndIsDeletedFalse(request.getPhone())) {
            throw new BusinessRuleException("Phone number already exists.");
        }
        if (request.getPhone() == null) {
            throw new BusinessRuleException("Phone must be provided.");
        }

        UserEntity user = UserEntity.builder()
                .phone(request.getPhone())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .role(request.getRole())
                .isActive(false)
                .isDeleted(false)
                .failedAttempts(0)
                .build();
        userRepository.save(user);

        if (request.getPhone() != null) {
            OtpCodeEntity otp = generateAndSendOtp(request.getPhone(), OtpPurpose.REGISTER);
            return RegisterResponse.builder()
                    .otpToken(otp.getOtpToken().toString())
                    .message(isProduction()
                            ? "OTP has been sent to your phone."
                            : "[DEV] OTP is " + DEV_OTP_CODE + ". otpToken: " + otp.getOtpToken())
                    .build();
        } else {
            user.setIsActive(true);
            userRepository.save(user);
            return RegisterResponse.builder()
                    .message("Account created and activated (no phone, no OTP required).")
                    .build();
        }
    }

    @Override
    @Transactional
    public TokenResponse verifyOtp(VerifyOtpRequest request) {
        OtpCodeEntity otp = otpCodeRepository.findByOtpTokenAndIsUsedFalse(UUID.fromString(request.getOtpToken()))
                .orElseThrow(() -> new BusinessRuleException("Invalid or already used OTP token."));

        if (otp.getExpiresAt().isBefore(Instant.now())) {
            throw new BusinessRuleException("OTP has expired.");
        }
        if (!otp.getCode().equals(request.getCode())) {
            throw new BusinessRuleException("Invalid OTP code.");
        }

        otp.setIsUsed(true);
        otpCodeRepository.save(otp);

        UserEntity user = userRepository.findByPhoneAndIsDeletedFalse(otp.getPhone())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        user.setIsActive(true);
        userRepository.save(user);

        return generateTokenResponse(user);
    }

    @Override
    @Transactional
    public TokenResponse login(LoginRequest request) {
        String identifier = request.getPhone();
        log.info("Logging in user: {}", identifier);

        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(identifier)
                .orElseThrow(() -> new BusinessRuleException("Invalid credentials."));

        if (user.getLockedUntil() != null && user.getLockedUntil().isAfter(Instant.now())) {
            throw new BusinessRuleException("Account is temporarily locked due to too many failed attempts.");
        }

        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(identifier, request.getPassword()));
        } catch (Exception ex) {
            int newAttempts = user.getFailedAttempts() + 1;
            user.setFailedAttempts(newAttempts);
            if (newAttempts >= MAX_FAILED_ATTEMPTS) {
                user.setLockedUntil(Instant.now().plus(LOCKOUT_MINUTES, ChronoUnit.MINUTES));
            }
            userRepository.save(user);
            throw new BusinessRuleException("Invalid credentials.");
        }

        user.setFailedAttempts(0);
        user.setLockedUntil(null);
        userRepository.save(user);

        if (request.getFcmToken() != null && !request.getFcmToken().isBlank()) {
            saveUserDevice(user, request.getFcmToken());
        }

        return generateTokenResponse(user);
    }

    @Override
    @Transactional
    public TokenResponse refreshToken(TokenRefreshRequest request) {
        RefreshTokenEntity token = refreshTokenRepository.findByTokenHash(request.getRefreshToken())
                .orElseThrow(() -> new BusinessRuleException("Invalid refresh token."));

        if (token.getExpiresAt().isBefore(Instant.now())) {
            refreshTokenRepository.delete(token);
            throw new BusinessRuleException("Refresh token has expired.");
        }

        return generateTokenResponse(token.getUser());
    }

    // ─────────── Private Helpers ───────────

    private TokenResponse generateTokenResponse(UserEntity user) {
        String subject = user.getPhone() != null ? user.getPhone() : user.getUsername();
        org.springframework.security.core.userdetails.User userDetails =
                new org.springframework.security.core.userdetails.User(
                        subject,
                        user.getPasswordHash(),
                        java.util.Collections.emptyList());

        String jwt = jwtService.generateToken(userDetails);
        String refreshTokenStr = jwtService.generateRefreshToken(userDetails);

        // Xóa refresh token cũ để tránh duplicate key constraint
        refreshTokenRepository.deleteAllByUserId(user.getId());

        RefreshTokenEntity rt = RefreshTokenEntity.builder()
                .user(user)
                .tokenHash(refreshTokenStr)
                .expiresAt(Instant.now().plusMillis(REFRESH_TOKEN_TTL_MS))
                .build();
        refreshTokenRepository.save(rt);

        return TokenResponse.builder()
                .accessToken(jwt)
                .refreshToken(refreshTokenStr)
                .role(user.getRole())
                .fullName(user.getFullName())
                .avatarBase64(user.getAvatarBase64())
                .isActive(user.getIsActive())
                .build();
    }

    /**
     * Sinh OTP, lưu DB và trả về OtpCodeEntity để lấy otpToken.
     * Non-PRODUCTION: OTP luôn là 123456 để dễ test.
     */
    private OtpCodeEntity generateAndSendOtp(String phone, OtpPurpose purpose) {
        String code = isProduction()
                ? String.format("%06d", new Random().nextInt(999_999))
                : DEV_OTP_CODE;

        OtpCodeEntity otp = OtpCodeEntity.builder()
                .phone(phone)
                .code(code)
                .purpose(purpose)
                .expiresAt(Instant.now().plus(OTP_EXPIRY_MINUTES, ChronoUnit.MINUTES))
                .build();
        otpCodeRepository.save(otp);

        if (isProduction()) {
            log.info("OTP sent via SMS to phone {}", phone);
            // TODO: Integrate SMS provider (e.g. Twilio, ESMS)
        } else {
            log.warn("[DEV] OTP for phone {} is {} (otpToken: {})", phone, code, otp.getOtpToken());
        }
        return otp;
    }

    private void saveUserDevice(UserEntity user, String fcmToken) {
        Optional<UserDeviceEntity> existing = userDeviceRepository.findByFcmToken(fcmToken);
        if (existing.isEmpty()) {
            UserDeviceEntity device = UserDeviceEntity.builder()
                    .user(user)
                    .fcmToken(fcmToken)
                    .build();
            userDeviceRepository.save(device);
        }
    }

    private boolean isProduction() {
        return PROD_ENV.equalsIgnoreCase(appEnvironment);
    }
}
