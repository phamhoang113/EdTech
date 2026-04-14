package com.edtech.backend.teaching.repository;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.edtech.backend.teaching.entity.AssessmentEntity;
import com.edtech.backend.teaching.enums.AssessmentType;

public interface AssessmentRepository extends JpaRepository<AssessmentEntity, UUID> {

    List<AssessmentEntity> findByClassIdAndIsDeletedFalseOrderByCreatedAtDesc(UUID classId);

    List<AssessmentEntity> findByClassIdAndTypeAndIsDeletedFalseOrderByCreatedAtDesc(UUID classId, AssessmentType type);

    /** Tìm assessments published, chưa xóa, thuộc danh sách lớp */
    List<AssessmentEntity> findByClassIdInAndIsPublishedTrueAndIsDeletedFalse(List<UUID> classIds);

    /** Tìm HOMEWORK có deadline (closes_at) trong khoảng thời gian */
    @Query("SELECT a FROM AssessmentEntity a WHERE a.type = 'HOMEWORK' AND a.isPublished = true " +
           "AND a.isDeleted = false AND a.closesAt BETWEEN :start AND :end")
    List<AssessmentEntity> findHomeworkWithDeadlineBetween(
            @Param("start") Instant start, @Param("end") Instant end);

    /** Tìm EXAM có opens_at trong khoảng thời gian (cho scheduler nhắc nhở) */
    @Query("SELECT a FROM AssessmentEntity a WHERE a.type = 'EXAM' AND a.isPublished = true " +
           "AND a.isDeleted = false AND a.opensAt BETWEEN :start AND :end")
    List<AssessmentEntity> findExamsStartingBetween(
            @Param("start") Instant start, @Param("end") Instant end);
}
