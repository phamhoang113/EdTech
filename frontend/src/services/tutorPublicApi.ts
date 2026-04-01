import apiClient from './apiClient';

export interface ApiResponse<T> {
  code?: number;
  message?: string;
  data: T;
}

export interface PageResponse<T> {
  content: T[];
  totalPages: number;
  totalElements: number;
  size: number;
  number: number;
}

export interface TutorPublicResponse {
  userId: string;
  fullName: string;
  bio?: string;
  subjects?: string[];
  location?: string;
  teachingMode?: string;
  hourlyRate?: number;
  rating?: number;
  ratingCount?: number;
  teachingLevels?: string[];
  achievements?: string;
  experienceYears?: number;
  avatarBase64?: string;
  tutorType?: string;
}

interface GetTutorsParams {
  page?: number;
  size?: number;
  sort?: string;
}

export const tutorPublicApi = {
  getPublicTutors: async (params?: GetTutorsParams) => {
    const res = await apiClient.get<ApiResponse<PageResponse<TutorPublicResponse>>>('/api/v1/public/tutors', { params });
    return res.data;
  }
};
