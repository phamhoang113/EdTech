package com.edtech.backend.messaging.entity;

import com.edtech.backend.auth.enums.UserRole;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "conversation_backups")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ConversationBackupEntity {

    @Id
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Enumerated(EnumType.STRING)
    @Column(name = "user_role", nullable = false)
    private UserRole userRole;

    @Column(name = "last_message_preview")
    private String lastMessagePreview;

    @Column(name = "last_message_at")
    private LocalDateTime lastMessageAt;

    @Column(name = "last_message_sender_name")
    private String lastMessageSenderName;

    @Column(name = "unread_count_admin")
    private int unreadCountAdmin;

    @Column(name = "unread_count_user")
    private int unreadCountUser;

    @Column(name = "is_closed")
    private boolean isClosed;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "archived_at", updatable = false)
    private LocalDateTime archivedAt;
}
