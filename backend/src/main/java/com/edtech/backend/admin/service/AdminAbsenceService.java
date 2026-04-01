package com.edtech.backend.admin.service;

import com.edtech.backend.admin.dto.AdminAbsenceRequestDTO;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.entity.AbsenceRequestEntity;
import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.AbsenceRequestStatus;
import com.edtech.backend.cls.enums.AbsenceRequestType;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.repository.AbsenceRequestRepository;
import com.edtech.backend.cls.repository.SessionRepository;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminAbsenceService {

    private final AbsenceRequestRepository absenceRequestRepository;
    private final SessionRepository sessionRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<AdminAbsenceRequestDTO> getAllRequests() {
        return absenceRequestRepository.findAll().stream().map(req -> {
            SessionEntity session = req.getSession();
            String studentName = null;
            if (session.getCls() != null && session.getCls().getStudents() != null && !session.getCls().getStudents().isEmpty()) {
                studentName = session.getCls().getStudents().iterator().next().getFullName();
            }

            String tutorName = null;
            if (session.getCls() != null && session.getCls().getTutorId() != null) {
                tutorName = userRepository.findById(session.getCls().getTutorId())
                        .map(UserEntity::getFullName)
                        .orElse(null);
            }

            return AdminAbsenceRequestDTO.builder()
                    .id(req.getId())
                    .sessionId(session.getId())
                    .sessionDate(session.getSessionDate())
                    .startTime(session.getStartTime())
                    .endTime(session.getEndTime())
                    .classTitle(session.getCls() != null ? session.getCls().getTitle() : null)
                    .subject(session.getCls() != null ? session.getCls().getSubject() : null)
                    .tutorName(tutorName)
                    .studentName(studentName)
                    .requestType(req.getRequestType())
                    .reason(req.getReason())
                    .makeUpRequired(req.getMakeUpRequired())
                    .makeupDate(req.getMakeupDate())
                    .makeupTime(req.getMakeupTime())
                    .status(req.getStatus())
                    .createdAt(req.getCreatedAt())
                    .reviewedBy(req.getReviewedBy() != null ? req.getReviewedBy().getFullName() : null)
                    .reviewedAt(req.getReviewedAt())
                    .build();
        }).toList();
    }

    @Transactional
    public void processRequest(UUID requestId, boolean isApproved) {
        AbsenceRequestEntity request = absenceRequestRepository.findById(requestId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy yêu cầu xin nghỉ."));

        if (request.getStatus() != AbsenceRequestStatus.PENDING) {
            throw new BusinessRuleException("Yêu cầu này đã được xử lý trước đó.");
        }

        UUID adminId = resolveAdminId();
        UserEntity admin = userRepository.findById(adminId).orElse(null);

        request.setStatus(isApproved ? AbsenceRequestStatus.APPROVED : AbsenceRequestStatus.REJECTED);
        request.setReviewedBy(admin);
        request.setReviewedAt(OffsetDateTime.now());

        if (isApproved) {
            SessionEntity session = request.getSession();

            if (request.getRequestType() == AbsenceRequestType.TUTOR_LEAVE) {
                session.setStatus(SessionStatus.CANCELLED_BY_TUTOR);
            } else {
                session.setStatus(SessionStatus.CANCELLED_BY_STUDENT);
            }

            if (Boolean.TRUE.equals(request.getMakeUpRequired())) {
                session.setRequiresMakeup(true);
            }

            sessionRepository.save(session);

            // Auto-generate makeup session if requested
            if (Boolean.TRUE.equals(request.getMakeUpRequired())
                    && request.getMakeupDate() != null
                    && request.getMakeupTime() != null) {

                Duration originalDuration = Duration.between(session.getStartTime(), session.getEndTime());

                SessionEntity makeupSession = SessionEntity.builder()
                        .cls(session.getCls())
                        .sessionDate(request.getMakeupDate())
                        .startTime(request.getMakeupTime())
                        .endTime(request.getMakeupTime().plus(originalDuration))
                        .status(SessionStatus.SCHEDULED)
                        .tutorNote(String.format("[HỌC BÙ] Bù cho buổi %s (%s - %s)",
                                session.getSessionDate(),
                                session.getStartTime().toString().substring(0, 5),
                                session.getEndTime().toString().substring(0, 5)))
                        .build();

                sessionRepository.save(makeupSession);
                log.info("[ADMIN_MAKEUP] Created makeup session {} for cancelled session {}",
                        makeupSession.getId(), session.getId());
            }
        }

        absenceRequestRepository.save(request);
        log.info("[ADMIN_ABSENCE] Admin {} processed absence request {} -> {}", adminId, requestId, request.getStatus());
    }

    private UUID resolveAdminId() {
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (principal instanceof UserEntity user) {
                return user.getId();
            } else if (principal instanceof String principalStr) {
                UserEntity u = userRepository.findByPhoneAndIsDeletedFalse(principalStr).orElse(null);
                if (u != null) return u.getId();
            }
        } catch (Exception e) {
            log.warn("Cannot resolve admin ID from security context: {}", e.getMessage());
        }
        return UUID.fromString("00000000-0000-0000-0000-000000000001");
    }
}

