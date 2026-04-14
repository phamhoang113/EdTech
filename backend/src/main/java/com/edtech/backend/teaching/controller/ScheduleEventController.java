package com.edtech.backend.teaching.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

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
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.student.entity.StudentProfileEntity;
import com.edtech.backend.student.repository.StudentProfileRepository;
import com.edtech.backend.teaching.dto.response.ScheduleEventResponse;
import com.edtech.backend.teaching.service.ScheduleEventService;

/**
 * API gộp schedule events (homework deadlines + exams) cho calendar.
 */
@RestController
@RequestMapping("/api/v1/schedule")
@RequiredArgsConstructor
@Tag(name = "Teaching - Schedule Events", description = "Events cho calendar: deadline BT, lịch KT")
@SecurityRequirement(name = "bearerAuth")
public class ScheduleEventController {

    private final ScheduleEventService scheduleEventService;
    private final UserRepository userRepository;
    private final ClassRepository classRepository;
    private final StudentProfileRepository studentProfileRepository;

    @GetMapping("/events")
    @PreAuthorize("hasAnyRole('TUTOR', 'PARENT', 'STUDENT')")
    @Operation(summary = "Lấy events cho calendar (gộp homework deadline + exam)")
    public ResponseEntity<ApiResponse<List<ScheduleEventResponse>>> getEvents(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        UUID userId = resolveUserId(userDetails);
        String role = resolveRole(userDetails);

        List<UUID> classIds = resolveClassIds(userId, role);

        List<ScheduleEventResponse> events =
                scheduleEventService.getTeachingEvents(classIds, startDate, endDate);

        return ResponseEntity.ok(ApiResponse.ok(events, "Schedule events."));
    }

    private List<UUID> resolveClassIds(UUID userId, String role) {
        List<ClassEntity> classes;
        switch (role) {
            case "TUTOR":
                classes = classRepository.findByTutorIdAndIsDeletedFalseOrderByCreatedAtDesc(userId);
                break;
            case "PARENT":
                classes = classRepository.findByParentIdAndIsDeletedFalseOrderByCreatedAtDesc(userId);
                break;
            case "STUDENT":
                // HS tự mở lớp → parentId = studentId (cùng logic StudentClassController)
                classes = classRepository.findByParentIdAndIsDeletedFalseOrderByCreatedAtDesc(userId);

                // Fallback: HS được PH thêm vào lớp → resolve parent qua StudentProfile
                if (classes.isEmpty()) {
                    UUID parentId = resolveParentIdForStudent(userId);
                    if (parentId != null) {
                        classes = classRepository.findByParentIdAndIsDeletedFalseOrderByCreatedAtDesc(parentId);
                    }
                }
                break;
            default:
                classes = List.of();
                break;
        }
        return classes.stream().map(ClassEntity::getId).collect(Collectors.toList());
    }

    private UUID resolveParentIdForStudent(UUID studentUserId) {
        List<StudentProfileEntity> profiles = studentProfileRepository.findByUserId(studentUserId);
        if (profiles.isEmpty()) {
            return null;
        }
        return profiles.get(0).getParentId();
    }

    private UUID resolveUserId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        return user.getId();
    }

    private String resolveRole(UserDetails userDetails) {
        return userDetails.getAuthorities().stream()
                .findFirst()
                .map(a -> a.getAuthority().replace("ROLE_", ""))
                .orElse("STUDENT");
    }
}

