package com.edtech.backend.notification.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UnreadCountDTO {
    private long count;
}
