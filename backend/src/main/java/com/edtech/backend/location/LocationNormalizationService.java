package com.edtech.backend.location;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class LocationNormalizationService {

    private final ProvinceRepository provinceRepository;
    private final WardRepository wardRepository;

    /**
     * Tries to normalize the location finding exact codes.
     */
    public LocationNormalizationResponse normalize(LocationNormalizationRequest request) {
        LocationNormalizationResponse.LocationNormalizationResponseBuilder responseBuilder = LocationNormalizationResponse.builder()
                .normalizedAddress(request.getRawAddress())
                .latitude(request.getLatitude())
                .longitude(request.getLongitude());

        if (request.getProvinceName() == null || request.getProvinceName().isBlank()) {
            return responseBuilder.build();
        }

        // Try to find province
        String searchProvince = cleanName(request.getProvinceName());
        Optional<Province> provinceOpt = provinceRepository.findByNameContainingIgnoreCase(searchProvince);
        
        if (provinceOpt.isEmpty()) {
            // Can't find province, return early
            return responseBuilder.build();
        }

        Province province = provinceOpt.get();
        responseBuilder.provinceCode(province.getCode());

        if (request.getWardName() == null || request.getWardName().isBlank()) {
            return responseBuilder.build();
        }

        String searchWard = cleanName(request.getWardName());
        
        // Find ward directly in database
        Optional<Ward> directWardOpt = wardRepository.findByNameContainingIgnoreCaseAndProvinceCode(searchWard, province.getCode());
        if (directWardOpt.isPresent()) {
            responseBuilder.wardCode(directWardOpt.get().getCode());
            responseBuilder.newWardName(directWardOpt.get().getName());
            return responseBuilder.build();
        }

        return responseBuilder.build();
    }

    private String cleanName(String name) {
        // Remove common prefixes to improve search matching
        name = name.toLowerCase();
        name = name.replace("tỉnh", "")
                   .replace("thành phố", "")
                   .replace("phường", "")
                   .replace("xã", "")
                   .replace("thị trấn", "")
                   .trim();
        return name;
    }
}
