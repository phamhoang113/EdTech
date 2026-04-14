package com.edtech.backend.teaching.scheduler;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.core.service.FileStorageService;
import com.edtech.backend.teaching.entity.SubmissionEntity;
import com.edtech.backend.teaching.enums.SubmissionStatus;
import com.edtech.backend.teaching.repository.SubmissionRepository;

/**
 * Auto-cleanup file bài tập/kiểm tra đã hoàn thành — chạy lúc 3h sáng mỗi ngày.
 *
 * Quy tắc:
 * 1. GS chọn "Hoàn thành" (COMPLETED) + 7 ngày → xóa file
 * 2. Không tương tác 7 ngày (lastInteractionAt + 7d < now) → xóa file
 *
 * File vật lý bị xóa, DB metadata (điểm, comment) giữ lại.
 * Status chuyển sang ARCHIVED, files_cleaned = true.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class FileCleanupScheduler {

    private static final int CLEANUP_AFTER_DAYS = 7;

    private final SubmissionRepository submissionRepository;
    private final FileStorageService fileStorageService;

    @Scheduled(cron = "0 0 3 * * ?")
    @Transactional
    public void cleanupExpiredFiles() {
        log.info("=== FileCleanupScheduler: starting cleanup ===");

        Instant cutoff = Instant.now().minus(CLEANUP_AFTER_DAYS, ChronoUnit.DAYS);
        List<SubmissionEntity> submissions = submissionRepository.findSubmissionsForCleanup(cutoff);

        int cleanedCount = 0;
        long freedBytes = 0;

        for (SubmissionEntity sub : submissions) {
            long fileSize = sub.getFileSize() != null ? sub.getFileSize() : 0;

            // Xóa file bài nộp (HS)
            if (sub.getFileUrl() != null) {
                fileStorageService.delete(sub.getFileUrl());
                sub.setFileUrl(null);
                sub.setFileName(null);
                freedBytes += fileSize;
            }

            // Xóa file sửa bài (GS)
            if (sub.getTutorFileUrl() != null) {
                fileStorageService.delete(sub.getTutorFileUrl());
                sub.setTutorFileUrl(null);
                sub.setTutorFileName(null);
            }

            sub.setFilesCleaned(true);
            sub.setStatus(SubmissionStatus.ARCHIVED);

            submissionRepository.save(sub);
            cleanedCount++;

            log.debug("[CLEANUP] submissionId={}, freedBytes={}", sub.getId(), fileSize);
        }

        if (cleanedCount > 0) {
            log.info("=== FileCleanupScheduler: cleaned {} submissions, freed ~{}MB ===",
                    cleanedCount, freedBytes / (1024 * 1024));
        } else {
            log.info("=== FileCleanupScheduler: nothing to clean ===");
        }
    }
}
