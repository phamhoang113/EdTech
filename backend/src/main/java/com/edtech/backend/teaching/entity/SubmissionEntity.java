package com.edtech.backend.teaching.entity;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.edtech.backend.core.entity.BaseEntity;
import com.edtech.backend.teaching.enums.SubmissionStatus;

/**
 * Bài nộp (HS nộp cho GS).
 *
 * Lifecycle: DRAFT → SUBMITTED → REVIEWING → GRADED → COMPLETED → ARCHIVED
 * - COMPLETED: GS đánh dấu hoàn thành, bắt đầu countdown 7 ngày cleanup.
 * - ARCHIVED: file vật lý đã xóa, chỉ giữ metadata.
 */
@Entity
@Table(name = "submissions")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SubmissionEntity extends BaseEntity {

    @Column(name = "assessment_id", nullable = false)
    private UUID assessmentId;

    @Column(name = "student_id", nullable = false)
    private UUID studentId;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(nullable = false)
    @Builder.Default
    private SubmissionStatus status = SubmissionStatus.DRAFT;

    @Column(name = "total_score")
    private BigDecimal totalScore;

    @Column(name = "tutor_comment")
    private String tutorComment;

    /** File bài nộp (HS upload) */
    @Column(name = "file_url")
    private String fileUrl;

    @Column(name = "file_name")
    private String fileName;

    @Column(name = "file_size")
    private Long fileSize;

    /** File bài sửa (GS upload cho HS) */
    @Column(name = "tutor_file_url")
    private String tutorFileUrl;

    @Column(name = "tutor_file_name")
    private String tutorFileName;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "student_attachments", columnDefinition = "jsonb")
    @Builder.Default
    private java.util.List<AttachmentInfo> studentAttachments = new java.util.ArrayList<>();

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "tutor_attachments", columnDefinition = "jsonb")
    @Builder.Default
    private java.util.List<AttachmentInfo> tutorAttachments = new java.util.ArrayList<>();

    @Column(name = "submitted_at")
    private Instant submittedAt;

    @Column(name = "graded_at")
    private Instant gradedAt;

    @Column(name = "graded_by")
    private UUID gradedBy;

    // ─── Lifecycle tracking cho auto-cleanup ───

    @Column(name = "completed_at")
    private Instant completedAt;

    @Column(name = "last_interaction_at")
    @Builder.Default
    private Instant lastInteractionAt = Instant.now();

    @Column(name = "files_cleaned", nullable = false)
    @Builder.Default
    private Boolean filesCleaned = false;
}
