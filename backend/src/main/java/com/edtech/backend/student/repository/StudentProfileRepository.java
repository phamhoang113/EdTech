package com.edtech.backend.student.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.edtech.backend.student.entity.StudentProfileEntity;

@Repository
public interface StudentProfileRepository extends JpaRepository<StudentProfileEntity, UUID> {

    /** Tất cả con em của một phụ huynh (chưa xoá) */
    @Query("SELECT s FROM StudentProfileEntity s JOIN FETCH s.user u WHERE s.parentId = :parentId AND u.isDeleted = false ORDER BY u.createdAt")
    List<StudentProfileEntity> findByParentIdAndNotDeleted(@Param("parentId") UUID parentId);

    /** Tìm profile theo id + parentId (bảo vệ PH xem hồ sơ con người khác) */
    @Query("SELECT s FROM StudentProfileEntity s JOIN FETCH s.user u WHERE s.id = :id AND s.parentId = :parentId AND u.isDeleted = false")
    Optional<StudentProfileEntity> findByIdAndParentId(@Param("id") UUID id, @Param("parentId") UUID parentId);

    /** Tìm profile theo userId + parentId (kiểm tra đã liên kết chưa) */
    @Query("SELECT s FROM StudentProfileEntity s WHERE s.user.id = :userId AND s.parentId = :parentId")
    Optional<StudentProfileEntity> findByUserIdAndParentId(@Param("userId") UUID userId, @Param("parentId") UUID parentId);

    /** Tìm tất cả profile (liên kết) của học sinh */
    List<StudentProfileEntity> findByUserId(UUID userId);

    /** Đếm số PH khác đang liên kết với học sinh (để quyết định có soft-delete user không) */
    @Query("SELECT COUNT(s) FROM StudentProfileEntity s WHERE s.user.id = :userId AND s.parentId != :excludeParentId")
    long countByUserIdExcludingParent(@Param("userId") UUID userId, @Param("excludeParentId") UUID excludeParentId);
}
