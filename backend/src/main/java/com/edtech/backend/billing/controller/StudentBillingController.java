package com.edtech.backend.billing.controller;

import java.util.List;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.billing.dto.BillingDTO;
import com.edtech.backend.billing.service.StudentBillingService;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;

@RestController
@RequestMapping("/api/v1/students/billings")
@RequiredArgsConstructor
public class StudentBillingController {

    private final StudentBillingService studentBillingService;
    private final UserRepository userRepository;

    private UUID resolveStudentId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found."));
        if (!"STUDENT".equals(user.getRole().name())) {
            throw new BusinessRuleException("Chỉ học sinh mới có quyền thực hiện.");
        }
        return user.getId();
    }

    @GetMapping
    @PreAuthorize("hasRole('STUDENT')")
    public ResponseEntity<ApiResponse<List<BillingDTO>>> getBillings(
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID studentId = resolveStudentId(userDetails);
        List<BillingDTO> billings = studentBillingService.getBillingsForStudent(studentId);
        return ResponseEntity.ok(ApiResponse.ok(billings));
    }

    @PostMapping("/{id}/confirm")
    @PreAuthorize("hasRole('STUDENT')")
    public ResponseEntity<ApiResponse<String>> confirmTransfer(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID studentId = resolveStudentId(userDetails);
        studentBillingService.confirmTransfer(studentId, id);
        return ResponseEntity.ok(ApiResponse.ok("Đã thông báo chuyển khoản thành công. Đang chờ kế toán đối soát."));
    }
}
