package com.edtech.backend.billing.controller;

import java.time.Instant;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.billing.dto.TutorPayoutDTO;
import com.edtech.backend.billing.entity.TutorPayoutEntity;
import com.edtech.backend.billing.enums.TutorPayoutStatus;
import com.edtech.backend.billing.repository.TutorPayoutRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;

@RestController
@RequestMapping("/api/v1/tutors")
@RequiredArgsConstructor
public class TutorBillingController {

    private final TutorPayoutRepository tutorPayoutRepository;
    private final UserRepository userRepository;

    private UUID resolveTutorId(UserDetails userDetails) {
        UserEntity tutor = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("Tutor not found"));
        if (!"TUTOR".equals(tutor.getRole().name())) {
            throw new BusinessRuleException("Chỉ gia sư mới có quyền thực hiện.");
        }
        return tutor.getId();
    }

    @GetMapping("/payouts")
    @PreAuthorize("hasRole('TUTOR')")
    public ResponseEntity<ApiResponse<List<TutorPayoutDTO>>> getMyPayouts(
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID tutorId = resolveTutorId(userDetails);
        List<TutorPayoutDTO> payouts = tutorPayoutRepository.findByTutorIdOrderByCreatedAtDesc(tutorId)
                .stream().map(TutorPayoutDTO::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(ApiResponse.ok(payouts));
    }

    @PostMapping("/payouts/{id}/confirm")
    @PreAuthorize("hasRole('TUTOR')")
    @Transactional
    public ResponseEntity<ApiResponse<String>> confirmPayoutReceived(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetails userDetails) {
        UUID tutorId = resolveTutorId(userDetails);

        TutorPayoutEntity payout = tutorPayoutRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Payout không tồn tại."));

        if (!payout.getTutor().getId().equals(tutorId)) {
            throw new BusinessRuleException("Bạn không có quyền xác nhận payout này.");
        }

        if (payout.getStatus() != TutorPayoutStatus.PAID_OUT) {
            throw new BusinessRuleException("Chỉ có thể xác nhận nhận tiền khi admin đã chi lương.");
        }

        if (payout.getConfirmedByTutorAt() != null) {
            throw new BusinessRuleException("Bạn đã xác nhận nhận tiền trước đó.");
        }

        payout.setConfirmedByTutorAt(Instant.now());
        tutorPayoutRepository.save(payout);

        return ResponseEntity.ok(ApiResponse.ok("Đã xác nhận nhận lương thành công. Cảm ơn bạn!"));
    }
}
