package com.edtech.backend.cls.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.ClassStatus;

@Repository
public interface ClassRepository extends JpaRepository<ClassEntity, UUID> {

    @Modifying
    @Query("UPDATE ClassEntity c SET c.parentId = :newParentId WHERE c.parentId = :studentId")
    void migrateParentId(@Param("studentId") UUID studentId, @Param("newParentId") UUID newParentId);

    long countByStudents_IdAndStatusInAndIsDeletedFalse(UUID studentId, List<ClassStatus> statuses);

    // ─── Tutor open classes ──────────────────────────────────────────────────
    List<ClassEntity> findByStatusAndIsDeletedFalseOrderByCreatedAtDesc(ClassStatus status);

    @Query("SELECT c FROM ClassEntity c WHERE c.status = :status AND c.isDeleted = false AND (:includeMock = true OR c.isMock = false) ORDER BY c.isMock ASC, c.createdAt DESC")
    List<ClassEntity> findPublicOpenClasses(@Param("status") ClassStatus status, @Param("includeMock") boolean includeMock);

    /** Đếm số lớp đang dạy của 1 gia sư */
    long countByTutorIdAndStatusAndIsDeletedFalse(UUID tutorId, ClassStatus status);

    /** Tìm lớp đang được giao cho 1 gia sư theo trạng thái */
    List<ClassEntity> findByTutorIdAndStatusAndIsDeletedFalse(UUID tutorId, ClassStatus status);

    /** Tất cả lớp của GS (chưa xóa) — dùng cho schedule events + teaching screen */
    List<ClassEntity> findByTutorIdAndIsDeletedFalseOrderByCreatedAtDesc(UUID tutorId);

    // ─── Admin queries ───────────────────────────────────────────────────────

    /** Tất cả lớp (chưa xóa) sắp xếp mới nhất trước */
    List<ClassEntity> findByIsDeletedFalseOrderByCreatedAtDesc();

    /** Tất cả lớp theo trạng thái (chưa xóa) */
    List<ClassEntity> findByStatusAndIsDeletedFalse(ClassStatus status);

    /** Đếm lớp theo trạng thái (chưa xóa) */
    long countByStatusAndIsDeletedFalse(ClassStatus status);

    /** Lấy tất cả lớp của 1 phụ huynh (chưa xóa) */
    List<ClassEntity> findByParentIdAndIsDeletedFalseOrderByCreatedAtDesc(UUID parentId);

    /** Lấy tất cả lớp mà học sinh ĐANG HỌC (chưa xóa) */
    List<ClassEntity> findByStudents_IdAndIsDeletedFalseOrderByCreatedAtDesc(UUID studentId);

    /** Tìm lớp OPEN đã hết hạn endDate (dùng cho scheduler auto-close) */
    List<ClassEntity> findByStatusAndEndDateBeforeAndIsDeletedFalse(ClassStatus status, LocalDate date);

    /** Tìm tất cả lớp của GS theo danh sách trạng thái (chưa xóa) */
    List<ClassEntity> findByTutorIdAndStatusInAndIsDeletedFalse(UUID tutorId, List<ClassStatus> statuses);

    /** Tìm lớp theo keyword (mã lớp, tiêu đề, hoặc môn chứa keyword) */
    @Query("SELECT c FROM ClassEntity c WHERE c.isDeleted = false " +
           "AND (LOWER(c.classCode) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "OR LOWER(c.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "OR LOWER(c.subject) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<ClassEntity> searchByKeyword(@Param("keyword") String keyword);
}
