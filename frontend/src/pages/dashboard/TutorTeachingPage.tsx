import { useState, useEffect, useRef } from 'react';
import {
  ClipboardList, FileText, Plus, Upload, Download, Trash2,
  Clock, Users, Send
} from 'lucide-react';
import { tutorApi } from '../../services/tutorApi';
import type { TutorClassDTO } from '../../services/tutorApi';
import { teachingApi } from '../../services/teachingApi';
import type { AssessmentDTO, SubmissionDTO, MaterialDTO, AssessmentType } from '../../services/teachingApi';
import apiClient from '../../services/apiClient';
import './TutorTeaching.css';
import './Dashboard.css';

/* ── Helpers ──────────────────────────────────────────── */

function formatDate(iso: string | null): string {
  if (!iso) return '—';
  return new Date(iso).toLocaleDateString('vi-VN', {
    day: '2-digit', month: '2-digit', year: 'numeric',
    hour: '2-digit', minute: '2-digit',
  });
}

function formatFileSize(bytes: number | null): string {
  if (!bytes) return '';
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1048576) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / 1048576).toFixed(1)} MB`;
}

function getMaterialIcon(type: string): { emoji: string; cls: string } {
  switch (type) {
    case 'IMAGE': return { emoji: '🖼️', cls: 'image' };
    case 'VIDEO': return { emoji: '🎬', cls: 'video' };
    case 'DOCUMENT': return { emoji: '📄', cls: 'doc' };
    default: return { emoji: '📎', cls: 'other' };
  }
}

/* ── Tab type ─────────────────────────────────────────── */
type Tab = 'materials' | 'homework' | 'exam';

/* ── Assessment Detail View ──────────────────────────── */
import { FilePreviewModal } from '../../components/FilePreviewModal';

interface AssessmentDetailProps {
  assessment: AssessmentDTO;
  onBack: () => void;
  onPublish: (a: AssessmentDTO) => void;
  onDelete: (a: AssessmentDTO) => void;
}

function AssessmentDetail({ assessment, onBack, onPublish, onDelete }: AssessmentDetailProps) {
  const [submissions, setSubmissions] = useState<SubmissionDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [grading, setGrading] = useState<SubmissionDTO | null>(null);
  const [gradeScore, setGradeScore] = useState('');
  const [gradeComment, setGradeComment] = useState('');
  const [gradeTutorFiles, setGradeTutorFiles] = useState<File[]>([]);
  const [saving, setSaving] = useState(false);
  const [previewFile, setPreviewFile] = useState<{ url: string, name: string, downloadUrl: string } | null>(null);

  useEffect(() => {
    loadSubmissions();
  }, [assessment.id]);

  const loadSubmissions = async () => {
    setLoading(true);
    try {
      const data = await teachingApi.listSubmissions(assessment.id);
      setSubmissions(data);
    } catch { /* empty */ }
    setLoading(false);
  };

  const handleGrade = async () => {
    if (!grading) return;
    setSaving(true);
    try {
      await teachingApi.gradeSubmission(grading.id, {
        score: gradeScore ? Number(gradeScore) : undefined,
        comment: gradeComment || undefined,
        tutorFiles: gradeTutorFiles.length > 0 ? gradeTutorFiles : undefined,
      });
      setGrading(null);
      setGradeScore('');
      setGradeComment('');
      setGradeTutorFiles([]);
      loadSubmissions();
    } catch { /* empty */ }
    setSaving(false);
  };


  return (
    <div>
      <button className="teaching-btn teaching-btn-secondary" onClick={onBack} style={{ marginBottom: 16 }}>
        ← Quay lại
      </button>

      <div className="teaching-card" style={{ cursor: 'default' }}>
        <div className="teaching-card-header">
          <h3 className="teaching-card-title">{assessment.title}</h3>
          <div style={{ display: 'flex', gap: 8 }}>
            <span className={`teaching-badge ${assessment.type === 'HOMEWORK' ? 'badge-homework' : 'badge-exam'}`}>
              {assessment.type === 'HOMEWORK' ? 'Bài tập' : 'Kiểm tra'}
            </span>
            <span className={`teaching-badge ${assessment.isPublished ? 'badge-published' : 'badge-draft'}`}>
              {assessment.isPublished ? 'Đã giao' : 'Nháp'}
            </span>
          </div>
        </div>
        {assessment.description && <p className="teaching-card-desc">{assessment.description}</p>}
        <div className="teaching-card-meta">
          {assessment.closesAt && (
            <span className="teaching-meta-item"><Clock size={13} /> Hạn: {formatDate(assessment.closesAt)}</span>
          )}
          {assessment.attachmentName && (
            <button
              className="teaching-btn teaching-btn-secondary"
              style={{ padding: '4px 10px', fontSize: '0.76rem' }}
              onClick={() => {
                const url = `/api/v1/assessments/${assessment.id}/attachment`;
                setPreviewFile({
                  url,
                  name: assessment.attachmentName!,
                  downloadUrl: url
                });
              }}
            >
              <Download size={12} /> {assessment.attachmentName}
            </button>
          )}
        </div>
        <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
          {!assessment.isPublished && (
            <button className="teaching-btn teaching-btn-primary" onClick={() => onPublish(assessment)}>
              <Send size={14} /> Giao bài
            </button>
          )}
          <button className="teaching-btn teaching-btn-danger" onClick={() => onDelete(assessment)}>
            <Trash2 size={14} /> Xóa
          </button>
        </div>
      </div>

      {/* Submissions list */}
      <h3 style={{ fontSize: '0.95rem', fontWeight: 700, margin: '20px 0 12px', color: 'var(--color-text)' }}>
        📋 Bài nộp ({submissions.length})
      </h3>

      {loading ? (
        <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Đang tải...</p>
      ) : submissions.length === 0 ? (
        <div className="teaching-empty">
          <div className="teaching-empty-icon">📭</div>
          <p>Chưa có bài nộp nào.</p>
        </div>
      ) : (
        <div className="teaching-card" style={{ cursor: 'default', padding: 0 }}>
          {submissions.map(sub => (
            <div key={sub.id} className="submission-item">
              <div className="submission-info">
                <div className="student-name">{sub.studentName || 'Học sinh'}</div>
                <div className="file-name">
                  {sub.fileName} • {formatFileSize(sub.fileSize)} • {formatDate(sub.submittedAt)}
                </div>
              </div>
              <div className="submission-actions">
                {sub.totalScore !== null && (
                  <span className="score-display">{Number(sub.totalScore).toFixed(1)}</span>
                )}
                <span className={`teaching-badge badge-${sub.status.toLowerCase()}`}>
                  {sub.status === 'SUBMITTED' ? 'Đã nộp' : sub.status === 'GRADED' ? 'Đã chấm' : sub.status === 'DRAFT' ? 'Chưa nộp' : sub.status}
                </span>
                {sub.studentAttachments && sub.studentAttachments.length > 0 ? (
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
                    {sub.studentAttachments.map((att, idx) => (
                      <button
                        key={idx}
                        className="teaching-btn teaching-btn-secondary"
                        style={{ padding: '2px 8px', fontSize: '0.7rem' }}
                        onClick={() => {
                          const url = teachingApi.getSubmissionDownloadUrl(sub.id, att.fileUrl, att.fileName);
                          setPreviewFile({
                            url,
                            name: att.fileName,
                            downloadUrl: url
                          });
                        }}
                      >
                        📎 {att.fileName}
                      </button>
                    ))}
                  </div>
                ) : sub.fileName ? (
                  <button
                    className="teaching-btn teaching-btn-secondary"
                    style={{ padding: '2px 8px', fontSize: '0.7rem' }}
                    onClick={() => {
                      const url = `/api/v1/submissions/${sub.id}/download`;
                      setPreviewFile({
                        url,
                        name: sub.fileName!,
                        downloadUrl: url
                      });
                    }}
                  >
                    📎 {sub.fileName}
                  </button>
                ) : (
                  <span style={{ color: 'var(--color-text-muted)' }}>-</span>
                )}
                <button
                  className="teaching-btn teaching-btn-primary"
                  style={{ padding: '4px 10px', fontSize: '0.76rem' }}
                  onClick={() => { setGrading(sub); setGradeScore(sub.totalScore != null ? String(sub.totalScore) : ''); setGradeComment(sub.tutorComment || ''); }}
                >
                  ✍️ Chấm
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Grade modal */}
      {grading && (
        <div className="teaching-modal-backdrop" onClick={() => setGrading(null)}>
          <div className="teaching-modal" onClick={e => e.stopPropagation()}>
            <h2>✍️ Chấm bài — {grading.studentName}</h2>
            <div className="teaching-form-group">
              <label>Điểm</label>
              <div className="grade-input">
                <input
                  type="number"
                  step="0.1"
                  min="0"
                  max="10"
                  value={gradeScore}
                  onChange={e => setGradeScore(e.target.value)}
                  placeholder="0.0"
                />
                <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>/ 10</span>
              </div>
            </div>
            <div className="teaching-form-group">
              <label>Nhận xét</label>
              <textarea
                value={gradeComment}
                onChange={e => setGradeComment(e.target.value)}
                placeholder="Nhận xét cho học sinh..."
                rows={3}
              />
            </div>
            <div className="teaching-form-group">
              <label>File sửa bài (tùy chọn)</label>
              <label className={`teaching-file-upload ${gradeTutorFiles.length > 0 ? 'has-file' : ''}`} style={{ display: 'block' }}>
                <Upload size={24} style={{ color: gradeTutorFiles.length > 0 ? '#10b981' : 'var(--color-text-muted)', margin: '0 auto' }} />
                {gradeTutorFiles.length > 0 ? (
                  gradeTutorFiles.map((f, i) => <p key={i} className="teaching-file-name">📎 {f.name}</p>)
                ) : (
                  <p>Kéo thả hoặc nhấn để chọn nhiều file sửa</p>
                )}
                <input 
                  type="file" 
                  multiple
                  style={{ display: 'none' }} 
                  onChange={e => {
                    if (e.target.files) {
                      setGradeTutorFiles(Array.from(e.target.files));
                    }
                  }} 
                />
              </label>
            </div>
            <div className="teaching-form-actions">
              <button className="teaching-btn teaching-btn-secondary" onClick={() => setGrading(null)}>Hủy</button>
              <button className="teaching-btn teaching-btn-primary" onClick={handleGrade} disabled={saving}>
                {saving ? 'Đang lưu...' : 'Lưu điểm'}
              </button>
            </div>
          </div>
        </div>
      )}

      {previewFile && (
        <FilePreviewModal
          isOpen={true}
          onClose={() => setPreviewFile(null)}
          fileUrl={previewFile.url}
          fileName={previewFile.name}
          downloadUrl={previewFile.downloadUrl}
        />
      )}
    </div>
  );
}

/* ── Date/Time Picker Helper ───────────────────────────── */
function DateTimePicker({ value, onChange }: { value: string, onChange: (v: string) => void }) {
  const [d, t] = value ? value.split('T') : ['', ''];
  
  const handleDate = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.value) {
      onChange('');
    } else {
      onChange(`${e.target.value}T${t || '23:59'}`);
    }
  };

  const handleTime = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.value && !d) {
      onChange('');
    } else {
      onChange(`${d || new Date().toISOString().split('T')[0]}T${e.target.value || '23:59'}`);
    }
  };

  return (
    <div style={{ display: 'flex', gap: '8px' }}>
      <input type="date" value={d} onChange={handleDate} style={{ flex: 3 }} />
      <input type="time" value={t} onChange={handleTime} style={{ flex: 2 }} />
    </div>
  );
}

/* ── Create Assessment Modal ─────────────────────────── */
interface CreateAssessmentModalProps {
  classId: string;
  defaultType: AssessmentType;
  onClose: () => void;
  onCreated: () => void;
}

function CreateAssessmentModal({ classId, defaultType, onClose, onCreated }: CreateAssessmentModalProps) {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [type, setType] = useState<AssessmentType>(defaultType);
  const [opensAt, setOpensAt] = useState('');
  const [closesAt, setClosesAt] = useState('');
  const [durationMin, setDurationMin] = useState('');
  const [file, setFile] = useState<File | null>(null);
  const [saving, setSaving] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

  const handleSubmit = async () => {
    if (!title.trim()) return;
    setSaving(true);
    try {
      await teachingApi.createAssessment(classId, {
        title: title.trim(),
        description: description.trim() || undefined,
        type,
        opensAt: type === 'EXAM' && opensAt ? new Date(opensAt).toISOString() : undefined,
        closesAt: closesAt ? new Date(closesAt).toISOString() : undefined,
        durationMin: type === 'EXAM' && durationMin ? Number(durationMin) : undefined,
        file: file || undefined,
      });
      onCreated();
    } catch { /* empty */ }
    setSaving(false);
  };

  return (
    <div className="teaching-modal-backdrop" onClick={onClose}>
      <div className="teaching-modal" onClick={e => e.stopPropagation()}>
        <h2>📝 Tạo bài tập / kiểm tra</h2>
        <div className="teaching-form-group">
          <label>Tiêu đề *</label>
          <input value={title} onChange={e => setTitle(e.target.value)} placeholder="VD: Bài tập chương 3" />
        </div>
        <div className="teaching-form-group">
          <label>Mô tả</label>
          <textarea value={description} onChange={e => setDescription(e.target.value)} placeholder="Hướng dẫn, yêu cầu..." rows={3} />
        </div>
        <div className="teaching-form-group">
          <label>Loại</label>
          <select value={type} onChange={e => setType(e.target.value as AssessmentType)}>
            <option value="HOMEWORK">Bài tập</option>
            <option value="EXAM">Kiểm tra</option>
          </select>
        </div>
        <div className="teaching-form-group">
          <label>Hạn nộp {type === 'EXAM' && '(Bắt buộc)'}</label>
          <DateTimePicker value={closesAt} onChange={setClosesAt} />
        </div>
        {type === 'EXAM' && (
          <>
            <div className="teaching-form-group">
              <label>Giờ bắt đầu làm bài (Mở đề)</label>
              <DateTimePicker value={opensAt} onChange={setOpensAt} />
            </div>
            <div className="teaching-form-group">
              <label>Thời gian làm bài (Phút)</label>
              <input type="number" min="1" value={durationMin} onChange={e => setDurationMin(e.target.value)} placeholder="VD: 45" />
            </div>
          </>
        )}
        <div className="teaching-form-group">
          <label>File đề bài (tùy chọn)</label>
          <div
            className={`teaching-file-upload ${file ? 'has-file' : ''}`}
            onClick={() => fileRef.current?.click()}
          >
            <Upload size={24} style={{ color: file ? '#10b981' : 'var(--color-text-muted)' }} />
            {file ? (
              <p className="teaching-file-name">📎 {file.name} ({formatFileSize(file.size)})</p>
            ) : (
              <p>Kéo thả hoặc nhấn để chọn file</p>
            )}
            <input ref={fileRef} type="file" onChange={e => setFile(e.target.files?.[0] || null)} />
          </div>
        </div>
        <div className="teaching-form-actions">
          <button className="teaching-btn teaching-btn-secondary" onClick={onClose}>Hủy</button>
          <button className="teaching-btn teaching-btn-primary" onClick={handleSubmit} disabled={saving || !title.trim()}>
            {saving ? 'Đang tạo...' : 'Tạo bài'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ── Upload Material Modal ───────────────────────────── */
interface UploadMaterialModalProps {
  classId: string;
  onClose: () => void;
  onUploaded: () => void;
}

function UploadMaterialModal({ classId, onClose, onUploaded }: UploadMaterialModalProps) {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [file, setFile] = useState<File | null>(null);
  const [saving, setSaving] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

  const handleSubmit = async () => {
    if (!title.trim() || !file) return;
    setSaving(true);
    try {
      await teachingApi.uploadMaterial(classId, {
        title: title.trim(),
        description: description.trim() || undefined,
        file,
      });
      onUploaded();
    } catch { /* empty */ }
    setSaving(false);
  };

  return (
    <div className="teaching-modal-backdrop" onClick={onClose}>
      <div className="teaching-modal" onClick={e => e.stopPropagation()}>
        <h2>📁 Upload tài liệu</h2>
        <div className="teaching-form-group">
          <label>Tiêu đề *</label>
          <input value={title} onChange={e => setTitle(e.target.value)} placeholder="VD: Slide bài giảng tuần 5" />
        </div>
        <div className="teaching-form-group">
          <label>Mô tả</label>
          <textarea value={description} onChange={e => setDescription(e.target.value)} placeholder="Mô tả tài liệu..." rows={2} />
        </div>
        <div className="teaching-form-group">
          <label>File tài liệu *</label>
          <div
            className={`teaching-file-upload ${file ? 'has-file' : ''}`}
            onClick={() => fileRef.current?.click()}
          >
            <Upload size={24} style={{ color: file ? '#10b981' : 'var(--color-text-muted)' }} />
            {file ? (
              <p className="teaching-file-name">📎 {file.name} ({formatFileSize(file.size)})</p>
            ) : (
              <p>Kéo thả hoặc nhấn để chọn file</p>
            )}
            <input ref={fileRef} type="file" onChange={e => setFile(e.target.files?.[0] || null)} />
          </div>
        </div>
        <div className="teaching-form-actions">
          <button className="teaching-btn teaching-btn-secondary" onClick={onClose}>Hủy</button>
          <button className="teaching-btn teaching-btn-primary" onClick={handleSubmit} disabled={saving || !title.trim() || !file}>
            {saving ? 'Đang tải...' : 'Upload'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ══════════════════════════════════════════════════════
   MAIN: TutorTeachingPage
   ══════════════════════════════════════════════════════ */
export const TutorTeachingPage = () => {
  const [classes, setClasses] = useState<TutorClassDTO[]>([]);
  const [selectedClassId, setSelectedClassId] = useState<string>('');
  const [tab, setTab] = useState<Tab>('materials');

  // Assessments
  const [assessments, setAssessments] = useState<AssessmentDTO[]>([]);
  const [selectedAssessment, setSelectedAssessment] = useState<AssessmentDTO | null>(null);
  const [showCreateModal, setShowCreateModal] = useState(false);

  const [materials, setMaterials] = useState<MaterialDTO[]>([]);
  const [showUploadModal, setShowUploadModal] = useState(false);
  const [previewFile, setPreviewFile] = useState<{ url: string, name: string, downloadUrl: string } | null>(null);

  const [loading, setLoading] = useState(false);

  useEffect(() => {
    tutorApi.getMyClasses().then(data => {
      setClasses(data);
      if (data.length > 0) setSelectedClassId(data[0].id);
    }).catch(() => {});
  }, []);

  useEffect(() => {
    if (!selectedClassId) return;
    loadData();
  }, [selectedClassId, tab]);

  const loadData = async () => {
    setLoading(true);
    try {
      if (tab === 'homework' || tab === 'exam') {
        const assessmentType = tab === 'homework' ? 'HOMEWORK' : 'EXAM';
        const data = await teachingApi.listAssessments(selectedClassId, assessmentType);
        setAssessments(data);
      } else {
        const data = await teachingApi.listMaterials(selectedClassId);
        setMaterials(data);
      }
    } catch { /* empty */ }
    setLoading(false);
  };

  const handlePublish = async (assessment: AssessmentDTO) => {
    if (!confirm('Giao bài cho tất cả học sinh?')) return;
    try {
      await teachingApi.publishAssessment(assessment.id, [], []);
      loadData();
      setSelectedAssessment(null);
    } catch { /* empty */ }
  };

  const handleDeleteAssessment = async (assessment: AssessmentDTO) => {
    if (!confirm(`Xóa "${assessment.title}"?`)) return;
    try {
      await teachingApi.deleteAssessment(assessment.id);
      loadData();
      setSelectedAssessment(null);
    } catch { /* empty */ }
  };

  const handleDeleteMaterial = async (material: MaterialDTO) => {
    if (!confirm(`Xóa tài liệu "${material.title}"?`)) return;
    try {
      await teachingApi.deleteMaterial(material.id);
      loadData();
    } catch { /* empty */ }
  };

  const handleDownloadMaterial = async (material: MaterialDTO) => {
    try {
      const response = await apiClient.get(material.downloadUrl, { responseType: 'blob' });
      const blobUrl = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = blobUrl;
      link.download = material.fileName;
      link.click();
      window.URL.revokeObjectURL(blobUrl);
    } catch { /* empty */ }
  };

  // If viewing assessment detail
  if (selectedAssessment) {
    return (
      <div className="teaching-page">
        <AssessmentDetail
          assessment={selectedAssessment}
          onBack={() => setSelectedAssessment(null)}
          onPublish={handlePublish}
          onDelete={handleDeleteAssessment}
        />
      </div>
    );
  }

  return (
    <div className="teaching-page">
      {/* Header */}
      <div className="teaching-header">
        <h1>📚 Giảng dạy</h1>
        <select
          className="teaching-class-select"
          value={selectedClassId}
          onChange={e => { setSelectedClassId(e.target.value); setSelectedAssessment(null); }}
        >
          {classes.length === 0 && <option value="">Chưa có lớp nào</option>}
          {classes.map(cls => (
            <option key={cls.id} value={cls.id}>
              {cls.title} — {cls.subject} ({cls.grade})
            </option>
          ))}
        </select>
      </div>

      {/* 3 Tabs — giống App */}
      <div className="teaching-tabs">
        <button className={`teaching-tab ${tab === 'materials' ? 'active' : ''}`} onClick={() => setTab('materials')}>
          <FileText size={16} /> Tài liệu
        </button>
        <button className={`teaching-tab ${tab === 'homework' ? 'active' : ''}`} onClick={() => setTab('homework')}>
          <ClipboardList size={16} /> Bài tập
        </button>
        <button className={`teaching-tab ${tab === 'exam' ? 'active' : ''}`} onClick={() => setTab('exam')}>
          <FileText size={16} /> Kiểm tra
        </button>
      </div>

      {!selectedClassId ? (
        <div className="teaching-empty">
          <div className="teaching-empty-icon">📭</div>
          <p>Bạn chưa được phân công lớp nào.</p>
        </div>
      ) : loading ? (
        <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem', textAlign: 'center', padding: 32 }}>Đang tải...</p>
      ) : (
        <>
          {/* ── Homework / Exam Tab ── */}
          {(tab === 'homework' || tab === 'exam') && (
            <>
              <div style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: 14 }}>
                <button className="teaching-btn teaching-btn-primary" onClick={() => setShowCreateModal(true)}>
                  <Plus size={16} /> {tab === 'homework' ? 'Giao bài' : 'Tạo đề'}
                </button>
              </div>

              {assessments.length === 0 ? (
                <div className="teaching-empty">
                  <div className="teaching-empty-icon">{tab === 'homework' ? '📝' : '📋'}</div>
                  <p>Chưa có {tab === 'homework' ? 'bài tập' : 'đề kiểm tra'} nào.</p>
                </div>
              ) : (
                assessments.map(a => (
                  <div key={a.id} className="teaching-card" onClick={() => setSelectedAssessment(a)}>
                    <div className="teaching-card-header">
                      <h3 className="teaching-card-title">{a.title}</h3>
                      <div style={{ display: 'flex', gap: 6 }}>
                        <span className={`teaching-badge ${a.type === 'HOMEWORK' ? 'badge-homework' : 'badge-exam'}`}>
                          {a.type === 'HOMEWORK' ? 'Bài tập' : 'Kiểm tra'}
                        </span>
                        <span className={`teaching-badge ${a.isPublished ? 'badge-published' : 'badge-draft'}`}>
                          {a.isPublished ? 'Đã giao' : 'Nháp'}
                        </span>
                      </div>
                    </div>
                    {a.description && <p className="teaching-card-desc">{a.description}</p>}
                    <div className="teaching-card-meta">
                      {a.closesAt && <span className="teaching-meta-item"><Clock size={13} /> Hạn: {formatDate(a.closesAt)}</span>}
                      {a.submittedCount != null && (
                        <span className="teaching-meta-item"><Users size={13} /> {a.submittedCount}/{a.totalStudents} đã nộp</span>
                      )}
                      {a.attachmentName && <span className="teaching-meta-item"><FileText size={13} /> {a.attachmentName}</span>}
                      <span className="teaching-meta-item"><Clock size={13} /> {formatDate(a.createdAt)}</span>
                    </div>
                  </div>
                ))
              )}
            </>
          )}

          {/* ── Materials Tab ── */}
          {tab === 'materials' && (
            <>
              <div style={{ display: 'flex', justifyContent: 'flex-end', marginBottom: 14 }}>
                <button className="teaching-btn teaching-btn-primary" onClick={() => setShowUploadModal(true)}>
                  <Upload size={16} /> Upload tài liệu
                </button>
              </div>

              {materials.length === 0 ? (
                <div className="teaching-empty">
                  <div className="teaching-empty-icon">📁</div>
                  <p>Chưa có tài liệu nào.</p>
                </div>
              ) : (
                materials.map(m => {
                  const icon = getMaterialIcon(m.type);
                  return (
                    <div 
                      key={m.id} 
                      className="material-item" 
                      style={{ cursor: 'pointer' }}
                      onClick={() => {
                          setPreviewFile({
                            url: m.downloadUrl,
                            name: m.fileName,
                            downloadUrl: m.downloadUrl
                          });
                      }}
                    >
                      <div className={`material-icon ${icon.cls}`}>{icon.emoji}</div>
                      <div className="material-info">
                        <div className="material-title" style={{ color: '#6366f1' }}>{m.title}</div>
                        <div className="material-meta">
                          {m.fileName} • {formatFileSize(m.fileSize)} • {formatDate(m.createdAt)}
                        </div>
                      </div>
                      <div className="material-actions">
                        <button
                          className="teaching-btn teaching-btn-secondary"
                          style={{ padding: '6px 12px', fontSize: '0.78rem' }}
                          onClick={(e) => {
                            e.stopPropagation();
                            handleDownloadMaterial(m);
                          }}
                        >
                          <Download size={13} />
                        </button>
                        <button
                          className="teaching-btn teaching-btn-danger"
                          style={{ padding: '6px 12px', fontSize: '0.78rem' }}
                          onClick={(e) => {
                            e.stopPropagation();
                            handleDeleteMaterial(m);
                          }}
                        >
                          <Trash2 size={13} />
                        </button>
                      </div>
                    </div>
                  );
                })
              )}
            </>
          )}
        </>
      )}

      {/* Modals */}
      {showCreateModal && selectedClassId && (
        <CreateAssessmentModal
          classId={selectedClassId}
          defaultType={tab === 'exam' ? 'EXAM' : 'HOMEWORK'}
          onClose={() => setShowCreateModal(false)}
          onCreated={() => { setShowCreateModal(false); loadData(); }}
        />
      )}
      {showUploadModal && selectedClassId && (
        <UploadMaterialModal
          classId={selectedClassId}
          onClose={() => setShowUploadModal(false)}
          onUploaded={() => { setShowUploadModal(false); loadData(); }}
        />
      )}

      {previewFile && (
        <FilePreviewModal
          isOpen={true}
          onClose={() => setPreviewFile(null)}
          fileUrl={previewFile.url}
          fileName={previewFile.name}
          downloadUrl={previewFile.downloadUrl}
        />
      )}
    </div>
  );
};
