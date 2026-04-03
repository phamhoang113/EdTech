package com.edtech.backend.tutor.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.tutor.dto.response.TutorPublicResponse;
import com.edtech.backend.tutor.service.PublicTutorService;

@RestController
@RequestMapping("/api/v1/public/tutors")
@RequiredArgsConstructor
public class PublicTutorController {

    private final PublicTutorService publicTutorService;

    @GetMapping
    public ApiResponse<Page<TutorPublicResponse>> getPublicTutors(
            @PageableDefault(size = 10, sort = {"rating"}) Pageable pageable
    ) {
        Page<TutorPublicResponse> responses = publicTutorService.getPublicTutors(pageable);
        return ApiResponse.ok(responses, "Lấy danh sách gia sư công khai thành công");
    }
}
