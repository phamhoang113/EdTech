package com.edtech.backend.tutor.service;

import java.util.UUID;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
import com.edtech.backend.tutor.dto.request.TutorAbsenceReqDTO;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TutorAbsenceService {

    private final AbsenceRequestRepository absenceRequestRepository;
    private final SessionRepository sessionRepository;
    private final UserRepository userRepository;

    @Transactional
    public void createAbsenceRequest(TutorAbsenceReqDTO request) {
        UUID tutorId = resolveTutorId();
        UserEntity tutor = userRepository.findById(tutorId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy gia sư"));

        SessionEntity session = sessionRepository.findById(request.getSessionId())
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy ca học"));

        // Verify ownership
        if (session.getCls().getTutorId() == null || !session.getCls().getTutorId().equals(tutorId)) {
            throw new BusinessRuleException("Bạn không phải gia sư của lớp này");
        }

        // Verify session status
        if (session.getStatus() != SessionStatus.SCHEDULED) {
            throw new BusinessRuleException("Chỉ có thể xin nghỉ các ca học đã chốt (SCHEDULED).");
        }

        boolean hasMakeup = request.getMakeupDate() != null;

        AbsenceRequestEntity absenceRequest = AbsenceRequestEntity.builder()
                .session(session)
                .requester(tutor)
                .requestType(AbsenceRequestType.TUTOR_LEAVE)
                .reason(request.getReason())
                .makeupDate(request.getMakeupDate())
                .makeupTime(request.getMakeupTime())
                .proofUrl(request.getProofUrl())
                .status(AbsenceRequestStatus.PENDING)
                .makeUpRequired(hasMakeup)
                .build();

        absenceRequestRepository.save(absenceRequest);
        
        log.info("[TUTOR_ABSENCE] Tutor {} created absence request for session {}", tutorId, session.getId());
    }

    private UUID resolveTutorId() {
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            String username = null;
            
            if (principal instanceof UserDetails userDetails) {
                username = userDetails.getUsername();
            } else if (principal instanceof String principalStr) {
                username = principalStr;
            } else if (principal instanceof UserEntity user) {
                return user.getId();
            }

            if (username != null) {
                UserEntity u = userRepository.findByPhoneAndIsDeletedFalse(username).orElse(null);
                if (u != null) return u.getId();
            }
        } catch (Exception e) {
            log.warn("Cannot resolve tutor ID from security context: {}", e.getMessage());
        }
        throw new BusinessRuleException("Unauthorized");
    }
}
