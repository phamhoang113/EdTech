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

export interface TutorClassDTO {
  id: string;
  title: string;
  subject: string;
  grade: string;
  mode: string;
  status: string;
  sessionsPerWeek: number;
  sessionDurationMin: number;
  tutorFee: number;
  startDate: string | null;
  endDate: string | null;
  schedule: string;
  address: string | null;
  description: string | null;
}

export interface TutorSessionDTO {
  id: string;
  classId: string;
  classTitle: string;
  subject: string;
  tutorName: string;
  tutorPhone: string;
  sessionDate: string;
  startTime: string;
  endTime: string;
  meetLink?: string;
  meetLinkSetAt?: string;
  status: 'SCHEDULED' | 'LIVE' | 'COMPLETED' | 'CANCELLED';
  tutorNote?: string;
}

export interface ScheduleStatusResponse {
  hasNextWeekSessions: boolean;
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

  getMyClasses: async (): Promise<TutorClassDTO[]> => {
    const res = await apiClient.get<TutorClassDTO[]>('/api/v1/tutor/classes');
    return res.data;
  },

  getMySessions: async (startDate?: string, endDate?: string): Promise<TutorSessionDTO[]> => {
    const res = await apiClient.get<TutorSessionDTO[]>('/api/v1/tutor/sessions', {
      params: { startDate, endDate },
    });
    return res.data;
  },

  getScheduleStatus: async (): Promise<ScheduleStatusResponse> => {
    const res = await apiClient.get<ScheduleStatusResponse>('/api/v1/tutor/schedule/status');
    return res.data;
  },
};
