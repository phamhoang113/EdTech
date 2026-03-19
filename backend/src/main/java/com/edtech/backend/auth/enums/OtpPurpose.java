package com.edtech.backend.auth.enums;

/**
 * Mục đích sinh OTP.
 * Thay thế raw String "REGISTER", "RESET_PASSWORD" trong code.
 */
public enum OtpPurpose {
    REGISTER,       // Kích hoạt tài khoản sau khi đăng ký
    RESET_PASSWORD, // Đặt lại mật khẩu
    CHANGE_PHONE    // Đổi số điện thoại
}
