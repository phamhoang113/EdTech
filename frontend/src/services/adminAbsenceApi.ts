import apiClient from './apiClient';

interface ApiResponse<T> {
  data: T;
  message?: string;
}

export interface AdminAbsenceRequestDTO {
  id: string;
  sessionId: string;
  sessionDate: string;
  startTime: string;
  endTime: string;
  classTitle?: string;
  subject?: string;
  tutorName?: string;
  studentName?: string;
  requestType: 'TUTOR_LEAVE' | 'STUDENT_LEAVE';
  reason: string;
  makeUpRequired: boolean;
  status: 'PENDING' | 'APPROVED' | 'REJECTED';
  createdAt: string;
  reviewedBy?: string;
  reviewedAt?: string;
}

export const adminAbsenceApi = {
  getAllRequests: async () => {
    const res = await apiClient.get<ApiResponse<AdminAbsenceRequestDTO[]>>('/api/v1/admin/absence-requests');
    return res.data;
  },

  approveRequest: async (id: string) => {
    const res = await apiClient.post<ApiResponse<string>>(`/api/v1/admin/absence-requests/${id}/approve`);
    return res.data;
  },

  rejectRequest: async (id: string) => {
    const res = await apiClient.post<ApiResponse<string>>(`/api/v1/admin/absence-requests/${id}/reject`);
    return res.data;
  }
};
