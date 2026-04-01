package com.edtech.backend.notification.controller;

import com.edtech.backend.core.dto.ApiResponse;
import com.edtech.backend.notification.dto.NotificationResponseDTO;
import com.edtech.backend.notification.dto.UnreadCountDTO;
import com.edtech.backend.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequestMapping("/api/v1/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping
    public ApiResponse<Page<NotificationResponseDTO>> getMyNotifications(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        
        Pageable pageable = PageRequest.of(page, size);
        Page<NotificationResponseDTO> notifications = notificationService.getUserNotifications(userDetails.getUsername(), pageable);
        return ApiResponse.ok(notifications, "Lấy danh sách thông báo thành công");
    }

    @GetMapping("/unread-count")
    public ApiResponse<UnreadCountDTO> getUnreadCount(
            @AuthenticationPrincipal UserDetails userDetails) {
        long count = notificationService.getUnreadCount(userDetails.getUsername());
        return ApiResponse.ok(UnreadCountDTO.builder().count(count).build(), "Lấy số thông báo chưa đọc thành công");
    }

    @PatchMapping("/{id}/read")
    public ApiResponse<Void> markAsRead(
            @PathVariable UUID id,
            @AuthenticationPrincipal UserDetails userDetails) {
        notificationService.markAsRead(id, userDetails.getUsername());
        return ApiResponse.ok(null, "Đánh dấu đã đọc thành công");
    }

    @PatchMapping("/read-all")
    public ApiResponse<Void> markAllAsRead(
            @AuthenticationPrincipal UserDetails userDetails) {
        notificationService.markAllAsRead(userDetails.getUsername());
        return ApiResponse.ok(null, "Đánh dấu tất cả đã đọc thành công");
    }
}
