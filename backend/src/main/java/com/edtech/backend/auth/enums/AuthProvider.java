package com.edtech.backend.auth.enums;

/**
 * Nguồn đăng ký ban đầu của user.
 * Dùng để phân biệt user tạo bằng SĐT vs OAuth2 (Google/Facebook).
 */
public enum AuthProvider {
    PHONE,
    GOOGLE,
    FACEBOOK
}
