package com.edtech.backend.auth.controller;

import java.util.List;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.dto.request.LinkProviderRequest;
import com.edtech.backend.auth.dto.request.SetPasswordRequest;
import com.edtech.backend.auth.dto.response.LinkedProviderResponse;
import com.edtech.backend.auth.enums.AuthProvider;
import com.edtech.backend.auth.service.AccountLinkingService;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.BusinessRuleException;

/**
 * API quản lý liên kết tài khoản 2 chiều:
 * - OAuth user → thiết lập username/password
 * - Password user → link Google/Facebook
 */
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AccountLinkingController {

    private final AccountLinkingService accountLinkingService;

    /** Link Google/Facebook vào tài khoản hiện tại */
    @PostMapping("/link-provider")
    public ApiResponse<Void> linkProvider(
            @Valid @RequestBody LinkProviderRequest request,
            Authentication authentication) {
        validateAuthentication(authentication);
        accountLinkingService.linkProvider(authentication.getName(), request);
        return ApiResponse.ok(null, "Liên kết tài khoản thành công.");
    }

    /** OAuth user thiết lập username + password lần đầu */
    @PostMapping("/set-password")
    public ApiResponse<Void> setPassword(
            @Valid @RequestBody SetPasswordRequest request,
            Authentication authentication) {
        validateAuthentication(authentication);
        accountLinkingService.setPassword(authentication.getName(), request);
        return ApiResponse.ok(null, "Thiết lập mật khẩu thành công. Bạn có thể đăng nhập bằng tên đăng nhập & mật khẩu.");
    }

    /** Gỡ liên kết OAuth provider */
    @DeleteMapping("/unlink-provider")
    public ApiResponse<Void> unlinkProvider(
            @RequestParam String provider,
            Authentication authentication) {
        validateAuthentication(authentication);
        AuthProvider authProvider = parseProvider(provider);
        accountLinkingService.unlinkProvider(authentication.getName(), authProvider);
        return ApiResponse.ok(null, "Đã gỡ liên kết " + provider + ".");
    }

    /** Lấy danh sách providers đã link */
    @GetMapping("/linked-providers")
    public ApiResponse<List<LinkedProviderResponse>> getLinkedProviders(Authentication authentication) {
        validateAuthentication(authentication);
        List<LinkedProviderResponse> providers = accountLinkingService.getLinkedProviders(authentication.getName());
        return ApiResponse.ok(providers, "OK");
    }

    private void validateAuthentication(Authentication authentication) {
        if (authentication == null) {
            throw new BusinessRuleException("Unauthorized");
        }
    }

    private AuthProvider parseProvider(String provider) {
        try {
            return AuthProvider.valueOf(provider.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new BusinessRuleException("Provider không hợp lệ: " + provider + ". Hỗ trợ: GOOGLE, FACEBOOK.");
        }
    }
}
