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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.billing.dto.BillingDTO;
import com.edtech.backend.billing.dto.LearningReportClassDTO;
import com.edtech.backend.billing.service.ParentBillingService;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;

@RestController
@RequestMapping("/api/v1/parents")
@RequiredArgsConstructor
public class ParentBillingController {

    private final ParentBillingService parentBillingService;

    private final UserRepository userRepository;

    private UUID resolveParentId(UserDetails userDetails) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found."));
        if (!"PARENT".equals(user.getRole().name())) {
            throw new BusinessRuleException("Chỉ phụ huynh mới có quyền thực hiện.");
        }
        return user.getId();
    }

    @GetMapping("/billings")
    @PreAuthorize("hasRole('PARENT')")
    public ResponseEntity<ApiResponse<List<BillingDTO>>> getBillings(
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID parentId = resolveParentId(userDetails);
        List<BillingDTO> billings = parentBillingService.getBillingsForParent(parentId);
        return ResponseEntity.ok(ApiResponse.ok(billings));
    }

    @PostMapping("/billings/{id}/confirm")
    @PreAuthorize("hasRole('PARENT')")
    public ResponseEntity<ApiResponse<String>> confirmTransfer(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID parentId = resolveParentId(userDetails);
        parentBillingService.confirmTransfer(parentId, id);
        return ResponseEntity.ok(ApiResponse.ok("Đã thông báo chuyển khoản thành công. Đang chờ kế toán đối soát."));
    }

    @GetMapping("/learning-report")
    @PreAuthorize("hasRole('PARENT')")
    public ResponseEntity<ApiResponse<List<LearningReportClassDTO>>> getLearningReport(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(required = false) UUID studentId,
            @RequestParam String yearMonth) {
        UUID parentId = resolveParentId(userDetails);
        List<LearningReportClassDTO> report = parentBillingService.getLearningReport(parentId, studentId, yearMonth);
        return ResponseEntity.ok(ApiResponse.ok(report));
    }
}
