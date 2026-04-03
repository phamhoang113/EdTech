package com.edtech.backend.billing.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import com.edtech.backend.billing.entity.TutorPayoutEntity;
import com.edtech.backend.billing.enums.TutorPayoutStatus;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TutorPayoutDTO {
    private UUID id;

    private UUID tutorId;
    private String tutorName;
    private String tutorPhone;

    // Tutor bank info (populated externally via TutorProfileRepository)
    private String tutorBankName;
    private String tutorBankAccount;
    private String tutorBankOwner;

    private UUID classId;
    private String classTitle;

    private Integer month;
    private Integer year;

    private BigDecimal amount;
    private String transactionCode;
    private TutorPayoutStatus status;

    // Payout tracking
    private String adminNote;
    private Instant paidAt;
    private Instant confirmedByTutorAt;

    private Instant createdAt;

    public static TutorPayoutDTO fromEntity(TutorPayoutEntity entity) {
        if (entity == null) return null;

        return TutorPayoutDTO.builder()
                .id(entity.getId())
                .tutorId(entity.getTutor() != null ? entity.getTutor().getId() : null)
                .tutorName(entity.getTutor() != null ? entity.getTutor().getFullName() : null)
                .tutorPhone(entity.getTutor() != null ? entity.getTutor().getPhone() : null)
                .classId(entity.getBilling() != null && entity.getBilling().getCls() != null ? entity.getBilling().getCls().getId() : null)
                .classTitle(entity.getBilling() != null && entity.getBilling().getCls() != null ? entity.getBilling().getCls().getTitle() : null)
                .month(entity.getBilling() != null ? entity.getBilling().getMonth() : null)
                .year(entity.getBilling() != null ? entity.getBilling().getYear() : null)
                .amount(entity.getAmount())
                .transactionCode(entity.getTransactionCode())
                .status(entity.getStatus())
                .adminNote(entity.getAdminNote())
                .paidAt(entity.getPaidAt())
                .confirmedByTutorAt(entity.getConfirmedByTutorAt())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
