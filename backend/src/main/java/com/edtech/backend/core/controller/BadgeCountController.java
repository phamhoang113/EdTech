package com.edtech.backend.core.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.billing.enums.BillingStatus;
import com.edtech.backend.billing.repository.BillingRepository;
import com.edtech.backend.cls.enums.AbsenceRequestStatus;
import com.edtech.backend.cls.enums.ApplicationStatus;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.repository.AbsenceRequestRepository;
import com.edtech.backend.cls.repository.ClassApplicationRepository;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.tutor.enums.VerificationStatus;
import com.edtech.backend.tutor.repository.TutorProfileRepository;

/**
 * Endpoint trả về badge counts cho sidebar — tuỳ theo role của user đăng nhập.
 * Gọi nhẹ, không cần phân quyền cụ thể (chỉ cần authenticated).
 */
@RestController
@RequestMapping("/api/v1/badge-counts")
@RequiredArgsConstructor
public class BadgeCountController {

    private final UserRepository userRepository;
    private final ClassRepository classRepository;
    private final ClassApplicationRepository classApplicationRepository;
    private final TutorProfileRepository tutorProfileRepository;
    private final AbsenceRequestRepository absenceRequestRepository;
    private final BillingRepository billingRepository;

    @GetMapping
    public ApiResponse<Map<String, Long>> getBadgeCounts(@AuthenticationPrincipal UserDetails principal) {
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(principal.getUsername()).orElse(null);
        if (user == null) return ApiResponse.ok(Map.of());

        Map<String, Long> counts = new HashMap<>();
        UserRole role = user.getRole();

        switch (role) {
            case ADMIN -> {
                counts.put("pendingApplications", classApplicationRepository.countByStatus(ApplicationStatus.PENDING));
                counts.put("pendingVerifications", tutorProfileRepository.countByVerificationStatus(VerificationStatus.PENDING));
                counts.put("pendingClassRequests", classRepository.countByStatusAndIsDeletedFalse(ClassStatus.PENDING_APPROVAL));
                counts.put("pendingAbsences", absenceRequestRepository.countByStatus(AbsenceRequestStatus.PENDING));
                counts.put("verifyingBillings", billingRepository.countByStatus(BillingStatus.VERIFYING));
            }
            case PARENT -> {
                // Số đơn GS đã được admin đề xuất (APPROVED) cho lớp của PH này, lớp vẫn OPEN
                long proposedForParent = countProposedApplicationsForParent(user.getId());
                long unpaidBillings = billingRepository.countByParentIdAndStatus(user.getId(), BillingStatus.UNPAID);
                counts.put("proposedApplicants", proposedForParent);
                counts.put("unpaidBillings", unpaidBillings);
            }
            case TUTOR -> {
                // Số lớp đang mở mà GS có thể nhận
                long openClasses = classRepository.countByStatusAndIsDeletedFalse(ClassStatus.OPEN);
                counts.put("openClasses", openClasses);
            }
            default -> {
                // Student — không có badge đặc biệt
            }
        }

        return ApiResponse.ok(counts);
    }

    /**
     * Đếm số GS được admin đề xuất cho lớp OPEN của parent.
     * = Tổng applications có status=APPROVED trên các lớp OPEN của parent.
     */
    private long countProposedApplicationsForParent(UUID parentId) {
        return classRepository.findByParentIdAndIsDeletedFalseOrderByCreatedAtDesc(parentId).stream()
                .filter(cls -> cls.getStatus() == ClassStatus.OPEN)
                .mapToLong(cls -> classApplicationRepository.countByClassIdAndStatus(cls.getId(), ApplicationStatus.APPROVED))
                .sum();
    }
}
