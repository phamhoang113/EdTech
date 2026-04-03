package com.edtech.backend.cls.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.dto.ClassDTO;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.service.TutorSessionService;
import com.edtech.backend.core.exception.EntityNotFoundException;

@RestController
@RequestMapping("/api/v1/tutor")
@RequiredArgsConstructor
@Tag(name = "Tutor - Dashboard", description = "APIs cho gia sư quản lý lớp học và lịch dạy")
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("hasRole('TUTOR')")
public class TutorSessionController {

    private final TutorSessionService tutorSessionService;
    private final UserRepository userRepository;

    @GetMapping("/sessions")
    @Operation(summary = "Lấy lịch dạy của gia sư", description = "Mặc định ±30 ngày")
    public ResponseEntity<List<SessionDTO>> getSessions(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        UUID tutorId = resolveUserId(userDetails);
        List<SessionDTO> sessions = tutorSessionService.getSessionsByTutor(tutorId, startDate, endDate);
        return ResponseEntity.ok(sessions);
    }

    @GetMapping("/classes")
    @Operation(summary = "Lấy danh sách lớp đang dạy")
    public ResponseEntity<List<ClassDTO>> getMyClasses(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID tutorId = resolveUserId(userDetails);
        List<ClassDTO> classes = tutorSessionService.getMyClasses(tutorId);
        return ResponseEntity.ok(classes);
    }

    private UUID resolveUserId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        return user.getId();
    }
}
