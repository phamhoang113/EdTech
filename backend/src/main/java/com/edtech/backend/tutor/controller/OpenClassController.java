package com.edtech.backend.tutor.controller;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.tutor.dto.response.OpenClassResponse;
import com.edtech.backend.tutor.service.OpenClassService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/classes")
@RequiredArgsConstructor
public class OpenClassController {

    private final OpenClassService openClassService;

    @GetMapping("/open")
    public ResponseEntity<ApiResponse<List<OpenClassResponse>>> getOpenClasses() {
        List<OpenClassResponse> classes = openClassService.getAllOpenClasses();
        return ResponseEntity.ok(ApiResponse.ok(classes));
    }

    @GetMapping("/filters")
    public ResponseEntity<ApiResponse<com.edtech.backend.tutor.dto.response.ClassFilterResponse>> getFilters() {
        return ResponseEntity.ok(ApiResponse.ok(openClassService.getClassFilters()));
    }
}
