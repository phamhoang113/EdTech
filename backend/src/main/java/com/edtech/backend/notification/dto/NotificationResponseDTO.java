package com.edtech.backend.notification.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.notification.entity.NotificationType;

@Getter
@Builder
public class NotificationResponseDTO {
    private UUID id;
    private NotificationType type;
    private String title;
    private String body;
    private String entityType;
    private UUID entityId;
    private boolean isRead;
    private LocalDateTime readAt;
    private LocalDateTime createdAt;
}
