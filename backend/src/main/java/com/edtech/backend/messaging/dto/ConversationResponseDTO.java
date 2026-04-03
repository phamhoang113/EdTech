package com.edtech.backend.messaging.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.auth.enums.UserRole;

@Getter
@Builder
public class ConversationResponseDTO {
    private UUID id;
    private UUID userId;
    private String userFullName;
    private String userAvatarBase64;
    private UserRole userRole;
    private String lastMessagePreview;
    private String lastMessageSenderName;
    private LocalDateTime lastMessageAt;
    private int unreadCountAdmin;
    private int unreadCountUser;
    private boolean isClosed;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
