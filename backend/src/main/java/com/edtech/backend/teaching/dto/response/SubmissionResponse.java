package com.edtech.backend.teaching.dto.response;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.teaching.entity.SubmissionEntity;
import com.edtech.backend.teaching.enums.SubmissionStatus;

@Getter
@Builder
public class SubmissionResponse {

    private UUID id;
    private UUID assessmentId;
    private UUID studentId;
    private SubmissionStatus status;
    private BigDecimal totalScore;
    private String tutorComment;
    private String fileName;
    private Long fileSize;
    private String downloadUrl;
    private String tutorFileName;
    private String tutorFileDownloadUrl;
    private Instant submittedAt;
    private Instant gradedAt;
    private Instant completedAt;
    private Instant createdAt;

    /** Tên HS (populated bởi service) */
    private String studentName;

    public static SubmissionResponse from(SubmissionEntity entity) {
        String downloadUrl = entity.getFileUrl() != null
                ? "/api/v1/submissions/" + entity.getId() + "/download"
                : null;
        String tutorDownloadUrl = entity.getTutorFileUrl() != null
                ? "/api/v1/submissions/" + entity.getId() + "/tutor-download"
                : null;

        return SubmissionResponse.builder()
                .id(entity.getId())
                .assessmentId(entity.getAssessmentId())
                .studentId(entity.getStudentId())
                .status(entity.getStatus())
                .totalScore(entity.getTotalScore())
                .tutorComment(entity.getTutorComment())
                .fileName(entity.getFileName())
                .fileSize(entity.getFileSize())
                .downloadUrl(downloadUrl)
                .tutorFileName(entity.getTutorFileName())
                .tutorFileDownloadUrl(tutorDownloadUrl)
                .submittedAt(entity.getSubmittedAt())
                .gradedAt(entity.getGradedAt())
                .completedAt(entity.getCompletedAt())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
