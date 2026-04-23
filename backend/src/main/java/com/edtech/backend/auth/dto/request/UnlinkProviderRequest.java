package com.edtech.backend.auth.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * Request để gỡ liên kết OAuth provider khỏi account.
 */
@Data
public class UnlinkProviderRequest {

    @NotBlank(message = "Provider is required")
    private String provider;
}
