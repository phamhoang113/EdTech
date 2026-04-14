package com.edtech.backend.teaching.enums;

/**
 * Lifecycle trạng thái bài nộp.
 * DRAFT → SUBMITTED → REVIEWING → GRADED → COMPLETED → ARCHIVED
 *
 * ARCHIVED: file vật lý đã bị xóa (auto-cleanup), chỉ giữ metadata (điểm, comment).
 */
public enum SubmissionStatus {
    DRAFT,
    SUBMITTED,
    REVIEWING,
    GRADED,
    COMPLETED,
    ARCHIVED
}
