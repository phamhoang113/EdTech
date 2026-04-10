package com.edtech.backend.lead.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.edtech.backend.lead.entity.ContactMessageEntity;

@Repository
public interface ContactMessageRepository extends JpaRepository<ContactMessageEntity, UUID> {

    List<ContactMessageEntity> findAllByOrderByCreatedAtDesc();

    long countByIsReadFalse();
}
