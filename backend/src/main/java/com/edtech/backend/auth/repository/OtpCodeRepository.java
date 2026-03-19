package com.edtech.backend.auth.repository;

import com.edtech.backend.auth.entity.OtpCodeEntity;
import com.edtech.backend.auth.enums.OtpPurpose;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface OtpCodeRepository extends JpaRepository<OtpCodeEntity, UUID> {

    /** Verify by otpToken (UUID trả cho client sau register) + not used yet */
    Optional<OtpCodeEntity> findByOtpTokenAndIsUsedFalse(UUID otpToken);

    /** Cleanup: kiểm tra xem OTP active còn tồn tại cho phone chưa */
    Optional<OtpCodeEntity> findTopByPhoneAndPurposeAndIsUsedFalseOrderByCreatedAtDesc(String phone, OtpPurpose purpose);
}
