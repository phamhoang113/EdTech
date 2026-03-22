package com.edtech.backend.admin.controller;

import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.admin.dto.AdminUserDetail;
import com.edtech.backend.admin.dto.AdminUserListItem;
import com.edtech.backend.admin.service.AdminUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final AdminUserService adminUserService;

    /** Lấy danh sách tất cả user, có thể lọc theo role */
    @GetMapping
    public ApiResponse<List<AdminUserListItem>> getAllUsers(
            @RequestParam(required = false) UserRole role) {
        return ApiResponse.ok(adminUserService.getAllUsers(role));
    }

    /** Lấy chi tiết đầy đủ một user */
    @GetMapping("/{userId}")
    public ApiResponse<AdminUserDetail> getUserDetail(@PathVariable UUID userId) {
        return ApiResponse.ok(adminUserService.getUserDetail(userId));
    }

    /** Khóa tài khoản user */
    @PatchMapping("/{userId}/lock")
    public ApiResponse<Void> lockUser(@PathVariable UUID userId) {
        adminUserService.setUserActive(userId, false);
        return ApiResponse.ok(null, "Đã khóa tài khoản");
    }

    /** Mở khóa tài khoản user */
    @PatchMapping("/{userId}/unlock")
    public ApiResponse<Void> unlockUser(@PathVariable UUID userId) {
        adminUserService.setUserActive(userId, true);
        return ApiResponse.ok(null, "Đã mở khóa tài khoản");
    }

    /** Xóa mềm user */
    @DeleteMapping("/{userId}")
    public ApiResponse<Void> deleteUser(@PathVariable UUID userId) {
        adminUserService.deleteUser(userId);
        return ApiResponse.ok(null, "Đã xóa người dùng");
    }
}
