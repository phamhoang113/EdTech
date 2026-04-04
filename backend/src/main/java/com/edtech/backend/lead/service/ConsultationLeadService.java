package com.edtech.backend.lead.service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import com.edtech.backend.core.exception.EntityNotFoundException;
import com.edtech.backend.lead.dto.ConsultationLeadRequest;
import com.edtech.backend.lead.dto.ConsultationLeadResponse;
import com.edtech.backend.lead.entity.ConsultationLeadEntity;
import com.edtech.backend.lead.repository.ConsultationLeadRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class ConsultationLeadService {

    private final ConsultationLeadRepository leadRepository;

    @Transactional
    public ConsultationLeadResponse createLead(ConsultationLeadRequest request) {
        log.info("Creating new consultation lead for {}", request.getName());
        ConsultationLeadEntity lead = ConsultationLeadEntity.builder()
                .name(request.getName())
                .phone(request.getPhone())
                .isContacted(false)
                .build();
        
        ConsultationLeadEntity saved = leadRepository.save(lead);
        return ConsultationLeadResponse.fromEntity(saved);
    }

    @Transactional(readOnly = true)
    public List<ConsultationLeadResponse> getAllLeads() {
        return leadRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(ConsultationLeadResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public ConsultationLeadResponse toggleContactStatus(UUID id) {
        log.info("Toggling contact status for lead {}", id);
        ConsultationLeadEntity lead = leadRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Consultation lead not found"));
        
        lead.setIsContacted(!lead.getIsContacted());
        ConsultationLeadEntity updated = leadRepository.save(lead);
        return ConsultationLeadResponse.fromEntity(updated);
    }
}
