package com.edtech.backend.location;

import lombok.Getter;

@Getter
public class LocationNormalizationRequest {
    private String rawAddress;
    private String provinceName;
    private String districtName;
    private String wardName;
    private java.math.BigDecimal latitude;
    private java.math.BigDecimal longitude;
}
