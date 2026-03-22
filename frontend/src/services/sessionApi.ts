import apiClient from './apiClient';

export interface SessionDTO {
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

export interface SessionCancelRequest {
  reason: string;
  makeUpRequired: boolean;
}

export const sessionApi = {
  getSessions: (startDate?: string, endDate?: string) => {
    return apiClient.get<SessionDTO[]>('/api/v1/parent/sessions', {
      params: { startDate, endDate }
    });
  },

  cancelSession: (sessionId: string, request: SessionCancelRequest) => {
    return apiClient.post<SessionDTO>(`/api/v1/parent/sessions/${sessionId}/cancel`, request);
  }
};
