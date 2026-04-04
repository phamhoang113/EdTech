package com.edtech.backend.auth.service.impl;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.dto.request.FirebaseAuthRequest;
import com.edtech.backend.auth.dto.request.LoginRequest;
import com.edtech.backend.auth.dto.request.TokenRefreshRequest;
import com.edtech.backend.auth.dto.request.ChangePasswordRequest;
import com.edtech.backend.auth.dto.request.ForgotPasswordInitRequest;
import com.edtech.backend.auth.dto.request.ForgotPasswordResetRequest;
import com.edtech.backend.auth.dto.response.ForgotPasswordInitResponse;
import com.edtech.backend.auth.dto.response.ForgotPasswordResetResponse;
import com.edtech.backend.auth.dto.response.TokenResponse;
import com.edtech.backend.auth.entity.RefreshTokenEntity;
import com.edtech.backend.auth.entity.UserDeviceEntity;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.RefreshTokenRepository;
import com.edtech.backend.auth.repository.UserDeviceRepository;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.auth.service.AuthService;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.security.jwt.JwtService;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final UserDeviceRepository userDeviceRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    /** Nếu không phải PRODUCTION → OTP mặc định là 123456 */
    @Value("${app.environment:development}")
    private String appEnvironment;

    // ─────────── Constants ───────────
    private static final int    MAX_FAILED_ATTEMPTS  = 5;
    private static final int    LOCKOUT_MINUTES      = 15;
    private static final int    OTP_EXPIRY_MINUTES   = 5;
    private static final long   REFRESH_TOKEN_TTL_MS = 604_800_000L; // 7 days
    private static final String PROD_ENV             = "production";

    // ─────────── Auth API ───────────

    @Override
    @Transactional
    public TokenResponse verifyFirebaseAuth(FirebaseAuthRequest request) {
        try {
            String phone;
            
            // BYPASS CHO LOCAL/SIT: Cho phép dùng MOCK_TOKEN_ + số điện thoại để đăng ký mà không cần check Firebase
            if (!isProduction() && request.getIdToken() != null && request.getIdToken().startsWith("MOCK_TOKEN_")) {
                phone = request.getIdToken().substring("MOCK_TOKEN_".length());
                log.info("Bypassing Firebase Auth (Local/SIT) for mock token with phone: {}", phone);
            } else {
                FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(request.getIdToken());
                // Extract phone_number claim (usually in E.164 format like +84912345678)
                Object phoneObj = decodedToken.getClaims().get("phone_number");
                if (phoneObj == null) {
                    throw new BusinessRuleException("Không tìm thấy số điện thoại trong chứng chỉ Firebase.");
                }
                phone = phoneObj.toString();
            }
            
            // Standardize format to local VN standard for matching
            if (phone.startsWith("+84")) {
                phone = "0" + phone.substring(3);
            }

            Optional<UserEntity> userOpt = userRepository.findByPhoneAndIsDeletedFalse(phone);
            UserEntity user;

            if (userOpt.isPresent()) {
                user = userOpt.get(); // Existing user -> Login
                log.info("Firebase Auth successful for existing user: {}", phone);
            } else {
                // New User -> Register
                if (request.getPassword() == null || request.getFullName() == null || request.getRole() == null) {
                    throw new BusinessRuleException("Số điện thoại chưa đăng ký. Vui lòng cung cấp mật khẩu, Họ và tên và Quyền (role) để hoàn tất đăng ký.");
                }
                user = UserEntity.builder()
                        .phone(phone)
                        .passwordHash(passwordEncoder.encode(request.getPassword()))
                        .fullName(request.getFullName())
                        .role(request.getRole())
                        .isActive(true) // Authenticated by Firebase immediately
                        .isDeleted(false)
                        .failedAttempts(0)
                        .build();
                userRepository.save(user);
                log.info("Firebase Auth successful. Registered new user: {}", phone);
            }

            return generateTokenResponse(user);

        } catch (Exception e) {
            log.error("Failed to verify Firebase token", e);
            throw new BusinessRuleException("Xác thực Firebase thất bại: " + e.getMessage());
        }
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

    @Override
    public ForgotPasswordInitResponse initForgotPassword(ForgotPasswordInitRequest request) {
        String identifier = request.getIdentifier();
        if (identifier.startsWith("+84")) {
            identifier = "0" + identifier.substring(3);
        }

        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(identifier)
                .orElseThrow(() -> new BusinessRuleException("Không tìm thấy tài khoản."));

        if (user.getPhone() == null || user.getPhone().isBlank()) {
            throw new BusinessRuleException("NO_PHONE_ASSOCIATED: Tài khoản không có số điện thoại liên kết. Vui lòng liên hệ Admin để cấp lại mật khẩu.");
        }

        String phone = user.getPhone();
        String masked = phone.substring(0, phone.length() - 3).replaceAll(".", "*") + phone.substring(phone.length() - 3);

        return ForgotPasswordInitResponse.builder()
                .maskedPhone(masked)
                .fullPhone(phone)
                .build();
    }

    @Override
    @Transactional
    public ForgotPasswordResetResponse resetPassword(ForgotPasswordResetRequest request) {
        String phone;
        if (!isProduction() && request.getIdToken() != null && request.getIdToken().startsWith("MOCK_TOKEN_")) {
            phone = request.getIdToken().substring("MOCK_TOKEN_".length());
            log.info("Bypassing Firebase Auth (Reset Password) for mock token with phone: {}", phone);
        } else {
            try {
                FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(request.getIdToken());
                Object phoneObj = decodedToken.getClaims().get("phone_number");
                if (phoneObj == null) {
                    throw new BusinessRuleException("Không tìm thấy số điện thoại trong chứng chỉ Firebase.");
                }
                phone = phoneObj.toString();
            } catch (Exception e) {
                log.error("Failed to verify Firebase token for reset", e);
                throw new BusinessRuleException("Xác thực OTP thất bại: " + e.getMessage());
            }
        }

        if (phone.startsWith("+84")) {
            phone = "0" + phone.substring(3);
        }

        String identifier = request.getIdentifier();
        if (identifier.startsWith("+84")) {
            identifier = "0" + identifier.substring(3);
        }

        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(identifier)
                .orElseThrow(() -> new BusinessRuleException("Không tìm thấy tài khoản."));

        if (!phone.equals(user.getPhone())) {
            throw new BusinessRuleException("Số điện thoại xác thực không khớp với số điện thoại của tài khoản.");
        }

        // Tạo mật khẩu ngẫu nhiên: 8 ký tự
        String newRandomPassword = generateRandomPassword(8);
        user.setPasswordHash(passwordEncoder.encode(newRandomPassword));
        user.setMustChangePassword(true);
        user.setFailedAttempts(0);
        user.setLockedUntil(null);
        userRepository.save(user);

        return ForgotPasswordResetResponse.builder()
                .newPassword(newRandomPassword)
                .build();
    }

    @Override
    @Transactional
    public void changePassword(ChangePasswordRequest request, String identifier) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(identifier)
                .orElseThrow(() -> new BusinessRuleException("User not found"));

        if (!passwordEncoder.matches(request.getOldPassword(), user.getPasswordHash())) {
            throw new BusinessRuleException("Mật khẩu cũ không chính xác.");
        }

        user.setPasswordHash(passwordEncoder.encode(request.getNewPassword()));
        user.setMustChangePassword(false);
        userRepository.save(user);
    }

    // ─────────── Private Helpers ───────────

    private TokenResponse generateTokenResponse(UserEntity user) {
        String subject = user.getPhone() != null ? user.getPhone() : user.getUsername();
        User userDetails =
                new User(
                        subject,
                        user.getPasswordHash(),
                        Collections.emptyList());

        UserRole role = user.getRole();
        String jwt = jwtService.generateTokenForRole(userDetails, role);
        String refreshTokenStr = jwtService.generateRefreshTokenForRole(userDetails, role);
        long refreshTtlMs = jwtService.getRefreshTokenTtlMs(role);

        // Xóa refresh token cũ để tránh duplicate key constraint
        refreshTokenRepository.deleteAllByUserId(user.getId());

        RefreshTokenEntity rt = RefreshTokenEntity.builder()
                .user(user)
                .tokenHash(refreshTokenStr)
                .expiresAt(Instant.now().plusMillis(refreshTtlMs))
                .build();
        refreshTokenRepository.save(rt);

        return TokenResponse.builder()
                .accessToken(jwt)
                .refreshToken(refreshTokenStr)
                .role(user.getRole())
                .fullName(user.getFullName())
                .avatarBase64(user.getAvatarBase64())
                .isActive(user.getIsActive())
                .mustChangePassword(user.getMustChangePassword())
                .build();
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
    
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        Random rnd = new Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
