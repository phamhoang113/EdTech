package com.edtech.backend.cls.repository;

import com.edtech.backend.cls.entity.AbsenceRequestEntity;
import com.edtech.backend.cls.enums.AbsenceRequestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;
import java.util.UUID;

@Repository
public interface AbsenceRequestRepository extends JpaRepository<AbsenceRequestEntity, UUID> {

    @Query("SELECT ar.session.id FROM AbsenceRequestEntity ar WHERE ar.session.id IN :sessionIds AND ar.status = :status")
    Set<UUID> findSessionIdsWithStatus(@Param("sessionIds") List<UUID> sessionIds, @Param("status") AbsenceRequestStatus status);

    long countByStatus(AbsenceRequestStatus status);
}
