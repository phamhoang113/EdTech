package com.edtech.backend.teaching.dto.response;

import java.time.Instant;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.teaching.entity.MaterialEntity;
import com.edtech.backend.teaching.enums.MaterialType;

@Getter
@Builder
public class MaterialResponse {

    private UUID id;
    private UUID classId;
    private UUID uploadedBy;
    private String title;
    private String description;
    private MaterialType type;
    private String fileName;
    private String mimeType;
    private Long fileSize;
    private String downloadUrl;
    private Instant createdAt;

    public static MaterialResponse from(MaterialEntity entity) {
        return MaterialResponse.builder()
                .id(entity.getId())
                .classId(entity.getClassId())
                .uploadedBy(entity.getUploadedBy())
                .title(entity.getTitle())
                .description(entity.getDescription())
                .type(entity.getType())
                .fileName(entity.getFileName())
                .mimeType(entity.getMimeType())
                .fileSize(entity.getFileSize())
                .downloadUrl("/api/v1/materials/" + entity.getId() + "/download")
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
