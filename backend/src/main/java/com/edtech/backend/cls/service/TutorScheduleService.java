package com.edtech.backend.cls.service;

import com.edtech.backend.cls.dto.ClassDTO;
import com.edtech.backend.cls.dto.ClassQuotaDTO;
import com.edtech.backend.cls.dto.CreateDraftRequest;
import com.edtech.backend.cls.dto.ScheduleSlotDTO;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.dto.SetScheduleRequest;
import com.edtech.backend.cls.dto.UpdateDraftRequest;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.enums.SessionType;
import com.edtech.backend.cls.enums.WeekDay;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.cls.repository.SessionRepository;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.TemporalAdjusters;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class TutorScheduleService {

    private static final int MAX_SESSIONS_PER_DAY = 8;
    private static final int MIN_DURATION_MINUTES = 30;
    private static final int MAX_DURATION_MINUTES = 240;

    private static final String ERR_CLASS_NOT_FOUND = "Lớp không tồn tại";
    private static final String ERR_SESSION_NOT_FOUND = "Buổi học không tồn tại";
    private static final String ERR_NOT_CLASS_TUTOR = "Bạn không phải gia sư của lớp này";
    private static final String ERR_NOT_SESSION_TUTOR = "Bạn không phải gia sư của buổi học này";
    private static final String ERR_DRAFT_ONLY = "Chỉ có thể chỉnh sửa buổi học ở trạng thái bản nháp";
    private static final String ERR_EMPTY_SCHEDULE = "Lịch dạy không được để trống";
    private static final String ERR_INVALID_DAY = "Ngày không hợp lệ: %s. Dùng: T2-T7, CN";
    private static final String ERR_START_BEFORE_END = "Giờ bắt đầu phải trước giờ kết thúc";
    private static final String ERR_DURATION_RANGE = "Thời lượng buổi học phải từ %d đến %d phút";
    private static final String ERR_MAX_SESSIONS = "Tối đa %d buổi/ngày";
    private static final String ERR_TIME_CONFLICT = "Trùng giờ với buổi '%s' (%s-%s)";
    private static final String ERR_SCHEDULE_PARSE = "Lỗi xử lý dữ liệu lịch dạy";
    private static final String ERR_CROSS_CLASS_CONFLICT = "Trùng lịch với lớp '%s' vào %s (%s-%s)";
    private static final String ERR_CLASSES_NO_SCHEDULE = "Các lớp sau chưa có lịch dạy: %s";
    private static final String ERR_DATE_OUT_OF_WEEK = "Ngày %s nằm ngoài tuần hiện tại";

    private final SessionRepository sessionRepository;
    private final ClassRepository classRepository;
    private final ObjectMapper objectMapper;

    // ─── Set/Update Class Schedule ──────────────────────────────────

    @Transactional
    public ClassDTO setClassSchedule(UUID tutorId, UUID classId, SetScheduleRequest request) {
        log.info("[SET_SCHEDULE] tutorId={}, classId={}", tutorId, classId);
        ClassEntity cls = classRepository.findById(classId)
                .orElseThrow(() -> new EntityNotFoundException(ERR_CLASS_NOT_FOUND));

        if (!tutorId.equals(cls.getTutorId())) {
            throw new BusinessRuleException(ERR_NOT_CLASS_TUTOR);
        }

        validateScheduleSlots(request.getSlots());
        validateCrossClassConflicts(tutorId, classId, request.getSlots());

        // Lưu old schedule cho notification
        String oldSchedule = cls.getSchedule();

        try {
            String scheduleJson = objectMapper.writeValueAsString(request.getSlots());
            cls.setSchedule(scheduleJson);
            cls.setSessionsPerWeek(request.getSlots().size());
        } catch (JsonProcessingException e) {
            throw new BusinessRuleException(ERR_SCHEDULE_PARSE);
        }

        classRepository.save(cls);

        log.info("[SET_SCHEDULE] tutorId={}, classId={}, oldSchedule={}, newSchedule={}",
                tutorId, classId, oldSchedule, cls.getSchedule());

        // TODO: Gửi notification cho Admin + PH về thay đổi lịch

        return ClassDTO.fromEntity(cls);
    }

    // ─── Get Draft Sessions ────────────────────────────────────────

    @Transactional(readOnly = true)
    public List<SessionDTO> getDraftSessions(UUID tutorId) {
        LocalDate nextMonday = LocalDate.now().with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        LocalDate nextSunday = nextMonday.plusDays(6);

        return sessionRepository.findByTutorIdAndStatusAndDateBetween(
                        tutorId, SessionStatus.DRAFT, nextMonday, nextSunday,
                        Sort.by(Sort.Direction.ASC, "sessionDate", "startTime")
                ).stream()
                .map(SessionDTO::fromEntity)
                .collect(Collectors.toList());
    }

    // ─── Update Draft Session ──────────────────────────────────────

    @Transactional
    public SessionDTO updateDraft(UUID tutorId, UUID sessionId, UpdateDraftRequest request) {
        SessionEntity session = findOwnedDraftSession(tutorId, sessionId);

        // Drag-drop: thay đổi ngày
        if (request.getSessionDate() != null) {
            session.setSessionDate(request.getSessionDate());
        }

        // Chỉnh giờ bắt đầu/kết thúc
        LocalTime newStart = request.getStartTime() != null ? request.getStartTime() : session.getStartTime();
        LocalTime newEnd = request.getEndTime() != null ? request.getEndTime() : session.getEndTime();

        if (request.getStartTime() != null || request.getEndTime() != null || request.getSessionDate() != null) {
            validateTimeRange(newStart, newEnd);
            checkTimeConflict(tutorId, session.getSessionDate(), newStart, newEnd, sessionId);
            
            // Cleanup overlapping CANCELLED sessions for the same class
            List<SessionEntity> sameDaySessions = sessionRepository.findByTutorIdAndDateBetween(
                    tutorId, session.getSessionDate(), session.getSessionDate(), Sort.by(Sort.Direction.ASC, "startTime"));
            for (SessionEntity existing : sameDaySessions) {
                if (existing.getStatus() == SessionStatus.CANCELLED && existing.getCls().getId().equals(session.getCls().getId()) && !existing.getId().equals(sessionId)) {
                    boolean isOverlapping = newStart.isBefore(existing.getEndTime()) && newEnd.isAfter(existing.getStartTime());
                    if (isOverlapping) {
                        sessionRepository.delete(existing);
                        log.info("[UPDATE_DRAFT] Deleted overlapping CANCELLED session {}", existing.getId());
                    }
                }
            }

            session.setStartTime(newStart);
            session.setEndTime(newEnd);
        }

        if (request.getMeetLink() != null) {
            session.setMeetLink(request.getMeetLink());
        }
        if (request.getTutorNote() != null) {
            session.setTutorNote(request.getTutorNote());
        }

        session = sessionRepository.save(session);
        return SessionDTO.fromEntity(session);
    }

    // ─── Delete (Cancel) Draft ─────────────────────────────────────

    @Transactional
    public void deleteDraft(UUID tutorId, UUID sessionId) {
        SessionEntity session = findOwnedDraftSession(tutorId, sessionId);
        session.setStatus(SessionStatus.CANCELLED);
        sessionRepository.save(session);
        log.info("[CANCEL_DRAFT] tutorId={}, sessionId={}", tutorId, sessionId);
    }

    // ─── Confirm All Drafts ────────────────────────────────────────

    @Transactional
    public Map<String, Object> confirmDrafts(UUID tutorId, LocalDate weekOf) {
        LocalDate targetMonday;
        LocalDate targetSunday;
        
        if (weekOf != null) {
            targetMonday = weekOf.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        } else {
            targetMonday = LocalDate.now().with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        }
        targetSunday = targetMonday.plusDays(6);

        // Validation: Block confirmation if any class has excess REGULAR sessions
        List<ClassQuotaDTO> quotas = getWeeklyQuotaStatus(tutorId, targetMonday);
        for (ClassQuotaDTO q : quotas) {
            if (q.getExcessCount() != null && q.getExcessCount() > 0) {
                throw new BusinessRuleException(
                        String.format("Lớp '%s' đang dư %d buổi học chính. Vui lòng huỷ bớt hoặc chuyển thành Lịch tăng cường.",
                                q.getClassTitle(), q.getExcessCount())
                );
            }
        }

        List<SessionEntity> drafts = sessionRepository.findByTutorIdAndStatusAndDateBetween(
                tutorId, SessionStatus.DRAFT, targetMonday, targetSunday,
                Sort.by(Sort.Direction.ASC, "sessionDate")
        );

        int confirmedCount = 0;
        int cancelledCount = 0;
        LocalDateTime now = LocalDateTime.now();
        for (SessionEntity s : drafts) {
            if (s.getStatus() == SessionStatus.DRAFT) {
                LocalDateTime sessionEndDateTime = LocalDateTime.of(s.getSessionDate(), s.getEndTime());
                if (sessionEndDateTime.isBefore(now)) {
                    s.setStatus(SessionStatus.COMPLETED);
                } else {
                    s.setStatus(SessionStatus.SCHEDULED);
                }
                confirmedCount++;
            } else if (s.getStatus() == SessionStatus.CANCELLED) {
                cancelledCount++;
            }
        }

        sessionRepository.saveAll(drafts);
        log.info("[CONFIRM_DRAFTS] tutorId={}, confirmedCount={}, cancelledCount={}, week={}/{}",
                tutorId, confirmedCount, cancelledCount, targetMonday, targetSunday);

        // TODO: Gửi notification cho PH

        return Map.of(
                "confirmedCount", confirmedCount,
                "cancelledCount", cancelledCount,
                "weekStart", targetMonday.toString(),
                "weekEnd", targetSunday.toString()
        );
    }

    // ─── Schedule Status (enhanced) ────────────────────────────────

    @Transactional(readOnly = true)
    public Map<String, Object> getScheduleStatus(UUID tutorId) {
        LocalDate nextMonday = LocalDate.now().with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        LocalDate nextSunday = nextMonday.plusDays(6);

        List<SessionEntity> nextWeekSessions = sessionRepository.findByTutorIdAndDateBetween(
                tutorId, nextMonday, nextSunday,
                Sort.by(Sort.Direction.ASC, "sessionDate")
        );

        long draftCount = nextWeekSessions.stream()
                .filter(s -> s.getStatus() == SessionStatus.DRAFT)
                .count();

        return Map.of(
                "hasNextWeekSessions", !nextWeekSessions.isEmpty(),
                "hasDraftSessions", draftCount > 0,
                "draftCount", draftCount
        );
    }

    // ─── Generate Drafts for Next Week (called by Scheduler) ──────

    @Transactional
    public int generateDraftsForNextWeek() {
        LocalDate nextMonday = LocalDate.now().with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        LocalDate nextSunday = nextMonday.plusDays(6);

        List<ClassEntity> activeClasses = classRepository.findByStatusAndIsDeletedFalse(ClassStatus.ACTIVE);
        int totalCreated = 0;

        for (ClassEntity cls : activeClasses) {
            if (cls.getTutorId() == null || cls.getSchedule() == null || "[]".equals(cls.getSchedule())) {
                continue;
            }

            List<ScheduleSlotDTO> slots = parseSchedule(cls.getSchedule());
            for (ScheduleSlotDTO slot : slots) {
                DayOfWeek dayOfWeek = WeekDay.resolve(slot.getDayOfWeek());
                if (dayOfWeek == null) {
                    log.warn("Unknown dayOfWeek '{}' in class {}", slot.getDayOfWeek(), cls.getId());
                    continue;
                }

                LocalDate sessionDate = nextMonday.with(TemporalAdjusters.nextOrSame(dayOfWeek));
                if (sessionDate.isAfter(nextSunday)) continue;

                LocalTime startTime = LocalTime.parse(slot.getStartTime());
                LocalTime endTime = LocalTime.parse(slot.getEndTime());

                // Skip nếu đã tồn tại
                boolean exists = sessionRepository.existsByClsIdAndSessionDateAndStartTime(
                        cls.getId(), sessionDate, startTime);
                if (exists) continue;

                SessionEntity session = SessionEntity.builder()
                        .cls(cls)
                        .sessionDate(sessionDate)
                        .startTime(startTime)
                        .endTime(endTime)
                        .status(SessionStatus.DRAFT)
                        .build();

                sessionRepository.save(session);
                totalCreated++;
            }
        }

        log.info("[GENERATE_DRAFTS] totalCreated={}, week={}/{}", totalCreated, nextMonday, nextSunday);
        return totalCreated;
    }

    // ─── Reset Drafts (delete all drafts → regenerate) ────────────

    @Transactional
    public Map<String, Object> resetDrafts(UUID tutorId, LocalDate targetDate) {
        LocalDate targetMonday = targetDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate targetSunday = targetMonday.plusDays(6);

        // Delete all DRAFT sessions for this tutor in the target week
        List<SessionEntity> existingDrafts = sessionRepository.findByTutorIdAndStatusAndDateBetween(
                tutorId, SessionStatus.DRAFT, targetMonday, targetSunday,
                Sort.by(Sort.Direction.ASC, "sessionDate")
        );
        int deletedCount = existingDrafts.size();
        sessionRepository.deleteAll(existingDrafts);

        log.info("[RESET_DRAFTS] tutorId={}, deletedCount={}, week={}/{}",
                tutorId, deletedCount, targetMonday, targetSunday);

        // Regenerate from class schedule
        Map<String, Object> genResult = generateDraftsForTutor(tutorId, targetDate);
        int createdCount = (int) genResult.get("createdCount");

        return Map.of(
                "deletedCount", deletedCount,
                "createdCount", createdCount,
                "weekStart", targetMonday.toString(),
                "weekEnd", targetSunday.toString()
        );
    }

    // ─── Create Single Draft (from class panel) ───────────────────

    @Transactional
    public SessionDTO createSingleDraft(UUID tutorId, CreateDraftRequest request) {
        ClassEntity cls = classRepository.findById(request.getClassId())
                .orElseThrow(() -> new EntityNotFoundException(ERR_CLASS_NOT_FOUND));

        if (!tutorId.equals(cls.getTutorId())) {
            throw new BusinessRuleException(ERR_NOT_CLASS_TUTOR);
        }

        LocalTime startTime = request.getStartTime();
        LocalTime endTime = request.getEndTime();
        LocalDate sessionDate = request.getSessionDate();

        validateTimeRange(startTime, endTime);
        checkTimeConflict(tutorId, sessionDate, startTime, endTime, null);

        SessionType sessionType = SessionType.EXTRA;

        // Link to making up a cancelled session if specified
        if (request.getMakeupForSessionId() != null) {
            sessionType = SessionType.MAKEUP;
            // Removed mutation of target 'requiresMakeup' to allow organic offset accumulation
        } else {
            LocalDate targetMonday = sessionDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
            LocalDate targetSunday = targetMonday.plusDays(6);
            long regularThisWeek = sessionRepository.findByClsId(cls.getId(), Sort.unsorted()).stream()
                    .filter(s -> !s.getStatus().name().startsWith("CANCELLED"))
                    .filter(s -> s.getSessionType() == SessionType.REGULAR)
                    .filter(s -> !s.getSessionDate().isBefore(targetMonday) && !s.getSessionDate().isAfter(targetSunday))
                    .count();
            int sessionsPerWeek = cls.getSessionsPerWeek() != null ? cls.getSessionsPerWeek() : 0;
            if (regularThisWeek < sessionsPerWeek) {
                sessionType = SessionType.REGULAR;
            }
        }

        SessionEntity session = SessionEntity.builder()
                .cls(cls)
                .sessionDate(sessionDate)
                .startTime(startTime)
                .endTime(endTime)
                .status(SessionStatus.DRAFT)
                .sessionType(sessionType)
                .build();

        // Cleanup overlapping CANCELLED sessions for the same class so they don't clutter the UI
        List<SessionEntity> sameDaySessions = sessionRepository.findByTutorIdAndDateBetween(
                tutorId, sessionDate, sessionDate, Sort.by(Sort.Direction.ASC, "startTime"));
        for (SessionEntity existing : sameDaySessions) {
            if (existing.getStatus() == SessionStatus.CANCELLED && existing.getCls().getId().equals(cls.getId())) {
                boolean isOverlapping = startTime.isBefore(existing.getEndTime()) && endTime.isAfter(existing.getStartTime());
                if (isOverlapping) {
                    sessionRepository.delete(existing);
                    log.info("[CREATE_SINGLE_DRAFT] Deleted overlapping CANCELLED session {}", existing.getId());
                }
            }
        }

        session = sessionRepository.save(session);
        log.info("[CREATE_SINGLE_DRAFT] tutorId={}, classId={}, date={}, time={}-{}",
                tutorId, request.getClassId(), sessionDate, startTime, endTime);

        return SessionDTO.fromEntity(session);
    }

    // ─── Generate Drafts for Tutor (on-demand) ─────────────────────

    @Transactional
    public Map<String, Object> generateDraftsForTutor(UUID tutorId, LocalDate targetDate) {
        LocalDate targetMonday = targetDate.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate targetSunday = targetMonday.plusDays(6);

        if (targetSunday.isBefore(LocalDate.now())) {
            throw new BusinessRuleException("Chỉ có thể tạo lịch cho tuần hiện tại hoặc tương lai");
        }

        // Chỉ cho tạo lịch tuần SAU từ Thứ 4 (T4) trở đi
        LocalDate thisMonday = LocalDate.now().with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        boolean isNextWeek = targetMonday.isAfter(thisMonday);
        if (isNextWeek && LocalDate.now().getDayOfWeek().getValue() < DayOfWeek.WEDNESDAY.getValue()) {
            throw new BusinessRuleException("Chỉ có thể tạo lịch tuần sau từ Thứ 4 trở đi");
        }

        List<ClassEntity> tutorClasses = classRepository.findByTutorIdAndStatusAndIsDeletedFalse(
                tutorId, ClassStatus.ACTIVE);

        // Validate: tất cả lớp ACTIVE phải có schedule
        List<String> unscheduledClassNames = tutorClasses.stream()
                .filter(c -> c.getSchedule() == null || "[]".equals(c.getSchedule()))
                .map(ClassEntity::getTitle)
                .collect(Collectors.toList());
        if (!unscheduledClassNames.isEmpty()) {
            throw new BusinessRuleException(
                    String.format(ERR_CLASSES_NO_SCHEDULE, String.join(", ", unscheduledClassNames)));
        }

        int totalCreated = 0;

        for (ClassEntity cls : tutorClasses) {
            if (cls.getSchedule() == null || "[]".equals(cls.getSchedule())) {
                continue;
            }

            List<ScheduleSlotDTO> slots = parseSchedule(cls.getSchedule());
            for (ScheduleSlotDTO slot : slots) {
                DayOfWeek dayOfWeek = WeekDay.resolve(slot.getDayOfWeek());
                if (dayOfWeek == null) {
                    log.warn("[GENERATE_DRAFTS_TUTOR] Unknown dayOfWeek '{}' in class {}",
                            slot.getDayOfWeek(), cls.getId());
                    continue;
                }

                LocalDate sessionDate = targetMonday.with(TemporalAdjusters.nextOrSame(dayOfWeek));
                if (sessionDate.isAfter(targetSunday)) continue;

                LocalTime startTime = LocalTime.parse(slot.getStartTime());
                LocalTime endTime = LocalTime.parse(slot.getEndTime());

                boolean exists = sessionRepository.existsByClsIdAndSessionDateAndStartTime(
                        cls.getId(), sessionDate, startTime);
                if (exists) continue;

                SessionEntity session = SessionEntity.builder()
                        .cls(cls)
                        .sessionDate(sessionDate)
                        .startTime(startTime)
                        .endTime(endTime)
                        .status(SessionStatus.DRAFT)
                        .build();

                sessionRepository.save(session);
                totalCreated++;
            }
        }

        log.info("[GENERATE_DRAFTS_TUTOR] tutorId={}, totalCreated={}, week={}/{}",
                tutorId, totalCreated, targetMonday, targetSunday);

        return Map.of(
                "createdCount", totalCreated,
                "weekStart", targetMonday.toString(),
                "weekEnd", targetSunday.toString()
        );
    }

    // ─── Auto-Confirm Drafts (called by Scheduler) ────────────────

    @Transactional
    public int autoConfirmDrafts() {
        LocalDate nextMonday = LocalDate.now().with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        LocalDate nextSunday = nextMonday.plusDays(6);

        List<SessionEntity> allDrafts = sessionRepository.findByStatusAndSessionDateBetween(
                SessionStatus.DRAFT, nextMonday, nextSunday
        );

        for (SessionEntity session : allDrafts) {
            session.setStatus(SessionStatus.SCHEDULED);
        }

        sessionRepository.saveAll(allDrafts);
        log.info("[AUTO_CONFIRM] confirmedCount={}, week={}/{}", allDrafts.size(), nextMonday, nextSunday);
        return allDrafts.size();
    }

    // ─── Private helpers ───────────────────────────────────────────

    private SessionEntity findOwnedDraftSession(UUID tutorId, UUID sessionId) {
        SessionEntity session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new EntityNotFoundException(ERR_SESSION_NOT_FOUND));

        if (!tutorId.equals(session.getCls().getTutorId())) {
            throw new BusinessRuleException(ERR_NOT_SESSION_TUTOR);
        }
        if (session.getStatus() != SessionStatus.DRAFT) {
            throw new BusinessRuleException(ERR_DRAFT_ONLY);
        }
        return session;
    }

    private void validateScheduleSlots(List<ScheduleSlotDTO> slots) {
        if (slots == null || slots.isEmpty()) {
            throw new BusinessRuleException(ERR_EMPTY_SCHEDULE);
        }
        for (ScheduleSlotDTO slot : slots) {
            if (WeekDay.resolve(slot.getDayOfWeek()) == null) {
                throw new BusinessRuleException(String.format(ERR_INVALID_DAY, slot.getDayOfWeek()));
            }
            LocalTime start = LocalTime.parse(slot.getStartTime());
            LocalTime end = LocalTime.parse(slot.getEndTime());
            validateTimeRange(start, end);
        }
    }

    private void validateTimeRange(LocalTime start, LocalTime end) {
        if (!start.isBefore(end)) {
            throw new BusinessRuleException(ERR_START_BEFORE_END);
        }
        long durationMinutes = Duration.between(start, end).toMinutes();
        if (durationMinutes < MIN_DURATION_MINUTES || durationMinutes > MAX_DURATION_MINUTES) {
            throw new BusinessRuleException(
                    String.format(ERR_DURATION_RANGE, MIN_DURATION_MINUTES, MAX_DURATION_MINUTES));
        }
    }

    private void checkTimeConflict(UUID tutorId, LocalDate date, LocalTime start, LocalTime end, UUID excludeSessionId) {
        List<SessionEntity> sameDaySessions = sessionRepository.findByTutorIdAndDateBetween(
                tutorId, date, date,
                Sort.by(Sort.Direction.ASC, "startTime")
        );

        long activeSessions = sameDaySessions.stream()
                .filter(s -> s.getStatus() != SessionStatus.CANCELLED)
                .filter(s -> !s.getId().equals(excludeSessionId))
                .count();
        if (activeSessions >= MAX_SESSIONS_PER_DAY) {
            throw new BusinessRuleException(String.format(ERR_MAX_SESSIONS, MAX_SESSIONS_PER_DAY));
        }

        for (SessionEntity existing : sameDaySessions) {
            if (existing.getId().equals(excludeSessionId)) continue;
            if (existing.getStatus() == SessionStatus.CANCELLED) continue;

            boolean isOverlapping = start.isBefore(existing.getEndTime()) && end.isAfter(existing.getStartTime());
            if (isOverlapping) {
                throw new BusinessRuleException(String.format(
                        ERR_TIME_CONFLICT,
                        existing.getCls().getTitle(),
                        existing.getStartTime(), existing.getEndTime()));
            }
        }
    }

    /**
     * Validate lịch mới không trùng giờ với các lớp khác cùng gia sư.
     */
    private void validateCrossClassConflicts(UUID tutorId, UUID currentClassId, List<ScheduleSlotDTO> newSlots) {
        List<ClassEntity> otherClasses = classRepository.findByTutorIdAndStatusAndIsDeletedFalse(
                tutorId, ClassStatus.ACTIVE
        ).stream()
                .filter(c -> !c.getId().equals(currentClassId))
                .filter(c -> c.getSchedule() != null && !"[]".equals(c.getSchedule()))
                .collect(Collectors.toList());

        for (ClassEntity other : otherClasses) {
            List<ScheduleSlotDTO> otherSlots = parseSchedule(other.getSchedule());
            for (ScheduleSlotDTO newSlot : newSlots) {
                for (ScheduleSlotDTO existingSlot : otherSlots) {
                    if (!newSlot.getDayOfWeek().equals(existingSlot.getDayOfWeek())) continue;

                    LocalTime newStart = LocalTime.parse(newSlot.getStartTime());
                    LocalTime newEnd = LocalTime.parse(newSlot.getEndTime());
                    LocalTime existStart = LocalTime.parse(existingSlot.getStartTime());
                    LocalTime existEnd = LocalTime.parse(existingSlot.getEndTime());

                    boolean isOverlapping = newStart.isBefore(existEnd) && newEnd.isAfter(existStart);
                    if (isOverlapping) {
                        throw new BusinessRuleException(String.format(
                                ERR_CROSS_CLASS_CONFLICT,
                                other.getTitle(),
                                existingSlot.getDayOfWeek(),
                                existingSlot.getStartTime(),
                                existingSlot.getEndTime()
                        ));
                    }
                }
            }
        }
    }

    private List<ScheduleSlotDTO> parseSchedule(String scheduleJson) {
        try {
            return objectMapper.readValue(scheduleJson, new TypeReference<>() {});
        } catch (JsonProcessingException e) {
            log.warn("[PARSE_SCHEDULE] Failed to parse JSON, classSchedule={}", scheduleJson, e);
            return Collections.emptyList();
        }
    }

    // ─── Quota Tracking ────────────────────────────────────────────────
    @Transactional
    public List<ClassQuotaDTO> getWeeklyQuotaStatus(UUID tutorId, LocalDate weekOf) {
        LocalDate monday = weekOf.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate sunday = monday.plusDays(6);

        List<ClassEntity> classes = classRepository.findByTutorIdAndStatusAndIsDeletedFalse(tutorId, ClassStatus.ACTIVE);
        List<SessionEntity> weekSessions = sessionRepository.findByTutorIdAndDateBetween(tutorId, monday, sunday, Sort.by("sessionDate"));

        return classes.stream().map(cls -> {
            int target = cls.getSessionsPerWeek() != null ? cls.getSessionsPerWeek() : 0;

            // Chưa set ngày bắt đầu học hoặc tuần này trước ngày bắt đầu -> không tính quota
            if (cls.getLearningStartDate() == null || sunday.isBefore(cls.getLearningStartDate())) {
                target = 0;
            }

            long regular = 0;
            long makeup = 0;
            long extra = 0;

            for (SessionEntity s : weekSessions) {
                boolean isCancelled = s.getStatus() == SessionStatus.CANCELLED ||
                                      s.getStatus() == SessionStatus.CANCELLED_BY_TUTOR ||
                                      s.getStatus() == SessionStatus.CANCELLED_BY_STUDENT;

                if (s.getCls().getId().equals(cls.getId()) && !isCancelled) {
                    if (s.getSessionType() == SessionType.REGULAR) regular++;
                    else if (s.getSessionType() == SessionType.MAKEUP) makeup++;
                    else if (s.getSessionType() == SessionType.EXTRA) extra++;;
                }
            }

            // Auto-fix: nếu quota chưa đủ REGULAR mà có EXTRA -> chuyển EXTRA thành REGULAR
            if (target > 0 && regular < target && extra > 0) {
                long needToPromote = Math.min(extra, target - regular);
                for (SessionEntity s : weekSessions) {
                    if (needToPromote <= 0) break;
                    if (s.getCls().getId().equals(cls.getId())
                            && s.getSessionType() == SessionType.EXTRA
                            && s.getStatus() != SessionStatus.CANCELLED
                            && s.getStatus() != SessionStatus.CANCELLED_BY_TUTOR
                            && s.getStatus() != SessionStatus.CANCELLED_BY_STUDENT) {
                        s.setSessionType(SessionType.REGULAR);
                        sessionRepository.save(s);
                        log.info("[AUTO_FIX_TYPE] session {} EXTRA->REGULAR for class {}", s.getId(), cls.getClassCode());
                        regular++;
                        extra--;
                        needToPromote--;
                    }
                }
            }

            // Tất cả buổi active (regular + makeup + extra) đều được tính vào quota
            long totalActive = regular + makeup + extra;
            int missing = (int) Math.max(0, target - totalActive);
            int excess = (int) Math.max(0, totalActive - target);

            return ClassQuotaDTO.builder()
                    .classId(cls.getId())
                    .classCode(cls.getClassCode())
                    .classTitle(cls.getTitle())
                    .targetSessions(target)
                    .regularSessions((int) regular)
                    .makeupSessions((int) makeup)
                    .extraSessions((int) extra)
                    .missingCount(missing)
                    .excessCount(excess)
                    .build();
        }).collect(Collectors.toList());
    }
}
