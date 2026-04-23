package com.edtech.backend.auth.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * Request để link OAuth provider (Google/Facebook) vào account hiện tại.
 * Client popup OAuth → lấy Firebase idToken → gửi lên.
 */
@Data
public class LinkProviderRequest {

    @NotBlank(message = "Firebase ID Token is required")
    private String idToken;
}
