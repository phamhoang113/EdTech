package com.edtech.backend.core.service;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

/**
 * Lưu file trên local disk server.
 * Base path configurable qua env var FILE_STORAGE_PATH.
 *
 * Cấu trúc:
 *   {basePath}/materials/{classId}/{uuid}_{filename}
 *   {basePath}/assignments/{classId}/{assessmentId}/{uuid}_{filename}
 *   {basePath}/submissions/{assessmentId}/{studentId}/{uuid}_{filename}
 */
@Slf4j
@Service
public class LocalDiskFileStorageService implements FileStorageService {

    private static final long MAX_FILE_SIZE = 20 * 1024 * 1024; // 20MB

    @Value("${app.file-storage.path:./edtech-files}")
    private String basePath;

    private Path rootLocation;

    @PostConstruct
    public void init() {
        rootLocation = Paths.get(basePath).toAbsolutePath().normalize();
        try {
            Files.createDirectories(rootLocation);
            log.info("File storage initialized at: {}", rootLocation);
        } catch (IOException e) {
            throw new IllegalStateException("Không thể tạo thư mục lưu file: " + rootLocation, e);
        }
    }

    @Override
    public String store(MultipartFile file, String folder) {
        validateFile(file);

        String originalFilename = sanitizeFilename(file.getOriginalFilename());
        String storedFilename = UUID.randomUUID().toString().substring(0, 8) + "_" + originalFilename;

        try {
            Path targetDir = rootLocation.resolve(folder).normalize();
            Files.createDirectories(targetDir);

            Path targetPath = targetDir.resolve(storedFilename).normalize();

            // Kiểm tra path traversal attack
            if (!targetPath.startsWith(rootLocation)) {
                throw new IllegalArgumentException("Đường dẫn file không hợp lệ.");
            }

            try (InputStream inputStream = file.getInputStream()) {
                Files.copy(inputStream, targetPath, StandardCopyOption.REPLACE_EXISTING);
            }

            // Trả về relative path (folder/filename)
            String relativePath = folder + "/" + storedFilename;
            log.info("Stored file: {} ({}bytes)", relativePath, file.getSize());
            return relativePath;

        } catch (IOException e) {
            log.error("Lỗi lưu file: {}", originalFilename, e);
            throw new IllegalStateException("Không thể lưu file: " + originalFilename, e);
        }
    }

    @Override
    public Resource loadAsResource(String filePath) {
        try {
            Path file = rootLocation.resolve(filePath).normalize();

            if (!file.startsWith(rootLocation)) {
                throw new IllegalArgumentException("Đường dẫn file không hợp lệ.");
            }

            Resource resource = new UrlResource(file.toUri());
            if (resource.exists() && resource.isReadable()) {
                return resource;
            }
            throw new IllegalStateException("File không tồn tại hoặc không đọc được: " + filePath);

        } catch (MalformedURLException e) {
            throw new IllegalStateException("File không tồn tại: " + filePath, e);
        }
    }

    @Override
    public void delete(String filePath) {
        if (filePath == null || filePath.isBlank()) return;

        try {
            Path file = rootLocation.resolve(filePath).normalize();

            if (!file.startsWith(rootLocation)) {
                log.warn("Attempted path traversal on delete: {}", filePath);
                return;
            }

            if (Files.deleteIfExists(file)) {
                log.info("Deleted file: {}", filePath);
            } else {
                log.warn("File not found for deletion: {}", filePath);
            }
        } catch (IOException e) {
            log.error("Lỗi xóa file: {}", filePath, e);
        }
    }

    private void validateFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File không được rỗng.");
        }
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("File vượt quá giới hạn 20MB.");
        }
    }

    private String sanitizeFilename(String filename) {
        if (filename == null || filename.isBlank()) {
            return "unnamed";
        }
        // Loại bỏ path separators và ký tự đặc biệt
        return filename
                .replaceAll("[/\\\\]", "")
                .replaceAll("[^a-zA-Z0-9._\\-\\p{L}]", "_")
                .trim();
    }
}
