import apiClient from './apiClient';
import type { SessionDTO } from './sessionApi';

interface ApiResponse<T> {
  data: T;
  message?: string;
}

export interface AdminScheduleAnalyticsDTO {
  totalSessions: number;
  makeupNeededSessions: number;
  extraSessions: number;
  totalParentRevenue: number;
  totalTutorSalary: number;
}

export interface QuotaShortfallItem {
  classId: string;
  classCode: string;
  classTitle: string;
  subject: string;
  tutorId: string;
  tutorName: string;
  sessionsPerWeek: number;
  activeThisWeek: number;
  missingCount: number;
  extraCount: number;
}

export const adminScheduleApi = {
  /** Lấy toàn bộ lịch dạy trên hệ thống */
  getSchedules: async (startDate: string, endDate: string, tutorId?: string, classCode?: string, tutorName?: string) => {
    const res = await apiClient.get<ApiResponse<SessionDTO[]>>('/api/v1/admin/schedules', {
      params: { startDate, endDate, tutorId, classCode, tutorName }
    });
    return res.data;
  },

  /** Cập nhật trạng thái thủ công (Khẩn cấp) */
  updateSessionStatus: async (sessionId: string, status: string) => {
    const res = await apiClient.patch<ApiResponse<string>>(`/api/v1/admin/schedules/${sessionId}/status`, null, {
      params: { status }
    });
    return res.data;
  },

  /** Lấy thống kê hiệu suất dòng tiền / thiếu buổi */
  getAnalytics: async (startDate: string, endDate: string, tutorId?: string, classCode?: string, tutorName?: string) => {
    const res = await apiClient.get<ApiResponse<AdminScheduleAnalyticsDTO>>('/api/v1/admin/schedules/analytics', {
      params: { startDate, endDate, tutorId, classCode, tutorName }
    });
    return res.data;
  },

  /** Lấy chi tiết các lớp thiếu/dư buổi trong tuần hiện tại */
  getQuotaDetails: async (tutorId?: string) => {
    const res = await apiClient.get<ApiResponse<QuotaShortfallItem[]>>('/api/v1/admin/schedules/quota-details', {
      params: { tutorId: tutorId || undefined }
    });
    return res.data;
  },

  /** Gợi ý gia sư và lớp theo keyword (autocomplete) */
  suggest: async (keyword: string) => {
    const res = await apiClient.get<ApiResponse<ScheduleSuggestDTO>>('/api/v1/admin/schedules/suggest', {
      params: { keyword }
    });
    return res.data;
  }
};

export interface ScheduleSuggestDTO {
  tutors: TutorSuggestion[];
  classes: ClassSuggestion[];
}

export interface TutorSuggestion {
  id: string;
  fullName: string;
  phone: string;
}

export interface ClassSuggestion {
  id: string;
  classCode: string;
  title: string;
  subject: string;
}
