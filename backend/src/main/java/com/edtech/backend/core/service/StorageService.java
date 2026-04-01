package com.edtech.backend.core.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Base64;

@Slf4j
@Service
@Transactional(readOnly = true)
public class StorageService {

    /**
     * Chuyển đổi file upload thành chuỗi Base64 (Data URI scheme).
     *
     * @param file   MultipartFile từ request
     * @param folder Thư mục lưu (không còn dùng cho Base64, giữ để tương thích signature cũ)
     * @return Chuỗi Data URI chứa Base64 của ảnh (vd: "data:image/jpeg;base64,...")
     */
    public String upload(MultipartFile file, String folder) {
        try {
            if (file == null || file.isEmpty()) {
                throw new IllegalArgumentException("File rỗng hoặc không tồn tại.");
            }

            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                // Mặc định ép về jpeg nếu không lấy được (hoặc throw lỗi tùy bạn định hướng quản lý file)
                contentType = "image/jpeg";
                log.warn("Không lấy được Content-Type, mặc định dùng image/jpeg");
            }

            byte[] fileContent = file.getBytes();
            String encodedString = Base64.getEncoder().encodeToString(fileContent);

            log.info("Converted file to Base64 data string. Content-Type: {}, Size (bytes): {}", contentType, fileContent.length);

            return "data:" + contentType + ";base64," + encodedString;

        } catch (IOException e) {
            log.error("Lỗi khi đọc file để chuyển đổi sang Base64", e);
            throw new IllegalStateException("Không thể xử lý file ảnh: " + e.getMessage(), e);
        }
    }

    /**
     * Xóa file (MinIO cũ, nay ảnh nằm trong DB, khi xóa bản ghi sẽ mất theo URL - ta chỉ cần xoá url ở phía service gọi).
     * Method này giữ lại dưới dạng no-op (không làm gì) để tương thích interface.
     */
    public void delete(String objectName) {
        log.info("Delete file invoked for Base64 format (No-op). Object: {}", objectName);
    }
}
