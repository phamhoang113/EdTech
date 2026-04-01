package com.edtech.backend.tutor.dto.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UpdateTutorProfileRequest {
    /** Base64 encoded avatar image (optional) */
    private String avatarBase64;
    private String email;
    private String bio;
    private String location;
    private String[] subjects;
    private String[] teachingLevels;
    private String achievements;
    private Integer experienceYears;
    /** ONLINE | OFFLINE | BOTH */
    private String teachingMode;

    private String bankName;
    private String bankAccountNumber;
    private String bankOwnerName;
}
