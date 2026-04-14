package com.edtech.backend.teaching.service;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.core.service.FileStorageService;
import com.edtech.backend.notification.entity.NotificationType;
import com.edtech.backend.notification.service.NotificationService;
import com.edtech.backend.teaching.dto.response.AssessmentResponse;
import com.edtech.backend.teaching.entity.AssessmentEntity;
import com.edtech.backend.teaching.enums.AssessmentType;
import com.edtech.backend.teaching.repository.AssessmentRepository;
import com.edtech.backend.teaching.repository.SubmissionRepository;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AssessmentService {

    private final AssessmentRepository assessmentRepository;
    private final SubmissionRepository submissionRepository;
    private final FileStorageService fileStorageService;
    private final NotificationService notificationService;
    private final com.edtech.backend.cls.repository.SessionRepository sessionRepository;
    private final com.edtech.backend.cls.repository.ClassRepository classRepository;

    /**
     * Tạo bài tập hoặc đề kiểm tra (GS).
     *
     * - HOMEWORK: chỉ cần closesAt (deadline)
     * - EXAM: bắt buộc opensAt + durationMin
     */
    @Transactional
    public AssessmentResponse createAssessment(UUID classId, UUID tutorId,
                                                String title, String description,
                                                AssessmentType type,
                                                Instant opensAt, Instant closesAt,
                                                Integer durationMin,
                                                MultipartFile file) {
        validateAssessmentInput(type, opensAt, closesAt, durationMin);

        AssessmentEntity entity = AssessmentEntity.builder()
                .classId(classId)
                .createdBy(tutorId)
                .title(title)
                .description(description)
                .type(type)
                .opensAt(type == AssessmentType.EXAM ? opensAt : Instant.now())
                .closesAt(closesAt)
                .durationMin(durationMin)
                .build();

        // Upload file đề (nếu có)
        if (file != null && !file.isEmpty()) {
            String folder = "assignments/" + classId + "/" + entity.getId();
            String storedPath = fileStorageService.store(file, folder);
            entity.setAttachmentUrl(storedPath);
            entity.setAttachmentName(file.getOriginalFilename());
        }

        entity = assessmentRepository.save(entity);
        log.info("Assessment created: type={}, classId={}, title={}", type, classId, title);

        // NẾU LÀ EXAM, GẮN VÀO CALENDAR LÀM 1 SESSION TYPE "EXTRA"
        if (type == AssessmentType.EXAM && opensAt != null && durationMin != null) {
            com.edtech.backend.cls.entity.ClassEntity cls = classRepository.findById(classId).orElse(null);
            if (cls != null) {
                java.time.LocalDate examDate = opensAt.atZone(java.time.ZoneId.of("Asia/Ho_Chi_Minh")).toLocalDate();
                java.time.LocalTime examStart = opensAt.atZone(java.time.ZoneId.of("Asia/Ho_Chi_Minh")).toLocalTime();
                java.time.LocalTime examEnd = examStart.plusMinutes(durationMin);

                com.edtech.backend.cls.entity.SessionEntity session = com.edtech.backend.cls.entity.SessionEntity.builder()
                        .cls(cls)
                        .sessionDate(examDate)
                        .startTime(examStart)
                        .endTime(examEnd)
                        .status(com.edtech.backend.cls.enums.SessionStatus.SCHEDULED)
                        .sessionType(com.edtech.backend.cls.enums.SessionType.EXTRA)
                        .tutorNote("Lịch Kiểm tra: " + title)
                        .requiresMakeup(false)
                        .build();

                sessionRepository.save(session);
                log.info("Lịch Kiểm Tra (EXAM Session) đã được tạo tự động cho lớp: {}", classId);
            }
        }

        return AssessmentResponse.from(entity);
    }

    /**
     * Publish bài tập/đề kiểm tra → gửi notification.
     */
    @Transactional
    public AssessmentResponse publish(UUID assessmentId, UUID tutorId,
                                      List<UUID> studentIds, List<UUID> parentIds) {
        AssessmentEntity entity = findById(assessmentId);

        if (!entity.getCreatedBy().equals(tutorId)) {
            throw new BusinessRuleException("Bạn không có quyền publish.");
        }

        entity.setIsPublished(true);
        assessmentRepository.save(entity);

        // Gửi notification
        NotificationType notifType = entity.getType() == AssessmentType.EXAM
                ? NotificationType.TEST_SCHEDULED
                : NotificationType.HOMEWORK_ASSIGNED;

        String notifTitle = entity.getType() == AssessmentType.EXAM
                ? "Đề kiểm tra mới: " + entity.getTitle()
                : "Bài tập mới: " + entity.getTitle();

        String notifBody = entity.getType() == AssessmentType.EXAM
                ? "Kiểm tra lúc " + entity.getOpensAt() + ", thời lượng " + entity.getDurationMin() + " phút."
                : "Deadline: " + entity.getClosesAt();

        // Tự động lấy danh sách học sinh và phụ huynh từ lớp học nếu frontend truyền mảng rỗng
        List<UUID> targetStudentIds = (studentIds == null) ? new java.util.ArrayList<>() : new java.util.ArrayList<>(studentIds);
        List<UUID> targetParentIds = (parentIds == null) ? new java.util.ArrayList<>() : new java.util.ArrayList<>(parentIds);

        if (targetStudentIds.isEmpty() || targetParentIds.isEmpty()) {
            com.edtech.backend.cls.entity.ClassEntity cls = classRepository.findById(entity.getClassId()).orElse(null);
            if (cls != null) {
                if (targetStudentIds.isEmpty()) {
                    cls.getStudents().forEach(s -> targetStudentIds.add(s.getId()));
                }
                if (targetParentIds.isEmpty() && cls.getParentId() != null) {
                    targetParentIds.add(cls.getParentId());
                }
            }
        }

        // Gửi cho HS
        for (UUID studentId : targetStudentIds) {
            notificationService.sendNotification(
                    studentId, notifType, notifTitle, notifBody, "ASSESSMENT", entity.getId());
        }

        // Gửi cho PH
        for (UUID parentId : targetParentIds) {
            notificationService.sendNotification(
                    parentId, notifType, notifTitle, notifBody, "ASSESSMENT", entity.getId());
        }

        log.info("Published assessment: id={}, notified {} students, {} parents",
                assessmentId, studentIds.size(), parentIds.size());

        return AssessmentResponse.from(entity);
    }

    /**
     * List bài tập/kiểm tra theo lớp (có thể filter theo type).
     */
    public List<AssessmentResponse> listByClass(UUID classId, AssessmentType type) {
        List<AssessmentEntity> entities;
        if (type != null) {
            entities = assessmentRepository.findByClassIdAndTypeAndIsDeletedFalseOrderByCreatedAtDesc(classId, type);
        } else {
            entities = assessmentRepository.findByClassIdAndIsDeletedFalseOrderByCreatedAtDesc(classId);
        }

        return entities.stream().map(entity -> {
            long submittedCount = submissionRepository.countByAssessmentIdAndStatusNot(
                    entity.getId(), com.edtech.backend.teaching.enums.SubmissionStatus.DRAFT);
            return AssessmentResponse.from(entity, submittedCount, 0);
        }).toList();
    }

    /**
     * Chi tiết 1 assessment.
     */
    public AssessmentResponse getDetail(UUID assessmentId) {
        AssessmentEntity entity = findById(assessmentId);
        return AssessmentResponse.from(entity);
    }

    /**
     * Download file đề bài.
     */
    public Resource downloadAttachment(UUID assessmentId) {
        AssessmentEntity entity = findById(assessmentId);
        if (entity.getAttachmentUrl() == null) {
            throw new BusinessRuleException("Bài tập này không có file đính kèm.");
        }
        
        // RÀNG BUỘC EXAM: Chưa đến giờ thì khóa!
        if (entity.getType() == AssessmentType.EXAM && entity.getOpensAt() != null) {
            if (Instant.now().isBefore(entity.getOpensAt())) {
                throw new BusinessRuleException("Chưa đến giờ làm bài kiểm tra. Bạn quay lại lúc " + entity.getOpensAt().atZone(java.time.ZoneId.of("Asia/Ho_Chi_Minh")).toLocalDateTime() + " nhé!");
            }
        }
        
        return fileStorageService.loadAsResource(entity.getAttachmentUrl());
    }

    /**
     * Soft delete assessment.
     */
    @Transactional
    public void deleteAssessment(UUID assessmentId, UUID tutorId) {
        AssessmentEntity entity = findById(assessmentId);
        if (!entity.getCreatedBy().equals(tutorId)) {
            throw new BusinessRuleException("Bạn không có quyền xóa.");
        }

        // Xóa file đề
        if (entity.getAttachmentUrl() != null) {
            fileStorageService.delete(entity.getAttachmentUrl());
        }

        entity.setIsDeleted(true);
        assessmentRepository.save(entity);
        log.info("Assessment soft-deleted: id={}", assessmentId);
    }

    public AssessmentEntity findById(UUID id) {
        return assessmentRepository.findById(id)
                .filter(a -> !a.getIsDeleted())
                .orElseThrow(() -> new EntityNotFoundException("Bài tập/kiểm tra không tồn tại."));
    }

    private void validateAssessmentInput(AssessmentType type, Instant opensAt,
                                          Instant closesAt, Integer durationMin) {
        if (type == AssessmentType.EXAM) {
            if (opensAt == null) {
                throw new BusinessRuleException("Kiểm tra phải có thời gian bắt đầu (opensAt).");
            }
            if (durationMin == null || durationMin <= 0) {
                throw new BusinessRuleException("Kiểm tra phải có thời lượng (durationMin > 0).");
            }
        }

        if (type == AssessmentType.HOMEWORK && closesAt == null) {
            throw new BusinessRuleException("Bài tập phải có deadline (closesAt).");
        }
    }
}
