package com.edtech.backend.teaching.service;

import java.util.List;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.core.service.FileStorageService;
import com.edtech.backend.notification.entity.NotificationType;
import com.edtech.backend.notification.service.NotificationService;
import com.edtech.backend.teaching.dto.response.MaterialResponse;
import com.edtech.backend.teaching.entity.MaterialEntity;
import com.edtech.backend.teaching.enums.MaterialType;
import com.edtech.backend.teaching.repository.MaterialRepository;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MaterialService {

    private final MaterialRepository materialRepository;
    private final FileStorageService fileStorageService;
    private final NotificationService notificationService;

    /**
     * Upload tài liệu cho lớp — chỉ TUTOR.
     */
    @Transactional
    public MaterialResponse uploadMaterial(UUID classId, UUID tutorId, String title,
                                           String description, MultipartFile file) {
        String folder = "materials/" + classId;
        String storedPath = fileStorageService.store(file, folder);

        MaterialType type = resolveType(file.getContentType());

        MaterialEntity entity = MaterialEntity.builder()
                .classId(classId)
                .uploadedBy(tutorId)
                .title(title)
                .description(description)
                .type(type)
                .fileUrl(storedPath)
                .fileName(file.getOriginalFilename())
                .mimeType(file.getContentType())
                .fileSize(file.getSize())
                .build();

        entity = materialRepository.save(entity);
        log.info("Material uploaded: classId={}, title={}, size={}", classId, title, file.getSize());

        return MaterialResponse.from(entity);
    }

    /**
     * Gửi notification cho tất cả HS trong lớp (gọi sau khi upload).
     */
    public void notifyStudents(UUID classId, UUID materialId, String title,
                               List<UUID> studentIds) {
        String notifTitle = "Tài liệu mới: " + title;
        String notifBody = "Gia sư đã upload tài liệu mới. Nhấn để xem và tải về.";

        for (UUID studentId : studentIds) {
            notificationService.sendNotification(
                    studentId, NotificationType.MATERIAL_UPLOADED,
                    notifTitle, notifBody, "MATERIAL", materialId);
        }

        log.info("Notified {} students about material: {}", studentIds.size(), title);
    }

    /**
     * List tài liệu của lớp.
     */
    public List<MaterialResponse> listByClass(UUID classId) {
        return materialRepository.findByClassIdAndIsDeletedFalseOrderByCreatedAtDesc(classId)
                .stream()
                .map(MaterialResponse::from)
                .toList();
    }

    /**
     * Download file tài liệu.
     */
    public Resource downloadMaterial(UUID materialId) {
        MaterialEntity entity = findById(materialId);
        return fileStorageService.loadAsResource(entity.getFileUrl());
    }

    /**
     * Lấy entity để build response header (filename, contentType).
     */
    public MaterialEntity findById(UUID materialId) {
        return materialRepository.findById(materialId)
                .filter(m -> !m.getIsDeleted())
                .orElseThrow(() -> new EntityNotFoundException("Tài liệu không tồn tại."));
    }

    /**
     * Soft delete tài liệu + xóa file vật lý — chỉ TUTOR.
     */
    @Transactional
    public void deleteMaterial(UUID materialId, UUID tutorId) {
        MaterialEntity entity = findById(materialId);

        if (!entity.getUploadedBy().equals(tutorId)) {
            throw new IllegalArgumentException("Bạn không có quyền xóa tài liệu này.");
        }

        // Xóa file vật lý
        fileStorageService.delete(entity.getFileUrl());

        entity.setIsDeleted(true);
        materialRepository.save(entity);
        log.info("Material soft-deleted: id={}", materialId);
    }

    private MaterialType resolveType(String contentType) {
        if (contentType == null) return MaterialType.OTHER;
        if (contentType.startsWith("image/")) return MaterialType.IMAGE;
        if (contentType.startsWith("video/")) return MaterialType.VIDEO;
        if (contentType.contains("pdf") || contentType.contains("word") || contentType.contains("document")) {
            return MaterialType.DOCUMENT;
        }
        return MaterialType.OTHER;
    }
}
