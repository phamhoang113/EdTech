package com.edtech.backend.core.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

import lombok.extern.slf4j.Slf4j;

/**
 * Tiện ích nén/giải nén ảnh base64 bằng GZIP (lossless).
 *
 * Quy trình lưu:  base64 string → bytes → GZIP compress → Base64 encode → lưu DB (nhỏ hơn ~60-70%)
 * Quy trình đọc:  DB string → Base64 decode → GZIP decompress → base64 string gốc (100% nguyên vẹn)
 *
 * Marker: chuỗi nén bắt đầu bằng "GZ:" để phân biệt với base64 thường.
 */
@Slf4j
public final class ImageCompressUtil {

    private static final String GZIP_MARKER = "GZ:";
    private static final int BUFFER_SIZE = 8192;

    private ImageCompressUtil() {
        // Utility class
    }

    /**
     * Nén base64 data URL bằng GZIP.
     * Input:  "data:image/webp;base64,UklGR..."  (ảnh gốc, ~200KB-2MB)
     * Output: "GZ:H4sIAAAAAAAAA..."              (nén, ~80-400KB)
     *
     * @param base64DataUrl chuỗi base64 data URL gốc
     * @return chuỗi đã nén (prefix "GZ:"), hoặc chuỗi gốc nếu nén thất bại
     */
    public static String compress(String base64DataUrl) {
        if (base64DataUrl == null || base64DataUrl.isBlank()) {
            return base64DataUrl;
        }

        // Đã nén rồi → trả về luôn
        if (base64DataUrl.startsWith(GZIP_MARKER)) {
            return base64DataUrl;
        }

        try {
            byte[] inputBytes = base64DataUrl.getBytes(java.nio.charset.StandardCharsets.UTF_8);
            byte[] compressed = gzipCompress(inputBytes);
            String result = GZIP_MARKER + Base64.getEncoder().encodeToString(compressed);

            double ratio = 100.0 - (result.length() * 100.0 / base64DataUrl.length());
            log.debug("Image compressed: {}KB → {}KB (giảm {}%)",
                    inputBytes.length / 1024, result.length() / 1024, Math.round(ratio));

            return result;
        } catch (IOException e) {
            log.warn("GZIP compress failed, returning original: {}", e.getMessage());
            return base64DataUrl;
        }
    }

    /**
     * Giải nén chuỗi đã nén → trả về base64 data URL gốc 100% nguyên vẹn.
     * Input:  "GZ:H4sIAAAAAAAAA..."
     * Output: "data:image/webp;base64,UklGR..."
     *
     * Nếu input không có prefix "GZ:" → coi là chưa nén, trả về nguyên bản.
     *
     * @param stored chuỗi từ DB (có thể đã nén hoặc chưa)
     * @return base64 data URL gốc
     */
    public static String decompress(String stored) {
        if (stored == null || stored.isBlank()) {
            return stored;
        }

        // Chưa nén → trả về luôn
        if (!stored.startsWith(GZIP_MARKER)) {
            return stored;
        }

        try {
            String compressedBase64 = stored.substring(GZIP_MARKER.length());
            byte[] compressed = Base64.getDecoder().decode(compressedBase64);
            byte[] decompressed = gzipDecompress(compressed);

            return new String(decompressed, java.nio.charset.StandardCharsets.UTF_8);
        } catch (IOException e) {
            log.warn("GZIP decompress failed, returning stored value: {}", e.getMessage());
            return stored;
        }
    }

    /**
     * Nén mảng base64 (dùng cho certBase64s của Tutor).
     */
    public static String[] compressArray(String[] base64Array) {
        if (base64Array == null) return null;
        String[] result = new String[base64Array.length];
        for (int i = 0; i < base64Array.length; i++) {
            result[i] = compress(base64Array[i]);
        }
        return result;
    }

    /**
     * Giải nén mảng base64.
     */
    public static String[] decompressArray(String[] compressedArray) {
        if (compressedArray == null) return null;
        String[] result = new String[compressedArray.length];
        for (int i = 0; i < compressedArray.length; i++) {
            result[i] = decompress(compressedArray[i]);
        }
        return result;
    }

    /**
     * Kiểm tra chuỗi đã được nén GZIP hay chưa.
     */
    public static boolean isCompressed(String value) {
        return value != null && value.startsWith(GZIP_MARKER);
    }

    // ─── GZIP byte-level operations ────────────────────────────────────

    private static byte[] gzipCompress(byte[] data) throws IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream(data.length);
        try (GZIPOutputStream gzos = new GZIPOutputStream(bos)) {
            gzos.write(data);
        }
        return bos.toByteArray();
    }

    private static byte[] gzipDecompress(byte[] compressed) throws IOException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        try (GZIPInputStream gzis = new GZIPInputStream(new ByteArrayInputStream(compressed))) {
            byte[] buffer = new byte[BUFFER_SIZE];
            int len;
            while ((len = gzis.read(buffer)) != -1) {
                bos.write(buffer, 0, len);
            }
        }
        return bos.toByteArray();
    }
}
