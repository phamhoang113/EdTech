package com.edtech.backend.auth.controller;

import com.edtech.backend.auth.dto.request.LoginRequest;
import com.edtech.backend.auth.dto.request.RegisterRequest;
import com.edtech.backend.auth.dto.request.TokenRefreshRequest;
import com.edtech.backend.auth.dto.request.VerifyOtpRequest;
import com.edtech.backend.auth.dto.response.RegisterResponse;
import com.edtech.backend.auth.dto.response.TokenResponse;
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
    public ApiResponse<RegisterResponse> register(@Valid @RequestBody RegisterRequest request) {
        RegisterResponse response = authService.register(request);
        return ApiResponse.ok(response, response.getMessage());
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
