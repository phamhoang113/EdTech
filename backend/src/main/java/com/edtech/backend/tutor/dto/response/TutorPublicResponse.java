package com.edtech.backend.tutor.dto.response;

import java.math.BigDecimal;
import java.util.UUID;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class TutorPublicResponse {
    private UUID userId;
    private String fullName;
    private String bio;
    private String[] subjects;
    private String location;
    private String teachingMode;
    private BigDecimal hourlyRate;
    private BigDecimal rating;
    private Integer ratingCount;
    private String[] teachingLevels;
    private String achievements;
    private Integer experienceYears;
    private String avatarBase64;
    private String tutorType;
}
