package com.edtech.backend.student.controller;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.student.dto.StudentRequest;
import com.edtech.backend.student.dto.StudentResponse;
import com.edtech.backend.student.service.StudentService;
import jakarta.validation.Valid;
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
@RequestMapping("/api/v1/parent/students")
@RequiredArgsConstructor
@PreAuthorize("hasRole('PARENT')")
public class ParentStudentController {

    private final StudentService studentService;
    private final UserRepository userRepository;

    @GetMapping("/lookup")
    public ResponseEntity<ApiResponse<StudentResponse>> lookupByPhone(@RequestParam String phone) {
        StudentResponse found = studentService.lookupByPhone(phone);
        if (found == null) {
            return ResponseEntity.ok(ApiResponse.ok(null, "NOT_FOUND"));
        }
        return ResponseEntity.ok(ApiResponse.ok(found, "FOUND"));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<StudentResponse>>> getMyChildren(
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID parentId = resolveParentId(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok(studentService.getChildrenByParentId(parentId)));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<StudentResponse>> addChild(
            @Valid @RequestBody StudentRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID parentId = resolveParentId(userDetails.getUsername());
        StudentResponse created = studentService.addChild(request, parentId);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(created));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<StudentResponse>> updateChild(
            @PathVariable UUID id,
            @Valid @RequestBody StudentRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID parentId = resolveParentId(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok(studentService.updateChild(id, parentId, request), "Đã cập nhật thông tin!"));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteChild(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID parentId = resolveParentId(userDetails.getUsername());
        studentService.removeChild(id, parentId);
        return ResponseEntity.ok(ApiResponse.ok(null, "Đã xoá liên kết con em."));
    }

    // ─── Helper ──────────────────────────────────────────────────────────────

    private UUID resolveParentId(String phone) {
        return userRepository.findByIdentifierAndIsDeletedFalse(phone)
                .map(UserEntity::getId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy phụ huynh."));
    }
}
