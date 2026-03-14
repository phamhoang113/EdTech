package com.edtech.backend.auth.controller;

import com.edtech.backend.auth.dto.LoginRequest;
import com.edtech.backend.auth.dto.RegisterRequest;
import com.edtech.backend.auth.dto.TokenRefreshRequest;
import com.edtech.backend.auth.dto.TokenResponse;
import com.edtech.backend.auth.dto.VerifyOtpRequest;
import com.edtech.backend.auth.service.AuthService;
import com.edtech.backend.core.dto.ApiResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ApiResponse<Void> register(@Valid @RequestBody RegisterRequest request) {
        authService.register(request);
        return ApiResponse.ok(null, "Registration initiated. Please verify OTP.");
    }

    @PostMapping("/verify-otp")
    public ApiResponse<TokenResponse> verifyOtp(@Valid @RequestBody VerifyOtpRequest request) {
        return ApiResponse.ok(authService.verifyOtp(request), "OTP verified successfully. User activated.");
    }

    @PostMapping("/login")
    public ApiResponse<TokenResponse> login(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.ok(authService.login(request), "Login successful.");
    }

    @PostMapping("/refresh")
    public ApiResponse<TokenResponse> refreshToken(@Valid @RequestBody TokenRefreshRequest request) {
        return ApiResponse.ok(authService.refreshToken(request), "Token refreshed successfully.");
    }
}
