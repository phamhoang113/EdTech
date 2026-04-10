package com.edtech.backend.admin.service;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.admin.dto.AdminUserDetail;
import com.edtech.backend.admin.dto.AdminUserListItem;
import com.edtech.backend.admin.dto.CreateUserAdminRequest;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.util.ImageCompressUtil;
import com.edtech.backend.student.entity.StudentProfileEntity;
import com.edtech.backend.student.repository.StudentProfileRepository;
import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.enums.VerificationStatus;
import com.edtech.backend.tutor.repository.TutorProfileRepository;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminUserService {

    private final UserRepository userRepository;
    private final TutorProfileRepository tutorProfileRepository;
    private final StudentProfileRepository studentProfileRepository;
    private final PasswordEncoder passwordEncoder;
    private final AdminTutorService adminTutorService;

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
                .username(user.getUsername())
                .email(user.getEmail())
                .phone(user.getPhone())
                .role(user.getRole())
                .avatarBase64(ImageCompressUtil.decompress(user.getAvatarBase64()))
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

        // Nếu là PARENT, load danh sách con em
        if (user.getRole() == UserRole.PARENT) {
            List<AdminUserDetail.LinkedChild> children = studentProfileRepository
                    .findByParentIdAndNotDeleted(userId)
                    .stream()
                    .map(profile -> AdminUserDetail.LinkedChild.builder()
                            .profileId(profile.getId().toString())
                            .fullName(profile.getUser().getFullName())
                            .phone(profile.getUser().getPhone())
                            .username(profile.getUser().getUsername())
                            .grade(profile.getGrade())
                            .school(profile.getSchool())
                            .linkStatus(profile.getLinkStatus())
                            .build())
                    .toList();
            builder.children(children);
        }

        // Nếu là STUDENT, load danh sách PH liên kết
        if (user.getRole() == UserRole.STUDENT) {
            List<AdminUserDetail.LinkedParent> parentLinks = studentProfileRepository
                    .findByUserId(userId)
                    .stream()
                    .map(profile -> {
                        UserEntity parent = userRepository.findById(profile.getParentId()).orElse(null);
                        return AdminUserDetail.LinkedParent.builder()
                                .profileId(profile.getId().toString())
                                .parentName(parent != null ? parent.getFullName() : "?")
                                .parentPhone(parent != null ? parent.getPhone() : null)
                                .linkStatus(profile.getLinkStatus())
                                .build();
                    })
                    .toList();
            builder.parentLinks(parentLinks);
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
                
        if (user.getRole() == UserRole.TUTOR) {
            adminTutorService.deleteTutor(userId);
        } else {
            user.setIsDeleted(true);
            user.setIsActive(false);
            userRepository.save(user);
        }
    }

    /** Mở lớp hộ: Amin tự do tạo User cho phép login ngay không cần OTP */
    @Transactional
    public AdminUserDetail createUserBypass(CreateUserAdminRequest req) {
        if (userRepository.findByPhoneAndIsDeletedFalse(req.getPhone()).isPresent()) {
            throw new BusinessRuleException("Số điện thoại " + req.getPhone() + " đã tồn tại trong hệ thống.");
        }

        UserEntity user = UserEntity.builder()
                .phone(req.getPhone())
                .username(req.getPhone())
                .passwordHash(passwordEncoder.encode(req.getPassword()))
                .fullName(req.getFullName())
                .role(req.getRole())
                .isActive(true)
                .isDeleted(false)
                .build();

        UserEntity saved = userRepository.save(user);

        // Nếu role là TUTOR thì tao profile rỗng
        if (req.getRole() == UserRole.TUTOR) {
            TutorProfileEntity tp = TutorProfileEntity.builder()
                    .userId(saved.getId())
                    .verificationStatus(VerificationStatus.UNVERIFIED)
                    .build();
            tutorProfileRepository.save(tp);
        }

        return getUserDetail(saved.getId());
    }

    @Transactional
    public com.edtech.backend.admin.dto.AdminResetPasswordResponse resetPassword(UUID userId) {
        UserEntity user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));

        // Generate random password (8 chars)
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random rnd = new java.util.Random();
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        String newRandomPassword = sb.toString();

        user.setPasswordHash(passwordEncoder.encode(newRandomPassword));
        user.setMustChangePassword(true);
        user.setFailedAttempts(0);
        user.setLockedUntil(null);
        userRepository.save(user);

        return com.edtech.backend.admin.dto.AdminResetPasswordResponse.builder()
                .newPassword(newRandomPassword)
                .build();
    }

    private AdminUserListItem toListItem(UserEntity u) {
        return AdminUserListItem.builder()
                .id(u.getId())
                .fullName(u.getFullName())
                .username(u.getUsername())
                .email(u.getEmail())
                .phone(u.getPhone())
                .role(u.getRole())
                .avatarBase64(ImageCompressUtil.decompress(u.getAvatarBase64()))
                .isActive(u.getIsActive())
                .isDeleted(u.getIsDeleted())
                .createdAt(u.getCreatedAt())
                .build();
    }
}
