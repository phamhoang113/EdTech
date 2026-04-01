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
import com.edtech.backend.cls.repository.SessionRepository;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.entity.SystemSettingEntity;
import com.edtech.backend.core.repository.SystemSettingRepository;
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
public class StudentBillingService {

    private final BillingRepository billingRepository;
    private final SessionRepository sessionRepository;
    private final UserRepository userRepository;
    private final SystemSettingRepository systemSettingRepository;

    @Transactional(readOnly = true)
    public List<BillingDTO> getBillingsForStudent(UUID studentId) {
        String bankBin = systemSettingRepository.findByKey("VIETQR_BANK_BIN").map(SystemSettingEntity::getValue).orElse("BIDV");
        String bankAccount = systemSettingRepository.findByKey("VIETQR_BANK_ACCOUNT").map(SystemSettingEntity::getValue).orElse("0976947441");
        String accountName = systemSettingRepository.findByKey("VIETQR_ACCOUNT_NAME").map(SystemSettingEntity::getValue).orElse("Pham Phu Hoang");
        // Remove spaces for url param just in case
        final String finalAccountName = accountName.replace(" ", "%20");

        // The studentId is stored in parentId column because the student is the payer
        return billingRepository.findByParentIdOrderByYearDescMonthDesc(studentId)
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
    public void confirmTransfer(UUID studentId, UUID billingId) {
        BillingEntity billing = billingRepository.findById(billingId)
            .orElseThrow(() -> new EntityNotFoundException("Không tìm thấy hoá đơn"));
        if (!billing.getParent().getId().equals(studentId)) {
            throw new BusinessRuleException("Hoá đơn này không thuộc về bạn");
        }
        if (billing.getStatus() != BillingStatus.UNPAID) {
            throw new BusinessRuleException("Trạng thái không hợp lệ. Chỉ có thể xác nhận hoá đơn chưa thanh toán.");
        }
        billing.setStatus(BillingStatus.VERIFYING);
        billingRepository.save(billing);
    }
}
