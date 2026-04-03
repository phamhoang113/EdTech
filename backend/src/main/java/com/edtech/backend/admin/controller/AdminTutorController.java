package com.edtech.backend.admin.controller;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.admin.dto.AdminTutorListItem;
import com.edtech.backend.admin.dto.AdminTutorVerificationResponse;
import com.edtech.backend.admin.service.AdminTutorService;
import com.edtech.backend.core.dto.ApiResponse;

@RestController
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminTutorController {

    private final AdminTutorService adminTutorService;

    // ─── Danh sách gia sư ────────────────────────────────────────────────────

    /** Admin xem toàn bộ gia sư (kể cả đã xóa mềm) */
    @GetMapping("/api/v1/admin/tutors")
    public ApiResponse<List<AdminTutorListItem>> getAllTutors() {
        return ApiResponse.ok(adminTutorService.getAllTutors(), "Lấy danh sách gia sư thành công");
    }

    /** Admin xóa mềm gia sư */
    @DeleteMapping("/api/v1/admin/tutors/{userId}")
    public ApiResponse<Void> deleteTutor(@PathVariable UUID userId) {
        adminTutorService.deleteTutor(userId);
        return ApiResponse.ok(null, "Đã xóa gia sư thành công");
    }

    // ─── Xác minh gia sư ─────────────────────────────────────────────────────

    @GetMapping("/api/v1/admin/tutors/verifications")
    public ApiResponse<List<AdminTutorVerificationResponse>> getAllVerifications() {
        return ApiResponse.ok(adminTutorService.getAllVerifications(), "Lấy danh sách yêu cầu duyệt gia sư thành công");
    }

    @PostMapping("/api/v1/admin/tutors/verifications/{id}/approve")
    public ApiResponse<Void> approveTutor(@PathVariable UUID id, @RequestParam BigDecimal rate) {
        adminTutorService.approveTutor(id, rate);
        return ApiResponse.ok(null, "Phê duyệt gia sư thành công");
    }

    @PostMapping("/api/v1/admin/tutors/verifications/{id}/reject")
    public ApiResponse<Void> rejectTutor(@PathVariable UUID id) {
        adminTutorService.rejectTutor(id);
        return ApiResponse.ok(null, "Từ chối gia sư thành công");
    }
}
