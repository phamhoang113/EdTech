package com.edtech.backend.tutor.dto.response;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class OpenClassResponse {
    private UUID id;
    private String title;
    private String subject;
    private String grade;
    private String location;

    private String schedule;
    private String timeFrame;

    // V20 NEW FIELDS
    private String classCode;
    private Integer feePercentage;
    private BigDecimal parentFee;
    private BigDecimal minTutorFee;
    private BigDecimal maxTutorFee;
    private List<String> tutorLevelRequirement;
    private String genderRequirement;
    private Integer sessionsPerWeek;
    private Integer sessionDurationMin;
    private Integer studentCount;
    private String levelFees; // raw JSON: [{level, tutor_fee}]
}
