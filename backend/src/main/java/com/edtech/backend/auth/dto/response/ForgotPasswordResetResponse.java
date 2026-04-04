package com.edtech.backend.auth.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ForgotPasswordResetResponse {
    private String newPassword;
}
