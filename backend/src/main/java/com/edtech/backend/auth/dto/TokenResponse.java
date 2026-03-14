package com.edtech.backend.auth.dto;

import com.edtech.backend.auth.entity.UserRole;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class TokenResponse {
    private String accessToken;
    private String refreshToken;
    private UserRole role;
    private String fullName;
    private Boolean isActive;
}
