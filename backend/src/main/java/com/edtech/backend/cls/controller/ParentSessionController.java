package com.edtech.backend.cls.controller;

import com.edtech.backend.cls.dto.SessionCancelRequest;
import com.edtech.backend.cls.dto.SessionDTO;
import com.edtech.backend.cls.service.ParentSessionService;
import com.edtech.backend.auth.entity.UserEntity;
import com.edtech.backend.auth.repository.UserRepository;
import com.edtech.backend.core.exception.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/parent/sessions")
@RequiredArgsConstructor
@PreAuthorize("hasRole('PARENT')")
public class ParentSessionController {

    private final ParentSessionService parentSessionService;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<List<SessionDTO>> getSessions(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        UUID parentId = user.getId();
        
        List<SessionDTO> sessions = parentSessionService.getSessionsByParent(parentId, startDate, endDate);
        return ResponseEntity.ok(sessions);
    }

    @PostMapping("/{sessionId}/cancel")
    public ResponseEntity<SessionDTO> cancelSession(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable UUID sessionId,
            @RequestBody SessionCancelRequest request) {
        
        UserEntity user = userRepository.findByIdentifierAndIsDeletedFalse(userDetails.getUsername())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        UUID parentId = user.getId();
        
        SessionDTO result = parentSessionService.cancelSession(parentId, sessionId, request);
        return ResponseEntity.ok(result);
    }
}
