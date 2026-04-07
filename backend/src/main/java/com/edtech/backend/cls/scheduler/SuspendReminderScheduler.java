package com.edtech.backend.cls.scheduler;

import java.time.LocalDate;
import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.notification.entity.NotificationType;
import com.edtech.backend.notification.service.NotificationService;

/**
 * Scheduler nhắc nhở khi lớp sắp hết thời gian tạm hoãn.
 * Chạy mỗi ngày lúc 08:00, gửi notification nếu suspendEndDate còn <= 3 ngày.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class SuspendReminderScheduler {

    private static final int REMINDER_DAYS_BEFORE = 3;

    private final ClassRepository classRepository;
    private final NotificationService notificationService;

    @Scheduled(cron = "0 0 8 * * ?")
    public void checkSuspendReminders() {
        log.info("=== SuspendReminderScheduler: checking suspended classes ===");

        LocalDate today = LocalDate.now();
        LocalDate reminderDate = today.plusDays(REMINDER_DAYS_BEFORE);

        List<ClassEntity> suspendedClasses = classRepository.findByStatusAndIsDeletedFalse(ClassStatus.SUSPENDED);

        int notifiedCount = 0;
        for (ClassEntity cls : suspendedClasses) {
            if (cls.getSuspendEndDate() == null) continue;

            // Nhắc nếu endDate nằm trong khoảng [today, today + 3 ngày]
            boolean shouldRemind = !cls.getSuspendEndDate().isBefore(today)
                    && !cls.getSuspendEndDate().isAfter(reminderDate);

            if (shouldRemind) {
                long daysLeft = today.until(cls.getSuspendEndDate()).getDays();
                String title = "Lớp " + cls.getTitle() + " sắp hết thời gian tạm hoãn";
                String body = String.format("Lớp %s sẽ hết tạm hoãn sau %d ngày (%s). Vui lòng liên hệ để xác nhận tiếp tục.",
                        cls.getTitle(), daysLeft, cls.getSuspendEndDate());

                // Nhắc Admin (adminId = người tạo lớp)
                notificationService.sendNotification(
                        cls.getAdminId(), NotificationType.CLASS_SUSPEND_REMINDER,
                        title, body, "CLASS", cls.getId());

                // Nhắc GS
                if (cls.getTutorId() != null) {
                    notificationService.sendNotification(
                            cls.getTutorId(), NotificationType.CLASS_SUSPEND_REMINDER,
                            title, body, "CLASS", cls.getId());
                }

                // Nhắc PH
                notificationService.sendNotification(
                        cls.getParentId(), NotificationType.CLASS_SUSPEND_REMINDER,
                        title, body, "CLASS", cls.getId());

                notifiedCount++;
                log.info("[SUSPEND_REMINDER] classId={}, daysLeft={}", cls.getId(), daysLeft);
            }
        }

        log.info("=== SuspendReminderScheduler: notified {} classes ===", notifiedCount);
    }
}
