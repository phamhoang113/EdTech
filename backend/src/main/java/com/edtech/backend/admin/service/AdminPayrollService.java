package com.edtech.backend.admin.service;

import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.repository.SessionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminPayrollService {

    private final SessionRepository sessionRepository;

    public Object getPayrollStats(LocalDate startDate, LocalDate endDate, UUID tutorId) {
        Sort sort = Sort.by("sessionDate").ascending();
        List<SessionEntity> sessions;
        if (tutorId != null) {
            sessions = sessionRepository.findByTutorIdAndDateBetween(tutorId, startDate, endDate, sort);
        } else {
            sessions = sessionRepository.findBySessionDateBetween(startDate, endDate, sort);
        }

        // Only count COMPLETED sessions for payroll
        long completedSessions = sessions.stream()
                .filter(s -> s.getStatus() == SessionStatus.COMPLETED)
                .count();

        // Calculate total tutor fee (dummy mapping from cls)
        double totalSalary = sessions.stream()
                .filter(s -> s.getStatus() == SessionStatus.COMPLETED)
                .mapToDouble(s -> s.getCls().getTutorFee() != null ? s.getCls().getTutorFee().doubleValue() : 0.0)
                .sum();

        // Calculate penalties (dummy logic: CANCELLED_BY_TUTOR)
        long penalties = sessions.stream()
                .filter(s -> s.getStatus() == SessionStatus.CANCELLED_BY_TUTOR)
                .count();

        return Map.of(
                "totalCompletedSessions", completedSessions,
                "totalSalary", totalSalary,
                "totalPenalties", penalties,
                "penaltyAmount", penalties * 100000 // Giả sử 1 lỗi phạt 100k
        );
    }
}
