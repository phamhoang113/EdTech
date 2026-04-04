package com.edtech.backend.auth.service;

import com.edtech.backend.auth.dto.request.FirebaseAuthRequest;
import com.edtech.backend.auth.dto.request.LoginRequest;
import com.edtech.backend.auth.dto.request.TokenRefreshRequest;
import com.edtech.backend.auth.dto.response.TokenResponse;

import com.edtech.backend.auth.dto.request.ChangePasswordRequest;
import com.edtech.backend.auth.dto.request.ForgotPasswordInitRequest;
import com.edtech.backend.auth.dto.request.ForgotPasswordResetRequest;
import com.edtech.backend.auth.dto.response.ForgotPasswordInitResponse;
import com.edtech.backend.auth.dto.response.ForgotPasswordResetResponse;
import com.edtech.backend.core.dto.ApiResponse;

public interface AuthService {
    TokenResponse verifyFirebaseAuth(FirebaseAuthRequest request);
    TokenResponse login(LoginRequest request);
    TokenResponse refreshToken(TokenRefreshRequest request);
    
    ForgotPasswordInitResponse initForgotPassword(ForgotPasswordInitRequest request);
    ForgotPasswordResetResponse resetPassword(ForgotPasswordResetRequest request);
    void changePassword(ChangePasswordRequest request, String identifier);
}
