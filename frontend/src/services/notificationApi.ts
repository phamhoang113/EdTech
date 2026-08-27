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

export interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T;
}

export const notificationApi = {
  async getMyNotifications(page = 0, size = 20): Promise<ApiResponse<PageData<NotificationResponseDTO>>> {
    const res = await apiClient.get<ApiResponse<PageData<NotificationResponseDTO>>>('/api/v1/notifications', {
      params: { page, size }
    });
    return res.data;
  },

  async getUnreadCount(): Promise<ApiResponse<UnreadCountDTO>> {
    const res = await apiClient.get<ApiResponse<UnreadCountDTO>>('/api/v1/notifications/unread-count');
    return res.data;
  },

  async markAsRead(id: string): Promise<ApiResponse<void>> {
    const res = await apiClient.patch<ApiResponse<void>>(`/api/v1/notifications/${id}/read`);
    return res.data;
  },

  async markAllAsRead(): Promise<ApiResponse<void>> {
    const res = await apiClient.patch<ApiResponse<void>>('/api/v1/notifications/read-all');
    return res.data;
  }
};
