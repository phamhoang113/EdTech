package com.edtech.backend.tutor.repository;

import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.enums.VerificationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface TutorProfileRepository extends JpaRepository<TutorProfileEntity, UUID> {
    Optional<TutorProfileEntity> findByUserId(UUID userId);
    long countByVerificationStatus(VerificationStatus status);
    org.springframework.data.domain.Page<TutorProfileEntity> findByVerificationStatus(VerificationStatus status, org.springframework.data.domain.Pageable pageable);

    @org.springframework.data.jpa.repository.Query("SELECT p FROM TutorProfileEntity p WHERE p.verificationStatus = :status AND (:includeMock = true OR p.isMock = false) ORDER BY p.isMock ASC, p.rating DESC, p.ratingCount DESC")
    org.springframework.data.domain.Page<TutorProfileEntity> findPublicProfiles(@org.springframework.data.repository.query.Param("status") VerificationStatus status, @org.springframework.data.repository.query.Param("includeMock") boolean includeMock, org.springframework.data.domain.Pageable pageable);
}
