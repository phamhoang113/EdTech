package com.edtech.backend.ai.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.edtech.backend.ai.entity.AiSubscriptionEntity;

public interface AiSubscriptionRepository extends JpaRepository<AiSubscriptionEntity, UUID> {
    Optional<AiSubscriptionEntity> findByStudentId(UUID studentId);
}
