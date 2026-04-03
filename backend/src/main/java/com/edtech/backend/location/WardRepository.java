package com.edtech.backend.location;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WardRepository extends JpaRepository<Ward, String> {
    List<Ward> findByProvinceCode(String provinceCode);
    Optional<Ward> findByNameContainingIgnoreCaseAndProvinceCode(String name, String provinceCode);
}
