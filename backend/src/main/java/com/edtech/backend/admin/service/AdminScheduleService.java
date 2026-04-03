package com.edtech.backend.admin.service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.admin.dto.AdminScheduleAnalyticsDTO;
import com.edtech.backend.admin.dto.QuotaShortfallItem;
import com.edtech.backend.admin.dto.ScheduleSuggestDTO;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.cls.repository.SessionRepository;
import com.edtech.backend.core.exception.EntityNotFoundException;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminScheduleService {

    private static final int DEFAULT_SESSIONS_PER_MONTH = 4;
    private static final int WEEKS_PER_MONTH = 4;
    private static final int DAYS_IN_WEEK = 6;

    private final SessionRepository sessionRepository;
    private final UserRepository userRepository;
    private final ClassRepository classRepository;

    public List<SessionDTO> getSchedules(UUID tutorId, String classCode, String tutorName,
                                         LocalDate startDate, LocalDate endDate) {
        Sort sort = Sort.by("sessionDate").ascending().and(Sort.by("startTime").ascending());
        List<SessionEntity> sessions = sessionRepository.findByAdminAdvancedFilters(
                startDate, endDate, tutorId, classCode, tutorName, sort);

        Map<UUID, String> tutorNameMap = buildTutorNameMap(sessions);

        return sessions.stream().map(session -> {
            SessionDTO dto = SessionDTO.fromEntity(session);
            if (session.getCls() != null && session.getCls().getTutorId() != null) {
                dto.setTutorName(tutorNameMap.getOrDefault(session.getCls().getTutorId(), "Unknown"));
            }
            return dto;
        }).collect(Collectors.toList());
    }

    @Transactional
    public void updateStatus(UUID sessionId, SessionStatus status) {
        SessionEntity session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy buổi học."));
        session.setStatus(status);
        sessionRepository.save(session);
        log.info("[ADMIN_SCHEDULE] Status of session {} updated to {}", sessionId, status);
    }

    public AdminScheduleAnalyticsDTO getAnalytics(UUID tutorId, String classCode, String tutorName,
                                                   LocalDate startDate, LocalDate endDate) {
        Sort sort = Sort.by("sessionDate").ascending();
        List<SessionEntity> sessions = sessionRepository.findByAdminAdvancedFilters(
                startDate, endDate, tutorId, classCode, tutorName, sort);

        long totalSessions = sessions.size();
        long[] revenue = calculateRevenue(sessions);

        List<QuotaShortfallItem> details = buildQuotaDetails(tutorId);
        long totalMissing = details.stream().mapToInt(QuotaShortfallItem::getMissingCount).sum();
        long totalExtra = details.stream().mapToInt(QuotaShortfallItem::getExtraCount).sum();

        return AdminScheduleAnalyticsDTO.builder()
                .totalSessions(totalSessions)
                .makeupNeededSessions(totalMissing)
                .extraSessions(totalExtra)
                .totalParentRevenue(revenue[0])
                .totalTutorSalary(revenue[1])
                .build();
    }

    /** Trả về chi tiết các lớp thiếu/dư buổi trong tuần hiện tại. */
    public List<QuotaShortfallItem> getQuotaDetails(UUID tutorId) {
        return buildQuotaDetails(tutorId).stream()
                .filter(item -> item.getMissingCount() > 0 || item.getExtraCount() > 0)
                .collect(Collectors.toList());
    }

    // ─── Suggest / Autocomplete ──────────────────────────────────────────────

    private static final int SUGGEST_LIMIT = 10;

    /** Gợi ý gia sư và lớp khớp với keyword (dùng cho autocomplete). */
    @Transactional(readOnly = true)
    public ScheduleSuggestDTO getSuggestions(String keyword) {
        List<ScheduleSuggestDTO.TutorSuggestion> tutorSuggestions =
                userRepository.searchByKeywordAndRole(keyword, UserRole.TUTOR).stream()
                        .limit(SUGGEST_LIMIT)
                        .map(u -> ScheduleSuggestDTO.TutorSuggestion.builder()
                                .id(u.getId())
                                .fullName(u.getFullName())
                                .phone(u.getPhone())
                                .build())
                        .collect(Collectors.toList());

        List<ScheduleSuggestDTO.ClassSuggestion> classSuggestions =
                classRepository.searchByKeyword(keyword).stream()
                        .limit(SUGGEST_LIMIT)
                        .map(c -> ScheduleSuggestDTO.ClassSuggestion.builder()
                                .id(c.getId())
                                .classCode(c.getClassCode())
                                .title(c.getTitle())
                                .subject(c.getSubject())
                                .build())
                        .collect(Collectors.toList());

        return ScheduleSuggestDTO.builder()
                .tutors(tutorSuggestions)
                .classes(classSuggestions)
                .build();
    }

    // ─── Private Helpers ─────────────────────────────────────────────────────

    private List<QuotaShortfallItem> buildQuotaDetails(UUID filterTutorId) {
        LocalDate today = LocalDate.now();
        LocalDate currentMonday = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate currentSunday = currentMonday.plusDays(DAYS_IN_WEEK);

        List<ClassEntity> activeClasses = classRepository.findByStatusAndIsDeletedFalse(ClassStatus.ACTIVE);
        if (filterTutorId != null) {
            activeClasses = activeClasses.stream()
                    .filter(c -> filterTutorId.equals(c.getTutorId()))
                    .collect(Collectors.toList());
        }
        List<SessionEntity> weekSessions = sessionRepository.findBySessionDateBetween(
                currentMonday, currentSunday, Sort.by("sessionDate"));

        // Batch-load tutor names
        Set<UUID> tutorIds = activeClasses.stream()
                .map(ClassEntity::getTutorId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        Map<UUID, String> tutorNameMap = new HashMap<>();
        if (!tutorIds.isEmpty()) {
            userRepository.findAllById(tutorIds)
                    .forEach(user -> tutorNameMap.put(user.getId(), user.getFullName()));
        }

        List<QuotaShortfallItem> result = new ArrayList<>();
        for (ClassEntity cls : activeClasses) {
            int target = resolveWeeklyTarget(cls, currentSunday);
            int activeThisWeek = (int) countActiveSessionsForClass(weekSessions, cls.getId());
            int missing = Math.max(0, target - activeThisWeek);
            int extra = Math.max(0, activeThisWeek - target);

            String tutorName = cls.getTutorId() != null
                    ? tutorNameMap.getOrDefault(cls.getTutorId(), "N/A")
                    : "Chưa có";

            result.add(QuotaShortfallItem.builder()
                    .classId(cls.getId())
                    .classCode(cls.getClassCode())
                    .classTitle(cls.getTitle())
                    .subject(cls.getSubject())
                    .tutorId(cls.getTutorId())
                    .tutorName(tutorName)
                    .sessionsPerWeek(target)
                    .activeThisWeek(activeThisWeek)
                    .missingCount(missing)
                    .extraCount(extra)
                    .build());
        }
        return result;
    }

    private Map<UUID, String> buildTutorNameMap(List<SessionEntity> sessions) {
        Set<UUID> tutorIds = sessions.stream()
                .map(s -> s.getCls() != null ? s.getCls().getTutorId() : null)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        Map<UUID, String> tutorNameMap = new HashMap<>();
        if (!tutorIds.isEmpty()) {
            userRepository.findAllById(tutorIds)
                    .forEach(user -> tutorNameMap.put(user.getId(), user.getFullName()));
        }
        return tutorNameMap;
    }

    private long[] calculateRevenue(List<SessionEntity> sessions) {
        long parentRevenue = 0;
        long tutorSalary = 0;

        for (SessionEntity session : sessions) {
            if (session.getCls() == null || session.getStatus() != SessionStatus.COMPLETED) continue;

            ClassEntity cls = session.getCls();
            int sessionsPerMonth = cls.getSessionsPerWeek() != null && cls.getSessionsPerWeek() > 0
                    ? cls.getSessionsPerWeek() * WEEKS_PER_MONTH
                    : DEFAULT_SESSIONS_PER_MONTH;

            long parentFee = cls.getParentFee() != null ? cls.getParentFee().longValue() : 0L;
            long tutorFee = cls.getTutorFee() != null ? cls.getTutorFee().longValue() : 0L;

            parentRevenue += (parentFee / sessionsPerMonth);
            tutorSalary += (tutorFee / sessionsPerMonth);
        }
        return new long[]{parentRevenue, tutorSalary};
    }

    private int resolveWeeklyTarget(ClassEntity cls, LocalDate currentSunday) {
        int target = cls.getSessionsPerWeek() != null ? cls.getSessionsPerWeek() : 0;
        if (cls.getLearningStartDate() == null || currentSunday.isBefore(cls.getLearningStartDate())) {
            return 0;
        }
        return target;
    }

    private long countActiveSessionsForClass(List<SessionEntity> weekSessions, UUID classId) {
        return weekSessions.stream()
                .filter(s -> s.getCls() != null && s.getCls().getId().equals(classId))
                .filter(s -> !isCancelledSession(s))
                .count();
    }

    private boolean isCancelledSession(SessionEntity session) {
        return session.getStatus() == SessionStatus.CANCELLED
                || session.getStatus() == SessionStatus.CANCELLED_BY_TUTOR
                || session.getStatus() == SessionStatus.CANCELLED_BY_STUDENT;
    }
}
