package com.edtech.backend.teaching.controller;

import java.math.BigDecimal;
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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.teaching.dto.response.SubmissionResponse;
import com.edtech.backend.teaching.entity.SubmissionEntity;
import com.edtech.backend.teaching.service.SubmissionService;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
@Tag(name = "Teaching - Submissions", description = "Nộp bài & chấm điểm")
@SecurityRequirement(name = "bearerAuth")
public class SubmissionController {

    private final SubmissionService submissionService;
    private final UserRepository userRepository;

    @PostMapping("/assessments/{assessmentId}/submissions")
    @PreAuthorize("hasAnyRole('STUDENT', 'PARENT')")
    @Operation(summary = "Học sinh/Phụ huynh nộp bài (upload file)")
    public ResponseEntity<ApiResponse<SubmissionResponse>> submit(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID assessmentId,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            @RequestParam(value = "file", required = false) MultipartFile file) {

        UUID studentId = resolveUserId(userDetails);
        SubmissionResponse response = submissionService.submit(assessmentId, studentId, files, file);
        return ResponseEntity.ok(ApiResponse.ok(response, "Nộp bài thành công."));
    }

    @GetMapping("/assessments/{assessmentId}/submissions")
    @PreAuthorize("hasAnyRole('TUTOR', 'PARENT')")
    @Operation(summary = "GS/PH xem tất cả bài nộp")
    public ResponseEntity<ApiResponse<List<SubmissionResponse>>> listByAssessment(
            @PathVariable UUID assessmentId) {

        List<SubmissionResponse> list = submissionService.listByAssessment(assessmentId);
        return ResponseEntity.ok(ApiResponse.ok(list, "Danh sách bài nộp."));
    }

    @GetMapping("/assessments/{assessmentId}/my-submission")
    @PreAuthorize("hasAnyRole('STUDENT', 'PARENT')")
    @Operation(summary = "HS/PH xem bài nộp của mình")
    public ResponseEntity<ApiResponse<SubmissionResponse>> getMySubmission(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID assessmentId) {

        UUID studentId = resolveUserId(userDetails);
        SubmissionResponse response = submissionService.getMySubmission(assessmentId, studentId);
        return ResponseEntity.ok(ApiResponse.ok(response, response != null ? "Bài nộp." : "Chưa nộp bài."));
    }

    @GetMapping("/submissions/{id}")
    @PreAuthorize("hasAnyRole('TUTOR', 'STUDENT', 'PARENT')")
    @Operation(summary = "Chi tiết 1 bài nộp")
    public ResponseEntity<ApiResponse<SubmissionResponse>> getDetail(@PathVariable UUID id) {
        SubmissionResponse response = submissionService.getDetail(id);
        return ResponseEntity.ok(ApiResponse.ok(response, "Chi tiết bài nộp."));
    }

    @PatchMapping("/submissions/{id}/grade")
    @PreAuthorize("hasRole('TUTOR')")
    @Operation(summary = "Chấm điểm và upload file sửa bài")
    public ResponseEntity<ApiResponse<SubmissionResponse>> grade(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id,
            @RequestParam(value = "score", required = false) BigDecimal score,
            @RequestParam(value = "comment", required = false) String comment,
            @RequestParam(value = "tutorFiles", required = false) List<MultipartFile> tutorFiles,
            @RequestParam(value = "tutorFile", required = false) MultipartFile tutorFile) {

        UUID tutorId = resolveUserId(userDetails);
        SubmissionResponse response = submissionService.grade(id, tutorId, score, comment, tutorFiles, tutorFile);
        return ResponseEntity.ok(ApiResponse.ok(response, "Chấm bài thành công."));
    }

    @PatchMapping("/submissions/{id}/complete")
    @PreAuthorize("hasRole('TUTOR')")
    @Operation(summary = "GS đánh dấu hoàn thành → bắt đầu countdown cleanup 7 ngày")
    public ResponseEntity<ApiResponse<SubmissionResponse>> markComplete(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id) {

        UUID tutorId = resolveUserId(userDetails);
        SubmissionResponse response = submissionService.markComplete(id, tutorId);
        return ResponseEntity.ok(ApiResponse.ok(response, "Đã đánh dấu hoàn thành."));
    }

    @GetMapping("/submissions/{id}/download")
    @PreAuthorize("hasAnyRole('TUTOR', 'STUDENT', 'PARENT')")
    @Operation(summary = "Download file bài nộp")
    public ResponseEntity<Resource> downloadStudentFile(
            @PathVariable UUID id,
            @RequestParam(value = "url", required = false) String url,
            @RequestParam(value = "fileName", required = false) String fileName) {
        SubmissionEntity entity = submissionService.findById(id);
        Resource resource = submissionService.downloadSubmissionFile(id, url);

        String finalName = fileName != null ? fileName : (entity.getFileName() != null ? entity.getFileName() : resource.getFilename());
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(resolveContentType(finalName)))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "inline; filename=\"" + finalName + "\"")
                .body(resource);
    }

    @GetMapping("/submissions/{id}/tutor-download")
    @PreAuthorize("hasAnyRole('TUTOR', 'STUDENT', 'PARENT')")
    @Operation(summary = "Download file sửa bài (GS upload)")
    public ResponseEntity<Resource> downloadTutorFile(
            @PathVariable UUID id,
            @RequestParam(value = "url", required = false) String url,
            @RequestParam(value = "fileName", required = false) String fileName) {
        SubmissionEntity entity = submissionService.findById(id);
        Resource resource = submissionService.downloadTutorFile(id, url);

        String finalName = fileName != null ? fileName : (entity.getTutorFileName() != null ? entity.getTutorFileName() : resource.getFilename());
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(resolveContentType(finalName)))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "inline; filename=\"" + finalName + "\"")
                .body(resource);
    }

    private UUID resolveUserId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        return user.getId();
    }

    /** Detect content-type from filename for inline preview */
    private String resolveContentType(String filename) {
        if (filename == null) return "application/octet-stream";
        String lower = filename.toLowerCase();
        if (lower.endsWith(".pdf")) return "application/pdf";
        if (lower.endsWith(".png")) return "image/png";
        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
        if (lower.endsWith(".gif")) return "image/gif";
        if (lower.endsWith(".webp")) return "image/webp";
        if (lower.endsWith(".svg")) return "image/svg+xml";
        if (lower.endsWith(".bmp")) return "image/bmp";
        if (lower.endsWith(".doc") || lower.endsWith(".docx")) return "application/msword";
        if (lower.endsWith(".txt")) return "text/plain";
        return "application/octet-stream";
    }
}
