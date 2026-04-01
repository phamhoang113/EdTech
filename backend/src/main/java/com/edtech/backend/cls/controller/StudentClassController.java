package com.edtech.backend.cls.controller;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.enums.ApplicationStatus;
import com.edtech.backend.cls.enums.ClassMode;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.tutor.dto.request.ParentClassRequest;
import com.edtech.backend.admin.dto.AdminClassListItem;
import com.edtech.backend.tutor.dto.response.ClassApplicationResponse;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.cls.repository.ClassApplicationRepository;
import com.edtech.backend.tutor.service.ClassApplicationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/student")
@RequiredArgsConstructor
@PreAuthorize("hasRole('STUDENT')")
@Transactional
public class StudentClassController {

    private final ClassRepository classRepository;
    private final UserRepository userRepository;
    private final ClassApplicationService classApplicationService;
    private final ClassApplicationRepository classApplicationRepository;

    /** HS độc lập gửi yêu cầu mở lớp → status = PENDING_APPROVAL */
    @PostMapping("/classes")
    public ResponseEntity<ApiResponse<AdminClassListItem>> requestClass(
            @Valid @RequestBody ParentClassRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {

        UserEntity student = resolveUser(userDetails.getUsername());
        UUID studentId = student.getId();

        ClassEntity cls = ClassEntity.builder()
                .classCode(generateClassCode())
                .adminId(studentId)          // tạm dùng studentId, admin sẽ nhận sau
                .parentId(studentId)         // KHÓA CHÍNH: gán parentId = studentId
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
                .tutorProposals("[]")
                .status(ClassStatus.PENDING_APPROVAL)
                .isDeleted(false)
                .students(new java.util.HashSet<>(List.of(student))) // add exactly the student
                .build();

        ClassEntity saved = classRepository.save(cls);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok(toItem(saved, null), "Đã gửi yêu cầu mở lớp! Admin sẽ xem xét sớm."));
    }

    /** HS xem tất cả lớp của mình (mà hệ thống coi họ là parent) */
    @GetMapping("/classes")
    public ResponseEntity<ApiResponse<List<AdminClassListItem>>> getMyClasses(
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID studentId = resolveUser(userDetails.getUsername()).getId();
        // Querry parentId vì HS đang đóng vai trò parent
        List<ClassEntity> classes = classRepository.findByParentIdAndIsDeletedFalseOrderByCreatedAtDesc(studentId);

        List<AdminClassListItem> items = classes.stream()
                .map(c -> toItem(c, null))
                .collect(Collectors.toList());

        return ResponseEntity.ok(ApiResponse.ok(items));
    }

    /** HS xem gia sư đã đăng ký nhận lớp (admin đã duyệt đơn) */
    @GetMapping("/classes/{classId}/tutors")
    public ResponseEntity<ApiResponse<List<ClassApplicationResponse>>> getApplicants(
            @PathVariable UUID classId,
            @AuthenticationPrincipal UserDetails userDetails) {

        UUID studentId = resolveUser(userDetails.getUsername()).getId();
        List<ClassApplicationResponse> tutors =
                classApplicationService.getProposedTutorsForParent(classId, studentId);

        return ResponseEntity.ok(ApiResponse.ok(tutors));
    }

    // ─── Private helpers ─────────────────────────────────────────────────────

    private UserEntity resolveUser(String phone) {
        return userRepository.findByIdentifierAndIsDeletedFalse(phone)
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
