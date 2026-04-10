import apiClient from './apiClient';

export interface UserProfileResponse {
  fullName: string;
  phone: string;
  email: string | null;
  avatarBase64: string | null;
  role: string;
  address: string | null;
  school: string | null;
  grade: string | null;
}

export interface UpdateUserProfileRequest {
  phone?: string;
  email?: string;
  avatarBase64?: string;
  address?: string;
  school?: string;
  grade?: string;
}

export const userProfileApi = {
  getMyProfile: async (): Promise<UserProfileResponse> => {
    const response = await apiClient.get('/api/v1/users/profile/me');
    return response.data.data;
  },

  updateMyProfile: async (request: UpdateUserProfileRequest): Promise<UserProfileResponse> => {
    const response = await apiClient.put('/api/v1/users/profile', request);
    return response.data.data;
  },
};
