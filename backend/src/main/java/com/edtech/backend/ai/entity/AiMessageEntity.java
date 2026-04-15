package com.edtech.backend.ai.entity;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import com.edtech.backend.ai.enums.AiMessageRole;
import com.edtech.backend.core.entity.BaseEntity;

/**
 * Một tin nhắn trong conversation AI.
 * Role USER = học sinh, ASSISTANT = Gemini.
 */
@Entity
@Table(name = "ai_message")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiMessageEntity extends BaseEntity {

    @Column(name = "conversation_id", nullable = false)
    private UUID conversationId;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(nullable = false)
    private AiMessageRole role;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    /** URL ảnh nếu HS gửi ảnh (camera solver) */
    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "tokens_used")
    @Builder.Default
    private Integer tokensUsed = 0;
}
