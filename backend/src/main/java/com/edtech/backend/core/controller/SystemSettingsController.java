package com.edtech.backend.core.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.dto.SystemSettingsDto;
import com.edtech.backend.core.service.SystemSettingsService;

@RestController
@RequestMapping("/api/v1/admin/settings")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class SystemSettingsController {

    private final SystemSettingsService systemSettingsService;

    /** Lấy toàn bộ cài đặt hệ thống */
    @GetMapping
    public ApiResponse<SystemSettingsDto> getSettings() {
        return ApiResponse.ok(systemSettingsService.getSettings());
    }

    /** Cập nhật toàn bộ cài đặt hệ thống */
    @PutMapping
    public ApiResponse<SystemSettingsDto> updateSettings(@RequestBody SystemSettingsDto dto) {
        return ApiResponse.ok(systemSettingsService.updateSettings(dto), "Lưu cài đặt thành công");
    }
}
