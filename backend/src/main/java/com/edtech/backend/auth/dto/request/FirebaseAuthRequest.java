package com.edtech.backend.auth.dto.request;

import com.edtech.backend.auth.enums.UserRole;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class FirebaseAuthRequest {
    
    @NotBlank(message = "Firebase ID Token is required")
    private String idToken;

    // Optional fields used mainly during registration flow
    private String fullName;
    private String password;
    private UserRole role;
}
