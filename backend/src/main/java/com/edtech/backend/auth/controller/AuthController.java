package com.edtech.backend.auth.controller;

import java.util.Map;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.dto.request.ChangePasswordRequest;
import com.edtech.backend.auth.dto.request.FirebaseAuthRequest;
import com.edtech.backend.auth.dto.request.ForgotPasswordInitRequest;
import com.edtech.backend.auth.dto.request.ForgotPasswordResetRequest;
import com.edtech.backend.auth.dto.request.LoginRequest;
import com.edtech.backend.auth.dto.request.TokenRefreshRequest;
import com.edtech.backend.auth.dto.response.ForgotPasswordInitResponse;
import com.edtech.backend.auth.dto.response.ForgotPasswordResetResponse;
import com.edtech.backend.auth.dto.response.TokenResponse;
import com.edtech.backend.auth.service.AuthService;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.BusinessRuleException;

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
    public ApiResponse<ForgotPasswordInitResponse> initForgotPassword(
            @Valid @RequestBody ForgotPasswordInitRequest request) {
        return ApiResponse.ok(authService.initForgotPassword(request), "OTP sent via Firebase.");
    }

    @PostMapping("/forgot-password/reset")
    public ApiResponse<ForgotPasswordResetResponse> resetPassword(
            @Valid @RequestBody ForgotPasswordResetRequest request) {
        return ApiResponse.ok(authService.resetPassword(request), "Password reset successful.");
    }

    /** Check if phone already registered — call BEFORE generating OTP to save costs */
    @GetMapping("/check-phone")
    public ApiResponse<Map<String, Boolean>> checkPhone(@RequestParam String phone) {
        boolean exists = authService.checkPhoneExists(phone);
        return ApiResponse.ok(Map.of("exists", exists), "Phone check completed.");
    }

    @PutMapping("/password")
    public ApiResponse<Void> changePassword(
            @Valid @RequestBody ChangePasswordRequest request,
            Authentication authentication) {
        if (authentication == null) {
            throw new BusinessRuleException("Unauthorized");
        }
        authService.changePassword(request, authentication.getName());
        return ApiResponse.ok(null, "Password changed successfully.");
    }
}
