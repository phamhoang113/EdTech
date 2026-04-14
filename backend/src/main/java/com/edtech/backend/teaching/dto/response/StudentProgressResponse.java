package com.edtech.backend.teaching.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Getter;
import lombok.extern.jackson.Jacksonized;

/**
 * DTO tiến độ học tập của HS — PH xem.
 */
@Getter
@Builder
@Jacksonized
@JsonInclude(JsonInclude.Include.NON_NULL)
public class StudentProgressResponse {
    private final String assessmentId;
    private final String assessmentTitle;
    private final String type; // HOMEWORK | EXAM
    private final String status; // PENDING | SUBMITTED | GRADED | COMPLETED
    private final Double score;
    private final Double totalScore;
    private final String tutorComment;
    private final String closesAt;
    private final String submittedAt;
    private final String gradedAt;
}
