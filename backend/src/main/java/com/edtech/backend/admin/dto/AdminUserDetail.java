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
    String email;
    String phone;
    UserRole role;
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
}
