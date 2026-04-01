package com.edtech.backend.cls.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * Một slot trong lịch mẫu: ngày trong tuần + giờ bắt đầu/kết thúc.
 * VD: {"dayOfWeek": "T3", "startTime": "08:00", "endTime": "10:00"}
 */
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ScheduleSlotDTO {
    private String dayOfWeek;   // T2, T3, T4, T5, T6, T7, CN
    private String startTime;   // HH:mm
    private String endTime;     // HH:mm
}
