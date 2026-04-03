package com.edtech.backend.cls.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.dto.SessionCancelRequest;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.service.StudentSessionService;
import com.edtech.backend.core.exception.EntityNotFoundException;

@RestController
@RequestMapping("/api/v1/student/sessions")
@RequiredArgsConstructor
@Tag(name = "Student - Schedule Management", description = "Các API cho học sinh quản lý lịch học")
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("hasRole('STUDENT')")
public class StudentSessionController {

    private final StudentSessionService studentSessionService;
    private final UserRepository userRepository;

    @GetMapping
    @Operation(summary = "Lấy lịch học của học sinh", description = "Mặc định lấy từ -30 ngày đến +30 ngày nếu không có tham số")
    public ResponseEntity<List<SessionDTO>> getSessions(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        UUID studentId = user.getId();
        
        List<SessionDTO> sessions = studentSessionService.getSessionsByStudent(studentId, startDate, endDate);
        return ResponseEntity.ok(sessions);
    }

    @PostMapping("/{sessionId}/cancel")
    @Operation(summary = "Học sinh chủ động xin huỷ/nghỉ buổi học")
    public ResponseEntity<SessionDTO> cancelSession(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID sessionId,
            @RequestBody SessionCancelRequest request) {
        
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        UUID studentId = user.getId();
        
        SessionDTO result = studentSessionService.cancelSession(studentId, sessionId, request);
        return ResponseEntity.ok(result);
    }
}
