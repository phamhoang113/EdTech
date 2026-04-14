package com.edtech.backend.teaching.dto.response;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.teaching.entity.AssessmentEntity;
import com.edtech.backend.teaching.enums.AssessmentType;

@Getter
@Builder
public class AssessmentResponse {

    private UUID id;
    private UUID classId;
    private UUID createdBy;
    private String title;
    private String description;
    private AssessmentType type;
    private Instant opensAt;
    private Instant closesAt;
    private Integer durationMin;
    private BigDecimal totalScore;
    private BigDecimal passScore;
    private String attachmentName;
    private String attachmentDownloadUrl;
    private Boolean isPublished;
    private Instant createdAt;

    /** Tổng hợp bài nộp (chỉ GS thấy) */
    private Long submittedCount;
    private Long totalStudents;

    public static AssessmentResponse from(AssessmentEntity entity) {
        String downloadUrl = entity.getAttachmentUrl() != null
                ? "/api/v1/assessments/" + entity.getId() + "/attachment"
                : null;

        return AssessmentResponse.builder()
                .id(entity.getId())
                .classId(entity.getClassId())
                .createdBy(entity.getCreatedBy())
                .title(entity.getTitle())
                .description(entity.getDescription())
                .type(entity.getType())
                .opensAt(entity.getOpensAt())
                .closesAt(entity.getClosesAt())
                .durationMin(entity.getDurationMin())
                .totalScore(entity.getTotalScore())
                .passScore(entity.getPassScore())
                .attachmentName(entity.getAttachmentName())
                .attachmentDownloadUrl(downloadUrl)
                .isPublished(entity.getIsPublished())
                .createdAt(entity.getCreatedAt())
                .build();
    }

    public static AssessmentResponse from(AssessmentEntity entity, long submittedCount, long totalStudents) {
        AssessmentResponse response = from(entity);
        response.submittedCount = submittedCount;
        response.totalStudents = totalStudents;
        return response;
    }
}
