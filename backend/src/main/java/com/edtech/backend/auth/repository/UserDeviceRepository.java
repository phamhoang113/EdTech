package com.edtech.backend.auth.repository;

import com.edtech.backend.auth.entity.UserDeviceEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserDeviceRepository extends JpaRepository<UserDeviceEntity, UUID> {
    Optional<UserDeviceEntity> findByFcmToken(String fcmToken);
}
