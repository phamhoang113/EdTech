package com.edtech.backend.student.controller;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.student.dto.ParentLinkResponse;
import com.edtech.backend.student.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/student/parent-links")
@RequiredArgsConstructor
@PreAuthorize("hasRole('STUDENT')")
public class StudentLinkController {

    private final StudentService studentService;
    private final UserRepository userRepository;

    @GetMapping
    public ApiResponse<List<ParentLinkResponse>> getParentLinks(@AuthenticationPrincipal UserDetails principal) {
        UUID studentId = resolveUserId(principal.getUsername());
        return ApiResponse.ok(studentService.getParentLinks(studentId));
    }

    @PostMapping("/{linkId}/accept")
    public ApiResponse<Void> acceptParentLink(
            @PathVariable UUID linkId,
            @AuthenticationPrincipal UserDetails principal
    ) {
        UUID studentId = resolveUserId(principal.getUsername());
        studentService.acceptParentLink(studentId, linkId);
        return ApiResponse.ok(null, "Chấp nhận liên kết thành công.");
    }

    @PostMapping("/{linkId}/reject")
    public ApiResponse<Void> rejectParentLink(
            @PathVariable UUID linkId,
            @AuthenticationPrincipal UserDetails principal
    ) {
        UUID studentId = resolveUserId(principal.getUsername());
        studentService.rejectParentLink(studentId, linkId);
        return ApiResponse.ok(null, "Từ chối liên kết thành công.");
    }

    private UUID resolveUserId(String identifier) {
        return userRepository.findByIdentifierAndIsDeletedFalse(identifier)
                .map(UserEntity::getId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy học sinh."));
    }
}
