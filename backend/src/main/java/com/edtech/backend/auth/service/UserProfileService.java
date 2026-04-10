package com.edtech.backend.auth.service;

import java.util.function.Consumer;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.dto.UpdateUserProfileRequest;
import com.edtech.backend.auth.dto.UserProfileResponse;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.core.util.ImageCompressUtil;

/**
 * Service xử lý profile chung cho mọi role (Parent, Student).
 * Tutor giữ endpoint riêng vì có nhiều fields chuyên biệt.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserProfileService {

    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public UserProfileResponse getMyProfile(String username) {
        UserEntity user = findUserByIdentifier(username);
        return toResponse(user);
    }

    @Transactional
    public UserProfileResponse updateMyProfile(String username, UpdateUserProfileRequest request) {
        UserEntity user = findUserByIdentifier(username);

        // Phone chỉ cho cập nhật khi user chưa có phone
        if (request.getPhone() != null && !request.getPhone().trim().isEmpty()) {
            if (user.getPhone() != null && !user.getPhone().isEmpty()) {
                throw new IllegalArgumentException("Không thể thay đổi số điện thoại đã xác thực");
            }
            String phone = request.getPhone().trim();
            if (!phone.matches("^0\\d{9}$")) {
                throw new IllegalArgumentException("Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0)");
            }
            if (userRepository.findByPhoneAndIsDeletedFalse(phone).isPresent()) {
                throw new IllegalArgumentException("Số điện thoại này đã được sử dụng");
            }
            user.setPhone(phone);
        }

        updateIfPresent(request.getEmail(), user::setEmail);
        updateIfPresent(request.getAddress(), user::setAddress);
        updateIfPresent(request.getSchool(), user::setSchool);
        updateIfPresent(request.getGrade(), user::setGrade);

        // Nén ảnh avatar bằng GZIP trước khi lưu DB (lossless, giảm ~60-70%)
        if (request.getAvatarBase64() != null) {
            String compressed = ImageCompressUtil.compress(request.getAvatarBase64().trim());
            user.setAvatarBase64(compressed);
        }

        UserEntity saved = userRepository.save(user);
        return toResponse(saved);
    }

    private UserEntity findUserByIdentifier(String username) {
        return userRepository.findByIdentifierAndIsDeletedFalse(username)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy người dùng"));
    }

    private UserProfileResponse toResponse(UserEntity user) {
        return UserProfileResponse.builder()
                .fullName(user.getFullName())
                .phone(user.getPhone())
                .email(user.getEmail())
                .avatarBase64(ImageCompressUtil.decompress(user.getAvatarBase64()))
                .role(user.getRole().name())
                .address(user.getAddress())
                .school(user.getSchool())
                .grade(user.getGrade())
                .build();
    }

    private void updateIfPresent(String value, Consumer<String> setter) {
        if (value != null) {
            setter.accept(value.trim().isEmpty() ? null : value.trim());
        }
    }
}
