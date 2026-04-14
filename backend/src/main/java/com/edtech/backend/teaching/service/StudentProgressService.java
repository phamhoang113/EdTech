package com.edtech.backend.teaching.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.student.entity.StudentProfileEntity;
import com.edtech.backend.student.repository.StudentProfileRepository;
import com.edtech.backend.teaching.dto.response.StudentProgressResponse;
import com.edtech.backend.teaching.entity.AssessmentEntity;
import com.edtech.backend.teaching.entity.SubmissionEntity;
import com.edtech.backend.teaching.repository.AssessmentRepository;
import com.edtech.backend.teaching.repository.SubmissionRepository;

/**
 * Service tính tiến độ học tập của HS trong 1 lớp.
 * PH sẽ gọi API này để theo dõi con em.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class StudentProgressService {

    private final AssessmentRepository assessmentRepository;
    private final SubmissionRepository submissionRepository;
    private final ClassRepository classRepository;
    private final StudentProfileRepository studentProfileRepository;

    /**
     * Lấy tiến độ tất cả BT/KT của 1 lớp cho PH (userId = parentId).
     * Tìm studentId từ parentId → lấy submissions.
     */
    public List<StudentProgressResponse> getClassProgress(UUID classId, UUID parentId) {
        ClassEntity classEntity = classRepository.findById(classId)
                .orElseThrow(() -> new EntityNotFoundException("Class not found"));

        // Tìm student thuộc parent này
        UUID studentId = findStudentIdForParent(parentId, classId);

        // Lấy tất cả assessments của lớp
        List<AssessmentEntity> assessments =
                assessmentRepository.findByClassIdAndIsDeletedFalseOrderByCreatedAtDesc(classId);

        // Lấy submissions của student
        Map<UUID, SubmissionEntity> submissionMap =
                submissionRepository.findByClassIdAndStudentId(classId, studentId)
                        .stream()
                        .collect(Collectors.toMap(SubmissionEntity::getAssessmentId, Function.identity(), (a, b) -> a));

        List<StudentProgressResponse> progressList = new ArrayList<>();

        for (AssessmentEntity assessment : assessments) {
            if (!assessment.getIsPublished()) continue;

            SubmissionEntity submission = submissionMap.get(assessment.getId());

            StudentProgressResponse.StudentProgressResponseBuilder builder = StudentProgressResponse.builder()
                    .assessmentId(assessment.getId().toString())
                    .assessmentTitle(assessment.getTitle())
                    .type(assessment.getType().name())
                    .totalScore(assessment.getTotalScore() != null ? assessment.getTotalScore().doubleValue() : null)
                    .closesAt(assessment.getClosesAt() != null ? assessment.getClosesAt().toString() : null);

            if (submission != null) {
                builder.status(submission.getStatus().name())
                       .score(submission.getTotalScore() != null ? submission.getTotalScore().doubleValue() : null)
                       .tutorComment(submission.getTutorComment())
                       .submittedAt(submission.getSubmittedAt() != null ? submission.getSubmittedAt().toString() : null)
                       .gradedAt(submission.getGradedAt() != null ? submission.getGradedAt().toString() : null);
            } else {
                builder.status("PENDING");
            }

            progressList.add(builder.build());
        }

        return progressList;
    }

    private UUID findStudentIdForParent(UUID parentId, UUID classId) {
        // ClassEntity has parentId — student is linked through parent
        List<StudentProfileEntity> students = studentProfileRepository.findByParentIdAndNotDeleted(parentId);
        if (students.isEmpty()) {
            throw new EntityNotFoundException("Không tìm thấy học sinh.");
        }
        // Return first student (thường PH có 1 HS)
        return students.get(0).getUser().getId();
    }
}
