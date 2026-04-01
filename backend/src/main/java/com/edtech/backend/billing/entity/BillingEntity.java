package com.edtech.backend.billing.entity;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.billing.enums.BillingStatus;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.core.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "billings")
@Getter
@Setter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class BillingEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "class_id", nullable = false)
    private ClassEntity cls;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id", nullable = false)
    private UserEntity parent;

    @Column(name = "month", nullable = false)
    private Integer month;

    @Column(name = "year", nullable = false)
    private Integer year;

    @Column(name = "total_sessions", nullable = false)
    private Integer totalSessions;

    @Column(name = "parent_fee_amount", nullable = false)
    private BigDecimal parentFeeAmount;

    @Column(name = "tutor_payout_amount", nullable = false)
    private BigDecimal tutorPayoutAmount;

    @Column(name = "transaction_code", nullable = false, length = 50)
    private String transactionCode;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "status", nullable = false)
    @Builder.Default
    private BillingStatus status = BillingStatus.UNPAID;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "verified_by_admin_id")
    private UserEntity verifiedByAdmin;

    @Column(name = "verified_at")
    private Instant verifiedAt;
}
