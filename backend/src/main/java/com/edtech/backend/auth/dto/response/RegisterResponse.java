package com.edtech.backend.auth.dto.response;

import lombok.Builder;
import lombok.Getter;

/**
 * Trả về khi đăng ký thành công.
 * Client lưu otpToken, sau đó gửi otpToken + code để xác thực.
 */
@Getter
@Builder
public class RegisterResponse {
    private String otpToken; // UUID String để verify OTP (không cần truyền phone lên lại)
    private String message;
}
