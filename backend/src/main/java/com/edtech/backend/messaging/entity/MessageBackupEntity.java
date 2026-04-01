package com.edtech.backend.messaging.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "message_backups")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MessageBackupEntity {

    @Id
    private UUID id;

    @Column(name = "conversation_id", nullable = false)
    private UUID conversationId;

    @Column(name = "sender_id", nullable = false)
    private UUID senderId;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(name = "message_type")
    private String messageType;

    @Column(name = "is_read")
    private boolean isRead;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "archived_at", updatable = false)
    private LocalDateTime archivedAt;
}
