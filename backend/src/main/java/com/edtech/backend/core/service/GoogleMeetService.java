package com.edtech.backend.core.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.UUID;

@Service
@Slf4j
@Transactional(readOnly = true)
public class GoogleMeetService {

    public String createMeetLink(String summary, OffsetDateTime start, OffsetDateTime end) {
        log.info("Generating Mockup Google Meet Link for session: {}", summary);
        // Simulated local mode (Mockup)
        return "https://meet.google.com/simulated-" + UUID.randomUUID().toString().substring(0, 8);
    }
}
