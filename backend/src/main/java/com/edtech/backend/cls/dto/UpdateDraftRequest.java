package com.edtech.backend.cls.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * Request body cho GS chỉnh sửa 1 draft session.
 * Hỗ trợ: đổi giờ, đổi ngày (drag-drop), meet link, note.
 */
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateDraftRequest {
    private LocalDate sessionDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String meetLink;
    private String tutorNote;
}
