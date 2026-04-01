package com.edtech.backend.cls.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

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
