package com.edtech.backend.auth.service;

import com.edtech.backend.auth.dto.LoginRequest;
import com.edtech.backend.auth.dto.RegisterRequest;
import com.edtech.backend.auth.dto.TokenRefreshRequest;
import com.edtech.backend.auth.dto.TokenResponse;
import com.edtech.backend.auth.dto.VerifyOtpRequest;

public interface AuthService {
    void register(RegisterRequest request);
    TokenResponse verifyOtp(VerifyOtpRequest request);
    TokenResponse login(LoginRequest request);
    TokenResponse refreshToken(TokenRefreshRequest request);
}
