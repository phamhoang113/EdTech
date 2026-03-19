package com.edtech.backend.core.controller;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.service.StorageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/upload")
@RequiredArgsConstructor
public class UploadController {

    private final StorageService storageService;

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final List<String> ALLOWED_TYPES = List.of(
            "image/jpeg", "image/png", "image/webp", "image/gif"
    );

    /**
     * POST /api/v1/upload/image?folder=images
     * Trả về Base64 String của file ảnh
     */
    @PostMapping(value = "/image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ApiResponse<Map<String, String>>> uploadImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "folder", defaultValue = "images") String folder
    ) {
        validateImage(file);
        // Trả về Base64 string thay vì URL S3
        String base64String = storageService.upload(file, folder);
        return ResponseEntity.ok(ApiResponse.ok(Map.of("url", base64String), "Xử lý file thành công"));
    }

    // ---- Private helpers ----

    private void validateImage(MultipartFile file) {
        if (file.isEmpty())
            throw new IllegalArgumentException("File không được rỗng");
        if (file.getSize() > MAX_FILE_SIZE)
            throw new IllegalArgumentException("File không được vượt quá 5MB");
        if (!ALLOWED_TYPES.contains(file.getContentType()))
            throw new IllegalArgumentException("Chỉ chấp nhận ảnh JPEG, PNG, WebP, GIF");
    }

}
