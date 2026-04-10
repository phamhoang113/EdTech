package com.edtech.backend.lead.dto;

import java.time.Instant;
import java.util.UUID;

import com.edtech.backend.lead.entity.ContactMessageEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ContactMessageResponse {

    private UUID id;
    private String name;
    private String email;
    private String subject;
    private String message;
    private Boolean isRead;
    private Instant createdAt;

    public static ContactMessageResponse fromEntity(ContactMessageEntity entity) {
        return ContactMessageResponse.builder()
                .id(entity.getId())
                .name(entity.getName())
                .email(entity.getEmail())
                .subject(entity.getSubject())
                .message(entity.getMessage())
                .isRead(entity.getIsRead())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
