package com.edtech.backend.cls.dto;

import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ClassQuotaDTO {
    private UUID classId;
    private String classCode;
    private String classTitle;
    private Integer targetSessions;
    private Integer regularSessions;
    private Integer makeupSessions;
    private Integer extraSessions;
    private Integer missingCount;
    private Integer excessCount;
}
