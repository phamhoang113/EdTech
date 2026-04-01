package com.edtech.backend.cls.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
public class SessionCancelRequest {
    private String reason;
    private boolean makeUpRequired;
}
