package com.edtech.backend.admin.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

import com.edtech.backend.tutor.enums.VerificationStatus;

@Value
@Builder
public class AdminTutorListItem {

    // ── Identity ────────────────────────────────────────────────────────────
    UUID userId;
    String fullName;
    String username;
    String email;
    String phone;
    String avatarBase64;

    // ── Tutor profile ───────────────────────────────────────────────────────
    String tutorType;
    VerificationStatus verificationStatus;
    String bio;
    String achievements;
    List<String> subjects;
    List<String> teachingLevels;
    String teachingMode;
    String location;
    BigDecimal hourlyRate;
    Integer experienceYears;
    LocalDate dateOfBirth;
    BigDecimal rating;
    Integer ratingCount;

    // ── Admin stats ─────────────────────────────────────────────────────────
    boolean isDeleted;
    boolean isActive;
    long activeClassCount;
    /** Ước tính thu nhập GS/tháng = sum(tutorFee) các lớp đang dạy */
    BigDecimal estimatedMonthlyEarnings;
    /** Phí nền tảng/tháng từ GS = sum(platformFee) các lớp đang dạy */
    BigDecimal platformFeePerMonth;
    Instant createdAt;
}
