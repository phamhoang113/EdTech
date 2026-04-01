package com.edtech.backend.billing.controller;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.billing.dto.BillingDTO;
import com.edtech.backend.billing.dto.TutorPayoutDTO;
import com.edtech.backend.billing.entity.BillingEntity;
import com.edtech.backend.billing.entity.TutorPayoutEntity;
import com.edtech.backend.billing.enums.BillingStatus;
import com.edtech.backend.billing.enums.TutorPayoutStatus;
import com.edtech.backend.billing.repository.BillingRepository;
import com.edtech.backend.billing.repository.TutorPayoutRepository;
import com.edtech.backend.billing.service.BillingSchedulerService;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.repository.TutorProfileRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import jakarta.persistence.criteria.Predicate;
import java.util.ArrayList;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequestMapping("/api/v1/admins/billings")
@RequiredArgsConstructor
public class AdminBillingController {

    private final BillingSchedulerService billingSchedulerService;
    private final BillingRepository billingRepository;
    private final TutorPayoutRepository tutorPayoutRepository;
    private final UserRepository userRepository;
    private final TutorProfileRepository tutorProfileRepository;

    private UserEntity resolveAdmin(UserDetails userDetails) {
        return userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("Admin not found"));
    }

    // ─── Trigger billing generation (creates DRAFT) ────────────────────────

    @PostMapping("/trigger")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<String>> triggerBillingGeneration(
            @RequestParam int month, @RequestParam int year) {
        billingSchedulerService.generateMonthlyBillingsManual(month, year);
        return ResponseEntity.ok(ApiResponse.ok("Đã tạo hóa đơn nháp cho kỳ " + month + "/" + year + ". Vui lòng duyệt để gửi phụ huynh."));
    }

    // ─── List billings ─────────────────────────────────────────────────────

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<List<BillingDTO>>> getAllBillings(
            @RequestParam(required = false) BillingStatus status,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {
            
        Specification<BillingEntity> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (status != null) predicates.add(cb.equal(root.get("status"), status));
            if (month != null) predicates.add(cb.equal(root.get("month"), month));
            if (year != null) predicates.add(cb.equal(root.get("year"), year));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
        List<BillingEntity> entities = billingRepository.findAll(spec, Sort.by(Sort.Direction.DESC, "createdAt"));
        
        return ResponseEntity.ok(ApiResponse.ok(
                entities.stream().map(BillingDTO::fromEntity).collect(Collectors.toList())
        ));
    }

    // ─── Approve single DRAFT → UNPAID + create TutorPayout ────────────────

    @PostMapping("/{id}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    @Transactional
    public ResponseEntity<ApiResponse<String>> approveDraftBilling(@PathVariable UUID id) {
        BillingEntity billing = billingRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Hóa đơn không tồn tại."));

        if (billing.getStatus() != BillingStatus.DRAFT) {
            throw new BusinessRuleException("Chỉ có thể duyệt hóa đơn ở trạng thái Nháp.");
        }

        billing.setStatus(BillingStatus.UNPAID);
        billingRepository.save(billing);

        createTutorPayoutForBilling(billing);

        return ResponseEntity.ok(ApiResponse.ok("Đã duyệt hóa đơn. Phụ huynh/Học sinh sẽ thấy hóa đơn này."));
    }

    // ─── Approve all DRAFT of a period → UNPAID ────────────────────────────

    @PostMapping("/approve-all")
    @PreAuthorize("hasRole('ADMIN')")
    @Transactional
    public ResponseEntity<ApiResponse<String>> approveAllDraftBillings(
            @RequestParam int month, @RequestParam int year) {
        List<BillingEntity> drafts = billingRepository.findByStatusAndMonthAndYear(BillingStatus.DRAFT, month, year);

        if (drafts.isEmpty()) {
            return ResponseEntity.ok(ApiResponse.ok("Không có hóa đơn nháp nào cho kỳ " + month + "/" + year));
        }

        for (BillingEntity billing : drafts) {
            billing.setStatus(BillingStatus.UNPAID);
            createTutorPayoutForBilling(billing);
        }
        billingRepository.saveAll(drafts);

        return ResponseEntity.ok(ApiResponse.ok("Đã duyệt " + drafts.size() + " hóa đơn cho kỳ " + month + "/" + year));
    }

    // ─── Delete a DRAFT billing ────────────────────────────────────────────

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Transactional
    public ResponseEntity<ApiResponse<String>> deleteDraftBilling(@PathVariable UUID id) {
        BillingEntity billing = billingRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Hóa đơn không tồn tại."));

        if (billing.getStatus() != BillingStatus.DRAFT) {
            throw new BusinessRuleException("Chỉ có thể xóa hóa đơn ở trạng thái Nháp.");
        }

        billingRepository.delete(billing);
        return ResponseEntity.ok(ApiResponse.ok("Đã xóa hóa đơn nháp."));
    }

    // ─── Verify payment (VERIFYING → PAID) ─────────────────────────────────

    @PostMapping("/verify/{transactionCode}")
    @PreAuthorize("hasRole('ADMIN')")
    @Transactional
    public ResponseEntity<ApiResponse<String>> verifyPayment(
            @PathVariable String transactionCode,
            @AuthenticationPrincipal UserDetails userDetails) {

        UserEntity adminUser = resolveAdmin(userDetails);

        List<BillingEntity> billings = billingRepository.findByTransactionCode(transactionCode);
        if (billings.isEmpty()) {
            throw new EntityNotFoundException("Không tìm thấy hóa đơn nào có mã " + transactionCode);
        }

        boolean allPaid = billings.stream().allMatch(b -> b.getStatus() == BillingStatus.PAID);
        if (allPaid) {
            throw new BusinessRuleException("Các hóa đơn này đã được xác nhận thanh toán trước đó.");
        }

        for (BillingEntity billing : billings) {
            if (billing.getStatus() == BillingStatus.VERIFYING) {
                billing.setStatus(BillingStatus.PAID);
                billing.setVerifiedByAdmin(adminUser);
                billing.setVerifiedAt(Instant.now());
                if (!tutorPayoutRepository.existsByBillingId(billing.getId())) {
                    createTutorPayoutForBilling(billing);
                }
            }
        }
        billingRepository.saveAll(billings);

        // Unlock TutorPayouts for these billings
        List<UUID> billingIds = billings.stream().map(BillingEntity::getId).toList();
        List<TutorPayoutEntity> payouts = tutorPayoutRepository.findByBillingIdIn(billingIds);

        for (TutorPayoutEntity payout : payouts) {
            if (payout.getStatus() == TutorPayoutStatus.LOCKED) {
                payout.setStatus(TutorPayoutStatus.PENDING);
            }
        }
        if (!payouts.isEmpty()) {
            tutorPayoutRepository.saveAll(payouts);
        }

        long verifiedCount = billings.stream().filter(b -> b.getStatus() == BillingStatus.PAID).count();
        return ResponseEntity.ok(ApiResponse.ok(
                "Xác nhận thanh toán thành công " + verifiedCount + " hóa đơn. Đã mở khóa lương gia sư."
        ));
    }

    @PostMapping("/verify-bulk")
    @PreAuthorize("hasRole('ADMIN')")
    @Transactional
    public ResponseEntity<ApiResponse<String>> verifyBulkPayments(
            @RequestBody List<UUID> billingIds,
            @AuthenticationPrincipal UserDetails userDetails) {

        UserEntity adminUser = resolveAdmin(userDetails);

        List<BillingEntity> billings = billingRepository.findAllById(billingIds);
        if (billings.isEmpty()) {
            throw new EntityNotFoundException("Không tìm thấy hóa đơn nào hợp lệ để xác nhận.");
        }

        for (BillingEntity billing : billings) {
            if (billing.getStatus() == BillingStatus.VERIFYING || billing.getStatus() == BillingStatus.UNPAID) {
                billing.setStatus(BillingStatus.PAID);
                billing.setVerifiedByAdmin(adminUser);
                billing.setVerifiedAt(Instant.now());
                if (!tutorPayoutRepository.existsByBillingId(billing.getId())) {
                    createTutorPayoutForBilling(billing);
                }
            }
        }
        billingRepository.saveAll(billings);

        List<TutorPayoutEntity> payouts = tutorPayoutRepository.findByBillingIdIn(billingIds);
        for (TutorPayoutEntity payout : payouts) {
            if (payout.getStatus() == TutorPayoutStatus.LOCKED) {
                payout.setStatus(TutorPayoutStatus.PENDING);
            }
        }
        if (!payouts.isEmpty()) {
            tutorPayoutRepository.saveAll(payouts);
        }

        long verifiedCount = billings.stream().filter(b -> b.getStatus() == BillingStatus.PAID).count();
        return ResponseEntity.ok(ApiResponse.ok(
                "Đã xác nhận thanh toán thành công " + verifiedCount + " hóa đơn."
        ));
    }

    // ─── Tutor Payouts: List ───────────────────────────────────────────────

    @GetMapping("/payouts")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<List<TutorPayoutDTO>>> getTutorPayouts(
            @RequestParam(required = false) TutorPayoutStatus status,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Integer year) {
            
        Specification<TutorPayoutEntity> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (status != null) predicates.add(cb.equal(root.get("status"), status));
            if (month != null) predicates.add(cb.equal(root.get("billing").get("month"), month));
            if (year != null) predicates.add(cb.equal(root.get("billing").get("year"), year));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
        List<TutorPayoutEntity> entities = tutorPayoutRepository.findAll(spec, Sort.by(Sort.Direction.DESC, "createdAt"));

        List<TutorPayoutDTO> dtos = entities.stream().map(e -> {
            TutorPayoutDTO dto = TutorPayoutDTO.fromEntity(e);
            enrichWithBankInfo(dto);
            return dto;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(ApiResponse.ok(dtos));
    }

    // ─── Mark payout as paid by admin ──────────────────────────────────────

    @PostMapping("/payouts/{id}/mark-paid")
    @PreAuthorize("hasRole('ADMIN')")
    @Transactional
    public ResponseEntity<ApiResponse<String>> markPayoutPaid(
            @PathVariable UUID id,
            @RequestParam(required = false) String note) {

        TutorPayoutEntity payout = tutorPayoutRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Payout không tồn tại."));

        if (payout.getStatus() != TutorPayoutStatus.PENDING) {
            throw new BusinessRuleException("Chỉ có thể đánh dấu đã chi cho payout đang ở trạng thái Chờ chi.");
        }

        payout.setStatus(TutorPayoutStatus.PAID_OUT);
        payout.setAdminNote(note);
        payout.setPaidAt(Instant.now());
        tutorPayoutRepository.save(payout);

        String tutorName = payout.getTutor() != null ? payout.getTutor().getFullName() : "N/A";
        return ResponseEntity.ok(ApiResponse.ok("Đã đánh dấu chi lương cho gia sư " + tutorName));
    }

    // ─── Helper: Create TutorPayout for an approved billing ────────────────

    private void createTutorPayoutForBilling(BillingEntity billing) {
        if (billing.getCls() == null || billing.getCls().getTutorId() == null) {
            return;
        }

        // Check if payout already exists
        if (tutorPayoutRepository.existsByBillingId(billing.getId())) {
            return;
        }

        String tutorIdSub = billing.getCls().getTutorId().toString().substring(0, 6).toUpperCase();
        String yymm = String.format("%02d%02d", billing.getMonth(), billing.getYear() % 100);
        String tutorTxCode = "PAYT" + tutorIdSub + yymm;

        TutorPayoutEntity payout = TutorPayoutEntity.builder()
                .tutor(userRepository.getReferenceById(billing.getCls().getTutorId()))
                .billing(billing)
                .amount(billing.getTutorPayoutAmount())
                .transactionCode(tutorTxCode)
                .status(TutorPayoutStatus.LOCKED)
                .build();

        tutorPayoutRepository.save(payout);
    }

    private void enrichWithBankInfo(TutorPayoutDTO dto) {
        if (dto.getTutorId() == null) return;
        tutorProfileRepository.findByUserId(dto.getTutorId()).ifPresent(profile -> {
            dto.setTutorBankName(profile.getBankName());
            dto.setTutorBankAccount(profile.getBankAccountNumber());
            dto.setTutorBankOwner(profile.getBankOwnerName());
        });
    }
}
