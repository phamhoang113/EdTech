package com.edtech.backend.tutor.repository;

import com.edtech.backend.core.enums.ClassStatus;
import com.edtech.backend.tutor.entity.ClassEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ClassRepository extends JpaRepository<ClassEntity, UUID> {
    List<ClassEntity> findByStatusAndIsDeletedFalseOrderByCreatedAtDesc(ClassStatus status);
}
