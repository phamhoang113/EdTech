package com.edtech.backend.teaching.entity;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AttachmentInfo implements Serializable {
    private String fileUrl;
    private String fileName;
    private Long fileSize;
}
