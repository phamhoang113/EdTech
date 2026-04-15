package com.edtech.backend.ai.repository;

import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import com.edtech.backend.ai.entity.AiUsageLogEntity;

public interface AiUsageLogRepository extends JpaRepository<AiUsageLogEntity, UUID> {

    Optional<AiUsageLogEntity> findByStudentIdAndLogDate(UUID studentId, LocalDate logDate);

    @Modifying
    @Query("""
        INSERT INTO AiUsageLogEntity (studentId, logDate, messageCount)
        VALUES (:studentId, :logDate, 1)
        ON CONFLICT DO NOTHING
        """)
    void upsertIncrement(UUID studentId, LocalDate logDate);
}
