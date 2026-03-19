import apiClient from './apiClient';

export interface ApiResponse<T> {
  code?: number;
  message?: string;
  data: T;
}

export type VStatus = 'UNVERIFIED' | 'PENDING' | 'APPROVED' | 'REJECTED';

export interface DocItem {
  name: string;
  icon: string;
  url: string;
}

export interface AdminTutorVerificationResponse {
  id: string; // userId
  name: string;
  subjects: string[];
  date: string;
  status: VStatus;
  phone: string;
  idCardNumber: string;
  hourlyRate?: number;
  dob: string;
  university: string;
  degree: string;
  gradYear: string;
  experience: string;
  levels: string;
  location: string;
  docs: DocItem[];
  bg?: string; // Client-side added for UI
}

export const adminApi = {
  getTutorVerifications: async (): Promise<ApiResponse<AdminTutorVerificationResponse[]>> => {
    const response = await apiClient.get('/api/v1/admin/tutors/verifications');
    return response.data;
  },

  approveTutor: async (userId: string, rate: number): Promise<ApiResponse<void>> => {
    const response = await apiClient.post(`/api/v1/admin/tutors/verifications/${userId}/approve`, null, {
      params: { rate },
    });
    return response.data;
  },

  rejectTutor: async (userId: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.post(`/api/v1/admin/tutors/verifications/${userId}/reject`);
    return response.data;
  },
};

