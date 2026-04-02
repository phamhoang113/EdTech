package com.edtech.backend.auth.service;

import com.edtech.backend.auth.dto.request.LoginRequest;
import com.edtech.backend.auth.dto.request.TokenRefreshRequest;
import com.edtech.backend.auth.dto.response.TokenResponse;

public interface AuthService {
    TokenResponse verifyFirebaseAuth(com.edtech.backend.auth.dto.request.FirebaseAuthRequest request);
    TokenResponse login(LoginRequest request);
    TokenResponse refreshToken(TokenRefreshRequest request);
}
