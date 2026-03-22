package com.edtech.backend.cls.dto;

import lombok.Data;

@Data
public class SessionCancelRequest {
    private String reason;
    private boolean makeUpRequired;
}
