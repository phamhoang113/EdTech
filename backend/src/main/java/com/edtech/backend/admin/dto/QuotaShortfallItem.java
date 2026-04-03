package com.edtech.backend.admin.dto;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuotaShortfallItem {
    private UUID classId;
    private String classCode;
    private String classTitle;
    private String subject;
    private UUID tutorId;
    private String tutorName;
    private int sessionsPerWeek;
    private int activeThisWeek;
    private int missingCount;
    private int extraCount;
}
