package com.edtech.backend.cls.repository;

import com.edtech.backend.cls.entity.SessionEntity;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface SessionRepository extends JpaRepository<SessionEntity, UUID> {

    @Query("SELECT s FROM SessionEntity s WHERE s.cls.parent.id = :parentId " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findByParentIdAndDateBetween(
            @Param("parentId") UUID parentId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Sort sort
    );

    @Query("SELECT s FROM SessionEntity s JOIN s.cls.studentClasses sc " +
           "WHERE sc.student.id = :studentId " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findByStudentIdAndDateBetween(
            @Param("studentId") UUID studentId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Sort sort
    );

    @Query("SELECT s FROM SessionEntity s WHERE s.cls.tutor.id = :tutorId " +
           "AND s.sessionDate >= :startDate AND s.sessionDate <= :endDate")
    List<SessionEntity> findByTutorIdAndDateBetween(
            @Param("tutorId") UUID tutorId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Sort sort
    );

    List<SessionEntity> findByClsId(UUID classId, Sort sort);

}
