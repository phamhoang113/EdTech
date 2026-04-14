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
import com.edtech.backend.teaching.enums.AssessmentType;

/**
 * Bài tập / Đề kiểm tra.
 *
 * - HOMEWORK: chỉ có closes_at (deadline), không cần opens_at.
 * - EXAM: bắt buộc opens_at + duration_min, closes_at tự tính.
 */
@Entity
@Table(name = "assessments")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AssessmentEntity extends BaseEntity {

    @Column(name = "class_id", nullable = false)
    private UUID classId;

    @Column(name = "created_by", nullable = false)
    private UUID createdBy;

    @Column(nullable = false)
    private String title;

    private String description;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(nullable = false)
    private AssessmentType type;

    @Column(name = "opens_at")
    private Instant opensAt;

    @Column(name = "closes_at")
    private Instant closesAt;

    @Column(name = "duration_min")
    private Integer durationMin;

    @Column(name = "total_score", nullable = false)
    @Builder.Default
    private BigDecimal totalScore = BigDecimal.valueOf(100);

    @Column(name = "pass_score")
    private BigDecimal passScore;

    /** File đề bài (upload bởi GS) */
    @Column(name = "attachment_url")
    private String attachmentUrl;

    @Column(name = "attachment_name")
    private String attachmentName;

    @Column(name = "solution_url")
    private String solutionUrl;

    @Column(name = "solution_text")
    private String solutionText;

    @Column(name = "is_published", nullable = false)
    @Builder.Default
    private Boolean isPublished = false;

    @Column(name = "is_deleted", nullable = false)
    @Builder.Default
    private Boolean isDeleted = false;
}
