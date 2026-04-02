package com.edtech.backend.admin.service;

import com.edtech.backend.admin.dto.AdminClassListItem;
import com.edtech.backend.admin.dto.AdminClassScheduleStatsDTO;
import com.edtech.backend.admin.dto.CreateClassRequest;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.ApplicationStatus;
import com.edtech.backend.cls.enums.ClassMode;
import com.edtech.backend.cls.enums.ClassStatus;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.enums.SessionType;
import com.edtech.backend.cls.repository.ClassApplicationRepository;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.cls.repository.SessionRepository;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.repository.TutorProfileRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminClassService {

    private static final String ERR_CLASS_NOT_FOUND = "Không tìm thấy lớp học.";
    private static final String ERR_PARENT_NOT_FOUND = "Không tìm thấy phụ huynh.";
    private static final String ERR_INVALID_TRANSITION = "Không thể chuyển từ %s sang %s.";
    private static final String ERR_NOT_PENDING = "Lớp không ở trạng thái chờ duyệt.";
    private static final String DEFAULT_GENDER_REQ = "Không yêu cầu";
    private static final String DEFAULT_SCHEDULE = "[]";
    private static final int DEFAULT_FEE_PERCENT = 30;
    private static final int SEARCH_DEADLINE_MONTHS = 1;

    private final ClassRepository classRepository;
    private final UserRepository userRepository;
    private final TutorProfileRepository tutorProfileRepository;
    private final ClassApplicationRepository applicationRepository;
    private final SessionRepository sessionRepository;

    // ─── Statistics ───────────────────────────────────────────────────────────

    public Map<String, Long> getClassStats() {
        long open      = classRepository.countByStatusAndIsDeletedFalse(ClassStatus.OPEN);
        long active    = classRepository.countByStatusAndIsDeletedFalse(ClassStatus.ACTIVE);
        long completed = classRepository.countByStatusAndIsDeletedFalse(ClassStatus.COMPLETED);
        long cancelled = classRepository.countByStatusAndIsDeletedFalse(ClassStatus.CANCELLED);
        return Map.of(
                "total",     open + active + completed + cancelled,
                "open",      open,
                "active",    active,
                "completed", completed,
                "cancelled", cancelled
        );
    }

    // ─── List ─────────────────────────────────────────────────────────────────

    /** Lấy tất cả lớp (hoặc lọc theo status) */
    public List<AdminClassListItem> getAllClasses(ClassStatus status) {
        List<ClassEntity> entities = (status != null)
                ? classRepository.findByStatusAndIsDeletedFalse(status)
                : classRepository.findByIsDeletedFalseOrderByCreatedAtDesc();

        if (entities.isEmpty()) return new ArrayList<>();

        // Batch load users
        List<UUID> parentIds = entities.stream().map(ClassEntity::getParentId).distinct().collect(Collectors.toList());
        List<UUID> tutorIds  = entities.stream().filter(e -> e.getTutorId() != null).map(ClassEntity::getTutorId).distinct().collect(Collectors.toList());
        List<UUID> allIds = new ArrayList<>(parentIds);
        allIds.addAll(tutorIds);

        Map<UUID, UserEntity> userMap = userRepository.findAllById(allIds).stream()
                .collect(Collectors.toMap(UserEntity::getId, u -> u));
        Map<UUID, TutorProfileEntity> profileMap = tutorIds.isEmpty()
                ? Map.of()
                : tutorProfileRepository.findAll().stream()
                        .filter(p -> tutorIds.contains(p.getUserId()))
                        .collect(Collectors.toMap(TutorProfileEntity::getUserId, p -> p));

        // Group sessions by classId for ACTIVE classes to compute quotas
        List<UUID> activeClassIds = entities.stream()
                .filter(c -> c.getStatus() == ClassStatus.ACTIVE)
                .map(ClassEntity::getId)
                .collect(Collectors.toList());
        
        Map<UUID, List<SessionEntity>> sessionsByClass = activeClassIds.isEmpty() ? Map.of() : 
                sessionRepository.findByClsIdIn(activeClassIds).stream()
                .collect(Collectors.groupingBy(s -> s.getCls().getId()));

        LocalDate today = LocalDate.now();
        LocalDate targetMonday = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate targetSunday = targetMonday.plusDays(6);

        List<AdminClassListItem> result = new ArrayList<>();
        for (ClassEntity cls : entities) {
            UserEntity parent = userMap.get(cls.getParentId());
            UserEntity tutor  = cls.getTutorId() != null ? userMap.get(cls.getTutorId()) : null;
            TutorProfileEntity profile = tutor != null ? profileMap.get(tutor.getId()) : null;

            long pendingCount = applicationRepository.countByClassIdAndStatus(cls.getId(), ApplicationStatus.PENDING);

            long approvedCount = applicationRepository.countByClassIdAndStatus(cls.getId(), ApplicationStatus.APPROVED);
            boolean hasPendingProposals = approvedCount > 0
                    && cls.getTutorId() == null
                    && (cls.getStatus() == ClassStatus.OPEN || cls.getStatus() == ClassStatus.ASSIGNED);

            Integer missingSessionsThisWeek = 0;
            Integer pendingMakeupCount = 0;
            if (cls.getStatus() == ClassStatus.ACTIVE) {
                List<SessionEntity> classSessions = sessionsByClass.getOrDefault(cls.getId(), List.of());
                
                long _pending = classSessions.stream()
                        .filter(s -> s.getStatus().name().startsWith("CANCELLED") && Boolean.TRUE.equals(s.getRequiresMakeup()))
                        .filter(s -> classSessions.stream().noneMatch(o -> s.getId().equals(o.getMakeupForSessionId())))
                        .count();
                pendingMakeupCount = (int) _pending;
                
                long activeSessionsThisWeek = classSessions.stream()
                        .filter(s -> !s.getStatus().name().startsWith("CANCELLED"))
                        .filter(s -> !s.getSessionDate().isBefore(targetMonday) && !s.getSessionDate().isAfter(targetSunday))
                        .count();
                
                int sessionsPerWeek = cls.getSessionsPerWeek() != null ? cls.getSessionsPerWeek() : 0;
                
                if (cls.getLearningStartDate() == null || targetSunday.isBefore(cls.getLearningStartDate())) {
                    sessionsPerWeek = 0; // Chưa kết nối hoặc chưa đến tuần khai giảng -> không báo thiếu
                }

                missingSessionsThisWeek = Math.max(0, sessionsPerWeek - (int) activeSessionsThisWeek);
            }

            result.add(AdminClassListItem.builder()
                    .id(cls.getId())
                    .classCode(cls.getClassCode())
                    .isMock(cls.getIsMock())
                    .title(cls.getTitle())
                    .subject(cls.getSubject())
                    .grade(cls.getGrade())
                    .mode(cls.getMode() != null ? cls.getMode().name() : null)
                    .address(cls.getAddress())

                    .parentName(parent != null ? parent.getFullName() : null)
                    .parentPhone(parent != null ? parent.getPhone() : null)
                    .tutorName(tutor != null ? tutor.getFullName() : null)
                    .tutorPhone(tutor != null ? tutor.getPhone() : null)
                    .tutorType(profile != null && profile.getTutorType() != null ? profile.getTutorType().getDisplayName() : null)
                    .parentFee(cls.getParentFee())
                    .tutorFee(cls.getTutorFee())
                    .platformFee(cls.getPlatformFee())
                    .feePercentage(cls.getFeePercentage())
                    .sessionsPerWeek(cls.getSessionsPerWeek())
                    .sessionDurationMin(cls.getSessionDurationMin())
                    .timeFrame(cls.getTimeFrame())
                    .schedule(cls.getSchedule())
                    .genderRequirement(cls.getGenderRequirement())
                    .learningStartDate(cls.getLearningStartDate())
                    .levelFees(cls.getLevelFees())
                    .tutorProposals(cls.getTutorProposals())
                    .rejectionReason(cls.getRejectionReason())
                    .missingSessionsThisWeek(missingSessionsThisWeek)
                    .pendingMakeupCount(pendingMakeupCount)
                    .status(cls.getStatus())
                    .hasPendingProposals(hasPendingProposals)
                    .pendingApplicationCount(pendingCount)
                    .createdAt(cls.getCreatedAt())
                    .studentIds(cls.getStudents() != null ? cls.getStudents().stream().map(UserEntity::getId).toList() : List.of())
                    .build());
        }
        return result;
    }

    // ─── Create ───────────────────────────────────────────────────────────────

    @Transactional
    public AdminClassListItem createClass(CreateClassRequest request) {
        // Validate parent exists
        UserEntity parent = userRepository.findById(request.parentId())
                .orElseThrow(() -> new EntityNotFoundException(ERR_PARENT_NOT_FOUND));

        // Get admin id from security context
        UUID adminId = resolveAdminId();

        // Tính platform fee và tutor fee mặc định
        int feePercent = request.feePercentage() != null ? request.feePercentage() : DEFAULT_FEE_PERCENT;
        BigDecimal tutorFee = request.parentFee()
                .multiply(BigDecimal.valueOf(100 - feePercent))
                .divide(BigDecimal.valueOf(100));
        BigDecimal platformFee = request.parentFee().subtract(tutorFee);

        ClassEntity cls = ClassEntity.builder()
                .adminId(adminId)
                .parentId(request.parentId())
                .title(request.title())
                .subject(request.subject())
                .grade(request.grade())
                .mode(ClassMode.valueOf(request.mode().toUpperCase()))
                .address(request.address())

                .schedule(request.schedule() != null ? request.schedule() : DEFAULT_SCHEDULE)
                .sessionsPerWeek(request.sessionsPerWeek())
                .sessionDurationMin(request.sessionDurationMin())
                .timeFrame(request.timeFrame())
                .parentFee(request.parentFee())
                .tutorFee(tutorFee)
                .platformFee(platformFee)
                .feePercentage(feePercent)
                .levelFees(request.levelFees())
                .genderRequirement(request.genderRequirement() != null ? request.genderRequirement() : DEFAULT_GENDER_REQ)
                .startDate(request.startDate())
                .endDate(request.endDate())
                .status(ClassStatus.PENDING_APPROVAL)
                .isDeleted(false)
                .build();

        cls.setClassCode(generateClassCode());
        ClassEntity saved = classRepository.save(cls);
        log.info("[CREATE_CLASS_ON_BEHALF] adminId={}, classId={}, classCode={}", adminId, saved.getId(), saved.getClassCode());

        return buildSingleItem(saved, parent, null, null, 0L);
    }

    // ─── Update Status ────────────────────────────────────────────────────────

    @Transactional
    public void updateClassStatus(UUID classId, ClassStatus newStatus) {
        ClassEntity cls = findActiveClassOrThrow(classId);
        ClassStatus current = cls.getStatus();

        if (!isValidTransition(current, newStatus)) {
            throw new BusinessRuleException(
                    String.format(ERR_INVALID_TRANSITION, current, newStatus));
        }

        cls.setStatus(newStatus);
        classRepository.save(cls);
        log.info("[UPDATE_STATUS] classId={}, from={}, to={}", classId, current, newStatus);
    }

    // ─── Update Learning Start Date ──────────────────────────────────────────

    @Transactional
    public void updateLearningStartDate(UUID classId, LocalDate newStartDate) {
        ClassEntity cls = findActiveClassOrThrow(classId);
        cls.setLearningStartDate(newStartDate);
        classRepository.save(cls);
        log.info("[UPDATE_LEARNING_START_DATE] classId={}, newDate={}", classId, newStartDate);
    }

    // ─── Soft Delete ──────────────────────────────────────────────────────────

    @Transactional
    public void deleteClass(UUID classId) {
        ClassEntity cls = findActiveClassOrThrow(classId);
        cls.setIsDeleted(true);
        // Nếu lớp đang dạy (ACTIVE), coi như hủy - GS sẽ được thông báo ngoài luồng
        if (cls.getStatus() == ClassStatus.ACTIVE || cls.getStatus() == ClassStatus.OPEN) {
            cls.setTutorId(null);
            cls.setTutorFee(null);
            cls.setTutorProposals(null);
        }
        classRepository.save(cls);
        log.info("[DELETE_CLASS] classId={}", classId);
    }

    // ─── Private helpers ──────────────────────────────────────────────────────

    private ClassEntity findActiveClassOrThrow(UUID classId) {
        return classRepository.findById(classId)
                .filter(c -> !c.getIsDeleted())
                .orElseThrow(() -> new EntityNotFoundException(ERR_CLASS_NOT_FOUND));
    }

    private boolean isValidTransition(ClassStatus from, ClassStatus to) {
        return switch (from) {
            case OPEN   -> to == ClassStatus.ACTIVE || to == ClassStatus.CANCELLED;
            case ACTIVE -> to == ClassStatus.COMPLETED || to == ClassStatus.CANCELLED;
            default     -> false;
        };
    }

    private String generateClassCode() {
        String code;
        int attempts = 0;
        do {
            code = String.format("%06d", (int)(Math.random() * 900000) + 100000);
            attempts++;
        } while (attempts < 10); // simple - no uniqueness check needed for now
        return code;
    }

    private UUID resolveAdminId() {
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (principal instanceof UserEntity user) {
                return user.getId();
            }
        } catch (Exception e) {
            log.warn("Cannot resolve admin ID from security context: {}", e.getMessage());
        }
        return UUID.fromString("00000000-0000-0000-0000-000000000001"); // fallback
    }

    private AdminClassListItem buildSingleItem(ClassEntity cls, UserEntity parent, UserEntity tutor,
                                                TutorProfileEntity profile, long pendingCount) {
        return AdminClassListItem.builder()
                .id(cls.getId())
                .classCode(cls.getClassCode())
                .isMock(cls.getIsMock())
                .title(cls.getTitle())
                .subject(cls.getSubject())
                .grade(cls.getGrade())
                .mode(cls.getMode() != null ? cls.getMode().name() : null)
                .address(cls.getAddress())

                .parentName(parent != null ? parent.getFullName() : null)
                .parentPhone(parent != null ? parent.getPhone() : null)
                .tutorName(tutor != null ? tutor.getFullName() : null)
                .tutorPhone(tutor != null ? tutor.getPhone() : null)
                .tutorType(profile != null && profile.getTutorType() != null ? profile.getTutorType().getDisplayName() : null)
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
                .status(cls.getStatus())
                .pendingApplicationCount(pendingCount)
                .createdAt(cls.getCreatedAt())
                .studentIds(cls.getStudents() != null ? cls.getStudents().stream().map(UserEntity::getId).toList() : List.of())
                .build();
    }

    // ─── Class Request Approval ────────────────────────────────────────────────

    /** Admin duyệt yêu cầu mở lớp từ PH: PENDING_APPROVAL → OPEN.
     *  tutorFee = lương GS nhận hàng tháng (hiển thị cho GS).
     *  platformFee (TT giữ) = parentFee - tutorFee.
     *  feePercentage = % phí nhận lớp 1 lần dưới khi GS nhận lớp. */
    @Transactional
    public void approveClassRequest(UUID classId, BigDecimal tutorFee, String levelFees, String tutorProposals, Integer feePercentage) {
        ClassEntity cls = classRepository.findById(classId)
                .orElseThrow(() -> new EntityNotFoundException(ERR_CLASS_NOT_FOUND));

        if (cls.getStatus() != ClassStatus.PENDING_APPROVAL) {
            throw new BusinessRuleException(ERR_NOT_PENDING);
        }

        cls.setStatus(ClassStatus.OPEN);

        cls.setStartDate(LocalDate.now());
        cls.setEndDate(LocalDate.now().plusMonths(SEARCH_DEADLINE_MONTHS));

        // Lưu feePercentage (% phí nhận lớp 1 lần) nếu admin điền
        if (feePercentage != null && feePercentage > 0) {
            cls.setFeePercentage(feePercentage);
        }

        // Cập nhật levelFees nếu admin đã chỉnh sửa
        if (levelFees != null && !levelFees.isBlank()) {
            cls.setLevelFees(levelFees);
        }

        // Cập nhật mảng Lương TT Offer cho gia sư
        if (tutorProposals != null && !tutorProposals.isBlank()) {
            cls.setTutorProposals(tutorProposals);
        }

        /*
         * Theo luồng tiền mới (Fee Flow Update):
         * Cột cứng parentFee, tutorFee và platformFee sẽ được bảo toàn là ZERO trong giai đoạn này.
         * Điểm chốt duy nhất là lúc Phụ huynh chọn gia sư (ClassApplicationService.selectTutor), 
         * hệ thống mới bung JSON levelFees này ra để gán vào các cột tướng ứng.
         */

        classRepository.save(cls);
        log.info("[APPROVE_CLASS] classId={}", classId);
    }

    /** Admin từ chối yêu cầu mở lớp từ PH: PENDING_APPROVAL → CANCELLED */
    @Transactional
    public void rejectClassRequest(UUID classId, String reason) {
        ClassEntity cls = classRepository.findById(classId)
                .orElseThrow(() -> new EntityNotFoundException(ERR_CLASS_NOT_FOUND));

        if (cls.getStatus() != ClassStatus.PENDING_APPROVAL) {
            throw new BusinessRuleException(ERR_NOT_PENDING);
        }

        cls.setStatus(ClassStatus.CANCELLED);
        // Lưu lý do từ chối nếu entity có field
        if (reason != null && !reason.isBlank()) {
            cls.setRejectionReason(reason);
        }
        classRepository.save(cls);
        log.info("[REJECT_CLASS] classId={}, reason={}", classId, reason);
    }

    // ─── Schedule Stats ───────────────────────────────────────────────────────

    public AdminClassScheduleStatsDTO getScheduleStats(UUID classId) {
        findActiveClassOrThrow(classId);
        List<SessionEntity> sessions = sessionRepository.findByClsId(classId, Sort.unsorted());
        
        int total = 0, completed = 0, upcoming = 0;
        int regular = 0, makeup = 0, extra = 0;
        int cancelled = 0, pendingMakeup = 0;
        
        for (var s : sessions) {
            total++;
            var status = s.getStatus();
            var type = s.getSessionType();
            
            if (status == SessionStatus.COMPLETED) completed++;
            else if (status == SessionStatus.SCHEDULED || status == SessionStatus.LIVE) upcoming++;
            else if (status.name().startsWith("CANCELLED")) {
                cancelled++;
                if (Boolean.TRUE.equals(s.getRequiresMakeup())) {
                    boolean hasMakeup = sessions.stream().anyMatch(other -> s.getId().equals(other.getMakeupForSessionId()));
                    if (!hasMakeup) {
                        pendingMakeup++;
                    }
                }
            }
            
            if (type == SessionType.REGULAR) regular++;
            else if (type == SessionType.MAKEUP) makeup++;
            else if (type == SessionType.EXTRA) extra++;;
        }
        
        return AdminClassScheduleStatsDTO.builder()
                .totalSessions(total)
                .completedSessions(completed)
                .upcomingSessions(upcoming)
                .regularCount(regular)
                .makeupCount(makeup)
                .extraCount(extra)
                .cancelledCount(cancelled)
                .pendingMakeupCount(pendingMakeup)
                .build();
    }
}
