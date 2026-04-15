package com.edtech.backend.ai.service;

import java.time.Instant;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.ai.dto.AiSubscriptionStatusResponse;
import com.edtech.backend.ai.entity.AiSubscriptionEntity;
import com.edtech.backend.ai.enums.AiSubscriptionStatus;
import com.edtech.backend.ai.repository.AiSubscriptionRepository;
import com.edtech.backend.core.exception.BusinessRuleException;

/**
 * Quản lý subscription AI của học sinh.
 *
 * Lifecycle:
 *  - Lần đầu vào AI → tự kích hoạt TRIAL (30 ngày)
 *  - TRIAL hết hạn → EXPIRED
 *  - Thanh toán → ACTIVE (30 ngày tiếp)
 *  - ACTIVE hết hạn → EXPIRED
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AiSubscriptionService {

    private static final int TRIAL_DAYS = 30;
    private static final int PAID_DAYS  = 30;

    /** Số tin/ngày tối đa: trial = 20, paid = 100 */
    public static final int TRIAL_DAILY_LIMIT  = 20;
    public static final int PAID_DAILY_LIMIT   = 100;

    private final AiSubscriptionRepository subscriptionRepository;

    /**
     * Lấy trạng thái subscription — tự động tạo TRIAL nếu chưa có.
     */
    @Transactional
    public AiSubscriptionStatusResponse getOrCreateSubscription(UUID studentId) {
        AiSubscriptionEntity entity = subscriptionRepository.findByStudentId(studentId)
                .orElseGet(() -> activateTrial(studentId));

        entity = syncStatus(entity);
        return AiSubscriptionStatusResponse.from(entity);
    }

    /**
     * Kiểm tra HS có được phép gửi tin AI không.
     * Throws BusinessRuleException nếu hết quyền.
     */
    @Transactional
    public AiSubscriptionEntity requireAccess(UUID studentId) {
        AiSubscriptionEntity entity = subscriptionRepository.findByStudentId(studentId)
                .orElseGet(() -> activateTrial(studentId));

        entity = syncStatus(entity);

        boolean canUse = switch (entity.getStatus()) {
            case TRIAL  -> Instant.now().isBefore(entity.getTrialEndsAt());
            case ACTIVE -> Instant.now().isBefore(entity.getPaidUntil());
            default     -> false;
        };

        if (!canUse) {
            throw new BusinessRuleException(
                "AI_ACCESS_DENIED",
                "Thời gian dùng thử đã hết. Nâng cấp AI Premium (200.000đ/tháng) để tiếp tục."
            );
        }

        return entity;
    }

    /**
     * Lấy số tin/ngày tối đa theo loại subscription.
     */
    public int getDailyLimit(AiSubscriptionEntity subscription) {
        return subscription.getStatus() == AiSubscriptionStatus.TRIAL
                ? TRIAL_DAILY_LIMIT
                : PAID_DAILY_LIMIT;
    }

    /**
     * Admin/System kích hoạt paid subscription sau khi HS thanh toán.
     */
    @Transactional
    public AiSubscriptionStatusResponse activatePaid(UUID studentId) {
        AiSubscriptionEntity entity = subscriptionRepository.findByStudentId(studentId)
                .orElseGet(() -> activateTrial(studentId));

        Instant paidFrom = Instant.now();
        // Nếu đang còn ACTIVE → gia hạn thêm từ paidUntil hiện tại
        if (entity.getStatus() == AiSubscriptionStatus.ACTIVE
                && entity.getPaidUntil() != null
                && Instant.now().isBefore(entity.getPaidUntil())) {
            paidFrom = entity.getPaidUntil();
        }

        entity.setStatus(AiSubscriptionStatus.ACTIVE);
        entity.setPaidUntil(paidFrom.plusSeconds(PAID_DAYS * 86400L));
        entity = subscriptionRepository.save(entity);

        log.info("AI paid subscription activated: studentId={}, paidUntil={}", studentId, entity.getPaidUntil());
        return AiSubscriptionStatusResponse.from(entity);
    }

    // ── Private helpers ───────────────────────────────────────────────────

    private AiSubscriptionEntity activateTrial(UUID studentId) {
        Instant now = Instant.now();
        AiSubscriptionEntity entity = AiSubscriptionEntity.builder()
                .studentId(studentId)
                .status(AiSubscriptionStatus.TRIAL)
                .trialStartedAt(now)
                .trialEndsAt(now.plusSeconds(TRIAL_DAYS * 86400L))
                .build();

        entity = subscriptionRepository.save(entity);
        log.info("AI trial activated: studentId={}, endsAt={}", studentId, entity.getTrialEndsAt());
        return entity;
    }

    private AiSubscriptionEntity syncStatus(AiSubscriptionEntity entity) {
        Instant now = Instant.now();
        boolean changed = false;

        if (entity.getStatus() == AiSubscriptionStatus.TRIAL
                && entity.getTrialEndsAt() != null
                && now.isAfter(entity.getTrialEndsAt())) {
            entity.setStatus(AiSubscriptionStatus.EXPIRED);
            changed = true;
        }

        if (entity.getStatus() == AiSubscriptionStatus.ACTIVE
                && entity.getPaidUntil() != null
                && now.isAfter(entity.getPaidUntil())) {
            entity.setStatus(AiSubscriptionStatus.EXPIRED);
            changed = true;
        }

        if (changed) {
            entity = subscriptionRepository.save(entity);
            log.info("AI subscription expired: studentId={}", entity.getStudentId());
        }

        return entity;
    }
}
