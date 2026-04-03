package com.edtech.backend.location;

import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.edtech.backend.core.dto.ApiResponse;

@RestController
@RequestMapping("/api/v1/locations")
@RequiredArgsConstructor
public class LocationController {

    private final ProvinceRepository provinceRepository;
    private final WardRepository wardRepository;
    private final LocationNormalizationService locationNormalizationService;

    @GetMapping("/provinces")
    public ResponseEntity<ApiResponse<List<Province>>> getProvinces() {
        return ResponseEntity.ok(ApiResponse.ok(provinceRepository.findAll()));
    }

    @GetMapping("/provinces/{provinceCode}/wards")
    public ResponseEntity<ApiResponse<List<Ward>>> getWardsByProvince(@PathVariable String provinceCode) {
        return ResponseEntity.ok(ApiResponse.ok(wardRepository.findByProvinceCode(provinceCode)));
    }

    @PostMapping("/normalize")
    public ResponseEntity<ApiResponse<LocationNormalizationResponse>> normalizeAddress(@RequestBody LocationNormalizationRequest request) {
        return ResponseEntity.ok(ApiResponse.ok(locationNormalizationService.normalize(request)));
    }
}
