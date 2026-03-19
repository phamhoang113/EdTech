package com.edtech.backend.auth.service;

import com.edtech.backend.auth.dto.request.LoginRequest;
import com.edtech.backend.auth.dto.request.RegisterRequest;
import com.edtech.backend.auth.dto.request.TokenRefreshRequest;
import com.edtech.backend.auth.dto.request.VerifyOtpRequest;
import com.edtech.backend.auth.dto.response.RegisterResponse;
import com.edtech.backend.auth.dto.response.TokenResponse;

public interface AuthService {
    RegisterResponse register(RegisterRequest request);
    TokenResponse verifyOtp(VerifyOtpRequest request);
    TokenResponse login(LoginRequest request);
    TokenResponse refreshToken(TokenRefreshRequest request);
}
