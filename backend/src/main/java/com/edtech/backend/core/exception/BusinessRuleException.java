package com.edtech.backend.core.exception;

public class BusinessRuleException extends EdTechException {
    public BusinessRuleException(String message) {
        super(message, "BUSINESS_RULE_VIOLATION");
    }
}
