package com.edtech.backend.auth.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.dto.request.FirebaseAuthRequest;
import com.edtech.backend.auth.dto.request.LoginRequest;
import com.edtech.backend.auth.dto.request.TokenRefreshRequest;
import com.edtech.backend.auth.dto.response.TokenResponse;
import com.edtech.backend.auth.service.AuthService;
import com.edtech.backend.core.dto.ApiResponse;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/firebase")
    public ApiResponse<TokenResponse> verifyFirebaseAuth(@Valid @RequestBody FirebaseAuthRequest request) {
        return ApiResponse.ok(authService.verifyFirebaseAuth(request), "Firebase authentication successful.");
    }

    @PostMapping("/login")
    public ApiResponse<TokenResponse> login(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.ok(authService.login(request), "Login successful.");
    }

    @PostMapping("/refresh")
    public ApiResponse<TokenResponse> refreshToken(@Valid @RequestBody TokenRefreshRequest request) {
        return ApiResponse.ok(authService.refreshToken(request), "Token refreshed successfully.");
    }

    @PostMapping("/forgot-password/init")
    public ApiResponse<com.edtech.backend.auth.dto.response.ForgotPasswordInitResponse> initForgotPassword(
            @Valid @RequestBody com.edtech.backend.auth.dto.request.ForgotPasswordInitRequest request) {
        return ApiResponse.ok(authService.initForgotPassword(request), "OTP sent via Firebase.");
    }

    @PostMapping("/forgot-password/reset")
    public ApiResponse<com.edtech.backend.auth.dto.response.ForgotPasswordResetResponse> resetPassword(
            @Valid @RequestBody com.edtech.backend.auth.dto.request.ForgotPasswordResetRequest request) {
        return ApiResponse.ok(authService.resetPassword(request), "Password reset successful.");
    }

    @org.springframework.web.bind.annotation.PutMapping("/password")
    public ApiResponse<Void> changePassword(
            @Valid @RequestBody com.edtech.backend.auth.dto.request.ChangePasswordRequest request,
            org.springframework.security.core.Authentication authentication) {
        if (authentication == null) {
            throw new com.edtech.backend.core.exception.BusinessRuleException("Unauthorized");
        }
        authService.changePassword(request, authentication.getName());
        return ApiResponse.ok(null, "Password changed successfully.");
    }
}
