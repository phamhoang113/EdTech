package com.edtech.backend.lead.controller;

import java.util.List;
import java.util.UUID;

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

import com.edtech.backend.lead.dto.ContactMessageRequest;
import com.edtech.backend.lead.dto.ContactMessageResponse;
import com.edtech.backend.lead.service.ContactMessageService;

@RestController
@RequestMapping("/api/v1/contact-messages")
@RequiredArgsConstructor
public class ContactMessageController {

    private final ContactMessageService contactMessageService;

    /**
     * Public endpoint — khách gửi tin nhắn liên hệ.
     */
    @PostMapping
    public ResponseEntity<ContactMessageResponse> submit(@Valid @RequestBody ContactMessageRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(contactMessageService.createMessage(request));
    }

    /**
     * Admin — xem tất cả tin nhắn liên hệ.
     */
    @GetMapping("/admin")
    public ResponseEntity<List<ContactMessageResponse>> getAll() {
        return ResponseEntity.ok(contactMessageService.getAllMessages());
    }

    /**
     * Admin — toggle trạng thái đã đọc.
     */
    @PatchMapping("/admin/{id}/read")
    public ResponseEntity<ContactMessageResponse> toggleRead(@PathVariable UUID id) {
        return ResponseEntity.ok(contactMessageService.toggleReadStatus(id));
    }
}
