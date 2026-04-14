package com.edtech.backend.teaching.dto.response;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Getter;
import lombok.extern.jackson.Jacksonized;

/**
 * DTO tổng hợp tiến độ học tập — PH dashboard.
 */
@Getter
@Builder
@Jacksonized
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProgressSummaryResponse {

    /** Điểm trung bình bài tập (chỉ tính bài đã chấm) */
    private final Double homeworkAvgScore;

    /** Điểm trung bình kiểm tra (chỉ tính bài đã chấm) */
    private final Double examAvgScore;

    /** Số bài tập chưa nộp */
    private final int pendingHomeworkCount;

    /** Số bài kiểm tra sắp tới (closesAt > now) */
    private final int upcomingExamCount;

    /** Tổng bài tập */
    private final int totalHomework;

    /** Tổng kiểm tra */
    private final int totalExam;

    /** Chi tiết từng assessment */
    private final List<StudentProgressResponse> details;
}
