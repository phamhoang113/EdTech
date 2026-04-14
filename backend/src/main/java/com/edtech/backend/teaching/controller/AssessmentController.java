package com.edtech.backend.teaching.controller;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.teaching.dto.response.AssessmentResponse;
import com.edtech.backend.teaching.entity.AssessmentEntity;
import com.edtech.backend.teaching.enums.AssessmentType;
import com.edtech.backend.teaching.service.AssessmentService;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
@Tag(name = "Teaching - Assessments", description = "Quản lý bài tập & đề kiểm tra")
@SecurityRequirement(name = "bearerAuth")
public class AssessmentController {

    private final AssessmentService assessmentService;
    private final UserRepository userRepository;

    @PostMapping("/classes/{classId}/assessments")
    @PreAuthorize("hasRole('TUTOR')")
    @Operation(summary = "Tạo bài tập hoặc đề kiểm tra")
    public ResponseEntity<ApiResponse<AssessmentResponse>> create(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID classId,
            @RequestParam("title") String title,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("type") AssessmentType type,
            @RequestParam(value = "opensAt", required = false) Instant opensAt,
            @RequestParam(value = "closesAt", required = false) Instant closesAt,
            @RequestParam(value = "durationMin", required = false) Integer durationMin,
            @RequestParam(value = "file", required = false) MultipartFile file) {

        UUID tutorId = resolveUserId(userDetails);
        AssessmentResponse response = assessmentService.createAssessment(
                classId, tutorId, title, description, type, opensAt, closesAt, durationMin, file);
        return ResponseEntity.ok(ApiResponse.ok(response, "Tạo thành công."));
    }

    @GetMapping("/classes/{classId}/assessments")
    @PreAuthorize("hasAnyRole('TUTOR', 'PARENT', 'STUDENT')")
    @Operation(summary = "Danh sách bài tập/kiểm tra của lớp")
    public ResponseEntity<ApiResponse<List<AssessmentResponse>>> list(
            @PathVariable UUID classId,
            @RequestParam(value = "type", required = false) AssessmentType type) {

        List<AssessmentResponse> list = assessmentService.listByClass(classId, type);
        return ResponseEntity.ok(ApiResponse.ok(list, "Danh sách bài tập/kiểm tra."));
    }

    @GetMapping("/assessments/{id}")
    @PreAuthorize("hasAnyRole('TUTOR', 'PARENT', 'STUDENT')")
    @Operation(summary = "Chi tiết bài tập/kiểm tra")
    public ResponseEntity<ApiResponse<AssessmentResponse>> getDetail(@PathVariable UUID id) {
        AssessmentResponse response = assessmentService.getDetail(id);
        return ResponseEntity.ok(ApiResponse.ok(response, "Chi tiết."));
    }

    @PatchMapping("/assessments/{id}/publish")
    @PreAuthorize("hasRole('TUTOR')")
    @Operation(summary = "Publish bài tập/kiểm tra → gửi thông báo")
    public ResponseEntity<ApiResponse<AssessmentResponse>> publish(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id,
            @RequestParam(value = "studentIds", required = false) List<UUID> studentIds,
            @RequestParam(value = "parentIds", required = false) List<UUID> parentIds) {

        UUID tutorId = resolveUserId(userDetails);
        List<UUID> safeStudentIds = studentIds != null ? studentIds : List.of();
        List<UUID> safeParentIds = parentIds != null ? parentIds : List.of();
        AssessmentResponse response = assessmentService.publish(id, tutorId, safeStudentIds, safeParentIds);
        return ResponseEntity.ok(ApiResponse.ok(response, "Đã publish."));
    }

    @GetMapping("/assessments/{id}/attachment")
    @PreAuthorize("hasAnyRole('TUTOR', 'PARENT', 'STUDENT')")
    @Operation(summary = "Download file đề bài")
    public ResponseEntity<Resource> downloadAttachment(@PathVariable UUID id) {
        AssessmentEntity entity = assessmentService.findById(id);
        Resource resource = assessmentService.downloadAttachment(id);

        String attName = entity.getAttachmentName() != null ? entity.getAttachmentName().toLowerCase() : "";
        String contentType = "application/octet-stream";
        if (attName.endsWith(".pdf")) {
            contentType = "application/pdf";
        } else if (attName.endsWith(".png")) {
            contentType = "image/png";
        } else if (attName.endsWith(".jpg") || attName.endsWith(".jpeg")) {
            contentType = "image/jpeg";
        }
        
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "inline; filename=\"" + entity.getAttachmentName() + "\"")
                .body(resource);
    }

    @DeleteMapping("/assessments/{id}")
    @PreAuthorize("hasRole('TUTOR')")
    @Operation(summary = "Xóa bài tập/kiểm tra")
    public ResponseEntity<ApiResponse<Void>> delete(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id) {

        UUID tutorId = resolveUserId(userDetails);
        assessmentService.deleteAssessment(id, tutorId);
        return ResponseEntity.ok(ApiResponse.ok(null, "Đã xóa."));
    }

    private UUID resolveUserId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        return user.getId();
    }
}
