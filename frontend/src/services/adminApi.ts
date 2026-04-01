import apiClient from './apiClient';

export interface ApiResponse<T> {
  code?: number;
  message?: string;
  data: T;
}

export type VStatus = 'UNVERIFIED' | 'PENDING' | 'APPROVED' | 'REJECTED';

export interface DocItem {
  name: string;
  icon: string;
  url: string;
}

export interface AdminTutorVerificationResponse {
  id: string; // userId
  name: string;
  subjects: string[];
  date: string;
  status: VStatus;
  phone: string;
  idCardNumber: string;
  hourlyRate?: number;
  dob: string;
  university: string;
  degree: string;
  gradYear: string;
  experience: string;
  levels: string;
  location: string;
  docs: DocItem[];
  bg?: string; // Client-side added for UI
}

export type UserRole = 'ADMIN' | 'TUTOR' | 'PARENT' | 'STUDENT';

export interface AdminUserListItem {
  id: string;
  fullName: string;
  email: string | null;
  phone: string;
  role: UserRole;
  isActive: boolean;
  isDeleted: boolean;
  createdAt: string;
}

export interface AdminUserDetail extends AdminUserListItem {
  // Tutor profile (chỉ có khi role = TUTOR)
  tutorType?: string;
  verificationStatus?: string;
  bio?: string;
  subjects?: string[];
  teachingLevels?: string[];
  location?: string;
  teachingMode?: string;
  hourlyRate?: number;
  rating?: number;
  ratingCount?: number;
  experienceYears?: number;
  dateOfBirth?: string;
  achievements?: string;
}

export interface SystemSettings {
  // Chung
  siteName: string;
  contactEmail: string;
  contactPhone: string;
  maintenanceMode: boolean;
  // Nền tảng
  platformFeePercent: number;
  minHourlyRate: number;
  maxHourlyRate: number;
  maxClassesPerTutor: number;
  autoApproveEnabled: boolean;
  // Bảo mật
  requireStrongPassword: boolean;
  sessionTimeoutMinutes: number;
  maxLoginAttempts: number;
  // Thông báo
  emailOnNewUser: boolean;
  emailOnVerification: boolean;
  emailOnNewClass: boolean;
  emailOnPayment: boolean;
  // Giao diện
  primaryColor: string;
}

export const adminApi = {
  // ─── Class Requests (PENDING_APPROVAL) ───────────────────────────────────
  getPendingClassRequests: async (): Promise<ApiResponse<AdminClassListItem[]>> => {
    const response = await apiClient.get('/api/v1/admin/classes', { params: { status: 'PENDING_APPROVAL' } });
    return response.data;
  },

  approveClassRequest: async (classId: string, tutorFee?: number, levelFees?: string, tutorProposals?: string, platformPct?: number): Promise<ApiResponse<void>> => {
    const body: Record<string, unknown> = {};
    if (tutorFee !== undefined) body.tutorFee = tutorFee;
    if (levelFees !== undefined) body.levelFees = levelFees;
    if (tutorProposals !== undefined) body.tutorProposals = tutorProposals;
    if (platformPct !== undefined) body.feePercentage = platformPct;
    const response = await apiClient.patch(`/api/v1/admin/classes/${classId}/approve`, body);
    return response.data;
  },

  rejectClassRequest: async (classId: string, reason?: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.patch(`/api/v1/admin/classes/${classId}/reject`, null, {
      params: reason ? { reason } : {},
    });
    return response.data;
  },

  // ─── Users ───────────────────────────────────────────────────────────────
  getUsers: async (role?: UserRole): Promise<ApiResponse<AdminUserListItem[]>> => {
    const params = role ? { role } : {};
    const response = await apiClient.get('/api/v1/admin/users', { params });
    return response.data;
  },

  lockUser: async (userId: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.patch(`/api/v1/admin/users/${userId}/lock`);
    return response.data;
  },

  unlockUser: async (userId: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.patch(`/api/v1/admin/users/${userId}/unlock`);
    return response.data;
  },

  deleteUser: async (userId: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.delete(`/api/v1/admin/users/${userId}`);
    return response.data;
  },

  getUserDetail: async (userId: string): Promise<ApiResponse<AdminUserDetail>> => {
    const response = await apiClient.get(`/api/v1/admin/users/${userId}`);
    return response.data;
  },

  quickCreateUser: async (payload: { phone: string; password: string; fullName: string; role: UserRole }): Promise<ApiResponse<AdminUserDetail>> => {
    const response = await apiClient.post('/api/v1/admin/users/quick-create', payload);
    return response.data;
  },


  // ─── System Settings ─────────────────────────────────────────────────────
  getSettings: async (): Promise<ApiResponse<SystemSettings>> => {
    const response = await apiClient.get('/api/v1/admin/settings');
    return response.data;
  },

  updateSettings: async (dto: SystemSettings): Promise<ApiResponse<SystemSettings>> => {
    const response = await apiClient.put('/api/v1/admin/settings', dto);
    return response.data;
  },

  getTutorVerifications: async (): Promise<ApiResponse<AdminTutorVerificationResponse[]>> => {
    const response = await apiClient.get('/api/v1/admin/tutors/verifications');
    return response.data;
  },

  approveTutor: async (userId: string, rate: number): Promise<ApiResponse<void>> => {
    const response = await apiClient.post(`/api/v1/admin/tutors/verifications/${userId}/approve`, null, {
      params: { rate },
    });
    return response.data;
  },

  rejectTutor: async (userId: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.post(`/api/v1/admin/tutors/verifications/${userId}/reject`);
    return response.data;
  },

  // ─── Class Applications ──────────────────────────────────────────────────

  getClassApplications: async (status?: string): Promise<ApiResponse<ClassApplicationItem[]>> => {
    const params = status ? { status } : {};
    const response = await apiClient.get('/api/v1/admin/class-applications', { params });
    return response.data;
  },

  approveClassApplication: async (applicationId: string, actualSalary?: number): Promise<ApiResponse<ClassApplicationItem>> => {
    const params = actualSalary != null ? { actualSalary } : {};
    const response = await apiClient.post(`/api/v1/admin/class-applications/${applicationId}/approve`, null, { params });
    return response.data;
  },

  rejectClassApplication: async (applicationId: string): Promise<ApiResponse<ClassApplicationItem>> => {
    const response = await apiClient.post(`/api/v1/admin/class-applications/${applicationId}/reject`);
    return response.data;
  },

  // ─── Tutor List ──────────────────────────────────────────────────────────

  getAllTutors: async (): Promise<ApiResponse<AdminTutorListItem[]>> => {
    const response = await apiClient.get('/api/v1/admin/tutors');
    return response.data;
  },

  deleteTutor: async (userId: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.delete(`/api/v1/admin/tutors/${userId}`);
    return response.data;
  },

  // ─── Classes ────────────────────────────────────────────────────────────
  getClassStats: async (): Promise<ApiResponse<Record<string, number>>> => {
    const response = await apiClient.get('/api/v1/admin/classes/stats');
    return response.data;
  },

  getClassScheduleStats: async (classId: string): Promise<ApiResponse<AdminClassScheduleStatsDTO>> => {
    const response = await apiClient.get(`/api/v1/admin/classes/${classId}/schedule-stats`);
    return response.data;
  },

  // ─── Dashboard ───────────────────────────────────────────────────────────
  getDashboardStats: async (): Promise<ApiResponse<DashboardStats>> => {
    const response = await apiClient.get('/api/v1/admin/dashboard/stats');
    return response.data;
  },

  getAllClasses: async (status?: string): Promise<ApiResponse<AdminClassListItem[]>> => {
    const params = status ? { status } : {};
    const response = await apiClient.get('/api/v1/admin/classes', { params });
    return response.data;
  },

  createClass: async (body: CreateClassBody): Promise<ApiResponse<AdminClassListItem>> => {
    const response = await apiClient.post('/api/v1/admin/classes', body);
    return response.data;
  },

  updateClassStatus: async (classId: string, newStatus: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.patch(`/api/v1/admin/classes/${classId}/status`, null, { params: { newStatus } });
    return response.data;
  },

  updateLearningStartDate: async (classId: string, learningStartDate: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.patch(`/api/v1/admin/classes/${classId}/learning-start-date`, { learningStartDate });
    return response.data;
  },

  deleteClass: async (classId: string): Promise<ApiResponse<void>> => {
    const response = await apiClient.delete(`/api/v1/admin/classes/${classId}`);
    return response.data;
  },

  // ─── Billing ────────────────────────────────────────────────────────────

  getBillings: async (status?: string, month?: number, year?: number): Promise<ApiResponse<AdminBillingItem[]>> => {
    const params: Record<string, any> = {};
    if (status) params.status = status;
    if (month) params.month = month;
    if (year) params.year = year;
    const response = await apiClient.get('/api/v1/admins/billings', { params });
    return response.data;
  },

  triggerBilling: async (month: number, year: number): Promise<ApiResponse<string>> => {
    const response = await apiClient.post('/api/v1/admins/billings/trigger', null, { params: { month, year } });
    return response.data;
  },

  approveBilling: async (id: string): Promise<ApiResponse<string>> => {
    const response = await apiClient.post(`/api/v1/admins/billings/${id}/approve`);
    return response.data;
  },

  approveAllDraftBillings: async (month: number, year: number): Promise<ApiResponse<string>> => {
    const response = await apiClient.post('/api/v1/admins/billings/approve-all', null, { params: { month, year } });
    return response.data;
  },

  deleteDraftBilling: async (id: string): Promise<ApiResponse<string>> => {
    const response = await apiClient.delete(`/api/v1/admins/billings/${id}`);
    return response.data;
  },

  verifyPayment: async (transactionCode: string): Promise<ApiResponse<string>> => {
    const response = await apiClient.post(`/api/v1/admins/billings/verify/${transactionCode}`);
    return response.data;
  },

  verifyBulk: async (billingIds: string[]): Promise<ApiResponse<string>> => {
    const response = await apiClient.post('/api/v1/admins/billings/verify-bulk', billingIds);
    return response.data;
  },

  getTutorPayouts: async (status?: string, month?: number, year?: number): Promise<ApiResponse<AdminTutorPayoutItem[]>> => {
    const params: Record<string, any> = {};
    if (status) params.status = status;
    if (month) params.month = month;
    if (year) params.year = year;
    const response = await apiClient.get('/api/v1/admins/billings/payouts', { params });
    return response.data;
  },

  markPayoutPaid: async (id: string, note?: string): Promise<ApiResponse<string>> => {
    const params = note ? { note } : {};
    const response = await apiClient.post(`/api/v1/admins/billings/payouts/${id}/mark-paid`, null, { params });
    return response.data;
  },
};

export interface ClassApplicationItem {
  applicationId: string;
  classId: string;
  classTitle: string;
  classCode: string;
  description?: string;
  subject: string;
  grade: string;
  location?: string;
  timeFrame?: string;
  schedule?: string;
  sessionsPerWeek?: number;
  sessionDurationMin?: number;
  studentCount?: number;
  genderRequirement?: string;
  levelFees?: string;
  tutorProposals?: string;
  feePercentage?: number;
  tutorLevelRequirement?: string[];
  tutorId: string;
  tutorName: string;
  tutorPhone: string;
  tutorType?: string;
  tutorActiveClassesCount?: number;
  tutorPendingApplicationsCount?: number;
  parentPhone?: string;
  status: 'PENDING' | 'APPROVED' | 'REJECTED';
  note?: string;
  proposedSalary?: number;
  appliedAt: string;
}

export interface AdminTutorListItem {
  userId: string;
  fullName: string;
  phone: string;
  tutorType?: string;
  verificationStatus: 'UNVERIFIED' | 'PENDING' | 'APPROVED' | 'REJECTED';
  isDeleted: boolean;
  isActive: boolean;
  subjects?: string[];
  location?: string;
  hourlyRate?: number;
  activeClassCount: number;
  estimatedMonthlyEarnings?: number;
  platformFeePerMonth?: number;
  createdAt: string;
}

export type ClassStatus = 'OPEN' | 'ASSIGNED' | 'MATCHED' | 'ACTIVE' | 'COMPLETED' | 'CANCELLED' | 'AUTO_CLOSED';

export interface AdminClassListItem {
  id: string;
  classCode: string;
  title: string;
  subject: string;
  grade: string;
  mode: 'ONLINE' | 'OFFLINE';
  address?: string;
  parentName?: string;
  parentPhone?: string;
  tutorName?: string;
  tutorPhone?: string;
  tutorType?: string;
  parentFee: number;
  tutorFee?: number;
  platformFee?: number;
  feePercentage?: number;
  sessionsPerWeek?: number;
  sessionDurationMin?: number;
  timeFrame?: string;
  schedule?: string;
  genderRequirement?: string;
  /** JSON array [{level, fee}] — học phí Phụ huynh */
  levelFees?: string;
  /** JSON array [{level, fee}] — lương Trung tâm (TT giữ lại) */
  tutorProposals?: string;
  /** Lý do từ chối (chỉ có khi status = CANCELLED) */
  rejectionReason?: string;
  status: ClassStatus;
  learningStartDate?: string;
  
  // Quota Warnings
  missingSessionsThisWeek?: number;
  pendingMakeupCount?: number;

  hasPendingProposals: boolean;
  pendingApplicationCount: number;
  createdAt: string;
}

export interface AdminClassScheduleStatsDTO {
  totalSessions: number;
  completedSessions: number;
  upcomingSessions: number;
  regularCount: number;
  makeupCount: number;
  extraCount: number;
  cancelledCount: number;
  pendingMakeupCount: number;
}

export interface CreateClassBody {
  parentId: string;
  title: string;
  subject: string;
  grade: string;
  mode: 'ONLINE' | 'OFFLINE' | 'IN_PERSON';
  address?: string;
  schedule?: string;
  sessionsPerWeek: number;
  sessionDurationMin: number;
  timeFrame?: string;
  parentFee: number;
  feePercentage: number;
  levelFees?: string;
  genderRequirement?: string;
  startDate?: string;
  endDate?: string;
}

export interface DashboardMonthCount {
  label: string;
  count: number;
}

export interface DashboardStats {
  totalUsers: number;
  activeTutors: number;
  openClasses: number;
  activeClasses: number;
  pendingVerifications: number;
  tutorCount: number;
  parentCount: number;
  studentCount: number;
  adminCount: number;
  estimatedMonthlyRevenue: number;
  newUsersPerMonth: DashboardMonthCount[];
}

export type BillingStatusType = 'DRAFT' | 'UNPAID' | 'VERIFYING' | 'PAID';
export type PayoutStatusType = 'LOCKED' | 'PENDING' | 'PAID_OUT';

export interface AdminBillingItem {
  id: string;
  classId: string;
  classCode: string;
  classTitle: string;
  parentId: string;
  parentName: string;
  studentNames: string;
  month: number;
  year: number;
  totalSessions: number;
  parentFeeAmount: number;
  transactionCode: string;
  status: BillingStatusType;
  verifiedByAdminId: string | null;
  verifiedAt: string | null;
  createdAt: string;
}

export interface AdminTutorPayoutItem {
  id: string;
  tutorId: string;
  tutorName: string;
  tutorPhone: string;
  tutorBankName: string | null;
  tutorBankAccount: string | null;
  tutorBankOwner: string | null;
  classId: string;
  classTitle: string;
  month: number;
  year: number;
  amount: number;
  transactionCode: string;
  status: PayoutStatusType;
  adminNote: string | null;
  paidAt: string | null;
  confirmedByTutorAt: string | null;
  createdAt: string;
}
