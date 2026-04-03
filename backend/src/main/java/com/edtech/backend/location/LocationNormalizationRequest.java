package com.edtech.backend.location;

import java.math.BigDecimal;

import lombok.Getter;

@Getter
public class LocationNormalizationRequest {
    private String rawAddress;
    private String provinceName;
    private String districtName;
    private String wardName;
    private BigDecimal latitude;
    private BigDecimal longitude;
}
