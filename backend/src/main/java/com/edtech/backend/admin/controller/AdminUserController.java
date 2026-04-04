package com.edtech.backend.admin.controller;

import java.util.List;
import java.util.UUID;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.admin.dto.AdminUserDetail;
import com.edtech.backend.admin.dto.AdminUserListItem;
import com.edtech.backend.admin.dto.CreateUserAdminRequest;
import com.edtech.backend.admin.service.AdminUserService;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.core.dto.ApiResponse;

@RestController
@RequestMapping("/api/v1/admin/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final AdminUserService adminUserService;

    @PostMapping("/quick-create")
    public ApiResponse<AdminUserDetail> quickCreateUser(@Valid @RequestBody CreateUserAdminRequest req) {
        return ApiResponse.ok(adminUserService.createUserBypass(req), "Tạo người dùng thành công");
    }

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

    /** Reset mật khẩu của người dùng thành random password */
    @PostMapping("/{userId}/reset-password")
    public ApiResponse<com.edtech.backend.admin.dto.AdminResetPasswordResponse> resetPassword(@PathVariable UUID userId) {
        return ApiResponse.ok(adminUserService.resetPassword(userId), "Tạo mật khẩu tự động thành công (Force Change Password)");
    }

    /** Xóa mềm user */
    @DeleteMapping("/{userId}")
    public ApiResponse<Void> deleteUser(@PathVariable UUID userId) {
        adminUserService.deleteUser(userId);
        return ApiResponse.ok(null, "Đã xóa người dùng");
    }
}
