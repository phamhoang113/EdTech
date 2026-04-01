import apiClient from './apiClient';

export interface SessionDTO {
  id: string;
  classId: string;
  classCode?: string;
  classTitle: string;
  subject: string;
  tutorName: string;
  tutorPhone: string;
  sessionDate: string;
  startTime: string;
  endTime: string;
  meetLink?: string;
  meetLinkSetAt?: string;
  status: 'DRAFT' | 'SCHEDULED' | 'LIVE' | 'COMPLETED' | 'COMPLETED_PENDING' | 'CANCELLED' | 'CANCELLED_BY_TUTOR' | 'CANCELLED_BY_STUDENT' | 'DISPUTED';
  sessionType?: 'REGULAR' | 'MAKEUP' | 'EXTRA';
  tutorNote?: string;
  hasPendingAbsence?: boolean;
  requiresMakeup?: boolean;
  parentFee?: number;
  tutorFee?: number;
  makeupForSessionId?: string;
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
