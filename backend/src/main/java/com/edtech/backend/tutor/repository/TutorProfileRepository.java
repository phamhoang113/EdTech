package com.edtech.backend.tutor.repository;

import com.edtech.backend.tutor.entity.TutorProfileEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface TutorProfileRepository extends JpaRepository<TutorProfileEntity, UUID> {
    Optional<TutorProfileEntity> findByUserId(UUID userId);
}
