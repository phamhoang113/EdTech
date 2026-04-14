package com.edtech.backend.teaching.dto.response;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Getter;
import lombok.extern.jackson.Jacksonized;

/**
 * DTO thống nhất cho calendar events: session + deadline + exam.
 */
@Getter
@Builder
@Jacksonized
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ScheduleEventResponse {
    private final String type; // SESSION | HOMEWORK_DEADLINE | EXAM
    private final String title;
    private final String date;
    private final String startTime;
    private final String endTime;
    private final Integer durationMin;
    private final String className;
    private final String assessmentId;
    private final String submissionStatus;
    private final String status;
    private final Instant createdAt;
}
