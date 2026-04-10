package com.edtech.backend.auth.repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, UUID> {
    Optional<UserEntity> findByPhoneAndIsDeletedFalse(String phone);
    boolean existsByPhoneAndIsDeletedFalse(String phone);
    Optional<UserEntity> findByUsernameAndIsDeletedFalse(String username);

    /** Tìm user theo username (định danh đăng nhập duy nhất) */
    @Query("SELECT u FROM UserEntity u WHERE u.username = :identifier AND u.isDeleted = false")
    Optional<UserEntity> findByIdentifierAndIsDeletedFalse(@Param("identifier") String identifier);

    long countByIsDeletedFalse();
    long countByRoleAndIsDeletedFalse(UserRole role);

    /** Đếm user đăng ký trong khoảng thời gian (chưa xóa) */
    @Query("SELECT COUNT(u) FROM UserEntity u WHERE u.isDeleted = false AND u.createdAt >= :from AND u.createdAt < :to")
    long countByCreatedAtBetween(@Param("from") Instant from, @Param("to") Instant to);

    /** Lấy tất cả user chưa xóa, mới nhất trước */
    List<UserEntity> findAllByIsDeletedFalseOrderByCreatedAtDesc();

    /** Lấy user theo role, chưa xóa, mới nhất trước */
    List<UserEntity> findByRoleAndIsDeletedFalseOrderByCreatedAtDesc(UserRole role);

    /** Tìm user theo username + role */
    @Query("SELECT u FROM UserEntity u WHERE u.username = :identifier AND u.role = :role AND u.isDeleted = false")
    Optional<UserEntity> findByIdentifierAndRoleAndIsDeletedFalse(@Param("identifier") String identifier, @Param("role") UserRole role);

    /** Tìm user theo keyword (tên hoặc SĐT chứa keyword) */
    @Query("SELECT u FROM UserEntity u WHERE u.isDeleted = false AND u.role = :role " +
           "AND (LOWER(u.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "OR u.phone LIKE CONCAT('%', :keyword, '%'))")
    List<UserEntity> searchByKeywordAndRole(
            @Param("keyword") String keyword,
            @Param("role") UserRole role);
}
