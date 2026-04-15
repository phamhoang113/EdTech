import apiClient from './apiClient';

// ── Types ──────────────────────────────────────────────────────────────────

export type AiSubscriptionStatus = 'TRIAL' | 'ACTIVE' | 'EXPIRED' | 'CANCELLED';
export type AiMessageRole = 'USER' | 'ASSISTANT';

export interface AiSubscriptionStatusResponse {
  subscriptionId: string;
  status: AiSubscriptionStatus;
  trialDaysRemaining: number | null;
  paidUntil: string | null;
  canUseAi: boolean;
  isTrial: boolean;
}

export interface AiConversation {
  id: string;
  title: string;
  subject: string | null;
  grade: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface AiMessage {
  id: string;
  role: AiMessageRole;
  content: string;
  imageUrl: string | null;
  createdAt: string;
}

export interface CreateConversationRequest {
  subject?: string;
  grade?: string;
}

export interface SendMessageRequest {
  content?: string;
  imageBase64?: string;
  imageMimeType?: string;
}

// ── API ────────────────────────────────────────────────────────────────────

export const aiApi = {
  /** Lấy trạng thái subscription — tự kích hoạt trial nếu chưa có */
  getSubscriptionStatus: async (): Promise<AiSubscriptionStatusResponse> => {
    const res = await apiClient.get('/api/v1/ai/subscription/status');
    return res.data.data;
  },

  /** Tạo conversation mới */
  createConversation: async (request: CreateConversationRequest): Promise<AiConversation> => {
    const res = await apiClient.post('/api/v1/ai/conversations', request);
    return res.data.data;
  },

  /** Danh sách conversations */
  listConversations: async (): Promise<AiConversation[]> => {
    const res = await apiClient.get('/api/v1/ai/conversations');
    return res.data.data;
  },

  /** Lịch sử tin nhắn của 1 conversation */
  getMessages: async (conversationId: string): Promise<AiMessage[]> => {
    const res = await apiClient.get(`/api/v1/ai/conversations/${conversationId}/messages`);
    return res.data.data;
  },

  /** Gửi message — hỗ trợ text và ảnh base64 */
  sendMessage: async (
    conversationId: string,
    request: SendMessageRequest
  ): Promise<AiMessage> => {
    const res = await apiClient.post(
      `/api/v1/ai/conversations/${conversationId}/messages`,
      request,
      { timeout: 60000 } // AI có thể chậm hơn
    );
    return res.data.data;
  },

  /** Xóa conversation */
  deleteConversation: async (conversationId: string): Promise<void> => {
    await apiClient.delete(`/api/v1/ai/conversations/${conversationId}`);
  },
};
