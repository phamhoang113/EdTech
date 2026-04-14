package com.edtech.backend.teaching.repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.edtech.backend.teaching.entity.SubmissionEntity;
import com.edtech.backend.teaching.enums.SubmissionStatus;

public interface SubmissionRepository extends JpaRepository<SubmissionEntity, UUID> {

    List<SubmissionEntity> findByAssessmentIdOrderBySubmittedAtDesc(UUID assessmentId);

    Optional<SubmissionEntity> findByAssessmentIdAndStudentId(UUID assessmentId, UUID studentId);

    /** Đếm số bài đã nộp cho 1 assessment */
    long countByAssessmentIdAndStatusNot(UUID assessmentId, SubmissionStatus excludeStatus);

    /** Tìm HS đã nộp bài cho 1 assessment */
    List<SubmissionEntity> findByAssessmentIdAndStatus(UUID assessmentId, SubmissionStatus status);

    /** HS chưa nộp bài (dùng cho scheduler nhắc deadline) */
    @Query("SELECT s.studentId FROM SubmissionEntity s WHERE s.assessmentId = :assessmentId " +
           "AND s.status IN ('SUBMITTED', 'REVIEWING', 'GRADED', 'COMPLETED')")
    List<UUID> findSubmittedStudentIds(@Param("assessmentId") UUID assessmentId);

    /** File cleanup: tìm submissions cần xóa file */
    @Query("SELECT s FROM SubmissionEntity s WHERE s.filesCleaned = false AND (" +
           "(s.status = 'COMPLETED' AND s.completedAt < :cutoff) OR " +
           "(s.status IN ('SUBMITTED', 'REVIEWING', 'GRADED') AND s.lastInteractionAt < :cutoff))")
    List<SubmissionEntity> findSubmissionsForCleanup(@Param("cutoff") Instant cutoff);

    /** Tìm tất cả submissions của 1 student trong các assessments của 1 class */
    @Query("SELECT s FROM SubmissionEntity s JOIN AssessmentEntity a ON s.assessmentId = a.id " +
           "WHERE a.classId = :classId AND s.studentId = :studentId AND a.isDeleted = false " +
           "ORDER BY a.closesAt DESC")
    List<SubmissionEntity> findByClassIdAndStudentId(
            @Param("classId") UUID classId, @Param("studentId") UUID studentId);
}
