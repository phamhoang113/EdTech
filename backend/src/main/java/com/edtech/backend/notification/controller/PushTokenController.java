package com.edtech.backend.notification.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.notification.dto.PushTokenRequest;
import com.edtech.backend.notification.service.FcmPushService;

@RestController
@RequestMapping("/api/v1/push")
@RequiredArgsConstructor
public class PushTokenController {

    private final FcmPushService fcmPushService;

    @PostMapping("/register")
    public ApiResponse<Void> registerToken(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody PushTokenRequest request) {
        fcmPushService.registerToken(userDetails.getUsername(), request);
        return ApiResponse.ok(null, "Đăng ký push token thành công");
    }

    @DeleteMapping("/unregister")
    public ApiResponse<Void> unregisterToken(@RequestParam String token) {
        fcmPushService.unregisterToken(token);
        return ApiResponse.ok(null, "Hủy đăng ký push token thành công");
    }
}
