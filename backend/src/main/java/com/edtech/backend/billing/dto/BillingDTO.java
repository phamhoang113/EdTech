package com.edtech.backend.billing.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;
import java.util.stream.Collectors;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.billing.entity.BillingEntity;
import com.edtech.backend.billing.enums.BillingStatus;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BillingDTO {
    private UUID id;
    private UUID classId;
    private String classCode;
    private String classTitle;
    
    private UUID parentId;
    private String parentName;
    private String studentNames;

    private Integer month;
    private Integer year;
    
    private Integer totalSessions;
    private BigDecimal parentFeeAmount;
    private String transactionCode;
    private BillingStatus status;

    private UUID verifiedByAdminId;
    private Instant verifiedAt;
    private Instant createdAt;
    
    // VietQR integration field
    private String qrDataStr; 
    
    // Bank info for manual transfer
    private String beneficiaryBank;
    private String beneficiaryAccount;
    private String beneficiaryName;

    // Helper map
    public static BillingDTO fromEntity(BillingEntity entity) {
        if (entity == null) return null;
        
        return BillingDTO.builder()
                .id(entity.getId())
                .classId(entity.getCls() != null ? entity.getCls().getId() : null)
                .classCode(entity.getCls() != null ? entity.getCls().getClassCode() : null)
                .classTitle(entity.getCls() != null ? entity.getCls().getTitle() : null)
                .parentId(entity.getParent() != null ? entity.getParent().getId() : null)
                .parentName(entity.getParent() != null ? entity.getParent().getFullName() : null)
                .studentNames(entity.getCls() != null && entity.getCls().getStudents() != null ? entity.getCls().getStudents().stream().map(UserEntity::getFullName).collect(Collectors.joining(", ")) : null)
                .month(entity.getMonth())
                .year(entity.getYear())
                .totalSessions(entity.getTotalSessions())
                .parentFeeAmount(entity.getParentFeeAmount())
                .transactionCode(entity.getTransactionCode())
                .status(entity.getStatus())
                .verifiedByAdminId(entity.getVerifiedByAdmin() != null ? entity.getVerifiedByAdmin().getId() : null)
                .verifiedAt(entity.getVerifiedAt())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
