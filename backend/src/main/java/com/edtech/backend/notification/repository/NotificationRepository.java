package com.edtech.backend.notification.repository;

import com.edtech.backend.notification.entity.NotificationEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface NotificationRepository extends JpaRepository<NotificationEntity, UUID> {

    @Query("SELECT n FROM NotificationEntity n " +
           "JOIN FETCH n.recipient r " +
           "WHERE r.id = :recipientId " +
           "ORDER BY n.createdAt DESC")
    Page<NotificationEntity> findByRecipientIdOrderByCreatedAtDesc(@Param("recipientId") UUID recipientId, Pageable pageable);

    @Query("SELECT COUNT(n) FROM NotificationEntity n " +
           "WHERE n.recipient.id = :recipientId AND n.isRead = false")
    long countUnreadByRecipientId(@Param("recipientId") UUID recipientId);
    
    @Modifying
    @Query("UPDATE NotificationEntity n SET n.isRead = true, n.readAt = CURRENT_TIMESTAMP " +
           "WHERE n.recipient.id = :recipientId AND n.isRead = false")
    int markAllAsRead(@Param("recipientId") UUID recipientId);
}
