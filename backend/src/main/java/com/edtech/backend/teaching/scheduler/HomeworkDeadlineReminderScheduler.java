package com.edtech.backend.teaching.scheduler;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.UUID;

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
import com.edtech.backend.teaching.repository.SubmissionRepository;

/**
 * Nhắc nhở deadline bài tập — chạy mỗi ngày lúc 8h sáng.
 * Tìm bài tập có deadline ngày mai, gửi notification cho HS chưa nộp + PH.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class HomeworkDeadlineReminderScheduler {

    private final AssessmentRepository assessmentRepository;
    private final SubmissionRepository submissionRepository;
    private final ClassRepository classRepository;
    private final NotificationService notificationService;

    @Scheduled(cron = "0 0 8 * * ?")
    public void remindHomeworkDeadline() {
        log.info("=== HomeworkDeadlineReminderScheduler: checking deadlines ===");

        Instant tomorrowStart = Instant.now().plus(1, ChronoUnit.DAYS).truncatedTo(ChronoUnit.DAYS);
        Instant tomorrowEnd = tomorrowStart.plus(1, ChronoUnit.DAYS);

        List<AssessmentEntity> homeworks = assessmentRepository.findHomeworkWithDeadlineBetween(tomorrowStart, tomorrowEnd);

        int notifiedCount = 0;
        for (AssessmentEntity hw : homeworks) {
            List<UUID> submittedStudentIds = submissionRepository.findSubmittedStudentIds(hw.getId());

            // Lấy danh sách HS trong lớp
            ClassEntity cls = classRepository.findById(hw.getClassId()).orElse(null);
            if (cls == null) continue;

            // Gửi notification cho HS chưa nộp
            String title = "Nhắc nhở: " + hw.getTitle();
            String body = "Bài tập sẽ hết hạn vào ngày mai. Hãy nộp bài trước deadline!";

            // Gửi cho PH (nếu có)
            if (cls.getParentId() != null) {
                notificationService.sendNotification(
                        cls.getParentId(), NotificationType.HOMEWORK_DEADLINE_REMINDER,
                        title, body, "ASSESSMENT", hw.getId());
            }

            notifiedCount++;
            log.info("[HW_DEADLINE] assessmentId={}, classId={}", hw.getId(), hw.getClassId());
        }

        log.info("=== HomeworkDeadlineReminderScheduler: processed {} homework(s) ===", notifiedCount);
    }
}
