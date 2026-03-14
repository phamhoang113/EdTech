package com.edtech.backend.auth.repository;

import com.edtech.backend.auth.entity.OtpCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface OtpCodeRepository extends JpaRepository<OtpCode, UUID> {
    Optional<OtpCode> findTopByPhoneAndPurposeAndIsUsedFalseOrderByCreatedAtDesc(String phone, String purpose);
}
