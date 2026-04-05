package com.edtech.backend.notification.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.edtech.backend.notification.entity.UserPushTokenEntity;

@Repository
public interface UserPushTokenRepository extends JpaRepository<UserPushTokenEntity, UUID> {

    List<UserPushTokenEntity> findByUserId(UUID userId);

    boolean existsByToken(String token);

    void deleteByToken(String token);

    void deleteByUserId(UUID userId);
}
