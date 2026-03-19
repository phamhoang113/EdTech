import api from './apiClient';

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
}

export const classApi = {
  getOpenClasses: async (): Promise<OpenClassResponse[]> => {
    const response = await api.get('/api/v1/classes/open');
    return response.data.data;
  },
  
  getClassFilters: async (): Promise<any> => {
    const response = await api.get('/api/v1/classes/filters');
    return response.data.data;
  }
};
