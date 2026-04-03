package com.edtech.backend.admin.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

import com.edtech.backend.tutor.enums.VerificationStatus;

@Value
@Builder
public class AdminTutorListItem {
    UUID userId;
    String fullName;
    String phone;
    String tutorType;
    VerificationStatus verificationStatus;
    boolean isDeleted;
    boolean isActive;
    List<String> subjects;
    String location;
    BigDecimal hourlyRate;
    long activeClassCount;
    /** Ước tính thu nhập GS/tháng = sum(tutorFee) các lớp đang dạy */
    BigDecimal estimatedMonthlyEarnings;
    /** Phí nền tảng/tháng từ GS = sum(platformFee) các lớp đang dạy */
    BigDecimal platformFeePerMonth;
    Instant createdAt;
}
