package com.edtech.backend.cls.scheduler;

import java.time.LocalDate;
import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.repository.SessionRepository;

/**
 * Scheduler tự động đánh dấu COMPLETED cho các tiết học SCHEDULED ngày hôm trước.
 * Chạy hàng ngày lúc 00:30 AM — xem lại tất cả session ngày hôm qua,
 * nếu vẫn còn SCHEDULED hoặc LIVE thì chuyển sang COMPLETED.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class SessionAutoCompleteScheduler {

    private final SessionRepository sessionRepository;

    @Scheduled(cron = "0 30 0 * * *")
    @Transactional
    public void autoCompleteYesterdaySessions() {
        LocalDate yesterday = LocalDate.now().minusDays(1);

        List<SessionEntity> scheduledSessions = sessionRepository.findByStatusAndSessionDateBetween(
                SessionStatus.SCHEDULED, yesterday, yesterday);

        List<SessionEntity> liveSessions = sessionRepository.findByStatusAndSessionDateBetween(
                SessionStatus.LIVE, yesterday, yesterday);

        int completedCount = 0;

        for (SessionEntity session : scheduledSessions) {
            session.setStatus(SessionStatus.COMPLETED);
            completedCount++;
        }

        for (SessionEntity session : liveSessions) {
            session.setStatus(SessionStatus.COMPLETED);
            completedCount++;
        }

        if (completedCount > 0) {
            sessionRepository.saveAll(scheduledSessions);
            sessionRepository.saveAll(liveSessions);
            log.info("=== SessionAutoCompleteScheduler: auto-completed {} session(s) for {} ===",
                    completedCount, yesterday);
        } else {
            log.debug("SessionAutoCompleteScheduler: no sessions to auto-complete for {}", yesterday);
        }
    }
}
