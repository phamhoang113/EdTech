package com.edtech.backend.location;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProvinceRepository extends JpaRepository<Province, String> {
    java.util.Optional<Province> findByNameContainingIgnoreCase(String name);
}
