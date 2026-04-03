package com.edtech.backend.core.controller;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    @Value("${info.app.version:0.0.1-SNAPSHOT}")
    private String appVersion;

    @Value("${info.app.name:EdTech Backend}")
    private String appName;

    @GetMapping
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("status", "UP");
        body.put("service", appName);
        body.put("version", appVersion);
        body.put("timestamp", Instant.now().toString());
        return ResponseEntity.ok(body);
    }
}
