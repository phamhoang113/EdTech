package com.edtech.backend.auth.service.impl;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Random;

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

import com.edtech.backend.auth.dto.request.ChangePasswordRequest;
import com.edtech.backend.auth.dto.request.FirebaseAuthRequest;
import com.edtech.backend.auth.dto.request.ForgotPasswordInitRequest;
import com.edtech.backend.auth.dto.request.ForgotPasswordResetRequest;
import com.edtech.backend.auth.dto.request.LoginRequest;
import com.edtech.backend.auth.dto.request.TokenRefreshRequest;
import com.edtech.backend.auth.dto.response.ForgotPasswordInitResponse;
import com.edtech.backend.auth.dto.response.ForgotPasswordResetResponse;
import com.edtech.backend.auth.dto.response.TokenResponse;
import com.edtech.backend.auth.entity.RefreshTokenEntity;
import com.edtech.backend.auth.entity.UserDeviceEntity;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.entity.UserLinkedProviderEntity;
import com.edtech.backend.auth.enums.AuthProvider;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.RefreshTokenRepository;
import com.edtech.backend.auth.repository.UserDeviceRepository;
import com.edtech.backend.auth.repository.UserLinkedProviderRepository;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.auth.service.AuthService;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.util.ImageCompressUtil;
import com.edtech.backend.security.jwt.JwtService;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final UserDeviceRepository userDeviceRepository;
    private final UserLinkedProviderRepository linkedProviderRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @Value("${app.environment:development}")
    private String appEnvironment;

    // ─────────── Constants ───────────
    private static final int    MAX_FAILED_ATTEMPTS  = 5;
    private static final int    LOCKOUT_MINUTES      = 15;
    private static final long   REFRESH_TOKEN_TTL_MS = 604_800_000L;
    private static final String PROD_ENV             = "production";

    private static final String GOOGLE_SIGN_IN_PROVIDER   = "google.com";
    private static final String FACEBOOK_SIGN_IN_PROVIDER = "facebook.com";
    private static final String PHONE_SIGN_IN_PROVIDER    = "phone";

    // ─────────── Auth API ───────────

    @Override
    @Transactional
    public TokenResponse verifyFirebaseAuth(FirebaseAuthRequest request) {
        try {
            // 1. Decode Firebase token hoặc bypass cho dev
            FirebaseTokenInfo tokenInfo = decodeFirebaseToken(request.getIdToken());
            AuthProvider provider = tokenInfo.provider();
            String email = tokenInfo.email();
            String phone = tokenInfo.phone();
            String displayName = tokenInfo.displayName();
            String providerUid = tokenInfo.providerUid();

            // 2. Route theo provider type
            if (provider == AuthProvider.GOOGLE || provider == AuthProvider.FACEBOOK) {
                return handleOAuthLogin(request, provider, email, displayName, providerUid);
            }

            // 3. Phone provider → giữ nguyên flow hiện tại
            return handlePhoneAuth(request, phone);

        } catch (BusinessRuleException e) {
            throw e;
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

        // OAuth user chưa thiết lập password → hướng dẫn set password hoặc dùng OAuth
        if (user.getPasswordHash() == null) {
            throw new BusinessRuleException(
                    "Tài khoản chưa thiết lập mật khẩu. Vui lòng đăng nhập bằng Google/Facebook "
                    + "hoặc thiết lập mật khẩu trong phần Cài đặt.");
        }

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

        final String lookupId = identifier;
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(lookupId)
                .or(() -> userRepository.findByPhoneAndIsDeletedFalse(lookupId))
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

        final String lookupId = identifier;
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(lookupId)
                .or(() -> userRepository.findByPhoneAndIsDeletedFalse(lookupId))
                .orElseThrow(() -> new BusinessRuleException("Không tìm thấy tài khoản."));

        if (!phone.equals(user.getPhone())) {
            throw new BusinessRuleException("Số điện thoại xác thực không khớp với số điện thoại của tài khoản.");
        }

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

    @Override
    public boolean checkPhoneExists(String phone) {
        if (phone == null || phone.isBlank()) return false;
        String normalized = phone.trim();
        if (normalized.startsWith("+84")) {
            normalized = "0" + normalized.substring(3);
        }
        return userRepository.existsByPhoneAndIsDeletedFalse(normalized)
                || userRepository.findByIdentifierAndIsDeletedFalse(normalized).isPresent();
    }

    // ─────────── OAuth Handlers ───────────

    /**
     * Xử lý OAuth login/register (Google, Facebook).
     * Flow: tìm user qua linked_providers → tìm qua email → register mới.
     */
    private TokenResponse handleOAuthLogin(FirebaseAuthRequest request, AuthProvider provider,
                                           String email, String displayName, String providerUid) {
        if (email == null || email.isBlank()) {
            throw new BusinessRuleException("Không lấy được email từ " + provider + ". Vui lòng thử lại.");
        }

        // Ưu tiên tìm qua bảng linked_providers
        Optional<UserLinkedProviderEntity> linkedOpt = linkedProviderRepository
                .findByProviderAndProviderEmail(provider, email);

        if (linkedOpt.isPresent()) {
            UserEntity user = linkedOpt.get().getUser();
            log.info("OAuth login via linked provider [{}] for user: {}", provider, email);
            return generateTokenResponse(user);
        }

        // Tìm user có matching email (auto-link nếu chưa linked)
        Optional<UserEntity> emailUserOpt = userRepository.findByEmailAndIsDeletedFalse(email);
        if (emailUserOpt.isPresent()) {
            UserEntity user = emailUserOpt.get();
            linkProviderToUser(user, provider, email, providerUid);
            log.info("OAuth auto-linked [{}] to existing user with email: {}", provider, email);
            return generateTokenResponse(user);
        }

        // Không tìm thấy → đây là Register mới
        boolean isRegistrationRequest = request.getRole() != null;
        if (!isRegistrationRequest) {
            throw new BusinessRuleException(
                    "Email chưa đăng ký. Vui lòng cung cấp role (vai trò) để hoàn tất đăng ký.");
        }

        String fullName = resolveFullName(request.getFullName(), displayName, email);
        UserEntity newUser = UserEntity.builder()
                .email(email)
                .username(email)
                .passwordHash(null)
                .fullName(fullName)
                .role(request.getRole())
                .authProvider(provider)
                .isActive(true)
                .isDeleted(false)
                .failedAttempts(0)
                .build();
        userRepository.save(newUser);
        linkProviderToUser(newUser, provider, email, providerUid);

        log.info("OAuth registered new user via [{}]: {}", provider, email);
        return generateTokenResponse(newUser);
    }

    /** Xử lý Phone auth — giữ nguyên logic cũ */
    private TokenResponse handlePhoneAuth(FirebaseAuthRequest request, String phone) {
        if (phone != null && phone.startsWith("+84")) {
            phone = "0" + phone.substring(3);
        }

        Optional<UserEntity> userOpt = userRepository.findByIdentifierAndIsDeletedFalse(phone);
        if (userOpt.isEmpty()) {
            userOpt = userRepository.findByPhoneAndIsDeletedFalse(phone);
        }

        boolean isRegistrationRequest = request.getPassword() != null
                && request.getFullName() != null
                && request.getRole() != null;

        if (userOpt.isPresent()) {
            if (isRegistrationRequest) {
                throw new BusinessRuleException("Số điện thoại này đã được đăng ký. Vui lòng đăng nhập hoặc sử dụng số khác.");
            }

            UserEntity user = userOpt.get();
            if (user.getPhone() == null) {
                user.setPhone(phone);
                userRepository.save(user);
            }
            log.info("Firebase Auth successful for existing user: {}", phone);
            return generateTokenResponse(user);
        }

        if (!isRegistrationRequest) {
            throw new BusinessRuleException("Số điện thoại chưa đăng ký. Vui lòng cung cấp mật khẩu, Họ và tên và Quyền (role) để hoàn tất đăng ký.");
        }

        UserEntity user = UserEntity.builder()
                .phone(phone)
                .username(phone)
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .role(request.getRole())
                .authProvider(AuthProvider.PHONE)
                .isActive(true)
                .isDeleted(false)
                .failedAttempts(0)
                .build();
        userRepository.save(user);
        log.info("Firebase Auth successful. Registered new user: {}", phone);
        return generateTokenResponse(user);
    }

    // ─────────── Private Helpers ───────────

    /**
     * Decode Firebase idToken, extract provider info.
     * Hỗ trợ MOCK token cho môi trường dev.
     */
    private FirebaseTokenInfo decodeFirebaseToken(String idToken) throws Exception {
        if (!isProduction() && idToken != null && idToken.startsWith("MOCK_TOKEN_")) {
            String mockValue = idToken.substring("MOCK_TOKEN_".length());
            log.info("Bypassing Firebase Auth (Local/SIT) for mock token: {}", mockValue);

            // MOCK_GOOGLE_email@gmail.com hoặc MOCK_FACEBOOK_email@gmail.com
            if (mockValue.startsWith("GOOGLE_")) {
                String email = mockValue.substring("GOOGLE_".length());
                return new FirebaseTokenInfo(AuthProvider.GOOGLE, email, null, email.split("@")[0], "mock-google-uid");
            }
            if (mockValue.startsWith("FACEBOOK_")) {
                String email = mockValue.substring("FACEBOOK_".length());
                return new FirebaseTokenInfo(AuthProvider.FACEBOOK, email, null, email.split("@")[0], "mock-facebook-uid");
            }

            // MOCK_TOKEN_0912345678 → Phone provider (flow cũ)
            return new FirebaseTokenInfo(AuthProvider.PHONE, null, mockValue, null, null);
        }

        FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
        String signInProvider = extractSignInProvider(decodedToken);
        AuthProvider provider = mapSignInProvider(signInProvider);

        String email = decodedToken.getEmail();
        String phone = extractPhoneNumber(decodedToken);
        String displayName = decodedToken.getName();
        String providerUid = decodedToken.getUid();

        return new FirebaseTokenInfo(provider, email, phone, displayName, providerUid);
    }

    /** Extract sign_in_provider từ Firebase token claims */
    @SuppressWarnings("unchecked")
    private String extractSignInProvider(FirebaseToken token) {
        Map<String, Object> firebase = (Map<String, Object>) token.getClaims().get("firebase");
        if (firebase != null && firebase.containsKey("sign_in_provider")) {
            return firebase.get("sign_in_provider").toString();
        }
        return PHONE_SIGN_IN_PROVIDER;
    }

    private AuthProvider mapSignInProvider(String signInProvider) {
        if (GOOGLE_SIGN_IN_PROVIDER.equals(signInProvider)) return AuthProvider.GOOGLE;
        if (FACEBOOK_SIGN_IN_PROVIDER.equals(signInProvider)) return AuthProvider.FACEBOOK;
        return AuthProvider.PHONE;
    }

    private String extractPhoneNumber(FirebaseToken token) {
        Object phoneObj = token.getClaims().get("phone_number");
        return phoneObj != null ? phoneObj.toString() : null;
    }

    private void linkProviderToUser(UserEntity user, AuthProvider provider, String email, String providerUid) {
        // Check conflict: email đã linked bởi user khác → ưu tiên user đầu tiên
        if (linkedProviderRepository.existsByProviderAndProviderEmail(provider, email)) {
            throw new BusinessRuleException(
                    "Email " + email + " đã được liên kết với tài khoản khác trên " + provider + ".");
        }

        UserLinkedProviderEntity link = UserLinkedProviderEntity.builder()
                .user(user)
                .provider(provider)
                .providerEmail(email)
                .providerUserId(providerUid)
                .build();
        linkedProviderRepository.save(link);

        // Cập nhật email trong bảng users nếu chưa có
        if (user.getEmail() == null || user.getEmail().isBlank()) {
            user.setEmail(email);
            userRepository.save(user);
        }
    }

    /** Chọn fullName: ưu tiên request → displayName từ provider → fallback email prefix */
    private String resolveFullName(String requestFullName, String displayName, String email) {
        if (requestFullName != null && !requestFullName.isBlank()) return requestFullName;
        if (displayName != null && !displayName.isBlank()) return displayName;
        if (email != null && email.contains("@")) return email.split("@")[0];
        return "User";
    }

    private TokenResponse generateTokenResponse(UserEntity user) {
        String subject = user.getUsername();
        User userDetails = new User(
                subject,
                user.getPasswordHash() != null ? user.getPasswordHash() : "",
                Collections.emptyList());

        UserRole role = user.getRole();
        var extraClaims = Map.<String, Object>of(
                "role", role.name(),
                "fullName", user.getFullName() != null ? user.getFullName() : ""
        );
        String jwt = jwtService.generateTokenForRole(extraClaims, userDetails, role);
        String refreshTokenStr = jwtService.generateRefreshTokenForRole(userDetails, role);
        long refreshTtlMs = jwtService.getRefreshTokenTtlMs(role);

        refreshTokenRepository.deleteAllByUserId(user.getId());

        RefreshTokenEntity rt = RefreshTokenEntity.builder()
                .user(user)
                .tokenHash(refreshTokenStr)
                .expiresAt(Instant.now().plusMillis(refreshTtlMs))
                .build();
        refreshTokenRepository.save(rt);

        List<String> providerNames = linkedProviderRepository.findByUserId(user.getId())
                .stream()
                .map(lp -> lp.getProvider().name())
                .toList();

        return TokenResponse.builder()
                .accessToken(jwt)
                .refreshToken(refreshTokenStr)
                .role(user.getRole())
                .fullName(user.getFullName())
                .avatarBase64(ImageCompressUtil.decompress(user.getAvatarBase64()))
                .isActive(user.getIsActive())
                .mustChangePassword(user.getMustChangePassword())
                .authProvider(user.getAuthProvider().name())
                .email(user.getEmail())
                .hasPassword(user.getPasswordHash() != null)
                .linkedProviders(providerNames)
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

    /** Internal record to carry decoded Firebase token info */
    private record FirebaseTokenInfo(
            AuthProvider provider,
            String email,
            String phone,
            String displayName,
            String providerUid
    ) {}
}
