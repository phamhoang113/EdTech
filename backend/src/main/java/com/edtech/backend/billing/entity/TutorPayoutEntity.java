package com.edtech.backend.billing.entity;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.billing.enums.TutorPayoutStatus;
import com.edtech.backend.core.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "tutor_payouts")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class TutorPayoutEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "tutor_id", nullable = false)
    private UserEntity tutor;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "billing_id", nullable = false)
    private BillingEntity billing;

    @Column(name = "amount", nullable = false)
    private BigDecimal amount;

    @Column(name = "transaction_code", length = 50)
    private String transactionCode;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "status", nullable = false)
    @Builder.Default
    private TutorPayoutStatus status = TutorPayoutStatus.LOCKED;

    @Column(name = "admin_note", columnDefinition = "TEXT")
    private String adminNote;

    @Column(name = "paid_at")
    private Instant paidAt;

    @Column(name = "confirmed_by_tutor_at")
    private Instant confirmedByTutorAt;
}
