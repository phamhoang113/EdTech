package com.edtech.backend.billing.repository;

import com.edtech.backend.billing.entity.TutorPayoutEntity;
import com.edtech.backend.billing.enums.TutorPayoutStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
@Repository
public interface TutorPayoutRepository extends JpaRepository<TutorPayoutEntity, UUID>, JpaSpecificationExecutor<TutorPayoutEntity> {
    
    List<TutorPayoutEntity> findByTutorIdOrderByCreatedAtDesc(UUID tutorId);

    List<TutorPayoutEntity> findByStatusOrderByCreatedAtDesc(TutorPayoutStatus status);

    List<TutorPayoutEntity> findAllByOrderByCreatedAtDesc();

    List<TutorPayoutEntity> findByBillingIdIn(List<UUID> billingIds);

    boolean existsByBillingId(UUID billingId);
}
