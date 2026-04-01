package com.edtech.backend.admin.controller;

import com.edtech.backend.admin.service.AdminAbsenceService;
import com.edtech.backend.core.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin/absence-requests")
@RequiredArgsConstructor
@Tag(name = "Admin Absence Management", description = "Admin API for managing tutor/student absence requests")
public class AdminAbsenceController {

    private final AdminAbsenceService adminAbsenceService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get list of all absence requests")
    public ResponseEntity<ApiResponse<Object>> getAllRequests() {
        return ResponseEntity.ok(ApiResponse.ok(adminAbsenceService.getAllRequests()));
    }

    @PostMapping("/{id}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Approve an absence request")
    public ResponseEntity<ApiResponse<String>> approveRequest(@PathVariable UUID id) {
        adminAbsenceService.processRequest(id, true);
        return ResponseEntity.ok(ApiResponse.<String>ok(null, "Đơn đã được phê duyệt."));
    }

    @PostMapping("/{id}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Reject an absence request")
    public ResponseEntity<ApiResponse<String>> rejectRequest(@PathVariable UUID id) {
        adminAbsenceService.processRequest(id, false);
        return ResponseEntity.ok(ApiResponse.<String>ok(null, "Đơn đã bị từ chối."));
    }
}
