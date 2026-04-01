package com.edtech.backend.tutor.dto.response;

import com.edtech.backend.tutor.enums.TutorType;
import com.edtech.backend.tutor.enums.VerificationStatus;
import lombok.Builder;
import lombok.Getter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Builder
public class TutorProfileResponse {
    // From UserEntity
    private String fullName;
    private String email;
    private String avatarBase64;

    // From TutorProfileEntity
    private String bio;
    private String[] subjects;
    private String[] teachingLevels;
    private String location;
    private String teachingMode;
    private BigDecimal rating;
    private Integer ratingCount;
    private String idCardNumber;
    private String[] certBase64s;
    private VerificationStatus verificationStatus;
    private TutorType tutorType;
    private LocalDate dateOfBirth;
    private String achievements;
    private Integer experienceYears;
    
    // Bank Details
    private String bankName;
    private String bankAccountNumber;
    private String bankOwnerName;
}
