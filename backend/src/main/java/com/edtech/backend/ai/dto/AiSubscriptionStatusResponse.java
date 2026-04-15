package com.edtech.backend.ai.dto;

import java.time.Instant;
import java.util.UUID;

import lombok.Builder;
import lombok.Getter;

import com.edtech.backend.ai.entity.AiSubscriptionEntity;
import com.edtech.backend.ai.enums.AiSubscriptionStatus;

@Getter
@Builder
public class AiSubscriptionStatusResponse {

    private UUID subscriptionId;
    private AiSubscriptionStatus status;

    /** Còn bao nhiêu ngày trial (null nếu không phải TRIAL) */
    private Long trialDaysRemaining;

    /** Ngày paid subscription hết hạn (null nếu chưa trả phí) */
    private Instant paidUntil;

    /** HS có quyền dùng AI không */
    private boolean canUseAi;

    /** Có phải đang trial không */
    private boolean isTrial;

    public static AiSubscriptionStatusResponse from(AiSubscriptionEntity entity) {
        Instant now = Instant.now();
        boolean canUse = switch (entity.getStatus()) {
            case TRIAL -> entity.getTrialEndsAt() != null && now.isBefore(entity.getTrialEndsAt());
            case ACTIVE -> entity.getPaidUntil() != null && now.isBefore(entity.getPaidUntil());
            default -> false;
        };

        Long trialDays = null;
        if (entity.getStatus() == AiSubscriptionStatus.TRIAL && entity.getTrialEndsAt() != null) {
            long seconds = entity.getTrialEndsAt().getEpochSecond() - now.getEpochSecond();
            trialDays = Math.max(0, seconds / 86400);
        }

        return AiSubscriptionStatusResponse.builder()
                .subscriptionId(entity.getId())
                .status(entity.getStatus())
                .trialDaysRemaining(trialDays)
                .paidUntil(entity.getPaidUntil())
                .canUseAi(canUse)
                .isTrial(entity.getStatus() == AiSubscriptionStatus.TRIAL)
                .build();
    }
}
