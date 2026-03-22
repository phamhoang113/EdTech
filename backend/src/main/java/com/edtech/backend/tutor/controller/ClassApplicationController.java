package com.edtech.backend.tutor.controller;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.tutor.dto.request.ApplyClassRequest;
import com.edtech.backend.tutor.dto.response.ClassApplicationResponse;
import com.edtech.backend.cls.enums.ApplicationStatus;
import com.edtech.backend.tutor.service.ClassApplicationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ClassApplicationController {

    private final ClassApplicationService classApplicationService;
    private final UserRepository userRepository;

    // ─── Tutor endpoints ────────────────────────────────────────────────────

    /** Gia sư nộp đơn nhận lớp */
    @PostMapping("/api/v1/classes/{classId}/apply")
    @PreAuthorize("hasRole('TUTOR')")
    public ResponseEntity<ApiResponse<ClassApplicationResponse>> applyForClass(
            @PathVariable UUID classId,
            @RequestBody(required = false) ApplyClassRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID tutorId = resolveUserId(userDetails.getUsername());
        ClassApplicationResponse response = classApplicationService.applyForClass(
                classId, tutorId, request != null ? request : new ApplyClassRequest(null));

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok(response, "Đã đăng ký nhận lớp thành công!"));
    }

    /** Gia sư xem đơn của mình */
    @GetMapping("/api/v1/classes/my-applications")
    @PreAuthorize("hasRole('TUTOR')")
    public ResponseEntity<ApiResponse<List<ClassApplicationResponse>>> getMyApplications(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID tutorId = resolveUserId(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok(classApplicationService.getMyApplications(tutorId)));
    }

    // ─── Admin endpoints ─────────────────────────────────────────────────────

    /** Admin xem tất cả đơn, có thể filter theo status */
    @GetMapping("/api/v1/admin/class-applications")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<List<ClassApplicationResponse>>> getAllApplications(
            @RequestParam(required = false) ApplicationStatus status) {

        return ResponseEntity.ok(ApiResponse.ok(classApplicationService.getAllApplications(status)));
    }

    /** Admin xem đơn theo lớp */
    @GetMapping("/api/v1/admin/class-applications/by-class/{classId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<List<ClassApplicationResponse>>> getByClass(
            @PathVariable UUID classId) {

        return ResponseEntity.ok(ApiResponse.ok(classApplicationService.getApplicationsByClass(classId)));
    }

    /** Admin duyệt đơn */
    @PostMapping("/api/v1/admin/class-applications/{applicationId}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<ClassApplicationResponse>> approve(
            @PathVariable UUID applicationId,
            @RequestParam(required = false) java.math.BigDecimal actualSalary) {

        return ResponseEntity.ok(ApiResponse.ok(
                classApplicationService.approveApplication(applicationId, actualSalary),
                "Đã duyệt đơn và giao lớp thành công!"));
    }

    /** Admin từ chối đơn */
    @PostMapping("/api/v1/admin/class-applications/{applicationId}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<ClassApplicationResponse>> reject(
            @PathVariable UUID applicationId) {

        return ResponseEntity.ok(ApiResponse.ok(
                classApplicationService.rejectApplication(applicationId),
                "Đã từ chối đơn."));
    }

    // ─── Parent endpoints ─────────────────────────────────────────────────────

    /**
     * Phụ huynh xem danh sách gia sư được admin đề xuất (status=APPROVED) cho lớp của mình.
     */
    @GetMapping("/api/v1/classes/{classId}/proposed-tutors")
    @PreAuthorize("hasRole('PARENT')")
    public ResponseEntity<ApiResponse<List<ClassApplicationResponse>>> getProposedTutors(
            @PathVariable UUID classId,
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID parentId = resolveUserId(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok(
                classApplicationService.getProposedTutorsForParent(classId, parentId)));
    }

    /**
     * Phụ huynh chọn gia sư từ danh sách đề xuất.
     * → Lớp chuyển ASSIGNED, reject các đơn còn lại.
     */
    @PostMapping("/api/v1/class-applications/{applicationId}/select")
    @PreAuthorize("hasRole('PARENT')")
    public ResponseEntity<ApiResponse<ClassApplicationResponse>> selectTutor(
            @PathVariable UUID applicationId,
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID parentId = resolveUserId(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok(
                classApplicationService.parentSelectTutor(applicationId, parentId),
                "Đã chọn gia sư thành công! Lớp sẽ bắt đầu sớm."));
    }

    // ─── Private ─────────────────────────────────────────────────────────────

    private UUID resolveUserId(String phone) {
        return userRepository.findByIdentifierAndIsDeletedFalse(phone)
                .map(UserEntity::getId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy user."));
    }
}
