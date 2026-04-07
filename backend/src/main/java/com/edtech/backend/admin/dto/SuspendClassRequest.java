package com.edtech.backend.admin.dto;

import java.time.LocalDate;

import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Value;
import lombok.extern.jackson.Jacksonized;

@Value
@Builder
@Jacksonized
public class SuspendClassRequest {
    @NotNull(message = "Ngày bắt đầu tạm hoãn không được để trống")
    LocalDate startDate;

    @NotNull(message = "Ngày kết thúc tạm hoãn không được để trống")
    LocalDate endDate;

    String reason;
}
