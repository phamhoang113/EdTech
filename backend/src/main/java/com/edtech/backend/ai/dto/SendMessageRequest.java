package com.edtech.backend.ai.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

/** Request gửi message AIvào 1 conversation. */
@Getter
@NoArgsConstructor
public class SendMessageRequest {

    /** Nội dung text của HS */
    private String content;

    /** Base64 ảnh (camera solver), optional */
    private String imageBase64;

    /** MIME type của ảnh (image/jpeg, image/png), optional */
    private String imageMimeType;
}
