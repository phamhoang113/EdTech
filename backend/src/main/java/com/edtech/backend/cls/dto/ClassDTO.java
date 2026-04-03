package com.edtech.backend.cls.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.ClassMode;
import com.edtech.backend.cls.enums.ClassStatus;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClassDTO {
    private UUID id;
    private String classCode;
    private String title;
    private String subject;
    private String grade;
    private ClassMode mode;
    private ClassStatus status;
    private Integer sessionsPerWeek;
    private Integer sessionDurationMin;
    private BigDecimal tutorFee;
    private LocalDate startDate;
    private LocalDate learningStartDate;
    private LocalDate endDate;
    private String schedule;
    private String address;
    private String description;


    public static ClassDTO fromEntity(ClassEntity entity) {
        if (entity == null) {
            return null;
        }
        return ClassDTO.builder()
                .id(entity.getId())
                .classCode(entity.getClassCode())
                .title(entity.getTitle())
                .subject(entity.getSubject())
                .grade(entity.getGrade())
                .mode(entity.getMode())
                .status(entity.getStatus())
                .sessionsPerWeek(entity.getSessionsPerWeek())
                .sessionDurationMin(entity.getSessionDurationMin())
                .tutorFee(entity.getTutorFee())
                .startDate(entity.getStartDate())
                .learningStartDate(entity.getLearningStartDate())
                .endDate(entity.getEndDate())
                .schedule(entity.getSchedule())
                .address(entity.getAddress())
                .description(entity.getDescription())

                .build();
    }
}
