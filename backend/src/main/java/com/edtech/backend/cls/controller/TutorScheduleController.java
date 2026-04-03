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
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.dto.ClassDTO;
import com.edtech.backend.cls.dto.ClassQuotaDTO;
import com.edtech.backend.cls.dto.CreateDraftRequest;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.dto.SetScheduleRequest;
import com.edtech.backend.cls.dto.UpdateDraftRequest;
import com.edtech.backend.cls.service.TutorScheduleService;
import com.edtech.backend.core.exception.EntityNotFoundException;

@RestController
@RequestMapping("/api/v1/tutor")
@RequiredArgsConstructor
@Tag(name = "Tutor - Schedule Management", description = "APIs cho gia sư quản lý lịch dạy hàng tuần")
@SecurityRequirement(name = "bearerAuth")
@PreAuthorize("hasRole('TUTOR')")
public class TutorScheduleController {

    private final TutorScheduleService scheduleService;
    private final UserRepository userRepository;

    // ─── Set/Update Class Schedule ──────────────────────────────────

    @PutMapping("/classes/{classId}/schedule")
    @Operation(summary = "Set hoặc cập nhật lịch mẫu cho lớp")
    public ResponseEntity<ClassDTO> setClassSchedule(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID classId,
            @RequestBody SetScheduleRequest request) {

        UUID tutorId = resolveUserId(userDetails);
        ClassDTO result = scheduleService.setClassSchedule(tutorId, classId, request);
        return ResponseEntity.ok(result);
    }

    // ─── Draft Sessions ────────────────────────────────────────────

    @GetMapping("/schedule/drafts")
    @Operation(summary = "Lấy tất cả draft sessions tuần tới")
    public ResponseEntity<List<SessionDTO>> getDrafts(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID tutorId = resolveUserId(userDetails);
        List<SessionDTO> drafts = scheduleService.getDraftSessions(tutorId);
        return ResponseEntity.ok(drafts);
    }

    @PutMapping("/schedule/drafts/{sessionId}")
    @Operation(summary = "Chỉnh sửa 1 draft session (giờ, link, note)")
    public ResponseEntity<SessionDTO> updateDraft(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID sessionId,
            @RequestBody UpdateDraftRequest request) {

        UUID tutorId = resolveUserId(userDetails);
        SessionDTO result = scheduleService.updateDraft(tutorId, sessionId, request);
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/schedule/drafts/{sessionId}")
    @Operation(summary = "Huỷ 1 draft session")
    public ResponseEntity<Void> deleteDraft(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID sessionId) {

        UUID tutorId = resolveUserId(userDetails);
        scheduleService.deleteDraft(tutorId, sessionId);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/schedule/confirm")
    @Operation(summary = "Xác nhận tất cả draft → SCHEDULED")
    public ResponseEntity<Map<String, Object>> confirmDrafts(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate weekOf) {

        UUID tutorId = resolveUserId(userDetails);
        Map<String, Object> result = scheduleService.confirmDrafts(tutorId, weekOf);
        return ResponseEntity.ok(result);
    }

    // ─── Generate Drafts On-Demand ────────────────────────────────

    @PostMapping("/schedule/generate-drafts")
    @Operation(summary = "Tạo draft sessions cho tuần chỉ định (tuần tương lai)")
    public ResponseEntity<Map<String, Object>> generateDrafts(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate weekOf) {

        UUID tutorId = resolveUserId(userDetails);
        Map<String, Object> result = scheduleService.generateDraftsForTutor(tutorId, weekOf);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/schedule/reset-drafts")
    @Operation(summary = "Đặt lại mặc định: xóa tất cả draft → tạo lại từ lịch lớp")
    public ResponseEntity<Map<String, Object>> resetDrafts(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate weekOf) {

        UUID tutorId = resolveUserId(userDetails);
        Map<String, Object> result = scheduleService.resetDrafts(tutorId, weekOf);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/schedule/drafts")
    @Operation(summary = "Tạo 1 draft session từ class panel")
    public ResponseEntity<SessionDTO> createSingleDraft(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody CreateDraftRequest request) {

        UUID tutorId = resolveUserId(userDetails);
        SessionDTO result = scheduleService.createSingleDraft(tutorId, request);
        return ResponseEntity.ok(result);
    }

    // ─── Schedule Status (enhanced) ────────────────────────────────

    @GetMapping("/schedule/status")
    @Operation(summary = "Kiểm tra trạng thái lịch tuần tới (draft count, etc.)")
    public ResponseEntity<Map<String, Object>> getScheduleStatus(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID tutorId = resolveUserId(userDetails);
        Map<String, Object> status = scheduleService.getScheduleStatus(tutorId);
        return ResponseEntity.ok(status);
    }

    @GetMapping("/schedule/quota")
    @Operation(summary = "Lấy báo cáo dư/thiếu số buổi REGULAR trong tuần của các lớp")
    public ResponseEntity<List<ClassQuotaDTO>> getWeeklyQuotaStatus(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate weekOf) {

        UUID tutorId = resolveUserId(userDetails);
        List<ClassQuotaDTO> quotaStatus = scheduleService.getWeeklyQuotaStatus(tutorId, weekOf);
        return ResponseEntity.ok(quotaStatus);
    }

    // ─── Private helpers ───────────────────────────────────────────

    private UUID resolveUserId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        return user.getId();
    }
}
