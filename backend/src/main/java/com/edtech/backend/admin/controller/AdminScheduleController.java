package com.edtech.backend.admin.controller;

import com.edtech.backend.admin.service.AdminScheduleService;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.core.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin/schedules")
@RequiredArgsConstructor
@Tag(name = "Admin Schedule Management", description = "Admin API for managing platform wide schedules")
public class AdminScheduleController {

    /** UUID dùng khi user nhập ID không hợp lệ → filter sẽ match nothing */
    private static final UUID NON_EXISTENT_UUID = UUID.fromString("00000000-0000-0000-0000-000000000000");

    private final AdminScheduleService adminScheduleService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get list of all sessions across the platform")
    public ResponseEntity<ApiResponse<Object>> getSchedules(
            @RequestParam(required = false) String tutorId,
            @RequestParam(required = false) String classCode,
            @RequestParam(required = false) String tutorName,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        UUID parsedTutorId = parseTutorId(tutorId);
        return ResponseEntity.ok(ApiResponse.ok(adminScheduleService.getSchedules(parsedTutorId, classCode, tutorName, startDate, endDate)));
    }

    @PatchMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update status of a session manually")
    public ResponseEntity<ApiResponse<String>> updateStatus(
            @PathVariable UUID id,
            @RequestParam SessionStatus status) {
        adminScheduleService.updateStatus(id, status);
        return ResponseEntity.ok(ApiResponse.<String>ok(null, "Cập nhật trạng thái thành công."));
    }

    @GetMapping("/analytics")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get analytics metrics for sessions (revenue, missing sessions, etc.)")
    public ResponseEntity<ApiResponse<Object>> getAnalytics(
            @RequestParam(required = false) String tutorId,
            @RequestParam(required = false) String classCode,
            @RequestParam(required = false) String tutorName,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        UUID parsedTutorId = parseTutorId(tutorId);
        return ResponseEntity.ok(ApiResponse.ok(adminScheduleService.getAnalytics(parsedTutorId, classCode, tutorName, startDate, endDate)));
    }

    @GetMapping("/quota-details")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get per-class quota shortfall/extra details for the current week")
    public ResponseEntity<ApiResponse<Object>> getQuotaDetails(
            @RequestParam(required = false) String tutorId) {
        UUID parsedTutorId = parseTutorId(tutorId);
        return ResponseEntity.ok(ApiResponse.ok(adminScheduleService.getQuotaDetails(parsedTutorId)));
    }

    @GetMapping("/suggest")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Autocomplete suggestions for tutors and classes")
    public ResponseEntity<ApiResponse<Object>> suggest(
            @RequestParam String keyword) {
        if (keyword.isBlank() || keyword.trim().length() < 1) {
            return ResponseEntity.ok(ApiResponse.ok(null));
        }
        return ResponseEntity.ok(ApiResponse.ok(adminScheduleService.getSuggestions(keyword.trim())));
    }

    // ─── Private Helpers ─────────────────────────────────────────────────────

    /** Trả null nếu rỗng (bỏ qua filter), UUID hợp lệ nếu đúng format, hoặc NON_EXISTENT nếu sai format → match nothing */
    private UUID parseTutorId(String tutorId) {
        if (tutorId == null || tutorId.isBlank()) {
            return null;
        }
        try {
            return UUID.fromString(tutorId.trim());
        } catch (IllegalArgumentException e) {
            return NON_EXISTENT_UUID;
        }
    }
}

