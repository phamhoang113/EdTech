package com.edtech.backend.cls.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * Request body cho GS set/update lịch mẫu của lớp.
 */
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SetScheduleRequest {
    private List<ScheduleSlotDTO> slots;
}
