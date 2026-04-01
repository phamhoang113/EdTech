import apiClient from './apiClient';
import type { SessionDTO } from './sessionApi';
import type { ParentClass, TutorApplicant } from './parentApi';

interface ApiResponse<T> {
  data: T;
  message?: string;
}

export interface ParentLinkResponse {
  id: string;            // student_profile.id
  parentId: string;      // user.id của phụ huynh
  parentName: string;    // Tên phụ huynh
  parentPhone: string;   // SĐT phụ huynh
  linkStatus: 'PENDING' | 'ACCEPTED';
  createdAt: string;
}

export const studentApi = {
  /** Xem danh sách yêu cầu liên kết từ phụ huynh PENDING hoặc ACCEPTED */
  getParentLinks: async (): Promise<ApiResponse<ParentLinkResponse[]>> => {
    const res = await apiClient.get('/api/v1/student/parent-links');
    return res.data;
  },

  /** Lấy lịch học của học sinh */
  getSessions: (startDate?: string, endDate?: string) => {
    return apiClient.get<SessionDTO[]>('/api/v1/student/sessions', {
      params: { startDate, endDate }
    });
  },

  /** Học sinh xin nghỉ / huỷ buổi học */
  cancelSession: (sessionId: string, request: { reason: string; makeUpRequired: boolean }) => {
    return apiClient.post<SessionDTO>(`/api/v1/student/sessions/${sessionId}/cancel`, request);
  },

  /** Chấp thuận liên kết */
  acceptParentLink: async (linkId: string): Promise<ApiResponse<void>> => {
    const res = await apiClient.post(`/api/v1/student/parent-links/${linkId}/accept`);
    return res.data;
  },

  /** Từ chối liên kết */
  rejectParentLink: async (linkId: string): Promise<ApiResponse<void>> => {
    const res = await apiClient.post(`/api/v1/student/parent-links/${linkId}/reject`);
    return res.data;
  },

  /** Gửi yêu cầu tự động liên kết tới Phụ huynh qua SDT */
  requestParentLink: async (parentPhone: string): Promise<ApiResponse<void>> => {
    const res = await apiClient.post(`/api/v1/student/parent-links`, null, {
      params: { parentPhone }
    });
    return res.data;
  },

  /** Tạo yêu cầu mở lớp cho học sinh */
  createClassRequest: async (data: any): Promise<ApiResponse<ParentClass>> => {
    const res = await apiClient.post('/api/v1/student/classes', data);
    return res.data;
  },

  /** Lấy danh sách lớp do học sinh tự tạo */
  getMyClasses: async (): Promise<ApiResponse<ParentClass[]>> => {
    const res = await apiClient.get('/api/v1/student/classes');
    return res.data;
  },

  /** Lấy danh sách gia sư được đề xuất cho lớp */
  getProposedTutors: async (classId: string): Promise<ApiResponse<TutorApplicant[]>> => {
    const res = await apiClient.get(`/api/v1/classes/${classId}/proposed-tutors`);
    return res.data;
  },

  /** Chọn gia sư cho lớp */
  selectTutor: async (applicationId: string): Promise<ApiResponse<TutorApplicant>> => {
    const res = await apiClient.post(`/api/v1/class-applications/${applicationId}/select`);
    return res.data;
  },

  /** Lấy danh sách hóa đơn học phí của học sinh tự chi trả */
  getBillings: async (): Promise<ApiResponse<any[]>> => {
    const res = await apiClient.get('/api/v1/students/billings');
    return res.data;
  },

  /** Học sinh xác nhận đã chuyển khoản hóa đơn */
  confirmTransfer: async (billingId: string): Promise<ApiResponse<string>> => {
    const res = await apiClient.post(`/api/v1/students/billings/${billingId}/confirm`);
    return res.data;
  }
};
