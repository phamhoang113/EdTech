package com.edtech.backend.auth.dto.response;

import java.time.Instant;

import lombok.Builder;
import lombok.Getter;

/**
 * Response chứa thông tin 1 linked OAuth provider.
 */
@Getter
@Builder
public class LinkedProviderResponse {

    private String provider;
    private String providerEmail;
    private Instant linkedAt;
}
