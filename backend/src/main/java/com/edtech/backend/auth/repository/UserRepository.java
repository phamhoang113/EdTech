package com.edtech.backend.auth.repository;

import com.edtech.backend.auth.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    Optional<User> findByPhoneAndIsDeletedFalse(String phone);
    Optional<User> findByUsernameAndIsDeletedFalse(String username);
    boolean existsByPhoneAndIsDeletedFalse(String phone);
    boolean existsByUsernameAndIsDeletedFalse(String username);
}
