package com.edtech.backend.auth.service;

import com.edtech.backend.auth.dto.UpdateUserProfileRequest;
import com.edtech.backend.auth.dto.UserProfileResponse;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

        updateIfPresent(request.getEmail(), user::setEmail);
        updateIfPresent(request.getAvatarBase64(), user::setAvatarBase64);
        updateIfPresent(request.getAddress(), user::setAddress);
        updateIfPresent(request.getSchool(), user::setSchool);
        updateIfPresent(request.getGrade(), user::setGrade);

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
                .avatarBase64(user.getAvatarBase64())
                .role(user.getRole().name())
                .address(user.getAddress())
                .school(user.getSchool())
                .grade(user.getGrade())
                .build();
    }

    private void updateIfPresent(String value, java.util.function.Consumer<String> setter) {
        if (value != null) {
            setter.accept(value.trim().isEmpty() ? null : value.trim());
        }
    }
}
