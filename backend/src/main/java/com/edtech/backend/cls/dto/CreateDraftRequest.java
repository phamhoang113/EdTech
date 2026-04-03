package com.edtech.backend.cls.dto;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CreateDraftRequest {
    private UUID classId;
    private LocalDate sessionDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private UUID makeupForSessionId;
}
