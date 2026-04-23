package com.edtech.backend.auth.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.edtech.backend.auth.entity.UserLinkedProviderEntity;
import com.edtech.backend.auth.enums.AuthProvider;

@Repository
public interface UserLinkedProviderRepository extends JpaRepository<UserLinkedProviderEntity, UUID> {

    Optional<UserLinkedProviderEntity> findByProviderAndProviderEmail(AuthProvider provider, String providerEmail);

    List<UserLinkedProviderEntity> findByUserId(UUID userId);

    boolean existsByProviderAndProviderEmail(AuthProvider provider, String providerEmail);

    void deleteByUserIdAndProvider(UUID userId, AuthProvider provider);

    Optional<UserLinkedProviderEntity> findByUserIdAndProvider(UUID userId, AuthProvider provider);
}
