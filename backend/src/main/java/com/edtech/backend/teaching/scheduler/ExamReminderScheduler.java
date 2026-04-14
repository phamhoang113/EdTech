package com.edtech.backend.teaching.scheduler;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.notification.entity.NotificationType;
import com.edtech.backend.notification.service.NotificationService;
import com.edtech.backend.teaching.entity.AssessmentEntity;
import com.edtech.backend.teaching.repository.AssessmentRepository;

/**
 * Nhắc nhở kiểm tra — chạy mỗi giờ.
 * Tìm đề kiểm tra có opens_at trong 1 giờ tới, gửi notification cho HS + PH.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ExamReminderScheduler {

    private final AssessmentRepository assessmentRepository;
    private final ClassRepository classRepository;
    private final NotificationService notificationService;

    @Scheduled(cron = "0 0 * * * ?")
    public void remindUpcomingExams() {
        log.info("=== ExamReminderScheduler: checking upcoming exams ===");

        Instant now = Instant.now();
        Instant oneHourLater = now.plus(1, ChronoUnit.HOURS);

        List<AssessmentEntity> exams = assessmentRepository.findExamsStartingBetween(now, oneHourLater);

        int notifiedCount = 0;
        for (AssessmentEntity exam : exams) {
            ClassEntity cls = classRepository.findById(exam.getClassId()).orElse(null);
            if (cls == null) continue;

            String title = "Sắp kiểm tra: " + exam.getTitle();
            String body = "Kiểm tra sẽ bắt đầu trong 1 giờ nữa. Thời lượng: " + exam.getDurationMin() + " phút.";

            // Gửi cho PH
            if (cls.getParentId() != null) {
                notificationService.sendNotification(
                        cls.getParentId(), NotificationType.TEST_SCHEDULED,
                        title, body, "ASSESSMENT", exam.getId());
            }

            notifiedCount++;
            log.info("[EXAM_REMIND] assessmentId={}, opensAt={}", exam.getId(), exam.getOpensAt());
        }

        log.info("=== ExamReminderScheduler: processed {} exam(s) ===", notifiedCount);
    }
}
