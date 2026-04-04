package com.edtech.backend.lead.controller;

import java.util.List;
import java.util.UUID;

import com.edtech.backend.lead.dto.ConsultationLeadRequest;
import com.edtech.backend.lead.dto.ConsultationLeadResponse;
import com.edtech.backend.lead.service.ConsultationLeadService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/leads")
@RequiredArgsConstructor
public class ConsultationLeadController {

    private final ConsultationLeadService leadService;

    /**
     * Public endpoint for users to submit a consultation request.
     */
    @PostMapping
    public ResponseEntity<ConsultationLeadResponse> createLead(@Valid @RequestBody ConsultationLeadRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(leadService.createLead(request));
    }

    /**
     * Admin endpoint to get all leads.
     */
    @GetMapping("/admin")
    public ResponseEntity<List<ConsultationLeadResponse>> getAllLeads() {
        return ResponseEntity.ok(leadService.getAllLeads());
    }

    /**
     * Admin endpoint to toggle contact status.
     */
    @PatchMapping("/admin/{id}/contact")
    public ResponseEntity<ConsultationLeadResponse> toggleContactStatus(@PathVariable UUID id) {
        return ResponseEntity.ok(leadService.toggleContactStatus(id));
    }
}
