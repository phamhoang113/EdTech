package com.edtech.backend.admin.controller;

import java.util.Map;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.admin.dto.DashboardStatsResponse;
import com.edtech.backend.admin.service.AdminDashboardService;
import com.edtech.backend.core.dto.ApiResponse;

@RestController
@RequestMapping("/api/v1/admin/dashboard")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminDashboardController {

    private final AdminDashboardService adminDashboardService;

    /** Lấy toàn bộ số liệu tổng quan cho trang Dashboard admin */
    @GetMapping("/stats")
    public ApiResponse<DashboardStatsResponse> getStats() {
        return ApiResponse.ok(adminDashboardService.getStats());
    }

    /** Lấy badge counts nhẹ cho sidebar admin */
    @GetMapping("/badge-counts")
    public ApiResponse<Map<String, Long>> getBadgeCounts() {
        return ApiResponse.ok(adminDashboardService.getBadgeCounts());
    }
}
