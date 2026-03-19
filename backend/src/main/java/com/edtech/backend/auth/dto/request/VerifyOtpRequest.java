package com.edtech.backend.auth.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VerifyOtpRequest {
    @NotBlank(message = "OTP token is required")
    private String otpToken; // UUID String nhận được sau register

    @NotBlank(message = "OTP code is required")
    private String code;
}
