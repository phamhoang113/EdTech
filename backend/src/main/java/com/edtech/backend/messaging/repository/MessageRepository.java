package com.edtech.backend.messaging.repository;

import com.edtech.backend.messaging.entity.MessageEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface MessageRepository extends JpaRepository<MessageEntity, UUID> {

    Page<MessageEntity> findByConversationIdOrderByCreatedAtDesc(UUID conversationId, Pageable pageable);

    @Modifying
    @Query("UPDATE MessageEntity m SET m.isRead = true WHERE m.conversation.id = :conversationId AND m.isRead = false AND m.sender.id != :readerId")
    void markMessagesAsRead(UUID conversationId, UUID readerId);

    List<MessageEntity> findByConversationIdIn(List<UUID> conversationIds);

    @Modifying
    @Query("DELETE FROM MessageEntity m WHERE m.conversation.id IN :conversationIds")
    void deleteByConversationIdIn(List<UUID> conversationIds);
}
