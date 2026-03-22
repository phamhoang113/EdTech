package com.edtech.backend.admin.service;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.admin.dto.AdminUserDetail;
import com.edtech.backend.admin.dto.AdminUserListItem;
import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.repository.TutorProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminUserService {

    private final UserRepository userRepository;
    private final TutorProfileRepository tutorProfileRepository;

    /** Lấy danh sách tất cả user (chưa xóa), có thể lọc theo role */
    public List<AdminUserListItem> getAllUsers(UserRole role) {
        List<UserEntity> users;
        if (role != null) {
            users = userRepository.findByRoleAndIsDeletedFalseOrderByCreatedAtDesc(role);
        } else {
            users = userRepository.findAllByIsDeletedFalseOrderByCreatedAtDesc();
        }
        return users.stream().map(this::toListItem).toList();
    }

    /** Lấy chi tiết đầy đủ một user (kèm tutor profile nếu là TUTOR) */
    public AdminUserDetail getUserDetail(UUID userId) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));

        AdminUserDetail.AdminUserDetailBuilder builder = AdminUserDetail.builder()
                .id(user.getId())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .phone(user.getPhone())
                .role(user.getRole())
                .isActive(user.getIsActive())
                .isDeleted(user.getIsDeleted())
                .createdAt(user.getCreatedAt());

        // Nếu là TUTOR, load thêm profile
        if (user.getRole() == UserRole.TUTOR) {
            tutorProfileRepository.findByUserId(userId).ifPresent(p -> {
                builder.tutorType(p.getTutorType() != null ? p.getTutorType().name() : null)
                        .verificationStatus(p.getVerificationStatus())
                        .bio(p.getBio())
                        .subjects(p.getSubjects() != null ? Arrays.asList(p.getSubjects()) : List.of())
                        .teachingLevels(p.getTeachingLevels() != null ? Arrays.asList(p.getTeachingLevels()) : List.of())
                        .location(p.getLocation())
                        .teachingMode(p.getTeachingMode())
                        .hourlyRate(p.getHourlyRate())
                        .rating(p.getRating())
                        .ratingCount(p.getRatingCount())
                        .experienceYears(p.getExperienceYears())
                        .dateOfBirth(p.getDateOfBirth())
                        .achievements(p.getAchievements());
            });
        }

        return builder.build();
    }

    /** Khóa / mở khóa tài khoản user */
    @Transactional
    public void setUserActive(UUID userId, boolean active) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));
        user.setIsActive(active);
        userRepository.save(user);
    }

    /** Xóa mềm user */
    @Transactional
    public void deleteUser(UUID userId) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));
        user.setIsDeleted(true);
        userRepository.save(user);
    }

    private AdminUserListItem toListItem(UserEntity u) {
        return AdminUserListItem.builder()
                .id(u.getId())
                .fullName(u.getFullName())
                .email(u.getEmail())
                .phone(u.getPhone())
                .role(u.getRole())
                .isActive(u.getIsActive())
                .isDeleted(u.getIsDeleted())
                .createdAt(u.getCreatedAt())
                .build();
    }
}
