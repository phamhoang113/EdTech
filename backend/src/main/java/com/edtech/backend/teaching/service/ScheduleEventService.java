package com.edtech.backend.teaching.service;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.teaching.dto.response.ScheduleEventResponse;
import com.edtech.backend.teaching.entity.AssessmentEntity;
import com.edtech.backend.teaching.enums.AssessmentType;
import com.edtech.backend.teaching.repository.AssessmentRepository;

/**
 * Service gộp schedule events từ nhiều nguồn:
 * sessions (từ API cũ) + homework deadlines + exams.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ScheduleEventService {

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");
    private static final ZoneId VIETNAM_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");

    private final AssessmentRepository assessmentRepository;
    private final ClassRepository classRepository;

    /**
     * Lấy events (deadline BT + lịch KT) cho danh sách lớp trong khoảng ngày.
     * Session events sẽ được mobile gộp từ API cũ.
     */
    public List<ScheduleEventResponse> getTeachingEvents(
            List<UUID> classIds, LocalDate startDate, LocalDate endDate) {

        Instant startInstant = startDate.atStartOfDay(VIETNAM_ZONE).toInstant();
        Instant endInstant = endDate.atTime(LocalTime.MAX).atZone(VIETNAM_ZONE).toInstant();

        List<AssessmentEntity> assessments =
                assessmentRepository.findByClassIdInAndIsPublishedTrueAndIsDeletedFalse(classIds);

        List<ScheduleEventResponse> events = new ArrayList<>();

        for (AssessmentEntity assessment : assessments) {
            String className = resolveClassName(assessment.getClassId());

            if (assessment.getType() == AssessmentType.HOMEWORK && assessment.getClosesAt() != null) {
                // Homework → show deadline
                if (isInRange(assessment.getClosesAt(), startInstant, endInstant)) {
                    events.add(buildHomeworkDeadlineEvent(assessment, className));
                }
            } else if (assessment.getType() == AssessmentType.EXAM && assessment.getOpensAt() != null) {
                // Exam → show start time
                if (isInRange(assessment.getOpensAt(), startInstant, endInstant)) {
                    events.add(buildExamEvent(assessment, className));
                }
            }
        }

        events.sort(Comparator.comparing(ScheduleEventResponse::getDate)
                .thenComparing(e -> e.getStartTime() != null ? e.getStartTime() : "23:59"));
        return events;
    }

    private ScheduleEventResponse buildHomeworkDeadlineEvent(AssessmentEntity a, String className) {
        var deadlineLocal = a.getClosesAt().atZone(VIETNAM_ZONE);
        return ScheduleEventResponse.builder()
                .type("HOMEWORK_DEADLINE")
                .title(a.getTitle())
                .date(deadlineLocal.format(DATE_FMT))
                .startTime(deadlineLocal.format(TIME_FMT))
                .className(className)
                .assessmentId(a.getId().toString())
                .createdAt(a.getCreatedAt())
                .build();
    }

    private ScheduleEventResponse buildExamEvent(AssessmentEntity a, String className) {
        var opensLocal = a.getOpensAt().atZone(VIETNAM_ZONE);
        String endTime = null;
        if (a.getDurationMin() != null) {
            endTime = opensLocal.plusMinutes(a.getDurationMin()).format(TIME_FMT);
        }
        return ScheduleEventResponse.builder()
                .type("EXAM")
                .title(a.getTitle())
                .date(opensLocal.format(DATE_FMT))
                .startTime(opensLocal.format(TIME_FMT))
                .endTime(endTime)
                .durationMin(a.getDurationMin())
                .className(className)
                .assessmentId(a.getId().toString())
                .createdAt(a.getCreatedAt())
                .build();
    }

    private boolean isInRange(Instant instant, Instant start, Instant end) {
        return !instant.isBefore(start) && !instant.isAfter(end);
    }

    private String resolveClassName(UUID classId) {
        return classRepository.findById(classId)
                .map(ClassEntity::getTitle)
                .orElse("Lớp");
    }
}
