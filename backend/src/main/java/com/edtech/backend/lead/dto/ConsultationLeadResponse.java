package com.edtech.backend.lead.dto;

import java.time.Instant;
import java.util.UUID;

import com.edtech.backend.lead.entity.ConsultationLeadEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConsultationLeadResponse {

    private UUID id;
    private String name;
    private String phone;
    private Boolean isContacted;
    private Instant createdAt;

    public static ConsultationLeadResponse fromEntity(ConsultationLeadEntity entity) {
        return ConsultationLeadResponse.builder()
                .id(entity.getId())
                .name(entity.getName())
                .phone(entity.getPhone())
                .isContacted(entity.getIsContacted())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
