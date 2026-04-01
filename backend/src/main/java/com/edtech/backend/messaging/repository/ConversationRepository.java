package com.edtech.backend.messaging.repository;

import com.edtech.backend.messaging.entity.ConversationEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface ConversationRepository extends JpaRepository<ConversationEntity, UUID> {

    Optional<ConversationEntity> findByUserId(UUID userId);

    Page<ConversationEntity> findAllByOrderByLastMessageAtDesc(Pageable pageable);

    Page<ConversationEntity> findByUserIdOrderByLastMessageAtDesc(UUID userId, Pageable pageable);

    @Query("SELECT SUM(c.unreadCountAdmin) FROM ConversationEntity c WHERE c.unreadCountAdmin > 0")
    Long sumUnreadCountAdmin();

    @Query("SELECT c.unreadCountUser FROM ConversationEntity c WHERE c.user.id = :userId")
    Long getUnreadCountUser(UUID userId);

    @Query("SELECT c FROM ConversationEntity c WHERE (c.lastMessageAt IS NOT NULL AND c.lastMessageAt < :threshold) OR (c.lastMessageAt IS NULL AND c.updatedAt < :threshold)")
    java.util.List<ConversationEntity> findIdleConversations(java.time.LocalDateTime threshold);
}
