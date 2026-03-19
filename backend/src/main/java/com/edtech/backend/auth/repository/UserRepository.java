package com.edtech.backend.auth.repository;

import com.edtech.backend.auth.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, UUID> {
    Optional<UserEntity> findByPhoneAndIsDeletedFalse(String phone);
    boolean existsByPhoneAndIsDeletedFalse(String phone);
}
