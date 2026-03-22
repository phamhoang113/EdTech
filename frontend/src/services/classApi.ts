import api from './apiClient';

export interface LevelFeeItem {
  level: string;       // "Sinh viên" | "Giáo viên" | "Gia sư Tốt nghiệp"
  tutor_fee: number;
  parent_fee?: number;
  platform_fee?: number;
}

export interface OpenClassResponse {
  id: string;
  title: string;
  subject: string;
  grade: string;
  location: string;
  schedule: string;
  timeFrame: string;
  classCode: string;
  feePercentage: number;
  parentFee: number;
  minTutorFee: number;
  maxTutorFee: number;
  tutorLevelRequirement: string[];
  genderRequirement: string;
  sessionsPerWeek: number;
  sessionDurationMin: number;
  studentCount: number;
  levelFees?: string; // raw JSON string, parse to LevelFeeItem[]
}

export type ApplicationStatus = 'PENDING' | 'APPROVED' | 'REJECTED';

export interface ClassApplicationResponse {
  applicationId: string;
  classId: string;
  classTitle: string;
  classCode: string;
  subject: string;
  grade: string;
  tutorId: string;
  tutorName: string;
  status: ApplicationStatus;
  note?: string;
  createdAt: string;
}

export const classApi = {
  getOpenClasses: async (): Promise<OpenClassResponse[]> => {
    const response = await api.get('/api/v1/classes/open');
    return response.data.data;
  },

  getClassFilters: async (): Promise<any> => {
    const response = await api.get('/api/v1/classes/filters');
    return response.data.data;
  },

  applyForClass: async (classId: string, note?: string): Promise<ClassApplicationResponse> => {
    const response = await api.post(`/api/v1/classes/${classId}/apply`, { note });
    return response.data.data;
  },

  getMyApplications: async (): Promise<ClassApplicationResponse[]> => {
    const response = await api.get('/api/v1/classes/my-applications');
    return response.data.data;
  },
};

