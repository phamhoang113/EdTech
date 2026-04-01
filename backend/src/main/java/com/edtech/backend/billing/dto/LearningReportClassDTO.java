package com.edtech.backend.billing.dto;

import com.edtech.backend.cls.dto.SessionDTO;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LearningReportClassDTO {
    private UUID classId;
    private String classCode;
    private String classTitle;
    private String subject;
    
    // For parents to know which child this report is for (if querying 'All children')
    private UUID studentId;
    private String studentName;
    private String tutorName;

    // Running totals for the selected month
    private int totalSessionsMonth;
    private int completedSessionsMonth;
    private int cancelledSessionsMonth;

    // Current unbilled amount (Tam Tinh)
    private java.math.BigDecimal estimatedFeeMonth;

    private List<SessionDTO> sessionsMonth;
}
