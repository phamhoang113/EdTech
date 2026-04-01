package com.edtech.backend.messaging.dto;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Builder
public class MessageResponseDTO {
    private UUID id;
    private UUID conversationId;
    private UUID senderId;
    private String senderName;
    private String content;
    private String messageType;
    private boolean isRead;
    private LocalDateTime createdAt;
}
