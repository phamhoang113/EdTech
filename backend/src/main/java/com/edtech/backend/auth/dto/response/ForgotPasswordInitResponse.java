package com.edtech.backend.auth.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ForgotPasswordInitResponse {
    private String maskedPhone;
    private String fullPhone; // Used strictly for Firebase SMS locally on Client
}
