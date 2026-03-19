package com.edtech.backend.auth.enums;

/**
 * Vai trò người dùng trong hệ thống EdTech.
 * Dùng @Enumerated(EnumType.STRING) trong Entity.
 */
public enum UserRole {
    ADMIN,    // Quản trị viên hệ thống
    TUTOR,    // Gia sư
    PARENT,   // Phụ huynh / người đăng ký tìm gia sư
    STUDENT   // Học sinh (được tạo bởi phụ huynh hoặc tự đăng ký)
}
