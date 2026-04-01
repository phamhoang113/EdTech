package com.edtech.backend.location;

import lombok.Builder;
import lombok.Getter;
import java.math.BigDecimal;

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
