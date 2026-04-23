package com.edtech.backend.auth.service.impl;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.dto.request.LinkProviderRequest;
import com.edtech.backend.auth.dto.request.SetPasswordRequest;
import com.edtech.backend.auth.dto.response.LinkedProviderResponse;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.entity.UserLinkedProviderEntity;
import com.edtech.backend.auth.enums.AuthProvider;
import com.edtech.backend.auth.repository.UserLinkedProviderRepository;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.auth.service.AccountLinkingService;
import com.edtech.backend.core.exception.BusinessRuleException;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class AccountLinkingServiceImpl implements AccountLinkingService {

    private final UserRepository userRepository;
    private final UserLinkedProviderRepository linkedProviderRepository;
    private final PasswordEncoder passwordEncoder;

    private static final String PROD_ENV = "production";
    private static final String GOOGLE_SIGN_IN_PROVIDER = "google.com";
    private static final String FACEBOOK_SIGN_IN_PROVIDER = "facebook.com";

    @Value("${app.environment:development}")
    private String appEnvironment;

    @Override
    @Transactional
    public void linkProvider(String username, LinkProviderRequest request) {
        UserEntity user = findUserByUsername(username);

        try {
            String email;
            AuthProvider provider;
            String providerUid;

            // Dev mock support: MOCK_LINK_GOOGLE_email@gmail.com
            if (!isProduction() && request.getIdToken().startsWith("MOCK_LINK_")) {
                String mockValue = request.getIdToken().substring("MOCK_LINK_".length());
                if (mockValue.startsWith("GOOGLE_")) {
                    provider = AuthProvider.GOOGLE;
                    email = mockValue.substring("GOOGLE_".length());
                } else if (mockValue.startsWith("FACEBOOK_")) {
                    provider = AuthProvider.FACEBOOK;
                    email = mockValue.substring("FACEBOOK_".length());
                } else {
                    throw new BusinessRuleException("Mock token format không hợp lệ.");
                }
                providerUid = "mock-" + provider.name().toLowerCase() + "-uid";
            } else {
                FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(request.getIdToken());
                email = decodedToken.getEmail();
                providerUid = decodedToken.getUid();
                provider = detectProvider(decodedToken);
            }

            if (email == null || email.isBlank()) {
                throw new BusinessRuleException("Không lấy được email từ tài khoản liên kết.");
            }

            if (provider == AuthProvider.PHONE) {
                throw new BusinessRuleException("Chỉ hỗ trợ liên kết Google hoặc Facebook.");
            }

            // BR-1: Email đã linked bởi user khác → ưu tiên user đầu tiên, báo lỗi trùng
            Optional<UserLinkedProviderEntity> existingLink =
                    linkedProviderRepository.findByProviderAndProviderEmail(provider, email);
            if (existingLink.isPresent()) {
                if (!existingLink.get().getUser().getId().equals(user.getId())) {
                    throw new BusinessRuleException(
                            "Email " + email + " đã được liên kết với tài khoản khác trên " + provider + ".");
                }
                // Đã linked chính user này → bỏ qua
                log.info("Provider [{}] already linked for user: {}", provider, username);
                return;
            }

            // Lưu linked provider
            UserLinkedProviderEntity link = UserLinkedProviderEntity.builder()
                    .user(user)
                    .provider(provider)
                    .providerEmail(email)
                    .providerUserId(providerUid)
                    .build();
            linkedProviderRepository.save(link);

            // Cập nhật email trong users nếu chưa có
            if (user.getEmail() == null || user.getEmail().isBlank()) {
                user.setEmail(email);
                userRepository.save(user);
            }

            log.info("Linked [{}] ({}) to user: {}", provider, email, username);

        } catch (BusinessRuleException e) {
            throw e;
        } catch (Exception e) {
            log.error("Failed to link provider for user: {}", username, e);
            throw new BusinessRuleException("Liên kết tài khoản thất bại: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public void setPassword(String username, SetPasswordRequest request) {
        UserEntity user = findUserByUsername(username);

        // BR-2: Username mới phải unique
        String newUsername = request.getUsername().trim();
        Optional<UserEntity> existing = userRepository.findByIdentifierAndIsDeletedFalse(newUsername);
        if (existing.isPresent() && !existing.get().getId().equals(user.getId())) {
            throw new BusinessRuleException("Tên đăng nhập '" + newUsername + "' đã tồn tại. Vui lòng chọn tên khác.");
        }

        user.setUsername(newUsername);
        user.setPasswordHash(passwordEncoder.encode(request.getNewPassword()));
        user.setMustChangePassword(false);
        userRepository.save(user);

        log.info("Password set for user: {} (new username: {})", username, newUsername);
    }

    @Override
    @Transactional
    public void unlinkProvider(String username, AuthProvider provider) {
        UserEntity user = findUserByUsername(username);

        Optional<UserLinkedProviderEntity> linkOpt =
                linkedProviderRepository.findByUserIdAndProvider(user.getId(), provider);
        if (linkOpt.isEmpty()) {
            throw new BusinessRuleException("Tài khoản chưa liên kết với " + provider + ".");
        }

        // BR-3 & BR-4: Phải còn ít nhất 1 cách login
        boolean hasPassword = user.getPasswordHash() != null;
        long linkedCount = linkedProviderRepository.findByUserId(user.getId()).size();

        if (!hasPassword && linkedCount <= 1) {
            throw new BusinessRuleException(
                    "Không thể gỡ liên kết. Bạn cần thiết lập mật khẩu trước hoặc liên kết thêm phương thức đăng nhập khác.");
        }

        linkedProviderRepository.deleteByUserIdAndProvider(user.getId(), provider);
        log.info("Unlinked [{}] from user: {}", provider, username);
    }

    @Override
    public List<LinkedProviderResponse> getLinkedProviders(String username) {
        UserEntity user = findUserByUsername(username);
        return linkedProviderRepository.findByUserId(user.getId())
                .stream()
                .map(lp -> LinkedProviderResponse.builder()
                        .provider(lp.getProvider().name())
                        .providerEmail(lp.getProviderEmail())
                        .linkedAt(lp.getLinkedAt())
                        .build())
                .toList();
    }

    // ─────────── Private Helpers ───────────

    private UserEntity findUserByUsername(String username) {
        return userRepository.findByIdentifierAndIsDeletedFalse(username)
                .orElseThrow(() -> new BusinessRuleException("User not found."));
    }

    @SuppressWarnings("unchecked")
    private AuthProvider detectProvider(FirebaseToken token) {
        Map<String, Object> firebase = (Map<String, Object>) token.getClaims().get("firebase");
        if (firebase != null && firebase.containsKey("sign_in_provider")) {
            String signInProvider = firebase.get("sign_in_provider").toString();
            if (GOOGLE_SIGN_IN_PROVIDER.equals(signInProvider)) return AuthProvider.GOOGLE;
            if (FACEBOOK_SIGN_IN_PROVIDER.equals(signInProvider)) return AuthProvider.FACEBOOK;
        }
        return AuthProvider.PHONE;
    }

    private boolean isProduction() {
        return PROD_ENV.equalsIgnoreCase(appEnvironment);
    }
}
