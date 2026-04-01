package com.edtech.backend.cls.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

@Getter
@Setter
public class CreateDraftRequest {
    private UUID classId;
    private LocalDate sessionDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private UUID makeupForSessionId;
}
