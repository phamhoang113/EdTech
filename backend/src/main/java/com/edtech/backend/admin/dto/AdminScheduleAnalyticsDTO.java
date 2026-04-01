package com.edtech.backend.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminScheduleAnalyticsDTO {
    private long totalSessions;          // Tổng số buổi trong tháng
    private long makeupNeededSessions;   // Buổi thiếu (bị hủy và cần bù lịch)
    private long extraSessions;          // Buổi tăng cường (SessionType.EXTRA)

    private long totalParentRevenue;     // Tổng chi phí phụ huynh đã thanh toán
    private long totalTutorSalary;       // Tổng lương gia sư chi ra
}
