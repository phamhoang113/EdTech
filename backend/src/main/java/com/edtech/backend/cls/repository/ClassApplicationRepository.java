package com.edtech.backend.cls.repository;

import com.edtech.backend.cls.entity.ClassApplicationEntity;
import com.edtech.backend.cls.enums.ApplicationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ClassApplicationRepository extends JpaRepository<ClassApplicationEntity, UUID> {

    Optional<ClassApplicationEntity> findByClassIdAndTutorId(UUID classId, UUID tutorId);

    boolean existsByClassIdAndTutorId(UUID classId, UUID tutorId);

    List<ClassApplicationEntity> findByClassId(UUID classId);

    List<ClassApplicationEntity> findByTutorId(UUID tutorId);

    List<ClassApplicationEntity> findByStatus(ApplicationStatus status);

    List<ClassApplicationEntity> findByClassIdAndStatus(UUID classId, ApplicationStatus status);

    /** Xóa tất cả đơn PENDING của 1 lớp (không phải đơn vừa approved) */
    List<ClassApplicationEntity> findByClassIdAndStatusAndTutorIdNot(UUID classId, ApplicationStatus status, UUID excludeTutorId);

    /** Đếm số đơn theo tutorId và status */
    long countByTutorIdAndStatus(UUID tutorId, ApplicationStatus status);

    /** Đếm số đơn theo classId và status */
    long countByClassIdAndStatus(UUID classId, ApplicationStatus status);

    /** Kiểm tra có đơn theo classId và status không */
    boolean existsByClassIdAndStatus(UUID classId, ApplicationStatus status);

    /** Đếm tổng số đơn theo status */
    long countByStatus(ApplicationStatus status);
}
