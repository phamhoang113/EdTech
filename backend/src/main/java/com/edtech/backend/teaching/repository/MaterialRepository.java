package com.edtech.backend.teaching.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.edtech.backend.teaching.entity.MaterialEntity;

public interface MaterialRepository extends JpaRepository<MaterialEntity, UUID> {

    List<MaterialEntity> findByClassIdAndIsDeletedFalseOrderByCreatedAtDesc(UUID classId);
}
