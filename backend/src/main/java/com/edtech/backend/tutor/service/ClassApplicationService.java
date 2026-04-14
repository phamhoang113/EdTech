package com.edtech.backend.tutor.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.enums.UserRole;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.entity.ClassApplicationEntity;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.enums.ApplicationStatus;
import com.edtech.backend.cls.enums.ClassMode;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.repository.ClassApplicationRepository;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.core.service.GoogleMeetService;
import com.edtech.backend.notification.entity.NotificationType;
import com.edtech.backend.notification.service.NotificationService;
import com.edtech.backend.tutor.dto.request.ApplyClassRequest;
import com.edtech.backend.tutor.dto.response.ClassApplicationResponse;
import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.repository.TutorProfileRepository;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ClassApplicationService {

    private final ClassApplicationRepository applicationRepository;
    private final ClassRepository classRepository;
    private final UserRepository userRepository;
    private final TutorProfileRepository tutorProfileRepository;
    private final GoogleMeetService googleMeetService;
    private final NotificationService notificationService;

    /** Gia sư nộp đơn nhận lớp */
    @Transactional
    public ClassApplicationResponse applyForClass(UUID classId, UUID tutorId, ApplyClassRequest request) {
        ClassEntity classEntity = findOpenClassOrThrow(classId);

        if (applicationRepository.existsByClassIdAndTutorId(classId, tutorId)) {
            throw new BusinessRuleException("Bạn đã đăng ký lớp này rồi.");
        }

        ClassApplicationEntity application = ClassApplicationEntity.builder()
                .classId(classId)
                .tutorId(tutorId)
                .status(ApplicationStatus.PENDING)
                .note(request.note())
                .build();

        ClassApplicationEntity saved = applicationRepository.save(application);
        log.info("Tutor {} applied for class {}", tutorId, classId);

        UserEntity tutor = userRepository.findById(tutorId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy gia sư."));

        // Thông báo admin có đơn đăng ký mới
        notifyAdmins(NotificationType.APPLICATION_RECEIVED,
                "Đơn nhận lớp mới",
                String.format("Gia sư %s đã đăng ký nhận lớp %s.", tutor.getFullName(), classEntity.getTitle()),
                "APPLICATION", saved.getId());

        return buildResponse(saved, classEntity, tutor);
    }

    /** Tutor xem danh sách đơn của mình */
    public List<ClassApplicationResponse> getMyApplications(UUID tutorId) {
        return applicationRepository.findByTutorId(tutorId).stream()
                .map(app -> {
                    ClassEntity cls = classRepository.findById(app.getClassId())
                            .orElse(null);
                    UserEntity tutor = userRepository.findById(tutorId).orElse(null);
                    return buildResponse(app, cls, tutor);
                })
                .collect(Collectors.toList());
    }

    /** Admin xem tất cả đơn (có thể filter theo status) */
    public List<ClassApplicationResponse> getAllApplications(ApplicationStatus status) {
        List<ClassApplicationEntity> apps = (status != null)
                ? applicationRepository.findByStatus(status)
                : applicationRepository.findAll();

        return apps.stream()
                .map(app -> {
                    ClassEntity cls = classRepository.findById(app.getClassId()).orElse(null);
                    UserEntity tutor = userRepository.findById(app.getTutorId()).orElse(null);
                    return buildResponse(app, cls, tutor);
                })
                .collect(Collectors.toList());
    }

    /** Admin lấy đơn theo lớp */
    public List<ClassApplicationResponse> getApplicationsByClass(UUID classId) {
        return applicationRepository.findByClassId(classId).stream()
                .map(app -> {
                    ClassEntity cls = classRepository.findById(classId).orElse(null);
                    UserEntity tutor = userRepository.findById(app.getTutorId()).orElse(null);
                    return buildResponse(app, cls, tutor);
                })
                .collect(Collectors.toList());
    }

    /**
     * Admin đề xuất gia sư cho phụ huynh.
     * Chỉ đổi đơn từ PENDING → APPROVED. Lớp VẪN OPEN để GS khác còn đăng ký.
     * PH sẽ xem danh sách GS APPROVED và chọn người phù hợp.
     *
     * @param actualSalary Lương thực tế admin đặt (nếu null → tự tính từ levelFees)
     */
    @Transactional
    public ClassApplicationResponse approveApplication(UUID applicationId, BigDecimal actualSalary, String note) {
        ClassApplicationEntity application = findApplicationOrThrow(applicationId);

        if (application.getStatus() != ApplicationStatus.PENDING) {
            throw new BusinessRuleException("Đơn này đã được xử lý rồi.");
        }

        ClassEntity classEntity = findOpenClassOrThrow(application.getClassId());

        BigDecimal proposedSalary = actualSalary;
        if (proposedSalary == null) {
            proposedSalary = resolveSalaryFromLevelFees(classEntity, application.getTutorId());
        }

        // Chỉ đổi status đơn, KHÔNG ASSIGN lớp
        application.setStatus(ApplicationStatus.APPROVED);
        if (note != null && !note.isBlank()) {
            application.setNote(note);
        }
        applicationRepository.save(application);

        // Cập nhật JSON tutor_proposals trên lớp
        // Format: {"<tutorId>": <proposedSalary>, ...}
        updateTutorProposals(classEntity, application.getTutorId(), proposedSalary);
        classRepository.save(classEntity);

        log.info("Admin proposed tutor {} for class {} (application {}) proposedSalary={}",
                application.getTutorId(), application.getClassId(), applicationId, proposedSalary);

        UserEntity tutor = userRepository.findById(application.getTutorId())
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy gia sư."));

        // Thông báo gia sư: admin đã duyệt đơn
        notificationService.sendNotification(application.getTutorId(), NotificationType.APPLICATION_ACCEPTED,
                "Đơn được duyệt",
                String.format("Đơn đăng ký nhận lớp %s của bạn đã được admin phê duyệt.", classEntity.getTitle()),
                "APPLICATION", application.getId());

        // Thông báo phụ huynh: có gia sư được đề xuất
        notificationService.sendNotification(classEntity.getParentId(), NotificationType.APPLICATION_RECEIVED,
                "Gia sư được đề xuất",
                String.format("Admin đã đề xuất gia sư %s cho lớp %s. Vui lòng xem và chọn.", tutor.getFullName(), classEntity.getTitle()),
                "APPLICATION", application.getId());

        return buildResponse(application, classEntity, tutor);
    }

    /**
     * Phụ huynh xem danh sách gia sư được admin đề xuất (status=APPROVED) cho lớp của mình.
     */
    public List<ClassApplicationResponse> getProposedTutorsForParent(UUID classId, UUID parentId) {
        ClassEntity cls = classRepository.findById(classId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy lớp học."));

        if (!cls.getParentId().equals(parentId)) {
            throw new BusinessRuleException("Bạn không có quyền xem lớp này.");
        }

        return applicationRepository.findByClassIdAndStatus(classId, ApplicationStatus.APPROVED)
                .stream()
                .map(app -> {
                    UserEntity tutor = userRepository.findById(app.getTutorId()).orElse(null);
                    return buildResponse(app, cls, tutor);
                })
                .collect(Collectors.toList());
    }

    /**
     * Phụ huynh chọn gia sư từ danh sách đề xuất.
     * → Lớp chuyển ASSIGNED, set tutorId, set tutorFee thực tế.
     * → Reject tất cả đơn còn lại (PENDING + APPROVED khác).
     */
    @Transactional
    public ClassApplicationResponse parentSelectTutor(UUID applicationId, UUID parentId) {
        ClassApplicationEntity application = findApplicationOrThrow(applicationId);

        if (application.getStatus() != ApplicationStatus.APPROVED) {
            throw new BusinessRuleException("Gia sư này chưa được admin đề xuất.");
        }

        ClassEntity classEntity = classRepository.findById(application.getClassId())
                .filter(c -> !c.getIsDeleted())
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy lớp học."));

        if (!classEntity.getParentId().equals(parentId)) {
            throw new BusinessRuleException("Bạn không phải chủ lớp này.");
        }

        if (classEntity.getStatus() != ClassStatus.OPEN) {
            throw new BusinessRuleException("Lớp đã không còn trong trạng thái chờ gia sư.");
        }

        // PH chọn GS: lớp đang dạy luôn (OPEN → ACTIVE)
        classEntity.setTutorId(application.getTutorId());
        classEntity.setStatus(ClassStatus.ACTIVE);
        classEntity.setStartDate(LocalDate.now());
        classEntity.setLearningStartDate(LocalDate.now()); // Auto-set: PH chọn GS = ngày bắt đầu học
        classEntity.setEndDate(null); // Ongoing until manually completed

        // TutorFee: lấy từ proposedSalary admin đặt (lưu trong tutor_proposals JSON)
        BigDecimal tutorFee = resolveProposedSalary(classEntity, application.getTutorId());
        // Nếu chưa có proposal thì fallback về levelFees.tutor_fee
        if (tutorFee == null) tutorFee = resolveSalaryFromLevelFees(classEntity, application.getTutorId());
        if (tutorFee != null) classEntity.setTutorFee(tutorFee);

        // ParentFee: cập nhật theo levelFees[tutorLevel].parent_fee (giá đúng theo trình độ GS)
        BigDecimal parentFee = resolveParentFeeFromLevelFees(classEntity, application.getTutorId());
        if (parentFee != null) classEntity.setParentFee(parentFee);
        else parentFee = classEntity.getParentFee(); // giữ nguyên nếu levelFees không có parent_fee

        // PlatformFee = PH trả - GS nhận
        if (parentFee != null && tutorFee != null) {
            classEntity.setPlatformFee(parentFee.subtract(tutorFee));
        }

        // Tạo Google Meet Link cố định tĩnh nếu là lớp ONLINE
        if (classEntity.getMode() == ClassMode.ONLINE) {
            try {
                List<String> emails = new ArrayList<>();
                userRepository.findById(classEntity.getParentId()).ifPresent(u -> emails.add(u.getEmail()));
                userRepository.findById(application.getTutorId()).ifPresent(u -> emails.add(u.getEmail()));

                String summary = String.format("Lớp %s (Mã %s)", classEntity.getTitle(), classEntity.getClassCode());
                String description = "Đường link cố định dành cho Lớp Học trực tuyến thuộc nền tảng Gia Sư Tinh Hoa.";
                OffsetDateTime now = OffsetDateTime.now();
                
                String meetUrl = googleMeetService.createMeetLink(summary, description, now, now.plusHours(1), emails);
                classEntity.setMeetLink(meetUrl);
                log.info("Fixed Google Meet link generated for class {}: {}", classEntity.getId(), meetUrl);
            } catch (Exception e) {
                log.error("Failed to generate Google Meet link for class " + classEntity.getId(), e);
            }
        }

        classRepository.save(classEntity);

        // Reject tất cả đơn còn lại của cùng lớp
        List<ClassApplicationEntity> others = applicationRepository.findByClassId(classEntity.getId())
                .stream()
                .filter(a -> !a.getId().equals(applicationId)
                        && a.getStatus() != ApplicationStatus.REJECTED)
                .collect(Collectors.toList());
        others.forEach(a -> a.setStatus(ApplicationStatus.REJECTED));
        applicationRepository.saveAll(others);

        log.info("Parent {} selected tutor {} for class {} (application {})",
                parentId, application.getTutorId(), classEntity.getId(), applicationId);

        UserEntity tutor = userRepository.findById(application.getTutorId())
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy gia sư."));

        // Thông báo gia sư được chọn
        notificationService.sendNotification(application.getTutorId(), NotificationType.APPLICATION_ACCEPTED,
                "Bạn được chọn dạy lớp",
                String.format("Phụ huynh đã chọn bạn làm gia sư cho lớp %s.", classEntity.getTitle()),
                "CLASS", classEntity.getId());

        // Thông báo admin
        notifyAdmins(NotificationType.APPLICATION_ACCEPTED,
                "Phụ huynh chọn gia sư",
                String.format("Lớp %s đã được gán cho gia sư %s.", classEntity.getTitle(), tutor.getFullName()),
                "CLASS", classEntity.getId());

        // Thông báo các gia sư bị reject
        others.forEach(a -> notificationService.sendNotification(a.getTutorId(), NotificationType.APPLICATION_REJECTED,
                "Đơn không được chọn",
                String.format("Đơn đăng ký nhận lớp %s của bạn không được chọn.", classEntity.getTitle()),
                "APPLICATION", a.getId()));

        return buildResponse(application, classEntity, tutor);
    }

    /** Admin từ chối đơn */
    @Transactional
    public ClassApplicationResponse rejectApplication(UUID applicationId) {
        ClassApplicationEntity application = findApplicationOrThrow(applicationId);

        if (application.getStatus() != ApplicationStatus.PENDING) {
            throw new BusinessRuleException("Đơn này đã được xử lý rồi.");
        }

        application.setStatus(ApplicationStatus.REJECTED);
        applicationRepository.save(application);

        log.info("Admin rejected application {}", applicationId);

        // Thông báo gia sư: đơn bị từ chối
        ClassEntity cls = classRepository.findById(application.getClassId()).orElse(null);
        notificationService.sendNotification(application.getTutorId(), NotificationType.APPLICATION_REJECTED,
                "Đơn bị từ chối",
                String.format("Đơn đăng ký nhận lớp %s của bạn đã bị từ chối.", cls != null ? cls.getTitle() : ""),
                "APPLICATION", applicationId);

        UserEntity tutor = userRepository.findById(application.getTutorId()).orElse(null);
        return buildResponse(application, cls, tutor);
    }

    // ─── Private helpers ─────────────────────────────────────────────────────

    private ClassEntity findOpenClassOrThrow(UUID classId) {
        return classRepository.findById(classId)
                .filter(c -> !c.getIsDeleted())
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy lớp học."));
    }

    private ClassApplicationEntity findApplicationOrThrow(UUID applicationId) {
        return applicationRepository.findById(applicationId)
                .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy đơn đăng ký."));
    }

    /**
     * Cập nhật (hoặc thêm mới) entry trong JSON tutor_proposals trên lớp.
     * Format: {"<tutorId>": <proposedSalary>, ...}
     */
    private void updateTutorProposals(ClassEntity cls, UUID tutorId, BigDecimal proposedSalary) {
        ObjectMapper om = new ObjectMapper();
        try {
            String current = cls.getTutorProposals();
            ObjectNode node = (current != null && !current.isBlank())
                    ? (ObjectNode) om.readTree(current)
                    : om.createObjectNode();
            if (proposedSalary != null) {
                node.put(tutorId.toString(), proposedSalary.longValue());
            } else {
                node.putNull(tutorId.toString());
            }
            cls.setTutorProposals(om.writeValueAsString(node));
        } catch (Exception e) {
            log.warn("Cannot update tutorProposals JSON for class {}: {}", cls.getId(), e.getMessage());
        }
    }

    private BigDecimal resolveSalaryFromLevelFees(ClassEntity cls, UUID tutorId) {
        return resolveLevelFeesField(cls, tutorId, "fee");
    }

    private BigDecimal resolveParentFeeFromLevelFees(ClassEntity cls, UUID tutorId) {
        return resolveLevelFeesField(cls, tutorId, "fee");
    }

    /** Generic: đọc 1 field từ entry match́ trong levelFees JSON theo tutorType */
    private BigDecimal resolveLevelFeesField(ClassEntity cls, UUID tutorId, String field) {
        if (cls == null || cls.getLevelFees() == null) return null;
        TutorProfileEntity profile =
                tutorProfileRepository.findByUserId(tutorId).orElse(null);
        if (profile == null || profile.getTutorType() == null) return null;
        String displayName = profile.getTutorType().getDisplayName();
        try {
            ObjectMapper om = new ObjectMapper();
            List<JsonNode> nodes =
                    om.readValue(cls.getLevelFees(), new TypeReference<>() {});
            for (JsonNode node : nodes) {
                String level = node.has("level") ? node.get("level").asText() : "";
                if (level.equalsIgnoreCase(displayName) && node.has(field)) {
                    return BigDecimal.valueOf(node.get(field).asLong());
                }
            }
        } catch (Exception e) {
            log.warn("Cannot parse levelFees JSON for class {}: {}", cls.getId(), e.getMessage());
        }
        return null;
    }

    private ClassApplicationResponse buildResponse(
            ClassApplicationEntity app,
            ClassEntity cls,
            UserEntity tutor) {

        List<String> levelReqs = List.of();
        if (cls != null && cls.getLevelFees() != null) {
            try {
                ObjectMapper om = new ObjectMapper();
                List<JsonNode> nodes =
                        om.readValue(cls.getLevelFees(), new TypeReference<>() {});
                levelReqs = nodes.stream()
                        .map(n -> n.get("level").asText())
                        .collect(Collectors.toList());
            } catch (Exception e) {
                log.warn("Cannot parse levelFees for class {}: {}", cls.getId(), e.getMessage());
            }
        }

        // Tutor stats
        long activeClasses = 0;
        long pendingApps = 0;
        if (app.getTutorId() != null) {
            activeClasses = classRepository.countByTutorIdAndStatusAndIsDeletedFalse(
                    app.getTutorId(), ClassStatus.ACTIVE);
            pendingApps = applicationRepository.countByTutorIdAndStatus(
                    app.getTutorId(), ApplicationStatus.PENDING);
        }

        TutorProfileEntity tutorProfile = null;
        if (app.getTutorId() != null) {
            tutorProfile = tutorProfileRepository.findByUserId(app.getTutorId()).orElse(null);
        }

        String parentPhone = null;
        if (cls != null && cls.getParentId() != null) {
            parentPhone = userRepository.findById(cls.getParentId())
                    .map(UserEntity::getPhone)
                    .orElse(null);
        }

        return ClassApplicationResponse.builder()
                .applicationId(app.getId())
                .classId(app.getClassId())
                .classTitle(cls != null ? cls.getTitle() : null)
                .classCode(cls != null ? cls.getClassCode() : null)
                .isMockClass(cls != null ? cls.getIsMock() : null)
                .description(cls != null ? cls.getDescription() : null)
                .subject(cls != null ? cls.getSubject() : null)
                .grade(cls != null ? cls.getGrade() : null)
                .location(cls != null ? (cls.getMode() == ClassMode.ONLINE ? "Online" : cls.getAddress()) : null)
                .timeFrame(cls != null ? cls.getTimeFrame() : null)
                .schedule(cls != null ? cls.getSchedule() : null)
                .sessionsPerWeek(cls != null ? cls.getSessionsPerWeek() : null)
                .sessionDurationMin(cls != null ? cls.getSessionDurationMin() : null)
                .studentCount(1) // Placeholder cho đến khi có danh sách học sinh
                .genderRequirement(cls != null ? cls.getGenderRequirement() : null)
                .levelFees(cls != null ? com.edtech.backend.tutor.enums.TutorType.sortLevelFeesJson(cls.getLevelFees()) : null)
                .tutorProposals(cls != null ? cls.getTutorProposals() : null)
                .feePercentage(cls != null ? cls.getFeePercentage() : null)
                .tutorLevelRequirement(levelReqs)
                .tutorId(app.getTutorId())
                .tutorName(tutor != null ? tutor.getFullName() : null)
                .tutorPhone(tutor != null ? tutor.getPhone() : null)
                .tutorType(tutorProfile != null && tutorProfile.getTutorType() != null ? tutorProfile.getTutorType().getDisplayName() : null)
                .dateOfBirth(tutorProfile != null ? tutorProfile.getDateOfBirth() : null)
                .achievements(tutorProfile != null ? tutorProfile.getAchievements() : null)
                .rating(tutorProfile != null ? tutorProfile.getRating() : null)
                .ratingCount(tutorProfile != null ? tutorProfile.getRatingCount() : null)
                .certBase64s(tutorProfile != null ? com.edtech.backend.core.util.ImageCompressUtil.decompressArray(tutorProfile.getCertBase64s()) : null)
                .tutorActiveClassesCount(activeClasses)
                .tutorPendingApplicationsCount(pendingApps)
                .parentPhone(parentPhone)
                .status(app.getStatus())
                .note(app.getNote())
                .proposedSalary(resolveProposedSalary(cls, app.getTutorId()))
                .appliedAt(app.getCreatedAt())
                .build();
    }

    /** Lấy mức lương admin đề xuất cho 1 gia sư từ JSON tutorProposals trên lớp */
    /** Lấy mức lương admin đề xuất cho 1 gia sư từ JSON tutorProposals trên lớp */
    private BigDecimal resolveProposedSalary(ClassEntity cls, UUID tutorId) {
        if (cls == null || cls.getTutorProposals() == null || tutorId == null) return null;
        try {
            TutorProfileEntity profile =
                    tutorProfileRepository.findByUserId(tutorId).orElse(null);
            if (profile == null || profile.getTutorType() == null) return null;
            String levelReq = profile.getTutorType().getDisplayName();

            ObjectMapper om = new ObjectMapper();
            List<JsonNode> nodes =
                    om.readValue(cls.getTutorProposals(), new TypeReference<>() {});
            for (JsonNode node : nodes) {
                if (node.has("level") && node.get("level").asText().equalsIgnoreCase(levelReq) && node.has("fee")) {
                    return BigDecimal.valueOf(node.get("fee").asLong());
                }
            }
        } catch (Exception e) {
            log.warn("Cannot parse tutorProposals for class {}: {}", cls.getId(), e.getMessage());
        }

        // Fallback: Thử đọc the map `<tutorId>: <salary>` dành cho dữ liệu cũ (Legacy)
        try {
            ObjectMapper om = new ObjectMapper();
            JsonNode node = om.readTree(cls.getTutorProposals());
            JsonNode entry = node.get(tutorId.toString());
            if (entry != null && !entry.isNull()) {
                return BigDecimal.valueOf(entry.asLong());
            }
        } catch (Exception e) {
            log.warn("Cannot parse legacy tutorProposals for class {}: {}", cls.getId(), e.getMessage());
        }
        return null;
    }

    /** Gửi notification cho tất cả admin */
    private void notifyAdmins(NotificationType type, String title, String body, String entityType, UUID entityId) {
        userRepository.findByRoleAndIsDeletedFalseOrderByCreatedAtDesc(UserRole.ADMIN)
                .forEach(admin -> notificationService.sendNotification(
                        admin.getId(), type, title, body, entityType, entityId));
    }
}
