package com.edtech.backend.messaging.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
public class SendMessageRequest {
    @NotBlank(message = "Nội dung tin nhắn không được để trống")
    private String content;
    
    // Optional, used when admin wants to start a conversation with a specific user
    // Or if conversation logic requires sending to a specific conversation ID.
    // If sent by user, conversationId is looked up implicitly.
    private UUID conversationId;
    private UUID targetUserId;
    private String messageType = "TEXT";
}
