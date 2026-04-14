package com.edtech.backend.core.service;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

/**
 * Abstraction cho file storage.
 * Pha 1: LocalDiskFileStorageService (lưu trên disk server).
 * Pha 2: MinioFileStorageService (swap qua @Profile).
 */
public interface FileStorageService {

    /**
     * Lưu file vào storage.
     *
     * @param file   MultipartFile từ request
     * @param folder Thư mục con (vd: "materials/{classId}")
     * @return Relative path đã lưu (dùng để truy xuất sau)
     */
    String store(MultipartFile file, String folder);

    /**
     * Load file dưới dạng Resource để stream cho client download.
     *
     * @param filePath Relative path trả từ store()
     * @return Spring Resource
     */
    Resource loadAsResource(String filePath);

    /**
     * Xóa file khỏi storage.
     *
     * @param filePath Relative path trả từ store()
     */
    void delete(String filePath);
}
