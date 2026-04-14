package com.edtech.backend.teaching.controller;

import java.util.List;
import java.util.UUID;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.teaching.dto.response.ProgressSummaryResponse;
import com.edtech.backend.teaching.dto.response.StudentProgressResponse;
import com.edtech.backend.teaching.service.StudentProgressService;

/**
 * API tiến độ học tập — PH theo dõi con em.
 */
@RestController
@RequestMapping("/api/v1/classes")
@RequiredArgsConstructor
@Tag(name = "Teaching - Progress", description = "Tiến độ học tập HS")
@SecurityRequirement(name = "bearerAuth")
public class StudentProgressController {

    private final StudentProgressService progressService;
    private final UserRepository userRepository;

    @GetMapping("/{classId}/progress")
    @PreAuthorize("hasAnyRole('PARENT', 'TUTOR')")
    @Operation(summary = "Xem tiến độ BT/KT của HS trong lớp")
    public ResponseEntity<ApiResponse<List<StudentProgressResponse>>> getProgress(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID classId) {

        UUID userId = resolveUserId(userDetails);
        List<StudentProgressResponse> progress = progressService.getClassProgress(classId, userId);
        return ResponseEntity.ok(ApiResponse.ok(progress, "Tiến độ học tập."));
    }

    @GetMapping("/{classId}/progress/summary")
    @PreAuthorize("hasAnyRole('PARENT', 'TUTOR')")
    @Operation(summary = "Tổng hợp tiến độ: điểm TB, BT chưa nộp, KT sắp tới")
    public ResponseEntity<ApiResponse<ProgressSummaryResponse>> getProgressSummary(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID classId) {

        UUID userId = resolveUserId(userDetails);
        ProgressSummaryResponse summary = progressService.getProgressSummary(classId, userId);
        return ResponseEntity.ok(ApiResponse.ok(summary, "Tổng hợp tiến độ."));
    }

    private UUID resolveUserId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        return user.getId();
    }
}
