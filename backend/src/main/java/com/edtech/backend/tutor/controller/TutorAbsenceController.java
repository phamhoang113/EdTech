package com.edtech.backend.tutor.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.tutor.dto.request.TutorAbsenceReqDTO;
import com.edtech.backend.tutor.service.TutorAbsenceService;

@RestController
@RequestMapping("/api/v1/tutor/absence-requests")
@RequiredArgsConstructor
@Tag(name = "Tutor Absence", description = "Tutor API for requesting leaves/absences")
public class TutorAbsenceController {

    private final TutorAbsenceService tutorAbsenceService;

    @PostMapping
    @PreAuthorize("hasRole('TUTOR')")
    @Operation(summary = "Submit an absence request for a scheduled session")
    public ResponseEntity<ApiResponse<String>> createAbsenceRequest(@Valid @RequestBody TutorAbsenceReqDTO request) {
        tutorAbsenceService.createAbsenceRequest(request);
        return ResponseEntity.ok(ApiResponse.<String>ok(null, "Gửi đơn xin vắng mặt thành công."));
    }
}
