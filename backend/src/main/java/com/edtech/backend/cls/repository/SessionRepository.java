package com.edtech.backend.cls.repository;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.SessionStatus;

public interface SessionRepository extends JpaRepository<SessionEntity, UUID> {

    @Query("SELECT s FROM SessionEntity s WHERE s.cls.parentId = :parentId " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findByParentIdAndDateBetween(
            @Param("parentId") UUID parentId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Sort sort
    );

    @Query("SELECT s FROM SessionEntity s JOIN s.cls.students st " +
           "WHERE st.id = :studentId " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findByStudentIdAndDateBetween(
            @Param("studentId") UUID studentId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Sort sort
    );

    @Query("SELECT s FROM SessionEntity s WHERE s.cls.tutorId = :tutorId " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findByTutorIdAndDateBetween(
            @Param("tutorId") UUID tutorId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Sort sort
    );

    @Query("SELECT s FROM SessionEntity s WHERE s.cls.tutorId = :tutorId " +
           "AND s.status = :status " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findByTutorIdAndStatusAndDateBetween(
            @Param("tutorId") UUID tutorId,
            @Param("status") SessionStatus status,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Sort sort
    );

    @Query("SELECT s FROM SessionEntity s WHERE s.status = :status " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findByStatusAndSessionDateBetween(
            @Param("status") SessionStatus status,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

    @Query("SELECT s FROM SessionEntity s WHERE s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findBySessionDateBetween(
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Sort sort
    );

    @Query("SELECT s FROM SessionEntity s " +
           "JOIN s.cls c " +
           "LEFT JOIN UserEntity u ON c.tutorId = u.id " +
           "WHERE s.sessionDate >= :startDate AND s.sessionDate <= :endDate " +
           "AND (cast(:tutorId as uuid) IS NULL OR c.tutorId = :tutorId) " +
           "AND (cast(:classCode as text) IS NULL OR LOWER(c.classCode) LIKE LOWER(CONCAT('%', cast(:classCode as text), '%'))) " +
           "AND (cast(:tutorName as text) IS NULL OR LOWER(u.fullName) LIKE LOWER(CONCAT('%', cast(:tutorName as text), '%')))")
    List<SessionEntity> findByAdminAdvancedFilters(
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            @Param("tutorId") UUID tutorId,
            @Param("classCode") String classCode,
            @Param("tutorName") String tutorName,
            Sort sort
    );

    boolean existsByClsIdAndSessionDateAndStartTime(UUID clsId, LocalDate sessionDate, LocalTime startTime);

    List<SessionEntity> findByClsId(UUID classId, Sort sort);

    List<SessionEntity> findByClsIdIn(List<UUID> classIds);

    @Query("SELECT s FROM SessionEntity s WHERE s.cls.id = :classId " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findByClsIdAndSessionDateBetween(
            @Param("classId") UUID classId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

    @Query("SELECT s.cls.id, COUNT(s.id) " +
           "FROM SessionEntity s " +
           "WHERE s.status IN :statuses " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate " +
           "GROUP BY s.cls.id")
    List<Object[]> countSessionsByClassAndDateRange(
            @Param("statuses") List<SessionStatus> statuses,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

    /** Đếm số buổi GS nghỉ (CANCELLED_BY_TUTOR) theo class trong khoảng thời gian */
    @Query("SELECT s.cls.id, COUNT(s.id) " +
           "FROM SessionEntity s " +
           "WHERE s.status = :status " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate " +
           "GROUP BY s.cls.id")
    List<Object[]> countSessionsByStatusAndClassAndDateRange(
            @Param("status") SessionStatus status,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

    /** Đếm số buổi tăng cường (EXTRA) đã COMPLETED theo class trong khoảng thời gian */
    @Query("SELECT s.cls.id, COUNT(s.id) " +
           "FROM SessionEntity s " +
           "WHERE s.sessionType = :sessionType " +
           "AND s.status IN :statuses " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate " +
           "GROUP BY s.cls.id")
    List<Object[]> countSessionsByTypeAndStatusesAndClassAndDateRange(
            @Param("sessionType") com.edtech.backend.cls.enums.SessionType sessionType,
            @Param("statuses") List<SessionStatus> statuses,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

}
