package com.edtech.backend.location;

import java.math.BigDecimal;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LocationNormalizationResponse {
    private String normalizedAddress;
    private String provinceCode;
    private String wardCode;
    private String newWardName;
    private BigDecimal latitude;
    private BigDecimal longitude;
}
