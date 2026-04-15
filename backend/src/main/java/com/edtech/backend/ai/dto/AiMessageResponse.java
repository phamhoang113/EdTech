package com.edtech.backend.ai.dto;

import java.time.Instant;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.ai.entity.AiMessageEntity;
import com.edtech.backend.ai.enums.AiMessageRole;

@Getter
@Builder
public class AiMessageResponse {

    private UUID id;
    private AiMessageRole role;
    private String content;
    private String imageUrl;
    private Instant createdAt;

    public static AiMessageResponse from(AiMessageEntity entity) {
        return AiMessageResponse.builder()
                .id(entity.getId())
                .role(entity.getRole())
                .content(entity.getContent())
                .imageUrl(entity.getImageUrl())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
