package com.edtech.backend.location;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface WardRepository extends JpaRepository<Ward, String> {
    List<Ward> findByProvinceCode(String provinceCode);
    java.util.Optional<Ward> findByNameContainingIgnoreCaseAndProvinceCode(String name, String provinceCode);
}
