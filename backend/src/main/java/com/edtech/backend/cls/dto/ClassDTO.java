package com.edtech.backend.cls.dto;

import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.ClassMode;
import com.edtech.backend.cls.enums.ClassStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClassDTO {
    private UUID id;
    private String title;
    private String subject;
    private String grade;
    private ClassMode mode;
    private ClassStatus status;
    private Integer sessionsPerWeek;
    private Integer sessionDurationMin;
    private BigDecimal tutorFee;
    private LocalDate startDate;
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
                .title(entity.getTitle())
                .subject(entity.getSubject())
                .grade(entity.getGrade())
                .mode(entity.getMode())
                .status(entity.getStatus())
                .sessionsPerWeek(entity.getSessionsPerWeek())
                .sessionDurationMin(entity.getSessionDurationMin())
                .tutorFee(entity.getTutorFee())
                .startDate(entity.getStartDate())
                .endDate(entity.getEndDate())
                .schedule(entity.getSchedule())
                .address(entity.getAddress())
                .description(entity.getDescription())
                .build();
    }
}
