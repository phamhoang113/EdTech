/**
 * parentApi.ts — API client cho giao diện Phụ Huynh
 */
import apiClient from './apiClient';

/* ── Types ───────────────────────────────────────────────────────────────── */
export type ClassStatus =
  | 'PENDING_APPROVAL' | 'OPEN' | 'ASSIGNED' | 'MATCHED'
  | 'ACTIVE' | 'COMPLETED' | 'CANCELLED' | 'AUTO_CLOSED';

export interface ParentClass {
  id: string;
  classCode: string | null;
  title: string;
  subject: string;
  grade: string;
  mode: string;                        // ONLINE | OFFLINE
  address: string | null;
  parentFee: number;
  sessionsPerWeek: number;
  sessionDurationMin: number;
  timeFrame: string | null;
  schedule: string | null;             // JSON array
  levelFees: string | null;            // JSON array [{level, tutor_fee}]
  genderRequirement: string | null;
  status: ClassStatus;
  hasPendingProposals: boolean;
  studentIds?: string[];
  pendingApplicationCount: number;
  createdAt: string;
  tutorName?: string | null;
  tutorPhone?: string | null;
  /** Lý do từ chối của Admin (chỉ có khi status = CANCELLED) */
  rejectionReason?: string | null;
}


export interface ParentClassRequest {
  title: string;
  subject: string;
  grade: string;
  mode: 'ONLINE' | 'OFFLINE';
  address?: string;

  schedule?: string;
  sessionsPerWeek: number;
  sessionDurationMin: number;
  timeFrame?: string;
  parentFee: number;
  genderRequirement?: string;
  description?: string;
  levelFees?: string;  // JSON array [{level, tutor_fee}]
  studentIds?: string[]; // IDs của hoc sinh
}

export interface TutorApplicant {
  applicationId: string;
  classId: string;
  tutorName: string | null;
  tutorPhone: string | null;
  tutorType: string | null;
  dateOfBirth: string | null;      // ISO date from backend
  achievements: string | null;     // Bằng cấp / kinh nghiệm
  proposedSalary: number | null;
  note: string | null;
  status: string;
  appliedAt: string;               // Đã đổi tên từ createdAt ở BE
  rating: number | null;           // Đánh giá sao trung bình
  ratingCount: number | null;      // Tổng lượt đánh giá
  certBase64s: string[] | null;    // Ảnh bằng cấp base64
}

interface ApiResponse<T> {
  data: T;
  message?: string;
}

/* ── API ─────────────────────────────────────────────────────────────────── */
export const parentApi = {
  /** Gửi yêu cầu mở lớp mới */
  requestClass: async (body: ParentClassRequest): Promise<ApiResponse<ParentClass>> => {
    const res = await apiClient.post('/api/v1/parent/classes', body);
    return res.data;
  },

  /** Lấy tất cả lớp của PH đang đăng nhập */
  getMyClasses: async (): Promise<ApiResponse<ParentClass[]>> => {
    const res = await apiClient.get('/api/v1/parent/classes');
    return res.data;
  },

  /** Lấy danh sách gia sư đã đăng ký (admin duyệt) cho 1 lớp */
  getTutorApplicants: async (classId: string): Promise<ApiResponse<TutorApplicant[]>> => {
    const res = await apiClient.get(`/api/v1/parent/classes/${classId}/tutors`);
    return res.data;
  },

  /** PH chọn gia sư từ danh sách đề xuất */
  selectTutor: async (applicationId: string): Promise<ApiResponse<TutorApplicant>> => {
    const res = await apiClient.post(`/api/v1/class-applications/${applicationId}/select`);
    return res.data;
  },

  /** PH xóa lớp đã hủy */
  deleteClass: async (classId: string): Promise<ApiResponse<void>> => {
    const res = await apiClient.delete(`/api/v1/parent/classes/${classId}`);
    return res.data;
  },

  /** Lấy danh sách con em */
  getMyChildren: async (): Promise<ApiResponse<Student[]>> => {
    const res = await apiClient.get('/api/v1/parent/students');
    return res.data;
  },

  /** Thêm con em mới */
  addChild: async (body: StudentRequest): Promise<ApiResponse<Student>> => {
    const res = await apiClient.post('/api/v1/parent/students', body);
    return res.data;
  },

  /** Sửa thông tin con em */
  updateChild: async (id: string, body: StudentRequest): Promise<ApiResponse<Student>> => {
    const res = await apiClient.put(`/api/v1/parent/students/${id}`, body);
    return res.data;
  },

  /** Xoá con em */
  deleteChild: async (id: string): Promise<ApiResponse<null>> => {
    const res = await apiClient.delete(`/api/v1/parent/students/${id}`);
    return res.data;
  },

  /** Đặt lại mật khẩu cho con em */
  resetChildPassword: async (id: string, newPassword: string): Promise<ApiResponse<null>> => {
    const res = await apiClient.post(`/api/v1/parent/students/${id}/reset-password`, { newPassword });
    return res.data;
  },

  /** Tra cứu học sinh theo SĐT — trả về null nếu chưa có tài khoản */
  lookupChildByPhone: async (phone: string): Promise<ApiResponse<Student | null>> => {
    const res = await apiClient.get(`/api/v1/parent/students/lookup?phone=${encodeURIComponent(phone)}`);
    return res.data;
  },

  /** Cập nhật học sinh cho một lớp */
  updateClassStudents: async (classId: string, studentIds: string[]): Promise<ApiResponse<ParentClass>> => {
    const res = await apiClient.put(`/api/v1/parent/classes/${classId}/students`, studentIds);
    return res.data;
  },

  /** Xem danh sách hoá đơn thanh toán */
  getBillings: async (): Promise<ApiResponse<any[]>> => {
    const res = await apiClient.get('/api/v1/parents/billings');
    return res.data;
  },

  /** Xác nhận đã chuyển khoản */
  confirmTransfer: async (billingId: string): Promise<ApiResponse<string>> => {
    const res = await apiClient.post(`/api/v1/parents/billings/${billingId}/confirm`);
    return res.data;
  },

  /** Xem báo cáo học tập */
  getLearningReport: async (yearMonth: string, studentId?: string | null): Promise<ApiResponse<any[]>> => {
    let url = `/api/v1/parents/learning-report?yearMonth=${yearMonth}`;
    if (studentId) url += `&studentId=${studentId}`;
    const res = await apiClient.get(url);
    return res.data;
  },
};

/* ── Student types ───────────────────────────────────────────────────────── */
export interface Student {
  id: string;
  userId: string;
  fullName: string;
  phone: string | null;
  grade: string | null;
  school: string | null;
  avatarBase64: string | null;
  createdAt: string;
  
  // New fields for phoneless & pending links
  linkStatus: 'PENDING' | 'ACCEPTED' | 'REJECTED';
  username?: string;
  defaultPassword?: string;
}

export interface StudentRequest {
  phone?: string;
  fullName: string;
  grade?: string;
  school?: string;
}
