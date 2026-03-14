package com.edtech.backend.auth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LoginRequest {
    private String phone;
    private String username;

    @NotBlank(message = "Password is required")
    private String password;

    private String fcmToken;
}
