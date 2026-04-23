package com.edtech.backend.ai.dto;

import java.time.Instant;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.ai.entity.AiConversationEntity;

@Getter
@Builder
public class AiConversationResponse {

    private UUID id;
    private String title;
    private String subject;
    private String grade;
    private String learningGoal;
    private Instant createdAt;
    private Instant updatedAt;

    public static AiConversationResponse from(AiConversationEntity entity) {
        return AiConversationResponse.builder()
                .id(entity.getId())
                .title(entity.getTitle())
                .subject(entity.getSubject())
                .grade(entity.getGrade())
                .learningGoal(entity.getLearningGoal())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }
}
