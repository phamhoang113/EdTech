package com.edtech.backend.ai.entity;

import java.time.Instant;
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

import com.edtech.backend.ai.enums.AiSubscriptionStatus;
import com.edtech.backend.core.entity.BaseEntity;

/**
 * Subscription AI của học sinh.
 * Trial tự động kích hoạt khi lần đầu dùng AI.
 * Sau 30 ngày trial → EXPIRED → cần thanh toán 200k/tháng.
 */
@Entity
@Table(name = "ai_subscription")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiSubscriptionEntity extends BaseEntity {

    @Column(name = "student_id", nullable = false, unique = true)
    private UUID studentId;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(nullable = false)
    @Builder.Default
    private AiSubscriptionStatus status = AiSubscriptionStatus.TRIAL;

    /** Thời điểm HS lần đầu mở AI → bắt đầu đếm 30 ngày */
    @Column(name = "trial_started_at")
    private Instant trialStartedAt;

    @Column(name = "trial_ends_at")
    private Instant trialEndsAt;

    /** Ngày subscription trả phí hết hạn (null nếu chưa trả phí lần nào) */
    @Column(name = "paid_until")
    private Instant paidUntil;
}
