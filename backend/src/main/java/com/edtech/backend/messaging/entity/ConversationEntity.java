package com.edtech.backend.messaging.entity;

import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.entity.UserEntity;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "conversations")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ConversationEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true) // 1 user has 1 conversation with admin
    private UserEntity user;

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
    @Builder.Default
    private int unreadCountAdmin = 0;

    @Column(name = "unread_count_user")
    @Builder.Default
    private int unreadCountUser = 0;

    @Column(name = "is_closed")
    @Builder.Default
    private boolean isClosed = false;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
