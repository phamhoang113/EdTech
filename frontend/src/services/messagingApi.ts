import apiClient from './apiClient';
import type { UserRole } from '../store/useAuthStore';

export interface ConversationResponseDTO {
  id: string;
  userId: string;
  userFullName: string;
  userAvatarBase64?: string;
  userRole: UserRole;
  lastMessagePreview?: string;
  lastMessageSenderName?: string;
  lastMessageAt?: string;
  unreadCountAdmin: number;
  unreadCountUser: number;
  isClosed: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface MessageResponseDTO {
  id: string;
  conversationId: string;
  senderId: string;
  senderName: string;
  content: string;
  messageType: string;
  isRead: boolean;
  createdAt: string;
}

export interface SendMessageRequest {
  content: string;
  conversationId?: string;
  targetUserId?: string;
  messageType?: string;
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

export const messagingApi = {
  async getConversations(page = 0, size = 20): Promise<ApiResponse<PageData<ConversationResponseDTO>>> {
    const res = await apiClient.get<ApiResponse<PageData<ConversationResponseDTO>>>('/api/v1/messages/conversations', {
      params: { page, size }
    });
    return res.data;
  },

  async getMyConversation(): Promise<ApiResponse<ConversationResponseDTO>> {
    const res = await apiClient.get<ApiResponse<ConversationResponseDTO>>('/api/v1/messages/conversations/my');
    return res.data;
  },

  async getConversationById(id: string): Promise<ApiResponse<ConversationResponseDTO>> {
    const res = await apiClient.get<ApiResponse<ConversationResponseDTO>>(`/api/v1/messages/conversations/${id}`);
    return res.data;
  },

  async getMessages(conversationId: string, page = 0, size = 50): Promise<ApiResponse<PageData<MessageResponseDTO>>> {
    const res = await apiClient.get<ApiResponse<PageData<MessageResponseDTO>>>(`/api/v1/messages/conversations/${conversationId}/history`, {
      params: { page, size }
    });
    return res.data;
  },

  async sendMessage(request: SendMessageRequest): Promise<ApiResponse<MessageResponseDTO>> {
    const res = await apiClient.post<ApiResponse<MessageResponseDTO>>('/api/v1/messages', request);
    return res.data;
  },

  async markAsRead(conversationId: string): Promise<ApiResponse<void>> {
    const res = await apiClient.patch<ApiResponse<void>>(`/api/v1/messages/conversations/${conversationId}/read`);
    return res.data;
  },

  async getUnreadCount(): Promise<ApiResponse<{ count: number }>> {
    const res = await apiClient.get<ApiResponse<{ count: number }>>('/api/v1/messages/unread-count');
    return res.data;
  },

  async sendImageMessage(file: File, conversationId?: string, targetUserId?: string): Promise<ApiResponse<MessageResponseDTO>> {
    const formData = new FormData();
    formData.append('file', file);
    if (conversationId) formData.append('conversationId', conversationId);
    if (targetUserId) formData.append('targetUserId', targetUserId);
    const res = await apiClient.post<ApiResponse<MessageResponseDTO>>('/api/v1/messages/image', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return res.data;
  }
};
