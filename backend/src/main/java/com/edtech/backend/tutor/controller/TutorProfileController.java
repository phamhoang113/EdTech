package com.edtech.backend.tutor.controller;

import java.time.LocalDate;
import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.tutor.dto.request.UpdateTutorProfileRequest;
import com.edtech.backend.tutor.dto.response.TutorProfileResponse;
import com.edtech.backend.tutor.enums.TutorType;
import com.edtech.backend.tutor.service.TutorProfileService;

@RestController
@RequestMapping("/api/v1/tutors/profile")
@RequiredArgsConstructor
public class TutorProfileController {

    private final TutorProfileService tutorProfileService;

    @GetMapping("/me")
    public ApiResponse<TutorProfileResponse> getMyProfile(@AuthenticationPrincipal UserDetails userDetails) {
        String username = userDetails.getUsername();
        TutorProfileResponse response = tutorProfileService.getMyProfileByUsername(username);
        return ApiResponse.ok(response, "Lấy hồ sơ thành công");
    }

    @PutMapping("/me")
    public ApiResponse<TutorProfileResponse> updateMyProfile(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestBody UpdateTutorProfileRequest request
    ) {
        String username = userDetails.getUsername();
        TutorProfileResponse response = tutorProfileService.updateMyProfile(username, request);
        return ApiResponse.ok(response, "Cập nhật hồ sơ thành công");
    }

    @PostMapping("/verify")
    public ApiResponse<TutorProfileResponse> verifyProfile(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam("tutorType") TutorType tutorType,
            @RequestParam(value = "dateOfBirth", required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateOfBirth,
            @RequestParam("idCardNumber") String idCardNumber,
            @RequestParam(value = "degree", required = false) MultipartFile degree,
            @RequestParam(value = "subjects", required = false) List<String> subjects,
            @RequestParam(value = "teachingLevels", required = false) List<String> teachingLevels,
            @RequestParam(value = "achievements", required = false) String achievements,
            @RequestParam(value = "experienceYears", required = false) Integer experienceYears,
            @RequestParam(value = "location", required = false) String location
    ) {
        String username = userDetails.getUsername();
        TutorProfileResponse response = tutorProfileService.verifyProfileByUsername(
                username, tutorType, dateOfBirth, idCardNumber, degree, subjects, teachingLevels, achievements, experienceYears, location
        );
        return ApiResponse.ok(response, "Xác thực hồ sơ thành công. Vui lòng chờ duyệt.");
    }
}
