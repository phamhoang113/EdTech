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
import com.edtech.backend.teaching.dto.response.SubmissionResponse;
import com.edtech.backend.teaching.entity.AssessmentEntity;
import com.edtech.backend.teaching.entity.SubmissionEntity;
import com.edtech.backend.teaching.enums.SubmissionStatus;
import com.edtech.backend.teaching.repository.AssessmentRepository;
import com.edtech.backend.teaching.repository.SubmissionRepository;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.cls.repository.ClassRepository;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SubmissionService {

    private final SubmissionRepository submissionRepository;
    private final AssessmentRepository assessmentRepository;
    private final FileStorageService fileStorageService;
    private final NotificationService notificationService;
    private final UserRepository userRepository;
    private final ClassRepository classRepository;

    /**
     * HS nộp bài (upload file).
     */
    @Transactional
    public SubmissionResponse submit(UUID assessmentId, UUID studentId, List<MultipartFile> files, MultipartFile file) {
        AssessmentEntity assessment = assessmentRepository.findById(assessmentId)
                .filter(a -> !a.getIsDeleted() && a.getIsPublished())
                .orElseThrow(() -> new EntityNotFoundException("Bài tập không tồn tại hoặc chưa được publish."));

        // Kiểm tra deadline (cho HOMEWORK)
        if (assessment.getClosesAt() != null && Instant.now().isAfter(assessment.getClosesAt())) {
            throw new BusinessRuleException("Đã quá hạn nộp bài.");
        }

        // Kiểm tra đã nộp chưa (1 HS chỉ nộp 1 lần / assessment)
        submissionRepository.findByAssessmentIdAndStudentId(assessmentId, studentId)
                .ifPresent(existing -> {
                    throw new BusinessRuleException("Bạn đã nộp bài này rồi.");
                });

        List<MultipartFile> allFiles = new java.util.ArrayList<>();
        if (files != null) allFiles.addAll(files);
        if (file != null) allFiles.add(file);

        List<com.edtech.backend.teaching.entity.AttachmentInfo> attachments = new java.util.ArrayList<>();
        String folder = "submissions/" + assessmentId + "/" + studentId;

        for (MultipartFile f : allFiles) {
            if (f != null && !f.isEmpty()) {
                String storedPath = fileStorageService.store(f, folder);
                attachments.add(com.edtech.backend.teaching.entity.AttachmentInfo.builder()
                        .fileUrl(storedPath)
                        .fileName(f.getOriginalFilename())
                        .fileSize(f.getSize())
                        .build());
            }
        }

        SubmissionEntity entity = SubmissionEntity.builder()
                .assessmentId(assessmentId)
                .studentId(studentId)
                .status(SubmissionStatus.SUBMITTED)
                .fileUrl(attachments.isEmpty() ? null : attachments.get(0).getFileUrl())
                .fileName(attachments.isEmpty() ? null : attachments.get(0).getFileName())
                .fileSize(attachments.isEmpty() ? null : attachments.get(0).getFileSize())
                .studentAttachments(attachments)
                .submittedAt(Instant.now())
                .lastInteractionAt(Instant.now())
                .build();

        entity = submissionRepository.save(entity);

        // Notify GS
        notificationService.sendNotification(
                assessment.getCreatedBy(), NotificationType.HOMEWORK_SUBMITTED,
                "Học sinh nộp bài: " + assessment.getTitle(),
                "Có bài nộp mới cho bài tập \"" + assessment.getTitle() + "\".",
                "SUBMISSION", entity.getId());

        log.info("Submission created: assessmentId={}, studentId={}", assessmentId, studentId);
        return SubmissionResponse.from(entity);
    }

    /**
     * GS xem tất cả bài nộp của 1 assessment.
     */
    public List<SubmissionResponse> listByAssessment(UUID assessmentId) {
        AssessmentEntity assessment = assessmentRepository.findById(assessmentId)
                .orElseThrow(() -> new EntityNotFoundException("Assessment not found"));
        
        List<SubmissionEntity> submitted = submissionRepository.findByAssessmentIdOrderBySubmittedAtDesc(assessmentId);
        
        com.edtech.backend.cls.entity.ClassEntity cls = classRepository.findById(assessment.getClassId())
                .orElseThrow(() -> new EntityNotFoundException("Class not found"));

        List<SubmissionResponse> result = new java.util.ArrayList<>();
        java.util.Set<UUID> submittedStudentIds = submitted.stream()
                .map(SubmissionEntity::getStudentId)
                .collect(java.util.stream.Collectors.toSet());
        
        // Add submitted ones with student name
        for (SubmissionEntity sub : submitted) {
            String studentName = userRepository.findById(sub.getStudentId())
                    .map(com.edtech.backend.auth.entity.UserEntity::getFullName)
                    .orElse("Unknown");
            SubmissionResponse res = SubmissionResponse.from(sub);
            try {
                java.lang.reflect.Field nameField = SubmissionResponse.class.getDeclaredField("studentName");
                nameField.setAccessible(true);
                nameField.set(res, studentName);
            } catch (Exception e) {}
            result.add(res);
        }
        
        // Add draft ones for students who haven't submitted yet
        for (com.edtech.backend.auth.entity.UserEntity student : cls.getStudents()) {
            if (!submittedStudentIds.contains(student.getId())) {
                SubmissionResponse draft = SubmissionResponse.builder()
                        .id(UUID.randomUUID()) // dummy id for React key mapping
                        .assessmentId(assessmentId)
                        .studentId(student.getId())
                        .studentName(student.getFullName())
                        .status(SubmissionStatus.DRAFT)
                        .build();
                result.add(draft);
            }
        }
        return result;
    }

    /**
     * HS xem bài nộp của mình trong 1 assessment (null nếu chưa nộp).
     */
    public SubmissionResponse getMySubmission(UUID assessmentId, UUID studentId) {
        return submissionRepository.findByAssessmentIdAndStudentId(assessmentId, studentId)
                .map(SubmissionResponse::from)
                .orElse(null);
    }

    /**
     * Chi tiêt 1 bài nộp.
     */
    public SubmissionResponse getDetail(UUID submissionId) {
        SubmissionEntity entity = findById(submissionId);
        return SubmissionResponse.from(entity);
    }

    /**
     * GS chấm điểm + upload file sửa bài.
     */
    @Transactional
    public SubmissionResponse grade(UUID submissionId, UUID tutorId,
                                     java.math.BigDecimal score, String comment,
                                     List<MultipartFile> tutorFiles, MultipartFile tutorFile) {
        SubmissionEntity entity = findById(submissionId);

        List<MultipartFile> allFiles = new java.util.ArrayList<>();
        if (tutorFiles != null) allFiles.addAll(tutorFiles);
        if (tutorFile != null) allFiles.add(tutorFile);

        List<com.edtech.backend.teaching.entity.AttachmentInfo> attachments = new java.util.ArrayList<>();
        String folder = "submissions/" + entity.getAssessmentId() + "/" + entity.getStudentId();

        for (MultipartFile f : allFiles) {
            if (f != null && !f.isEmpty()) {
                String storedPath = fileStorageService.store(f, folder);
                attachments.add(com.edtech.backend.teaching.entity.AttachmentInfo.builder()
                        .fileUrl(storedPath)
                        .fileName(f.getOriginalFilename())
                        .fileSize(f.getSize())
                        .build());
            }
        }
        
        if (!attachments.isEmpty()) {
            if (entity.getTutorAttachments() == null) {
                entity.setTutorAttachments(new java.util.ArrayList<>());
            }
            entity.getTutorAttachments().addAll(attachments);
            entity.setTutorFileUrl(entity.getTutorAttachments().get(0).getFileUrl());
            entity.setTutorFileName(entity.getTutorAttachments().get(0).getFileName());
        }

        entity.setTotalScore(score);
        entity.setTutorComment(comment);
        entity.setGradedAt(Instant.now());
        entity.setGradedBy(tutorId);
        entity.setStatus(SubmissionStatus.GRADED);
        entity.setLastInteractionAt(Instant.now());

        submissionRepository.save(entity);

        // Notify HS (và PH nếu có — caller sẽ xử lý)
        AssessmentEntity assessment = assessmentRepository.findById(entity.getAssessmentId()).orElse(null);
        String assessmentTitle = assessment != null ? assessment.getTitle() : "Bài tập";

        notificationService.sendNotification(
                entity.getStudentId(), NotificationType.SUBMISSION_GRADED,
                "Bài đã chấm: " + assessmentTitle,
                score != null ? "Điểm: " + score : "Gia sư đã sửa bài của bạn.",
                "SUBMISSION", submissionId);

        log.info("Submission graded: id={}, score={}", submissionId, score);
        return SubmissionResponse.from(entity);
    }

    /**
     * GS đánh dấu hoàn thành → bắt đầu countdown 7 ngày cleanup.
     */
    @Transactional
    public SubmissionResponse markComplete(UUID submissionId, UUID tutorId) {
        SubmissionEntity entity = findById(submissionId);

        entity.setStatus(SubmissionStatus.COMPLETED);
        entity.setCompletedAt(Instant.now());
        entity.setLastInteractionAt(Instant.now());

        submissionRepository.save(entity);
        log.info("Submission marked complete: id={}, cleanup in 7 days", submissionId);

        return SubmissionResponse.from(entity);
    }

    /**
     * Download file bài nộp (HS hoặc GS xem).
     */
    public Resource downloadSubmissionFile(UUID submissionId, String url) {
        SubmissionEntity entity = findById(submissionId);
        
        String targetUrl = url != null ? url : entity.getFileUrl();
        if (targetUrl == null) {
            throw new BusinessRuleException("Bài nộp này không có file.");
        }
        
        boolean valid = false;
        if (entity.getFileUrl() != null && entity.getFileUrl().equals(targetUrl)) valid = true;
        if (!valid && entity.getStudentAttachments() != null) {
            valid = entity.getStudentAttachments().stream().anyMatch(a -> a.getFileUrl().equals(targetUrl));
        }
        
        if (!valid) throw new BusinessRuleException("File không hợp lệ hoặc không thuộc bài nộp này.");
        return fileStorageService.loadAsResource(targetUrl);
    }

    /**
     * Download file sửa bài (GS upload cho HS).
     */
    public Resource downloadTutorFile(UUID submissionId, String url) {
        SubmissionEntity entity = findById(submissionId);
        
        String targetUrl = url != null ? url : entity.getTutorFileUrl();
        if (targetUrl == null) {
            throw new BusinessRuleException("Chưa có file sửa bài.");
        }
        
        boolean valid = false;
        if (entity.getTutorFileUrl() != null && entity.getTutorFileUrl().equals(targetUrl)) valid = true;
        if (!valid && entity.getTutorAttachments() != null) {
            valid = entity.getTutorAttachments().stream().anyMatch(a -> a.getFileUrl().equals(targetUrl));
        }
        
        if (!valid) throw new BusinessRuleException("File không hợp lệ hoặc không thuộc bài nộp này.");
        return fileStorageService.loadAsResource(targetUrl);
    }

    public SubmissionEntity findById(UUID id) {
        return submissionRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Bài nộp không tồn tại."));
    }
}
