package com.edtech.backend.tutor.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.edtech.backend.tutor.entity.TutorProfileEntity;
import com.edtech.backend.tutor.enums.VerificationStatus;

@Repository
public interface TutorProfileRepository extends JpaRepository<TutorProfileEntity, UUID> {
    Optional<TutorProfileEntity> findByUserId(UUID userId);
    long countByVerificationStatus(VerificationStatus status);
    Page<TutorProfileEntity> findByVerificationStatus(VerificationStatus status, Pageable pageable);

    @Query("SELECT p FROM TutorProfileEntity p WHERE p.verificationStatus = :status AND (:includeMock = true OR p.isMock = false) ORDER BY p.rating DESC, p.ratingCount DESC")
    Page<TutorProfileEntity> findPublicProfiles(@Param("status") VerificationStatus status, @Param("includeMock") boolean includeMock, Pageable pageable);
}
