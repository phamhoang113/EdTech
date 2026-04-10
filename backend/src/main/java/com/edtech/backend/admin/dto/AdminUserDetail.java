package com.edtech.backend.admin.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.tutor.enums.VerificationStatus;

/** Chi tiết đầy đủ một user cho trang admin */
@Getter
@Builder
public class AdminUserDetail {

    // ── Basic user info ────────────────────────────────────────────────────
    UUID id;
    String fullName;
    String username;
    String email;
    String phone;
    UserRole role;
    String avatarBase64;
    Boolean isActive;
    Boolean isDeleted;
    Instant createdAt;

    // ── Tutor profile (chỉ có khi role = TUTOR) ───────────────────────────
    String tutorType;               // Sinh viên / Giáo viên
    VerificationStatus verificationStatus;
    String bio;
    List<String> subjects;
    List<String> teachingLevels;
    String location;
    String teachingMode;
    BigDecimal hourlyRate;
    BigDecimal rating;
    Integer ratingCount;
    Integer experienceYears;
    LocalDate dateOfBirth;
    String achievements;

    // ── Parent → children (chỉ có khi role = PARENT) ──────────────────────
    List<LinkedChild> children;

    // ── Student → parents (chỉ có khi role = STUDENT) ─────────────────────
    List<LinkedParent> parentLinks;

    @Getter
    @Builder
    public static class LinkedChild {
        String profileId;
        String fullName;
        String phone;
        String username;
        String grade;
        String school;
        String linkStatus;
    }

    @Getter
    @Builder
    public static class LinkedParent {
        String profileId;
        String parentName;
        String parentPhone;
        String linkStatus;
    }
}
