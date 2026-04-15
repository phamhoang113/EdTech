package com.edtech.backend.ai.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.edtech.backend.ai.entity.AiConversationEntity;

public interface AiConversationRepository extends JpaRepository<AiConversationEntity, UUID> {
    List<AiConversationEntity> findByStudentIdOrderByCreatedAtDesc(UUID studentId);
}
