package com.edtech.backend.admin.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

/**
 * Admin tạo lớp học mới.
 * schedule: JSON string "[{\"dayOfWeek\":\"MONDAY\",\"startTime\":\"07:00\",\"endTime\":\"09:00\"}]"
 * levelFees: JSON string "[{\"level\":\"Sinh viên\",\"tutor_fee\":500000}]"
 */
public record CreateClassRequest(
        @NotNull UUID parentId,

        @NotBlank String title,
        @NotBlank String subject,
        @NotBlank String grade,

        @NotBlank String mode,          // "ONLINE" | "OFFLINE"
        String address,                  // bắt buộc nếu OFFLINE

        String schedule,                 // JSON JSONB
        @NotNull @Positive Integer sessionsPerWeek,
        @NotNull @Positive Integer sessionDurationMin,

        String timeFrame,

        @NotNull BigDecimal parentFee,  // phụ huynh trả / tháng
        @NotNull Integer feePercentage, // % hoa hồng (default 30)
        String levelFees,               // JSON hoặc null
        String genderRequirement,

        LocalDate startDate,
        LocalDate endDate
) {}
