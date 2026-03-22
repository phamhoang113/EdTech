import apiClient from './apiClient';

interface ApiResponse<T> {
  data: T;
  message?: string;
}

export interface ParentLinkResponse {
  id: string;            // student_profile.id
  parentId: string;      // user.id của phụ huynh
  parentName: string;    // Tên phụ huynh
  parentPhone: string;   // SĐT phụ huynh
  linkStatus: 'PENDING' | 'ACCEPTED';
  createdAt: string;
}

export const studentApi = {
  /** Xem danh sách yêu cầu liên kết từ phụ huynh PENDING hoặc ACCEPTED */
  getParentLinks: async (): Promise<ApiResponse<ParentLinkResponse[]>> => {
    const res = await apiClient.get('/api/v1/student/parent-links');
    return res.data;
  },

  /** Chấp thuận liên kết */
  acceptParentLink: async (linkId: string): Promise<ApiResponse<void>> => {
    const res = await apiClient.post(`/api/v1/student/parent-links/${linkId}/accept`);
    return res.data;
  },

  /** Từ chối liên kết */
  rejectParentLink: async (linkId: string): Promise<ApiResponse<void>> => {
    const res = await apiClient.post(`/api/v1/student/parent-links/${linkId}/reject`);
    return res.data;
  }
};
