package com.edtech.backend.auth.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ForgotPasswordInitRequest {
    @NotBlank(message = "Tên đăng nhập hoặc SĐT không được để trống")
    private String identifier;
}
