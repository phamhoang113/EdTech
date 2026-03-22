package com.edtech.backend.cls.repository;

import com.edtech.backend.cls.entity.SessionAttendanceEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface SessionAttendanceRepository extends JpaRepository<SessionAttendanceEntity, UUID> {
    List<SessionAttendanceEntity> findBySessionId(UUID sessionId);
    List<SessionAttendanceEntity> findByStudentId(UUID studentId);
}
