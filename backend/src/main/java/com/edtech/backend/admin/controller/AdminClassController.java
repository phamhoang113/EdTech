package com.edtech.backend.admin.controller;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.admin.dto.ApproveClassRequest;
import com.edtech.backend.admin.dto.CreateClassRequest;
import com.edtech.backend.admin.dto.AdminClassListItem;
import com.edtech.backend.admin.service.AdminClassService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin/classes")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminClassController {

    private final AdminClassService adminClassService;

    /** Thống kê lớp theo trạng thái */
    @GetMapping("/stats")
    public ResponseEntity<ApiResponse<Map<String, Long>>> getStats() {
        return ResponseEntity.ok(ApiResponse.ok(adminClassService.getClassStats()));
    }

    /**
     * Danh sách lớp học.
     * @param status optional — filter theo ClassStatus (OPEN, ASSIGNED, ACTIVE...)
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<AdminClassListItem>>> getAllClasses(
            @RequestParam(required = false) ClassStatus status) {
        return ResponseEntity.ok(ApiResponse.ok(adminClassService.getAllClasses(status)));
    }

    /** Tạo lớp học mới */
    @PostMapping
    public ResponseEntity<ApiResponse<AdminClassListItem>> createClass(
            @Valid @RequestBody CreateClassRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(adminClassService.createClass(request)));
    }

    /**
     * Chuyển trạng thái lớp.
     * Valid transitions: OPEN→CANCELLED | ASSIGNED→ACTIVE/OPEN/CANCELLED | ACTIVE→COMPLETED/CANCELLED
     */
    @PatchMapping("/{id}/status")
    public ResponseEntity<ApiResponse<Void>> updateStatus(
            @PathVariable UUID id,
            @RequestParam ClassStatus newStatus) {
        adminClassService.updateClassStatus(id, newStatus);
        return ResponseEntity.ok(ApiResponse.ok(null));
    }

    /** Xóa mềm lớp (nếu ASSIGNED → revert về OPEN + xóa tutorId) */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteClass(@PathVariable UUID id) {
        adminClassService.deleteClass(id);
        return ResponseEntity.ok(ApiResponse.ok(null));
    }

    /** Duyệt yêu cầu mở lớp từ PH: PENDING_APPROVAL → OPEN.
     *  Body (tày chọn): { tutorFee, levelFees } — admin có thể set lương từng loại GS. */
    @PatchMapping("/{id}/approve")
    public ResponseEntity<ApiResponse<Void>> approveClassRequest(
            @PathVariable UUID id,
            @RequestBody(required = false) ApproveClassRequest body) {
        adminClassService.approveClassRequest(
                id,
                body != null ? body.tutorFee() : null,
                body != null ? body.levelFees() : null,
                body != null ? body.tutorProposals() : null,
                body != null ? body.feePercentage() : null);
        return ResponseEntity.ok(ApiResponse.ok(null, "Đã duyệt và mở lớp cho gia sư đăng ký"));
    }

    /** Từ chối yêu cầu mở lớp từ PH: PENDING_APPROVAL → CANCELLED */
    @PatchMapping("/{id}/reject")
    public ResponseEntity<ApiResponse<Void>> rejectClassRequest(
            @PathVariable UUID id,
            @RequestParam(required = false) String reason) {
        adminClassService.rejectClassRequest(id, reason);
        return ResponseEntity.ok(ApiResponse.ok(null, "Đã từ chối yêu cầu"));
    }
}
