package com.edtech.backend.cls.scheduler;

import java.time.LocalDate;
import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.repository.ClassRepository;

/**
 * Scheduler tự động đóng lớp OPEN đã quá hạn endDate mà chưa có gia sư nhận.
 * Chạy hàng ngày lúc 01:00 AM.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ClassExpiryScheduler {

    private final ClassRepository classRepository;

    @Scheduled(cron = "0 0 1 * * *")
    @Transactional
    public void autoCloseExpiredClasses() {
        LocalDate today = LocalDate.now();
        List<ClassEntity> expiredClasses = classRepository
                .findByStatusAndEndDateBeforeAndIsDeletedFalse(ClassStatus.OPEN, today);

        if (expiredClasses.isEmpty()) {
            log.debug("No expired OPEN classes found.");
            return;
        }

        for (ClassEntity cls : expiredClasses) {
            cls.setStatus(ClassStatus.AUTO_CLOSED);
            log.info("Auto-closed expired class: {} (code: {}, endDate: {})",
                    cls.getId(), cls.getClassCode(), cls.getEndDate());
        }

        classRepository.saveAll(expiredClasses);
        log.info("Auto-closed {} expired class(es).", expiredClasses.size());
    }
}
