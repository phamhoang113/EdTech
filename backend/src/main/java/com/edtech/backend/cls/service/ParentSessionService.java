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
public class ParentSessionService {

    private static final String ERR_SESSION_NOT_FOUND = "Buổi học không tồn tại";
    private static final String ERR_NO_PERMISSION = "Bạn không có quyền thao tác trên buổi học này";
    private static final String ERR_ONLY_SCHEDULED = "Chỉ có thể huỷ những buổi học chưa diễn ra";
    private static final String ERR_CANCEL_TOO_LATE = "Chỉ được huỷ buổi học trước 2 tiếng so với thời gian bắt đầu. Vui lòng liên hệ trực tiếp Gia sư hoặc Trung tâm.";
    private static final int MIN_CANCEL_HOURS_BEFORE = 2;

    private final SessionRepository sessionRepository;
    private final AbsenceRequestRepository absenceRequestRepository;
    private final UserRepository userRepository;
    private final NotificationService notificationService;

    @Transactional(readOnly = true)
    public List<SessionDTO> getSessionsByParent(UUID parentId, LocalDate startDate, LocalDate endDate) {
        if (startDate == null) {
            startDate = LocalDate.now().minusDays(30);
        }
        if (endDate == null) {
            endDate = LocalDate.now().plusDays(30);
        }

        List<SessionEntity> sessions = sessionRepository.findByParentIdAndDateBetween(
                parentId, startDate, endDate, Sort.by(Sort.Direction.ASC, "sessionDate", "startTime")
        );

        Set<UUID> tutorIds = sessions.stream()
                .map(s -> s.getCls() != null ? s.getCls().getTutorId() : null)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());

        Map<UUID, UserEntity> tutorMap = tutorIds.isEmpty() ? Map.of() :
            userRepository.findAllById(tutorIds).stream()
            .collect(Collectors.toMap(UserEntity::getId, t -> t));

        List<UUID> sessionIds = sessions.stream()
                .map(SessionEntity::getId)
                .collect(Collectors.toList());

        Set<UUID> pendingSessionIds = sessionIds.isEmpty() ? Set.of() :
            absenceRequestRepository.findSessionIdsWithStatus(sessionIds, AbsenceRequestStatus.PENDING);

        return sessions.stream()
                .map(s -> {
                    SessionDTO dto = SessionDTO.fromEntity(s);
                    if (s.getCls() != null && s.getCls().getTutorId() != null) {
                        UserEntity tutor = tutorMap.get(s.getCls().getTutorId());
                        if (tutor != null) {
                            dto.setTutorName(tutor.getFullName());
                            dto.setTutorPhone(tutor.getPhone());
                        }
                    }
                    dto.setHasPendingAbsence(pendingSessionIds.contains(s.getId()));
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public SessionDTO cancelSession(UUID parentId, UUID sessionId, SessionCancelRequest request) {
        log.info("[PARENT_ABSENCE] parentId={}, sessionId={}", parentId, sessionId);
        SessionEntity session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new EntityNotFoundException(ERR_SESSION_NOT_FOUND));

        if (!session.getCls().getParentId().equals(parentId)) {
            throw new BusinessRuleException(ERR_NO_PERMISSION);
        }

        if (session.getStatus() != SessionStatus.SCHEDULED) {
            throw new BusinessRuleException(ERR_ONLY_SCHEDULED);
        }

        LocalDateTime sessionDateTime = LocalDateTime.of(session.getSessionDate(), session.getStartTime());
        LocalDateTime now = LocalDateTime.now();

        if (now.plusHours(MIN_CANCEL_HOURS_BEFORE).isAfter(sessionDateTime)) {
            throw new BusinessRuleException(ERR_CANCEL_TOO_LATE);
        }

        UserEntity parent = userRepository.findById(parentId).orElse(null);

        AbsenceRequestEntity absenceRequest = AbsenceRequestEntity.builder()
                .session(session)
                .requester(parent)
                .requestType(AbsenceRequestType.STUDENT_LEAVE)
                .reason(request.getReason() != null ? request.getReason() : "Không có lý do")
                .makeUpRequired(request.isMakeUpRequired())
                .status(AbsenceRequestStatus.PENDING)
                .build();

        absenceRequestRepository.save(absenceRequest);

        log.info("[PARENT_ABSENCE] parentId={}, sessionId={}, makeUp={}, absenceId={}",
                parentId, sessionId, request.isMakeUpRequired(), absenceRequest.getId());

        // Notify Admin + GS về đơn xin nghỉ
        String parentName = parent != null ? parent.getFullName() : "Phụ huynh";
        String classTitle = session.getCls().getTitle();
        String notifBody = String.format("%s xin nghỉ buổi học ngày %s (%s).",
                parentName, session.getSessionDate(), classTitle);

        notifyAbsenceToAdminsAndTutor(session, notifBody, absenceRequest.getId());

        return SessionDTO.fromEntity(session);
    }

    private void notifyAbsenceToAdminsAndTutor(SessionEntity session, String body, UUID absenceId) {
        userRepository.findByRoleAndIsDeletedFalseOrderByCreatedAtDesc(UserRole.ADMIN)
                .forEach(admin -> notificationService.sendNotification(
                        admin.getId(), NotificationType.ABSENCE_REQUESTED,
                        "Đơn xin nghỉ mới", body, "ABSENCE", absenceId));

        UUID tutorId = session.getCls().getTutorId();
        if (tutorId != null) {
            notificationService.sendNotification(tutorId, NotificationType.ABSENCE_REQUESTED,
                    "Phụ huynh xin nghỉ cho con", body, "ABSENCE", absenceId);
        }
    }
}
