package com.edtech.backend.ai.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.edtech.backend.ai.entity.AiMessageEntity;

public interface AiMessageRepository extends JpaRepository<AiMessageEntity, UUID> {
    List<AiMessageEntity> findByConversationIdOrderByCreatedAtAsc(UUID conversationId);
}
