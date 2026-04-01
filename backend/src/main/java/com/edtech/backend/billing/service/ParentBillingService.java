package com.edtech.backend.billing.service;

import com.edtech.backend.billing.dto.BillingDTO;
import com.edtech.backend.billing.dto.LearningReportClassDTO;
import com.edtech.backend.billing.entity.BillingEntity;
import com.edtech.backend.billing.enums.BillingStatus;
import com.edtech.backend.billing.repository.BillingRepository;
import com.edtech.backend.core.exception.BusinessRuleException;
import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.entity.ClassEntity;
import com.edtech.backend.cls.entity.SessionEntity;
import com.edtech.backend.cls.enums.SessionStatus;
import com.edtech.backend.cls.repository.ClassRepository;
import com.edtech.backend.cls.repository.SessionRepository;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.student.entity.StudentProfileEntity;
import com.edtech.backend.student.repository.StudentProfileRepository;
import com.edtech.backend.core.repository.SystemSettingRepository;
import com.edtech.backend.core.entity.SystemSettingEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
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
public class ParentBillingService {

    private final BillingRepository billingRepository;
    private final SessionRepository sessionRepository;
    private final ClassRepository classRepository;
    private final StudentProfileRepository studentProfileRepository;
    private final UserRepository userRepository;
    private final SystemSettingRepository systemSettingRepository;



    @Transactional(readOnly = true)
    public List<BillingDTO> getBillingsForParent(UUID parentId) {
        String bankBin = systemSettingRepository.findByKey("VIETQR_BANK_BIN").map(SystemSettingEntity::getValue).orElse("BIDV");
        String bankAccount = systemSettingRepository.findByKey("VIETQR_BANK_ACCOUNT").map(SystemSettingEntity::getValue).orElse("0976947441");
        String accountName = systemSettingRepository.findByKey("VIETQR_ACCOUNT_NAME").map(SystemSettingEntity::getValue).orElse("Pham Phu Hoang");
        // Remove spaces for url param just in case
        final String finalAccountName = accountName.replace(" ", "%20");

        return billingRepository.findByParentIdOrderByYearDescMonthDesc(parentId)
                .stream()
                .filter(b -> b.getStatus() != BillingStatus.DRAFT)
                .map(BillingDTO::fromEntity)
                .map(dto -> {
                    dto.setBeneficiaryBank(bankBin);
                    dto.setBeneficiaryAccount(bankAccount);
                    dto.setBeneficiaryName(accountName);

                    if (dto.getParentFeeAmount() != null && dto.getTransactionCode() != null) {
                        dto.setQrDataStr(String.format("https://img.vietqr.io/image/%s-%s-compact.jpg?amount=%s&addInfo=%s&accountName=%s",
                                bankBin, bankAccount,
                                dto.getParentFeeAmount().toBigInteger().toString(),
                                dto.getTransactionCode(),
                                finalAccountName));
                    }
                    return dto;
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public void confirmTransfer(UUID parentId, UUID billingId) {
        BillingEntity billing = billingRepository.findById(billingId)
            .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy hoá đơn"));
        if (!billing.getParent().getId().equals(parentId)) {
            throw new BusinessRuleException("Hoá đơn này không thuộc về bạn");
        }
        if (billing.getStatus() != BillingStatus.UNPAID) {
            throw new BusinessRuleException("Trạng thái không hợp lệ. Chỉ có thể xác nhận hoá đơn chưa thanh toán.");
        }
        billing.setStatus(BillingStatus.VERIFYING);
        billingRepository.save(billing);
    }

    @Transactional(readOnly = true)
    public List<LearningReportClassDTO> getLearningReport(UUID parentId, UUID studentId, String yearMonth) {
        // yearMonth format: "yyyy-MM"
        int year = Integer.parseInt(yearMonth.split("-")[0]);
        int month = Integer.parseInt(yearMonth.split("-")[1]);

        LocalDate startDate = LocalDate.of(year, month, 1);
        LocalDate endDate = startDate.with(TemporalAdjusters.lastDayOfMonth());

        // Nếu studentId != null, lấy các session của riêng học sinh đó. 
        // Nếu studentId == null, lấy toàn bộ của parentId
        List<SessionEntity> sessions;
        Sort sort = Sort.by(Sort.Direction.ASC, "sessionDate", "startTime");

        if (studentId != null) {
            sessions = sessionRepository.findByStudentIdAndDateBetween(studentId, startDate, endDate, sort);
        } else {
            sessions = sessionRepository.findByParentIdAndDateBetween(parentId, startDate, endDate, sort);
        }

        // Group by class
        Map<ClassEntity, List<SessionEntity>> classSessionsMap = sessions.stream()
                .collect(Collectors.groupingBy(SessionEntity::getCls));

        List<LearningReportClassDTO> reports = new ArrayList<>();

        for (Map.Entry<ClassEntity, List<SessionEntity>> entry : classSessionsMap.entrySet()) {
            ClassEntity cls = entry.getKey();
            List<SessionEntity> clsSessions = entry.getValue();

            int completed = 0;
            int cancelled = 0;
            for (SessionEntity s : clsSessions) {
                if (s.getStatus() == SessionStatus.COMPLETED || s.getStatus() == SessionStatus.COMPLETED_PENDING) {
                    completed++;
                } else if (s.getStatus() == SessionStatus.CANCELLED || s.getStatus() == SessionStatus.CANCELLED_BY_TUTOR || s.getStatus() == SessionStatus.CANCELLED_BY_STUDENT) {
                    cancelled++;
                }
            }

            int sessionsPerMonth = cls.getSessionsPerWeek() != null && cls.getSessionsPerWeek() > 0 
                ? cls.getSessionsPerWeek() * 4 : 4;

            BigDecimal estFee = BigDecimal.ZERO;
            if (cls.getParentFee() != null) {
                BigDecimal parentFeePerSession = cls.getParentFee().divide(BigDecimal.valueOf(sessionsPerMonth), 0, RoundingMode.HALF_UP);
                estFee = parentFeePerSession.multiply(BigDecimal.valueOf(completed));
            }

            String tutorName = cls.getTutorId() != null 
                    ? userRepository.findById(cls.getTutorId()).map(UserEntity::getFullName).orElse("Chưa gán")
                    : "Chưa gán";

            String studentName = "Chưa có";
            if (studentId != null) {
                studentName = userRepository.findById(studentId).map(UserEntity::getFullName).orElse("Chưa có");
            } else if (cls.getStudents() != null && !cls.getStudents().isEmpty()) {
                studentName = cls.getStudents().stream().map(UserEntity::getFullName).collect(Collectors.joining(", "));
            }

            reports.add(LearningReportClassDTO.builder()
                    .classId(cls.getId())
                    .classCode(cls.getClassCode())
                    .classTitle(cls.getTitle())
                    .subject(cls.getSubject())
                    .studentName(studentName)
                    .tutorName(tutorName)
                    .totalSessionsMonth(clsSessions.size())
                    .completedSessionsMonth(completed)
                    .cancelledSessionsMonth(cancelled)
                    .estimatedFeeMonth(estFee)
                    .sessionsMonth(clsSessions.stream().map(SessionDTO::fromEntity).collect(Collectors.toList()))
                    .build());
        }

        return reports;
    }
}
