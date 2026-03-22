package com.edtech.backend.cls.service;

import com.edtech.backend.cls.dto.SessionCancelRequest;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.repository.SessionRepository;
import com.edtech.backend.core.exception.BadRequestException;
import com.edtech.backend.core.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ParentSessionService {

    private final SessionRepository sessionRepository;

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

        return sessions.stream()
                .map(SessionDTO::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public SessionDTO cancelSession(UUID parentId, UUID sessionId, SessionCancelRequest request) {
        SessionEntity session = sessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResourceNotFoundException("Buổi học không tồn tại"));

        // Verify ownership (the session must belong to a class of one of the parent's children)
        if (!session.getCls().getParent().getId().equals(parentId)) {
            throw new BadRequestException("Bạn không có quyền thao tác trên buổi học này");
        }

        if (session.getStatus() != SessionStatus.SCHEDULED) {
            throw new BadRequestException("Chỉ có thể huỷ những buổi học chưa diễn ra");
        }

        LocalDateTime sessionDateTime = LocalDateTime.of(session.getSessionDate(), session.getStartTime());
        LocalDateTime now = LocalDateTime.now();

        // Ràng buộc thời gian: trước 2 tiếng
        if (now.plusHours(2).isAfter(sessionDateTime)) {
            throw new BadRequestException("Chỉ được huỷ buổi học trước 2 tiếng so với thời gian bắt đầu. Vui lòng liên hệ trực tiếp Gia sư hoặc Trung tâm.");
        }

        session.setStatus(SessionStatus.CANCELLED);
        
        // Log lý do huỷ vào tutorNote tạm thời (hoặc tạo bảng SessionCancellation sau)
        String cancelNote = String.format("[PHỤ HUYNH HUỶ LỊCH]\nLý do: %s\nYêu cầu bù: %s",
                request.getReason() != null ? request.getReason() : "Không có",
                request.isMakeUpRequired() ? "CÓ" : "KHÔNG");
                
        session.setTutorNote(session.getTutorNote() != null 
            ? session.getTutorNote() + "\n\n" + cancelNote 
            : cancelNote);

        session = sessionRepository.save(session);
        return SessionDTO.fromEntity(session);
    }
}
