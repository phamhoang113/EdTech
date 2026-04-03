package com.edtech.backend.tutor.dto.request;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

/**
 * Phụ huynh gửi yêu cầu mở lớp.
 * parentId lấy từ authentication context (không cần truyền).
 */
public record ParentClassRequest(
        @NotBlank String title,
        @NotBlank String subject,
        @NotBlank String grade,

        @NotBlank String mode,           // "ONLINE" | "OFFLINE"
        String address,                   // bắt buộc nếu OFFLINE

        String schedule,                  // JSON array lịch học
        @NotNull @Positive Integer sessionsPerWeek,
        @NotNull @Positive Integer sessionDurationMin,

        String timeFrame,                 // VD: "Chiều tối"
        @NotNull BigDecimal parentFee,   // học phí PH muốn trả / tháng
        String genderRequirement,         // Nam / Nữ / Không yêu cầu
        String description,              // Ghi chú thêm cho admin
        String levelFees,                // JSON array loại GS + học phí [{level, tutor_fee}]
        List<UUID> studentIds     // Danh sách con (student user_id)
) {}
