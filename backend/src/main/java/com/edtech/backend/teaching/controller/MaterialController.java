package com.edtech.backend.teaching.controller;

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
import com.edtech.backend.teaching.dto.response.MaterialResponse;
import com.edtech.backend.teaching.entity.MaterialEntity;
import com.edtech.backend.teaching.service.MaterialService;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
@Tag(name = "Teaching - Materials", description = "Quản lý tài liệu học tập")
@SecurityRequirement(name = "bearerAuth")
public class MaterialController {

    private final MaterialService materialService;
    private final UserRepository userRepository;
    private final com.edtech.backend.cls.repository.ClassRepository classRepository;

    @PostMapping("/classes/{classId}/materials")
    @PreAuthorize("hasRole('TUTOR')")
    @Operation(summary = "Upload tài liệu cho lớp")
    public ResponseEntity<ApiResponse<MaterialResponse>> uploadMaterial(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID classId,
            @RequestParam("title") String title,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam("file") MultipartFile file) {

        UUID tutorId = resolveUserId(userDetails);
        MaterialResponse response = materialService.uploadMaterial(classId, tutorId, title, description, file);

        // Notify students
        com.edtech.backend.cls.entity.ClassEntity cls = classRepository.findById(classId).orElse(null);
        if (cls != null && !cls.getStudents().isEmpty()) {
            List<UUID> studentIds = cls.getStudents().stream().map(UserEntity::getId).toList();
            materialService.notifyStudents(classId, response.getId(), response.getTitle(), studentIds);
        }

        return ResponseEntity.ok(ApiResponse.ok(response, "Upload tài liệu thành công."));
    }

    @GetMapping("/classes/{classId}/materials")
    @PreAuthorize("hasAnyRole('TUTOR', 'PARENT', 'STUDENT')")
    @Operation(summary = "Danh sách tài liệu của lớp")
    public ResponseEntity<ApiResponse<List<MaterialResponse>>> listMaterials(@PathVariable UUID classId) {
        List<MaterialResponse> materials = materialService.listByClass(classId);
        return ResponseEntity.ok(ApiResponse.ok(materials, "Danh sách tài liệu."));
    }

    @GetMapping("/materials/{id}/download")
    @PreAuthorize("hasAnyRole('TUTOR', 'PARENT', 'STUDENT')")
    @Operation(summary = "Download tài liệu")
    public ResponseEntity<Resource> downloadMaterial(@PathVariable UUID id) {
        MaterialEntity entity = materialService.findById(id);
        Resource resource = materialService.downloadMaterial(id);

        String contentType = entity.getMimeType() != null
                ? entity.getMimeType()
                : "application/octet-stream";

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "inline; filename=\"" + entity.getFileName() + "\"")
                .body(resource);
    }

    @DeleteMapping("/materials/{id}")
    @PreAuthorize("hasRole('TUTOR')")
    @Operation(summary = "Xóa tài liệu")
    public ResponseEntity<ApiResponse<Void>> deleteMaterial(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID id) {

        UUID tutorId = resolveUserId(userDetails);
        materialService.deleteMaterial(id, tutorId);
        return ResponseEntity.ok(ApiResponse.ok(null, "Đã xóa tài liệu."));
    }

    private UUID resolveUserId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        return user.getId();
    }
}
