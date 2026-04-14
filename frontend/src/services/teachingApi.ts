/**
 * teachingApi.ts — API client for Teaching module (Assessments, Submissions, Materials)
 */
import apiClient from './apiClient';

/* ── Types ───────────────────────────────────────────────────────── */

export type AssessmentType = 'HOMEWORK' | 'EXAM';
export type SubmissionStatus = 'DRAFT' | 'SUBMITTED' | 'GRADED' | 'COMPLETED';

export interface AssessmentDTO {
  id: string;
  classId: string;
  createdBy: string;
  title: string;
  description: string | null;
  type: AssessmentType;
  opensAt: string | null;
  closesAt: string | null;
  durationMin: number | null;
  totalScore: number | null;
  passScore: number | null;
  attachmentName: string | null;
  attachmentDownloadUrl: string | null;
  isPublished: boolean;
  submittedCount: number | null;
  totalStudents: number | null;
  createdAt: string;
}

export interface AttachmentInfo {
  fileUrl: string;
  fileName: string;
  fileSize: number | null;
}

export interface SubmissionDTO {
  id: string;
  assessmentId: string;
  studentId: string;
  status: SubmissionStatus;
  totalScore: number | null;
  tutorComment: string | null;
  fileName: string | null;
  fileSize: number | null;
  downloadUrl: string | null;
  tutorFileName: string | null;
  tutorFileDownloadUrl: string | null;
  studentAttachments: AttachmentInfo[] | null;
  tutorAttachments: AttachmentInfo[] | null;
  submittedAt: string | null;
  gradedAt: string | null;
  completedAt: string | null;
  createdAt: string;
  studentName: string | null;
}

export type MaterialType = 'DOCUMENT' | 'IMAGE' | 'VIDEO' | 'OTHER';

export interface MaterialDTO {
  id: string;
  classId: string;
  uploadedBy: string;
  title: string;
  description: string | null;
  type: MaterialType;
  fileName: string;
  mimeType: string | null;
  fileSize: number;
  downloadUrl: string;
  createdAt: string;
}

interface ApiResponse<T> {
  data: T;
  message?: string;
}

/* ── Helpers ─────────────────────────────────────────────────────── */

const unwrap = <T>(res: { data: ApiResponse<T> }): T => res.data.data;

function buildBaseUrl(): string {
  return import.meta.env.VITE_API_URL || 'http://localhost:8080';
}

/* ── API ─────────────────────────────────────────────────────────── */

export const teachingApi = {
  // ─── Assessments ──────────────────────────────────────────────

  /** List assessments for a class (optional filter by type) */
  listAssessments: async (classId: string, type?: AssessmentType): Promise<AssessmentDTO[]> => {
    const res = await apiClient.get(`/api/v1/classes/${classId}/assessments`, {
      params: type ? { type } : undefined,
    });
    return unwrap(res);
  },

  /** Create assessment (TUTOR only) — multipart */
  createAssessment: async (
    classId: string,
    data: {
      title: string;
      description?: string;
      type: AssessmentType;
      opensAt?: string;
      closesAt?: string;
      durationMin?: number;
      file?: File;
    }
  ): Promise<AssessmentDTO> => {
    const formData = new FormData();
    formData.append('title', data.title);
    formData.append('type', data.type);
    if (data.description) formData.append('description', data.description);
    if (data.opensAt) formData.append('opensAt', data.opensAt);
    if (data.closesAt) formData.append('closesAt', data.closesAt);
    if (data.durationMin) formData.append('durationMin', String(data.durationMin));
    if (data.file) formData.append('file', data.file);

    const res = await apiClient.post(`/api/v1/classes/${classId}/assessments`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return unwrap(res);
  },

  /** Publish assessment → sends notifications */
  publishAssessment: async (
    assessmentId: string,
    studentIds: string[],
    parentIds: string[]
  ): Promise<AssessmentDTO> => {
    const res = await apiClient.patch(`/api/v1/assessments/${assessmentId}/publish`, null, {
      params: {
        studentIds: studentIds.join(','),
        parentIds: parentIds.join(','),
      },
    });
    return unwrap(res);
  },

  /** Get assessment detail */
  getAssessmentDetail: async (assessmentId: string): Promise<AssessmentDTO> => {
    const res = await apiClient.get(`/api/v1/assessments/${assessmentId}`);
    return unwrap(res);
  },

  /** Delete assessment (TUTOR only) */
  deleteAssessment: async (assessmentId: string): Promise<void> => {
    await apiClient.delete(`/api/v1/assessments/${assessmentId}`);
  },

  /** Download assessment attachment URL */
  getAssessmentAttachmentUrl: (assessmentId: string): string => {
    return `${buildBaseUrl()}/api/v1/assessments/${assessmentId}/attachment`;
  },

  // ─── Submissions ──────────────────────────────────────────────

  /** Student submits assignment (upload file) */
  submitAssignment: async (assessmentId: string, files: File[]): Promise<SubmissionDTO> => {
    const formData = new FormData();
    files.forEach(f => formData.append('files', f));

    const res = await apiClient.post(
      `/api/v1/assessments/${assessmentId}/submissions`,
      formData,
      { headers: { 'Content-Type': 'multipart/form-data' } }
    );
    return unwrap(res);
  },

  /** Student views own submission */
  getMySubmission: async (assessmentId: string): Promise<SubmissionDTO | null> => {
    const res = await apiClient.get(`/api/v1/assessments/${assessmentId}/my-submission`);
    return unwrap(res);
  },

  /** Tutor/Parent lists all submissions for an assessment */
  listSubmissions: async (assessmentId: string): Promise<SubmissionDTO[]> => {
    const res = await apiClient.get(`/api/v1/assessments/${assessmentId}/submissions`);
    return unwrap(res);
  },

  /** Tutor grades a submission */
  gradeSubmission: async (
    submissionId: string,
    data: { score?: number; comment?: string; tutorFiles?: File[] }
  ): Promise<SubmissionDTO> => {
    const formData = new FormData();
    if (data.score !== undefined) formData.append('score', String(data.score));
    if (data.comment) formData.append('comment', data.comment);
    if (data.tutorFiles) {
      data.tutorFiles.forEach(f => formData.append('tutorFiles', f));
    }

    const res = await apiClient.patch(`/api/v1/submissions/${submissionId}/grade`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return unwrap(res);
  },

  /** Download submission file URL */
  getSubmissionDownloadUrl: (submissionId: string, urlParam?: string, fileName?: string): string => {
    let url = `${buildBaseUrl()}/api/v1/submissions/${submissionId}/download`;
    const params = new URLSearchParams();
    if (urlParam) params.append('url', urlParam);
    if (fileName) params.append('fileName', fileName);
    const qs = params.toString();
    return qs ? `${url}?${qs}` : url;
  },

  /** Download tutor correction file URL */
  getTutorFileDownloadUrl: (submissionId: string, urlParam?: string, fileName?: string): string => {
    let url = `${buildBaseUrl()}/api/v1/submissions/${submissionId}/tutor-download`;
    const params = new URLSearchParams();
    if (urlParam) params.append('url', urlParam);
    if (fileName) params.append('fileName', fileName);
    const qs = params.toString();
    return qs ? `${url}?${qs}` : url;
  },

  // ─── Materials ────────────────────────────────────────────────

  /** List materials for a class */
  listMaterials: async (classId: string): Promise<MaterialDTO[]> => {
    const res = await apiClient.get(`/api/v1/classes/${classId}/materials`);
    return unwrap(res);
  },

  /** Upload material (TUTOR only) — multipart */
  uploadMaterial: async (
    classId: string,
    data: { title: string; description?: string; file: File }
  ): Promise<MaterialDTO> => {
    const formData = new FormData();
    formData.append('title', data.title);
    if (data.description) formData.append('description', data.description);
    formData.append('file', data.file);

    const res = await apiClient.post(`/api/v1/classes/${classId}/materials`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return unwrap(res);
  },

  /** Delete material (TUTOR only) */
  deleteMaterial: async (materialId: string): Promise<void> => {
    await apiClient.delete(`/api/v1/materials/${materialId}`);
  },

  /** Download material URL */
  getMaterialDownloadUrl: (materialId: string): string => {
    return `${buildBaseUrl()}/api/v1/materials/${materialId}/download`;
  },

  // ─── Progress ────────────────────────────────────────────────

  /** Get progress summary for a class (Parent/Tutor) */
  getProgressSummary: async (classId: string): Promise<ProgressSummaryDTO> => {
    const res = await apiClient.get(`/api/v1/classes/${classId}/progress/summary`);
    return unwrap(res);
  },
};

/* ── Progress types ─────────────────────────────────────────────── */

export interface StudentProgressDTO {
  assessmentId: string;
  assessmentTitle: string;
  type: 'HOMEWORK' | 'EXAM';
  status: 'PENDING' | 'SUBMITTED' | 'GRADED' | 'COMPLETED';
  score: number | null;
  totalScore: number | null;
  tutorComment: string | null;
  closesAt: string | null;
  submittedAt: string | null;
  gradedAt: string | null;
}

export interface ProgressSummaryDTO {
  homeworkAvgScore: number;
  examAvgScore: number;
  pendingHomeworkCount: number;
  upcomingExamCount: number;
  totalHomework: number;
  totalExam: number;
  details: StudentProgressDTO[];
}
