import apiClient from './apiClient';

export interface TutorProfileResponse {
  fullName: string;
  email: string | null;
  avatarBase64: string | null;
  bio: string | null;
  subjects: string[];
  teachingLevels: string[];
  location: string | null;
  teachingMode: string;
  rating: number;
  ratingCount: number;
  idCardNumber: string | null;
  verificationStatus: 'UNVERIFIED' | 'PENDING' | 'APPROVED' | 'REJECTED';
  tutorType: string | null;
  dateOfBirth: string | null;
  achievements: string | null;
  experienceYears: number;
}

export interface UpdateTutorProfileRequest {
  avatarBase64?: string;
  email?: string;
  bio?: string;
  location?: string;
  subjects?: string[];
  teachingLevels?: string[];
  achievements?: string;
  experienceYears?: number;
  teachingMode?: string;
}

const unwrap = <T>(res: { data: { data: T } }): T => res.data.data;

export const tutorApi = {
  getMyProfile: async (): Promise<TutorProfileResponse> => {
    const res = await apiClient.get('/api/v1/tutors/profile/me');
    return unwrap(res);
  },

  updateMyProfile: async (req: UpdateTutorProfileRequest): Promise<TutorProfileResponse> => {
    const res = await apiClient.put('/api/v1/tutors/profile/me', req);
    return unwrap(res);
  },
};
