package com.edtech.backend.cls.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.edtech.backend.cls.entity.SessionAttendanceEntity;

public interface SessionAttendanceRepository extends JpaRepository<SessionAttendanceEntity, UUID> {
    List<SessionAttendanceEntity> findBySessionId(UUID sessionId);
    List<SessionAttendanceEntity> findByStudentId(UUID studentId);
}
