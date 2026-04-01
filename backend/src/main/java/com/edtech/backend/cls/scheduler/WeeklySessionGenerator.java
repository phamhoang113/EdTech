package com.edtech.backend.cls.scheduler;

import com.edtech.backend.cls.service.TutorScheduleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Scheduler tạo DRAFT sessions cho tuần N+1 dựa trên class schedule.
 * Chạy Thứ 4 hàng tuần lúc 06:00 AM.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class WeeklySessionGenerator {

    private final TutorScheduleService scheduleService;

    @Scheduled(cron = "0 0 6 * * WED")
    public void generateWeeklySessions() {
        log.info("=== WeeklySessionGenerator: start generating draft sessions ===");
        int count = scheduleService.generateDraftsForNextWeek();
        log.info("=== WeeklySessionGenerator: generated {} draft sessions ===", count);
    }
}
