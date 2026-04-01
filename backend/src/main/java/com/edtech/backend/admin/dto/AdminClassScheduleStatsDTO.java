package com.edtech.backend.admin.dto;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class AdminClassScheduleStatsDTO {
    Integer totalSessions;
    Integer completedSessions;
    Integer upcomingSessions;
    
    Integer regularCount;
    Integer makeupCount;
    Integer extraCount;
    
    Integer cancelledCount;
    Integer pendingMakeupCount;
}
