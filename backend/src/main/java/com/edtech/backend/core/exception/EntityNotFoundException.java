package com.edtech.backend.core.exception;

public class EntityNotFoundException extends EdTechException {
    public EntityNotFoundException(String message) {
        super(message, "ENTITY_NOT_FOUND");
    }
}
