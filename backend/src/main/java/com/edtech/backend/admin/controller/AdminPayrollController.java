package com.edtech.backend.admin.controller;

import com.edtech.backend.admin.service.AdminPayrollService;
import com.edtech.backend.core.dto.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin/payrolls")
@RequiredArgsConstructor
@Tag(name = "Admin Payroll Management", description = "Admin API for tutor payrolls and KPIs")
public class AdminPayrollController {

    private final AdminPayrollService adminPayrollService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get payroll and KPI statistics for tutors")
    public ResponseEntity<ApiResponse<Object>> getPayrolls(
            @RequestParam(required = false) UUID tutorId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        return ResponseEntity.ok(ApiResponse.ok(adminPayrollService.getPayrollStats(startDate, endDate, tutorId)));
    }
}
