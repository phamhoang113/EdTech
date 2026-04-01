package com.edtech.backend.cls.service;

import com.edtech.backend.cls.dto.ClassDTO;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.AbsenceRequestStatus;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.repository.AbsenceRequestRepository;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.cls.repository.SessionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class TutorSessionService {

    private static final int DEFAULT_RANGE_DAYS = 30;
    private static final List<ClassStatus> ACTIVE_STATUSES = List.of(
            ClassStatus.ASSIGNED, ClassStatus.MATCHED, ClassStatus.ACTIVE
    );

    private final SessionRepository sessionRepository;
    private final ClassRepository classRepository;
    private final AbsenceRequestRepository absenceRequestRepository;

    @Transactional(readOnly = true)
    public List<SessionDTO> getSessionsByTutor(UUID tutorId, LocalDate startDate, LocalDate endDate) {
        if (startDate == null) {
            startDate = LocalDate.now().minusDays(DEFAULT_RANGE_DAYS);
        }
        if (endDate == null) {
            endDate = LocalDate.now().plusDays(DEFAULT_RANGE_DAYS);
        }

        List<SessionEntity> sessions = sessionRepository.findByTutorIdAndDateBetween(
                tutorId, startDate, endDate,
                Sort.by(Sort.Direction.ASC, "sessionDate", "startTime")
        );

        List<UUID> sessionIds = sessions.stream()
                .map(SessionEntity::getId)
                .collect(Collectors.toList());

        Set<UUID> pendingSessionIds = sessionIds.isEmpty() ? Set.of() :
            absenceRequestRepository.findSessionIdsWithStatus(sessionIds, AbsenceRequestStatus.PENDING);

        return sessions.stream()
                .map(s -> {
                    SessionDTO dto = SessionDTO.fromEntity(s);
                    dto.setHasPendingAbsence(pendingSessionIds.contains(s.getId()));
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ClassDTO> getMyClasses(UUID tutorId) {
        List<ClassEntity> classes = classRepository.findByTutorIdAndStatusInAndIsDeletedFalse(
                tutorId, ACTIVE_STATUSES
        );
        return classes.stream()
                .map(ClassDTO::fromEntity)
                .collect(Collectors.toList());
    }

    /**
     * Kiểm tra gia sư đã có session nào trong tuần tích (Mon~Sun) chưa.
     * Dùng để hiển thị cảnh báo đỏ nếu cuối tuần chưa set lịch tuần sau.
     */
    @Transactional(readOnly = true)
    public boolean hasNextWeekSessions(UUID tutorId) {
        LocalDate today = LocalDate.now();
        LocalDate nextMonday = today.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
        LocalDate nextSunday = nextMonday.plusDays(6);

        List<SessionEntity> sessions = sessionRepository.findByTutorIdAndDateBetween(
                tutorId, nextMonday, nextSunday,
                Sort.by(Sort.Direction.ASC, "sessionDate")
        );

        return !sessions.isEmpty();
    }
}
