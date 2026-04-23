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
  trial: boolean; // Java field 'trial' (không phải isTrial)
}

export interface AiConversation {
  id: string;
  title: string;
  subject: string | null;
  grade: string | null;
  learningGoal: string | null;
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
  subject: string;
  grade?: string;
}

export interface SendMessageRequest {
  content?: string;
  imageBase64?: string;
  imageMimeType?: string;
}

export interface UpdateConversationRequest {
  learningGoal?: string;
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

  /** Cập nhật conversation (mục tiêu học tập) */
  updateConversation: async (
    conversationId: string,
    request: UpdateConversationRequest
  ): Promise<AiConversation> => {
    const res = await apiClient.patch(
      `/api/v1/ai/conversations/${conversationId}`,
      request
    );
    return res.data.data;
  },

  /**
   * Gửi message tới AI với SSE streaming — nhận response từng chunk real-time.
   * Dùng native fetch (không qua axios) vì cần ReadableStream.
   * Trả về AbortController để có thể cancel stream.
   */
  sendMessageStream: (
    conversationId: string,
    request: SendMessageRequest,
    callbacks: {
      onChunk: (text: string) => void;
      onDone: (conversationId: string) => void;
      onError: (error: string) => void;
    }
  ): AbortController => {
    const controller = new AbortController();
    const baseUrl = import.meta.env.VITE_API_URL || 'http://localhost:8080';
    const token = localStorage.getItem('accessToken');

    const url = `${baseUrl}/api/v1/ai/conversations/${conversationId}/messages/stream`;

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: JSON.stringify(request),
      signal: controller.signal,
    })
      .then(async (response) => {
        if (!response.ok) {
          const text = await response.text().catch(() => '');
          callbacks.onError(text || `HTTP ${response.status}`);
          return;
        }

        const reader = response.body?.getReader();
        if (!reader) {
          callbacks.onError('Stream not supported');
          return;
        }

        const decoder = new TextDecoder();
        let buffer = '';

        while (true) {
          const { done, value } = await reader.read();
          if (done) break;

          buffer += decoder.decode(value, { stream: true });

          // Parse SSE lines từ buffer
          const lines = buffer.split('\n');
          buffer = lines.pop() || ''; // giữ lại dòng chưa hoàn chỉnh

          let currentEvent = '';

          for (const line of lines) {
            const trimmed = line.trim();

            if (trimmed.startsWith('event:')) {
              currentEvent = trimmed.substring(6).trim();
            } else if (trimmed.startsWith('data:')) {
              const data = trimmed.substring(5).trim();

              if (currentEvent === 'chunk' && data) {
                callbacks.onChunk(data);
              } else if (currentEvent === 'done' && data) {
                try {
                  const parsed = JSON.parse(data);
                  callbacks.onDone(parsed.conversationId || conversationId);
                } catch {
                  callbacks.onDone(conversationId);
                }
              } else if (currentEvent === 'error' && data) {
                callbacks.onError(data);
              }
            } else if (trimmed === '') {
              currentEvent = ''; // Reset sau mỗi blank line (SSE spec)
            }
          }
        }

        // Process remaining buffer
        if (buffer.trim()) {
          const remaining = buffer.trim();
          if (remaining.startsWith('data:')) {
            const data = remaining.substring(5).trim();
            if (data) callbacks.onChunk(data);
          }
        }
      })
      .catch((err) => {
        if (err.name !== 'AbortError') {
          callbacks.onError(err.message || 'Có lỗi xảy ra khi kết nối AI.');
        }
      });

    return controller;
  },
};
