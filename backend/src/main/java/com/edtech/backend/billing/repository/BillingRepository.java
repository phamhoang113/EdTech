package com.edtech.backend.billing.repository;

import com.edtech.backend.billing.entity.BillingEntity;
import com.edtech.backend.billing.enums.BillingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.Modifying;

import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
@Repository
public interface BillingRepository extends JpaRepository<BillingEntity, UUID>, JpaSpecificationExecutor<BillingEntity> {

    @Modifying
    @Query("UPDATE BillingEntity b SET b.parent = :newParent WHERE b.parent.id = :studentId")
    void migrateParent(@Param("studentId") UUID studentId, @Param("newParent") com.edtech.backend.auth.entity.UserEntity newParent);

    @Query("SELECT COUNT(b) FROM BillingEntity b JOIN b.cls c JOIN c.students s WHERE s.id = :studentId AND b.status IN (:statuses)")
    long countUnpaidByStudentId(@Param("studentId") UUID studentId, @Param("statuses") List<BillingStatus> statuses);
    
    List<BillingEntity> findByParentIdOrderByYearDescMonthDesc(UUID parentId);
    
    long countByParentIdAndStatus(UUID parentId, BillingStatus status);

    long countByStatus(BillingStatus status);
    
    List<BillingEntity> findByStatusOrderByCreatedAtDesc(BillingStatus status);
    
    @Query("SELECT b FROM BillingEntity b WHERE b.parent.id = :parentId AND (:status IS NULL OR b.status = :status) ORDER BY b.year DESC, b.month DESC")
    List<BillingEntity> findByParentIdAndOptionalStatus(@Param("parentId") UUID parentId, @Param("status") BillingStatus status);

    boolean existsByClsIdAndMonthAndYear(UUID clsId, Integer month, Integer year);

    List<BillingEntity> findByTransactionCode(String transactionCode);

    List<BillingEntity> findAllByOrderByCreatedAtDesc();

    List<BillingEntity> findByStatusAndMonthAndYear(BillingStatus status, Integer month, Integer year);
}
