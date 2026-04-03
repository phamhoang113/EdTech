package com.edtech.backend.admin.dto;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.cls.enums.AbsenceRequestStatus;
import com.edtech.backend.cls.enums.AbsenceRequestType;

@Getter
@Builder
public class AdminAbsenceRequestDTO {
    private UUID id;
    private UUID sessionId;
    private LocalDate sessionDate;
    private LocalTime startTime;
    private LocalTime endTime;
    
    private String classTitle;
    private String subject;
    private String tutorName;
    private String studentName; // Or requester name
    
    private AbsenceRequestType requestType;
    private String reason;
    private Boolean makeUpRequired;
    
    private LocalDate makeupDate;
    private LocalTime makeupTime;

    private AbsenceRequestStatus status;
    private Instant createdAt;
    
    private String reviewedBy;
    private OffsetDateTime reviewedAt;
}
