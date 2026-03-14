package com.edtech.backend.core.exception;

import lombok.Getter;

@Getter
public class EdTechException extends RuntimeException {
    
    private final String errorCode;

    public EdTechException(String message) {
        super(message);
        this.errorCode = "DEFAULT_ERROR";
    }

    public EdTechException(String message, String errorCode) {
        super(message);
        this.errorCode = errorCode;
    }
}
