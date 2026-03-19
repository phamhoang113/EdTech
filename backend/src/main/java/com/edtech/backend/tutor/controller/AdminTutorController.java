package com.edtech.backend.tutor.controller;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.tutor.dto.response.AdminTutorVerificationResponse;
import com.edtech.backend.tutor.service.AdminTutorService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/admin/tutors/verifications")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminTutorController {

    private final AdminTutorService adminTutorService;

    @GetMapping
    public ApiResponse<List<AdminTutorVerificationResponse>> getAllVerifications() {
        List<AdminTutorVerificationResponse> responses = adminTutorService.getAllVerifications();
        return ApiResponse.ok(responses, "Lấy danh sách yêu cầu duyệt gia sư thành công");
    }

    @PostMapping("/{id}/approve")
    public ApiResponse<Void> approveTutor(@PathVariable UUID id, @RequestParam BigDecimal rate) {
        adminTutorService.approveTutor(id, rate);
        return ApiResponse.ok(null, "Phê duyệt gia sư thành công");
    }

    @PostMapping("/{id}/reject")
    public ApiResponse<Void> rejectTutor(@PathVariable UUID id) {
        adminTutorService.rejectTutor(id);
        return ApiResponse.ok(null, "Từ chối gia sư thành công");
    }
}
