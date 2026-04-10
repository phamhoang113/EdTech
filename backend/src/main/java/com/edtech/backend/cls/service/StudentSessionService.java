package com.edtech.backend.cls.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
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

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.dto.SessionCancelRequest;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.entity.AbsenceRequestEntity;
import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.AbsenceRequestStatus;
import com.edtech.backend.cls.enums.AbsenceRequestType;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.repository.AbsenceRequestRepository;
import com.edtech.backend.cls.repository.SessionRepository;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.notification.entity.NotificationType;
import com.edtech.backend.notification.service.NotificationService;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class StudentSessionService {

    private static final int CANCELLATION_HOURS_BEFORE = 2;

    private static final String ERR_SESSION_NOT_FOUND = "Buổi học không tồn tại";
    private static final String ERR_NOT_IN_CLASS = "Bạn không có quyền thao tác trên buổi học này";
    private static final String ERR_ONLY_SCHEDULED = "Chỉ có thể huỷ những buổi học chưa diễn ra";
    private static final String ERR_TOO_LATE_TO_CANCEL =
            "Chỉ được huỷ buổi học trước 2 tiếng so với thời gian bắt đầu. Vui lòng liên hệ trực tiếp Gia sư hoặc Trung tâm.";
    private static final String DEFAULT_ABSENCE_REASON = "Không có lý do";

    private final SessionRepository sessionRepository;
    private final UserRepository userRepository;
    private final AbsenceRequestRepository absenceRequestRepository;
    private final NotificationService notificationService;

    public List<SessionDTO> getSessionsByStudent(UUID studentId, LocalDate startDate, LocalDate endDate) {
        if (startDate == null) {
            startDate = LocalDate.now().minusDays(30);
        }
        if (endDate == null) {
            endDate = LocalDate.now().plusDays(30);
        }

        List<SessionEntity> sessions = sessionRepository.findByStudentIdAndDateBetween(
                studentId, startDate, endDate, Sort.by(Sort.Direction.ASC, "sessionDate", "startTime")
        );

        Map<UUID, UserEntity> tutorMap = buildTutorMap(sessions);
        Set<UUID> pendingSessionIds = findPendingAbsenceSessionIds(sessions);

        return sessions.stream().map(session -> {
            SessionDTO dto = SessionDTO.fromEntity(session);
            enrichWithTutorInfo(dto, session, tutorMap);
            dto.setHasPendingAbsence(pendingSessionIds.contains(session.getId()));
            return dto;
        }).collect(Collectors.toList());
    }

    @Transactional
    public SessionDTO cancelSession(UUID studentId, UUID sessionId, SessionCancelRequest request) {
        log.info("[STUDENT_ABSENCE] studentId={}, sessionId={}", studentId, sessionId);

        SessionEntity session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new EntityNotFoundException(ERR_SESSION_NOT_FOUND));

        validateStudentBelongsToClass(studentId, session);
        validateSessionCanBeCancelled(session);

        UserEntity student = userRepository.findById(studentId).orElse(null);

        AbsenceRequestEntity absenceRequest = AbsenceRequestEntity.builder()
                .session(session)
                .requester(student)
                .requestType(AbsenceRequestType.STUDENT_LEAVE)
                .reason(request.getReason() != null ? request.getReason() : DEFAULT_ABSENCE_REASON)
                .makeUpRequired(request.isMakeUpRequired())
                .status(AbsenceRequestStatus.PENDING)
                .build();

        absenceRequestRepository.save(absenceRequest);

        log.info("[STUDENT_ABSENCE] studentId={}, sessionId={}, makeUp={}, absenceId={}",
                studentId, sessionId, request.isMakeUpRequired(), absenceRequest.getId());

        // Notify Admin + GS về đơn xin nghỉ
        String studentName = student != null ? student.getFullName() : "Học sinh";
        String classTitle = session.getCls().getTitle();
        String notifBody = String.format("%s xin nghỉ buổi học ngày %s (%s).",
                studentName, session.getSessionDate(), classTitle);

        notifyAbsenceToAdminsAndTutor(session, notifBody, absenceRequest.getId());

        return SessionDTO.fromEntity(session);
    }

    // ─── Private Helpers ─────────────────────────────────────────────────────

    private Map<UUID, UserEntity> buildTutorMap(List<SessionEntity> sessions) {
        Set<UUID> tutorIds = sessions.stream()
                .map(s -> s.getCls() != null ? s.getCls().getTutorId() : null)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        return userRepository.findAllById(tutorIds).stream()
                .collect(Collectors.toMap(UserEntity::getId, u -> u));
    }

    private Set<UUID> findPendingAbsenceSessionIds(List<SessionEntity> sessions) {
        List<UUID> sessionIds = sessions.stream().map(SessionEntity::getId).collect(Collectors.toList());
        return sessionIds.isEmpty() ? Set.of()
                : absenceRequestRepository.findSessionIdsWithStatus(sessionIds, AbsenceRequestStatus.PENDING);
    }

    private void enrichWithTutorInfo(SessionDTO dto, SessionEntity session, Map<UUID, UserEntity> tutorMap) {
        if (session.getCls() != null && session.getCls().getTutorId() != null) {
            UserEntity tutor = tutorMap.get(session.getCls().getTutorId());
            if (tutor != null) {
                dto.setTutorName(tutor.getFullName());
                dto.setTutorPhone(tutor.getPhone());
            }
        }
    }

    private void validateStudentBelongsToClass(UUID studentId, SessionEntity session) {
        boolean isStudentInClass = session.getCls().getStudents().stream()
                .anyMatch(st -> st.getId().equals(studentId));
        if (!isStudentInClass) {
            throw new BusinessRuleException(ERR_NOT_IN_CLASS);
        }
    }

    private void notifyAbsenceToAdminsAndTutor(SessionEntity session, String body, UUID absenceId) {
        // Notify tất cả Admin
        userRepository.findByRoleAndIsDeletedFalseOrderByCreatedAtDesc(UserRole.ADMIN)
                .forEach(admin -> notificationService.sendNotification(
                        admin.getId(), NotificationType.ABSENCE_REQUESTED,
                        "Đơn xin nghỉ mới", body, "ABSENCE", absenceId));

        // Notify GS của lớp
        UUID tutorId = session.getCls().getTutorId();
        if (tutorId != null) {
            notificationService.sendNotification(tutorId, NotificationType.ABSENCE_REQUESTED,
                    "Học sinh xin nghỉ", body, "ABSENCE", absenceId);
        }
    }

    private void validateSessionCanBeCancelled(SessionEntity session) {
        if (session.getStatus() != SessionStatus.SCHEDULED) {
            throw new BusinessRuleException(ERR_ONLY_SCHEDULED);
        }

        LocalDateTime sessionDateTime = LocalDateTime.of(session.getSessionDate(), session.getStartTime());
        LocalDateTime now = LocalDateTime.now();

        if (now.plusHours(CANCELLATION_HOURS_BEFORE).isAfter(sessionDateTime)) {
            throw new BusinessRuleException(ERR_TOO_LATE_TO_CANCEL);
        }
    }
}
