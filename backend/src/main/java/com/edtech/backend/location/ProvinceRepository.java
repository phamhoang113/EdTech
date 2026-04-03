package com.edtech.backend.location;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProvinceRepository extends JpaRepository<Province, String> {
    Optional<Province> findByNameContainingIgnoreCase(String name);
}
