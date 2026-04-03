package com.edtech.backend.tutor.controller;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.HashSet;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.admin.dto.AdminClassListItem;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.ApplicationStatus;
import com.edtech.backend.cls.enums.ClassMode;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.repository.ClassApplicationRepository;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.tutor.dto.request.ParentClassRequest;
import com.edtech.backend.tutor.dto.response.ClassApplicationResponse;
import com.edtech.backend.tutor.service.ClassApplicationService;

@RestController
@RequestMapping("/api/v1/parent")
@RequiredArgsConstructor
@PreAuthorize("hasRole('PARENT')")
@Transactional
public class ParentClassController {

    private final ClassRepository classRepository;
    private final UserRepository userRepository;
    private final ClassApplicationService classApplicationService;
    private final ClassApplicationRepository classApplicationRepository;

    /** PH gửi yêu cầu mở lớp → status = PENDING_APPROVAL */
    @PostMapping("/classes")
    public ResponseEntity<ApiResponse<AdminClassListItem>> requestClass(
            @Valid @RequestBody ParentClassRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID parentId = resolveUserId(userDetails.getUsername());

        List<UserEntity> studentUsers = (request.studentIds() != null && !request.studentIds().isEmpty())
                ? userRepository.findAllById(request.studentIds())
                : List.of();

        ClassEntity cls = ClassEntity.builder()
                .classCode(generateClassCode())
                .adminId(parentId)          // tạm dùng parentId, admin sẽ nhận sau
                .parentId(parentId)
                .title(request.title())
                .subject(request.subject())
                .grade(request.grade())
                .mode(ClassMode.valueOf(request.mode()))
                .address(request.address())
                .schedule(request.schedule() != null ? request.schedule() : "[]")
                .sessionsPerWeek(request.sessionsPerWeek())
                .sessionDurationMin(request.sessionDurationMin())
                .timeFrame(request.timeFrame())
                .parentFee(BigDecimal.ZERO)
                .tutorFee(BigDecimal.ZERO)
                .platformFee(BigDecimal.ZERO)
                .feePercentage(30)
                .genderRequirement(request.genderRequirement() != null ? request.genderRequirement() : "Không yêu cầu")
                .description(request.description())
                .levelFees(request.levelFees())
                .tutorProposals("[]")       // NOT NULL trong DB — khởi tạo rỗng
                .status(ClassStatus.PENDING_APPROVAL)
                .isDeleted(false)
                .students(new HashSet<>(studentUsers))
                .build();


        ClassEntity saved = classRepository.save(cls);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok(toItem(saved, null), "Đã gửi yêu cầu mở lớp! Admin sẽ xem xét sớm."));
    }

    /** PH xem tất cả lớp của mình */
    @GetMapping("/classes")
    public ResponseEntity<ApiResponse<List<AdminClassListItem>>> getMyClasses(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID parentId = resolveUserId(userDetails.getUsername());
        List<ClassEntity> classes = classRepository.findByParentIdAndIsDeletedFalseOrderByCreatedAtDesc(parentId);

        List<AdminClassListItem> items = classes.stream()
                .map(c -> toItem(c, null))
                .collect(Collectors.toList());

        return ResponseEntity.ok(ApiResponse.ok(items));
    }

    /** PH xem gia sư đã đăng ký nhận lớp (admin đã duyệt đơn) */
    @GetMapping("/classes/{classId}/tutors")
    public ResponseEntity<ApiResponse<List<ClassApplicationResponse>>> getApplicants(
            @PathVariable UUID classId,
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID parentId = resolveUserId(userDetails.getUsername());
        List<ClassApplicationResponse> tutors =
                classApplicationService.getProposedTutorsForParent(classId, parentId);

        return ResponseEntity.ok(ApiResponse.ok(tutors));
    }

    /** Cập nhật danh sách học sinh cho lớp đã tạo */
    @Transactional
    @PutMapping("/classes/{classId}/students")
    public ResponseEntity<ApiResponse<AdminClassListItem>> updateClassStudents(
            @PathVariable UUID classId,
            @RequestBody List<UUID> studentIds,
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID parentId = resolveUserId(userDetails.getUsername());
        ClassEntity cls = classRepository.findById(classId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy lớp học"));

        if (!cls.getParentId().equals(parentId)) {
            throw new BusinessRuleException("Bạn không quyền truy cập lớp này.");
        }

        List<UserEntity> studentUsers = (studentIds != null && !studentIds.isEmpty())
                ? userRepository.findAllById(studentIds)
                : List.of();

        cls.getStudents().clear();
        cls.getStudents().addAll(studentUsers);
        ClassEntity saved = classRepository.save(cls);

        return ResponseEntity.ok(ApiResponse.ok(toItem(saved, null), "Đã cập nhật học sinh cho lớp."));
    }


    // ─── Private helpers ─────────────────────────────────────────────────────

    private UUID resolveUserId(String phone) {
        return userRepository.findByIdentifierAndIsDeletedFalse(phone)
                .map(UserEntity::getId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy user."));
    }

    private AdminClassListItem toItem(ClassEntity cls, String parentName) {
        return AdminClassListItem.builder()
                .id(cls.getId())
                .classCode(cls.getClassCode())
                .title(cls.getTitle())
                .subject(cls.getSubject())
                .grade(cls.getGrade())
                .mode(cls.getMode() != null ? cls.getMode().name() : null)
                .address(cls.getAddress())
                .parentName(parentName)
                .parentFee(cls.getParentFee())
                .tutorFee(cls.getTutorFee())
                .platformFee(cls.getPlatformFee())
                .feePercentage(cls.getFeePercentage())
                .sessionsPerWeek(cls.getSessionsPerWeek())
                .sessionDurationMin(cls.getSessionDurationMin())
                .timeFrame(cls.getTimeFrame())
                .schedule(cls.getSchedule())
                .genderRequirement(cls.getGenderRequirement())
                .levelFees(cls.getLevelFees())
                .rejectionReason(cls.getRejectionReason())
                .status(cls.getStatus())
                .hasPendingProposals(
                        cls.getTutorId() == null
                        && classApplicationRepository.existsByClassIdAndStatus(cls.getId(), ApplicationStatus.APPROVED))
                .pendingApplicationCount((int) classApplicationRepository.countByClassIdAndStatus(
                        cls.getId(), ApplicationStatus.APPROVED))
                .createdAt(cls.getCreatedAt())
                .studentIds(cls.getStudents() != null ? cls.getStudents().stream().map(UserEntity::getId).toList() : List.of())
                .build();
    }

    /** Sinh mã lớp 6 ký tự dạng A-Z0-9 */
    private String generateClassCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code = new StringBuilder(6);
        for (int i = 0; i < 6; i++) {
            code.append(chars.charAt(ThreadLocalRandom.current().nextInt(chars.length())));
        }
        return code.toString();
    }
}
