import apiClient from './apiClient';

export interface NotificationResponseDTO {
  id: string;
  type: string;
  title: string;
  body: string;
  entityType?: string;
  entityId?: string;
  isRead: boolean;
  readAt?: string;
  createdAt: string;
}

export interface UnreadCountDTO {
  count: number;
}

interface PageData<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  size: number;
  number: number;
}

export const notificationApi = {
  getMyNotifications(page = 0, size = 20) {
    return apiClient.get<PageData<NotificationResponseDTO>>('/api/v1/notifications', {
      params: { page, size }
    });
  },

  getUnreadCount() {
    return apiClient.get<UnreadCountDTO>('/api/v1/notifications/unread-count');
  },

  markAsRead(id: string) {
    return apiClient.patch<void>(`/api/v1/notifications/${id}/read`);
  },

  markAllAsRead() {
    return apiClient.patch<void>('/api/v1/notifications/read-all');
  }
};
