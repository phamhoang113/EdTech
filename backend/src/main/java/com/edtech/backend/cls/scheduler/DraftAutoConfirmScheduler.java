package com.edtech.backend.cls.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.edtech.backend.cls.service.TutorScheduleService;

/**
 * Scheduler tự động confirm DRAFT sessions nếu GS không xác nhận trước deadline.
 * Chạy CN hàng tuần lúc 18:00.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class DraftAutoConfirmScheduler {

    private final TutorScheduleService scheduleService;

    @Scheduled(cron = "0 0 18 * * SUN")
    public void autoConfirmDrafts() {
        log.info("=== DraftAutoConfirmScheduler: auto-confirming unconfirmed drafts ===");
        int count = scheduleService.autoConfirmDrafts();
        log.info("=== DraftAutoConfirmScheduler: auto-confirmed {} sessions ===", count);
    }
}
