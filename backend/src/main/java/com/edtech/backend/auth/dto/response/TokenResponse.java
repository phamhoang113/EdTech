package com.edtech.backend.auth.dto.response;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.auth.enums.UserRole;

@Getter
@Builder
public class TokenResponse {
    private String accessToken;
    private String refreshToken;
    private UserRole role;
    private String fullName;
    private String avatarBase64;
    private Boolean isActive;
}
