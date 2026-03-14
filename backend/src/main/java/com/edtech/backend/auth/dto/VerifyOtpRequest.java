package com.edtech.backend.auth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class VerifyOtpRequest {
    @NotBlank(message = "Phone is required")
    private String phone;

    @NotBlank(message = "OTP code is required")
    private String code;
}
