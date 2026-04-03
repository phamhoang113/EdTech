package com.edtech.backend.auth.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.dto.UpdateUserProfileRequest;
import com.edtech.backend.auth.dto.UserProfileResponse;
import com.edtech.backend.auth.service.UserProfileService;
import com.edtech.backend.core.dto.ApiResponse;

/**
 * Controller xử lý profile chung cho mọi role (Parent, Student).
 * Tutor giữ endpoint riêng tại /api/v1/tutors/profile.
 */
@RestController
@RequestMapping("/api/v1/users/profile")
@RequiredArgsConstructor
public class UserProfileController {

    private final UserProfileService userProfileService;

    @GetMapping("/me")
    public ApiResponse<UserProfileResponse> getMyProfile(
            @AuthenticationPrincipal UserDetails userDetails) {
        String username = userDetails.getUsername();
        UserProfileResponse response = userProfileService.getMyProfile(username);
        return ApiResponse.ok(response);
    }

    @PutMapping
    public ApiResponse<UserProfileResponse> updateMyProfile(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody UpdateUserProfileRequest request) {
        String username = userDetails.getUsername();
        UserProfileResponse response = userProfileService.updateMyProfile(username, request);
        return ApiResponse.ok(response);
    }
}
