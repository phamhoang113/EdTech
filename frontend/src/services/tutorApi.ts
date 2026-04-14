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
  bankName: string | null;
  bankAccountNumber: string | null;
  bankOwnerName: string | null;
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
  bankName?: string;
  bankAccountNumber?: string;
  bankOwnerName?: string;
}

export interface TutorClassDTO {
  id: string;
  classCode: string;
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
  status: 'DRAFT' | 'SCHEDULED' | 'LIVE' | 'COMPLETED' | 'CANCELLED';
  sessionType: 'REGULAR' | 'MAKEUP' | 'EXTRA';
  tutorNote?: string;
  address?: string;
  hasPendingAbsence?: boolean;
  requiresMakeup?: boolean;
}

export interface ClassQuotaDTO {
  classId: string;
  classCode: string;
  classTitle: string;
  targetSessions: number;
  regularSessions: number;
  makeupSessions: number;
  extraSessions: number;
  missingCount: number;
  excessCount: number;
}

export interface ScheduleSlot {
  dayOfWeek: string;   // T2, T3, T4, T5, T6, T7, CN
  startTime: string;   // HH:mm
  endTime: string;     // HH:mm
}

export interface ScheduleStatusResponse {
  hasNextWeekSessions: boolean;
  hasDraftSessions: boolean;
  draftCount: number;
}

export interface ConfirmResponse {
  confirmedCount: number;
  cancelledCount: number;
  weekStart: string;
  weekEnd: string;
}

export interface TutorPayoutDTO {
  id: string;
  billingId: string;
  classCode: string;
  classTitle: string;
  tutorName: string;
  amount: number;
  transactionCode: string;
  status: 'LOCKED' | 'PENDING' | 'PAID_OUT';
  month: number;
  year: number;
  adminNote: string | null;
  paidAt: string | null;
  confirmedByTutorAt: string | null;
  createdAt: string;
}

const unwrap = <T>(res: { data: { data: T } }): T => res.data.data;

export const tutorApi = {
  // ─── Profile ─────────────────────────────────────────────
  getMyProfile: async (): Promise<TutorProfileResponse> => {
    const res = await apiClient.get('/api/v1/tutors/profile/me');
    return unwrap(res);
  },

  updateMyProfile: async (req: UpdateTutorProfileRequest): Promise<TutorProfileResponse> => {
    const res = await apiClient.put('/api/v1/tutors/profile/me', req);
    return unwrap(res);
  },

  // ─── Dashboard data ──────────────────────────────────────
  getMyClasses: async (): Promise<TutorClassDTO[]> => {
    const res = await apiClient.get('/api/v1/tutor/classes');
    return unwrap(res);
  },

  getMySessions: async (startDate?: string, endDate?: string): Promise<TutorSessionDTO[]> => {
    const res = await apiClient.get('/api/v1/tutor/sessions', {
      params: { startDate, endDate },
    });
    return unwrap(res);
  },

  getPayouts: async (): Promise<TutorPayoutDTO[]> => {
    const res = await apiClient.get('/api/v1/tutors/payouts');
    return unwrap(res);
  },

  confirmPayoutReceived: async (id: string): Promise<string> => {
    const res = await apiClient.post(`/api/v1/tutors/payouts/${id}/confirm`);
    return unwrap(res);
  },

  // ─── Schedule Management ─────────────────────────────────
  getScheduleStatus: async (): Promise<ScheduleStatusResponse> => {
    const res = await apiClient.get<ScheduleStatusResponse>('/api/v1/tutor/schedule/status');
    return res.data;
  },

  getWeeklyQuotaStatus: async (weekOf: string): Promise<ClassQuotaDTO[]> => {
    const res = await apiClient.get<ClassQuotaDTO[]>('/api/v1/tutor/schedule/quota', {
      params: { weekOf },
    });
    return res.data;
  },

  setClassSchedule: async (classId: string, slots: ScheduleSlot[]): Promise<TutorClassDTO> => {
    const res = await apiClient.put<TutorClassDTO>(`/api/v1/tutor/classes/${classId}/schedule`, { slots });
    return res.data;
  },

  getDraftSessions: async (): Promise<TutorSessionDTO[]> => {
    const res = await apiClient.get<TutorSessionDTO[]>('/api/v1/tutor/schedule/drafts');
    return res.data;
  },

  createSingleDraft: async (data: { classId: string; sessionDate: string; startTime: string; endTime: string; makeupForSessionId?: string }): Promise<TutorSessionDTO> => {
    const res = await apiClient.post<TutorSessionDTO>('/api/v1/tutor/schedule/drafts', data);
    return res.data;
  },

  updateDraft: async (sessionId: string, data: {
    sessionDate?: string;
    startTime?: string;
    endTime?: string;
    meetLink?: string;
    tutorNote?: string;
  }): Promise<TutorSessionDTO> => {
    const res = await apiClient.put<TutorSessionDTO>(`/api/v1/tutor/schedule/drafts/${sessionId}`, data);
    return res.data;
  },

  deleteDraft: async (sessionId: string): Promise<void> => {
    await apiClient.delete(`/api/v1/tutor/schedule/drafts/${sessionId}`);
  },

  confirmDrafts: async (weekOf?: string): Promise<ConfirmResponse> => {
    const params = weekOf ? { weekOf } : undefined;
    const res = await apiClient.post<ConfirmResponse>('/api/v1/tutor/schedule/confirm', null, { params });
    return res.data;
  },

  createAbsenceRequest: async (sessionId: string, payload: { reason: string; makeupDate?: string; makeupTime?: string; proofUrl?: string }) => {
    const res = await apiClient.post(`/api/v1/tutor/absence-requests`, { sessionId, ...payload });
    return res.data;
  },

  generateDrafts: async (weekOf: string): Promise<{ createdCount: number; weekStart: string; weekEnd: string; skippedClasses?: string[] }> => {
    const res = await apiClient.post('/api/v1/tutor/schedule/generate-drafts', null, {
      params: { weekOf },
    });
    return res.data;
  },

  updateSessionNote: async (sessionId: string, note: string): Promise<TutorSessionDTO> => {
    const res = await apiClient.patch<{ data: TutorSessionDTO }>(`/api/v1/tutor/schedule/sessions/${sessionId}/note`, { note });
    return res.data.data;
  },
};
