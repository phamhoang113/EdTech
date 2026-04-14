import { useState, useEffect, useRef } from 'react';
import {
  ClipboardList, FileText, Download, Clock,
  Upload, CheckCircle, AlertCircle, Eye
} from 'lucide-react';
import { parentApi } from '../../services/parentApi';
import type { ParentClass } from '../../services/parentApi';
import { teachingApi } from '../../services/teachingApi';
import type { AssessmentDTO, SubmissionDTO, MaterialDTO } from '../../services/teachingApi';
import apiClient from '../../services/apiClient';
import { FilePreviewModal } from '../../components/FilePreviewModal';
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

function isOverdue(closesAt: string | null): boolean {
  if (!closesAt) return false;
  return new Date(closesAt) < new Date();
}

type Tab = 'materials' | 'homework' | 'exam';

/* ── Submit Modal ─────────────────────────────────────── */
interface SubmitModalProps {
  assessment: AssessmentDTO;
  onClose: () => void;
  onSubmitted: () => void;
}

function SubmitModal({ assessment, onClose, onSubmitted }: SubmitModalProps) {
  const [files, setFiles] = useState<File[]>([]);
  const [saving, setSaving] = useState(false);
  const fileRef = useRef<HTMLInputElement>(null);

  const handleSubmit = async () => {
    if (files.length === 0) return;
    setSaving(true);
    try {
      await teachingApi.submitAssignment(assessment.id, files);
      onSubmitted();
    } catch { /* empty */ }
    setSaving(false);
  };

  return (
    <div className="teaching-modal-backdrop" onClick={onClose}>
      <div className="teaching-modal" onClick={e => e.stopPropagation()}>
        <h2>📤 Nộp bài — {assessment.title}</h2>
        {assessment.closesAt && (
          <p style={{
            fontSize: '0.82rem',
            color: isOverdue(assessment.closesAt) ? '#ef4444' : 'var(--color-text-muted)',
            marginBottom: 16
          }}>
            <Clock size={13} style={{ verticalAlign: -2 }} /> Hạn nộp: {formatDate(assessment.closesAt)}
            {isOverdue(assessment.closesAt) && ' (Quá hạn!)'}
          </p>
        )}
        <div className="teaching-form-group">
          <label>File bài làm *</label>
          <div
            className={`teaching-file-upload ${files.length > 0 ? 'has-file' : ''}`}
            onClick={() => fileRef.current?.click()}
          >
            <Upload size={24} style={{ color: files.length > 0 ? '#10b981' : 'var(--color-text-muted)' }} />
            {files.length > 0 ? (
              files.map((f, i) => <p key={i} className="teaching-file-name">📎 {f.name}</p>)
            ) : (
              <p>Chọn nhiều file bài làm để nộp</p>
            )}
            <input 
              ref={fileRef} 
              type="file" 
              multiple
              onChange={e => {
                if (e.target.files) {
                  setFiles(Array.from(e.target.files));
                }
              }} 
              style={{ display: 'none' }}
            />
          </div>
        </div>
        <div className="teaching-form-actions">
          <button className="teaching-btn teaching-btn-secondary" onClick={onClose}>Hủy</button>
          <button className="teaching-btn teaching-btn-primary" onClick={handleSubmit} disabled={saving || files.length === 0}>
            {saving ? 'Đang nộp...' : 'Nộp bài'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ── Assessment Detail — xem bài nộp của tất cả HS ──── */
interface AssessmentDetailProps {
  assessment: AssessmentDTO;
  onBack: () => void;
}

function AssessmentSubmissions({ assessment, onBack }: AssessmentDetailProps) {
  const [submissions, setSubmissions] = useState<SubmissionDTO[]>([]);
  const [loading, setLoading] = useState(true);
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

  const handleDownload = async (url: string, filename: string) => {
    try {
      const response = await apiClient.get(url, { responseType: 'blob' });
      const blobUrl = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = blobUrl;
      link.download = filename;
      link.click();
      window.URL.revokeObjectURL(blobUrl);
    } catch { /* empty */ }
  };

  return (
    <div>
      <button className="teaching-btn teaching-btn-secondary" onClick={onBack} style={{ marginBottom: 16 }}>← Quay lại</button>

      <div className="teaching-card" style={{ cursor: 'default' }}>
        <div className="teaching-card-header">
          <h3 className="teaching-card-title">{assessment.title}</h3>
          <span className={`teaching-badge ${assessment.type === 'HOMEWORK' ? 'badge-homework' : 'badge-exam'}`}>
            {assessment.type === 'HOMEWORK' ? 'Bài tập' : 'Kiểm tra'}
          </span>
        </div>
        {assessment.description && <p className="teaching-card-desc">{assessment.description}</p>}
        <div className="teaching-card-meta">
          {assessment.closesAt && <span className="teaching-meta-item"><Clock size={13} /> Hạn: {formatDate(assessment.closesAt)}</span>}
          {assessment.attachmentName && (
            <button
              className="teaching-btn teaching-btn-secondary"
              style={{ padding: '4px 10px', fontSize: '0.76rem' }}
              onClick={() => {
                const url = `/api/v1/assessments/${assessment.id}/attachment`;
                setPreviewFile({
                  url: url,
                  name: assessment.attachmentName!,
                  downloadUrl: url
                });
              }}
            >
              <Download size={12} /> Đề bài
            </button>
          )}
        </div>
      </div>

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
                {sub.studentAttachments && sub.studentAttachments.length > 0 ? (
                  <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', marginTop: 4 }}>
                    {sub.studentAttachments.map((att, idx) => (
                      <div key={idx} style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        <span 
                          style={{ cursor: 'pointer', color: '#6366f1', fontSize: '0.82rem', textDecoration: 'underline' }}
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
                        </span>
                        {att.fileSize && (
                          <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                            ({formatFileSize(att.fileSize)})
                          </span>
                        )}
                      </div>
                    ))}
                  </div>
                ) : sub.fileName && (
                  <div className="file-name">
                    {sub.fileName} • {formatFileSize(sub.fileSize)} • Nộp: {formatDate(sub.submittedAt)}
                  </div>
                )}
                {sub.tutorComment && (
                  <div style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', marginTop: 4 }}>
                    💬 GS nhận xét: {sub.tutorComment}
                  </div>
                )}
              </div>
              <div className="submission-actions">
                {sub.totalScore !== null && <span className="score-display">{Number(sub.totalScore).toFixed(1)}</span>}
                <span className={`teaching-badge badge-${sub.status.toLowerCase()}`}>
                  {sub.status === 'SUBMITTED' ? 'Đã nộp' : sub.status === 'GRADED' ? 'Đã chấm' : sub.status === 'COMPLETED' ? 'Hoàn thành' : sub.status}
                </span>
                <button className="teaching-btn teaching-btn-secondary" style={{ padding: '4px 10px', fontSize: '0.76rem' }}
                  onClick={() => handleDownload(`/api/v1/submissions/${sub.id}/download`, sub.fileName || 'download')}>
                  <Download size={12} />
                </button>
                {sub.tutorFileName && (
                  <button className="teaching-btn teaching-btn-secondary" style={{ padding: '4px 10px', fontSize: '0.76rem' }}
                    onClick={() => handleDownload(`/api/v1/submissions/${sub.id}/tutor-download`, sub.tutorFileName!)}>
                    <Download size={12} /> Bài sửa
                  </button>
                )}
              </div>
            </div>
          ))}
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

/* ══════════════════════════════════════════════════════
   MAIN: ParentTeachingPage
   ══════════════════════════════════════════════════════ */
export const ParentTeachingPage = () => {
  const [classes, setClasses] = useState<ParentClass[]>([]);
  const [selectedClassId, setSelectedClassId] = useState<string>('');
  const [tab, setTab] = useState<Tab>('materials');

  // Assessments (split by type like mobile)
  const [assessments, setAssessments] = useState<AssessmentDTO[]>([]);
  const [mySubmissions, setMySubmissions] = useState<Record<string, SubmissionDTO | null>>({});
  const [selectedAssessment, setSelectedAssessment] = useState<AssessmentDTO | null>(null);
  const [submitTarget, setSubmitTarget] = useState<AssessmentDTO | null>(null);
  const [previewFile, setPreviewFile] = useState<{ url: string, name: string, downloadUrl: string } | null>(null);

  // Materials
  const [materials, setMaterials] = useState<MaterialDTO[]>([]);

  const [loading, setLoading] = useState(false);

  useEffect(() => {
    parentApi.getMyClasses().then(res => {
      const classList = res.data || [];
      const activeClasses = classList.filter(c => c.status === 'ACTIVE' || c.status === 'MATCHED');
      setClasses(activeClasses);
      if (activeClasses.length > 0) setSelectedClassId(activeClasses[0].id);
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
        const published = data.filter(a => a.isPublished);
        // Thay vì filter bài nộp của chính PH (getMySubmission), ta sẽ gọi listSubmissions 
        // để lấy bài nộp của học sinh (con) trong lớp đó
        const subs: Record<string, SubmissionDTO | null> = {};
        await Promise.all(
          published.map(async (a) => {
            try {
              const list = await teachingApi.listSubmissions(a.id);
              subs[a.id] = list.length > 0 ? list[0] : null;
            } catch {
              subs[a.id] = null;
            }
          })
        );

        // Sắp xếp: Chưa nộp lên đầu tiên
        published.sort((a, b) => {
          const aHasSub = subs[a.id] ? 1 : 0;
          const bHasSub = subs[b.id] ? 1 : 0;
          return aHasSub - bHasSub;
        });

        setAssessments(published);
        setMySubmissions(subs);
      } else {
        const data = await teachingApi.listMaterials(selectedClassId);
        setMaterials(data);
      }
    } catch { /* empty */ }
    setLoading(false);
  };

  const handleDownload = async (url: string, filename: string) => {
    try {
      const response = await apiClient.get(url, { responseType: 'blob' });
      const blobUrl = window.URL.createObjectURL(new Blob([response.data]));
      const link = document.createElement('a');
      link.href = blobUrl;
      link.download = filename;
      link.click();
      window.URL.revokeObjectURL(blobUrl);
    } catch { /* empty */ }
  };

  const getSubmissionStatusLabel = (sub: SubmissionDTO | null): { text: string; cls: string } => {
    if (!sub || sub.status === 'DRAFT') return { text: 'Chưa nộp', cls: 'badge-draft' };
    switch (sub.status) {
      case 'SUBMITTED': return { text: 'Đã nộp', cls: 'badge-submitted' };
      case 'GRADED': return { text: 'Đã chấm', cls: 'badge-graded' };
      case 'COMPLETED': return { text: 'Hoàn thành', cls: 'badge-completed' };
      default: return { text: sub.status, cls: 'badge-draft' };
    }
  };

  // Detail view — xem bài nộp tất cả HS
  if (selectedAssessment) {
    return (
      <div className="teaching-page">
        <AssessmentSubmissions
          assessment={selectedAssessment}
          onBack={() => setSelectedAssessment(null)}
        />
      </div>
    );
  }

  return (
    <div className="teaching-page">
      {/* Header */}
      <div className="teaching-header">
        <h1>📖 Học tập</h1>
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
          <p>Chưa có lớp nào đang hoạt động.</p>
        </div>
      ) : loading ? (
        <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem', textAlign: 'center', padding: 32 }}>Đang tải...</p>
      ) : (
        <>
          {/* ── Homework / Exam Tab ── */}
          {(tab === 'homework' || tab === 'exam') && (
            assessments.length === 0 ? (
              <div className="teaching-empty">
                <div className="teaching-empty-icon">{tab === 'homework' ? '📝' : '📋'}</div>
                <p>Chưa có {tab === 'homework' ? 'bài tập' : 'đề kiểm tra'} nào.</p>
              </div>
            ) : (
              assessments.map(a => {
                const sub = mySubmissions[a.id];
                const status = getSubmissionStatusLabel(sub);
                const overdue = isOverdue(a.closesAt);
                const notStarted = a.type === 'EXAM' && a.opensAt ? new Date(a.opensAt) > new Date() : false;

                return (
                  <div key={a.id} className="teaching-card" style={{ cursor: 'default' }}>
                    <div className="teaching-card-header">
                      <h3 className="teaching-card-title">{a.title}</h3>
                      <div style={{ display: 'flex', gap: 6 }}>
                        <span className={`teaching-badge ${a.type === 'HOMEWORK' ? 'badge-homework' : 'badge-exam'}`}>
                          {a.type === 'HOMEWORK' ? 'Bài tập' : 'Kiểm tra'}
                        </span>
                        <span className={`teaching-badge ${status.cls}`}>{status.text}</span>
                      </div>
                    </div>
                    {a.description && !notStarted && <p className="teaching-card-desc">{a.description}</p>}
                    <div className="teaching-card-meta">
                      {a.opensAt && a.type === 'EXAM' && (
                        <span className="teaching-meta-item" style={{ color: notStarted ? '#f59e0b' : undefined }}>
                          <Clock size={13} /> Mở tính từ: {formatDate(a.opensAt)}
                          {notStarted && ' ⏳ (Chưa mở)'}
                        </span>
                      )}
                      {a.closesAt && (
                        <span className="teaching-meta-item" style={{ color: overdue ? '#ef4444' : undefined }}>
                          <Clock size={13} /> Hạn: {formatDate(a.closesAt)} {overdue && '⚠️'}
                        </span>
                      )}
                      {a.attachmentName && (
                        <button className="teaching-btn teaching-btn-secondary" style={{ padding: '4px 10px', fontSize: '0.76rem', opacity: notStarted ? 0.5 : 1 }}
                          onClick={() => {
                            if (!notStarted) {
                              const url = `/api/v1/assessments/${a.id}/attachment`;
                              setPreviewFile({
                                url,
                                name: a.attachmentName!,
                                downloadUrl: url
                              });
                            }
                          }} disabled={notStarted}>
                          <Download size={12} /> Đề bài {notStarted && '(Đang khóa)'}
                        </button>
                      )}
                    </div>

                    {/* Bài nộp của PH (con nhỏ dùng chung TK) */}
                    {sub ? (
                      <div style={{
                        marginTop: 14, padding: '12px 16px',
                        background: 'var(--color-bg-soft, #f8fafc)', borderRadius: 10,
                      }}>
                        {sub.studentAttachments && sub.studentAttachments.length > 0 ? (
                          <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', marginBottom: 6 }}>
                            <span style={{ fontWeight: 600, fontSize: '0.85rem', color: 'var(--color-text)' }}>Đã nộp:</span>
                            {sub.studentAttachments.map((att, idx) => (
                              <div key={idx} style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                                <CheckCircle size={15} style={{ color: '#10b981' }} />
                                <button
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
                                {att.fileSize && (
                                  <span style={{ fontSize: '0.78rem', color: 'var(--color-text-muted)' }}>
                                    ({formatFileSize(att.fileSize)})
                                  </span>
                                )}
                              </div>
                            ))}
                            <span style={{ fontSize: '0.78rem', color: 'var(--color-text-muted)', marginTop: 4 }}>
                              Nộp lúc: {formatDate(sub.submittedAt)}
                            </span>
                          </div>
                        ) : sub.fileName ? (
                          <div style={{ display: 'flex', flexDirection: 'column', gap: '4px', marginBottom: 6 }}>
                            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
                              <CheckCircle size={15} style={{ color: '#10b981' }} />
                              <span style={{ fontWeight: 600, fontSize: '0.85rem', color: 'var(--color-text)' }}>Đã nộp:</span>
                            </div>
                            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
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
                            </div>
                            <span style={{ fontSize: '0.78rem', color: 'var(--color-text-muted)' }}>
                              Nộp lúc: {formatDate(sub.submittedAt)} • {formatFileSize(sub.fileSize)}
                            </span>
                          </div>
                        ) : (
                          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
                            <CheckCircle size={15} style={{ color: '#10b981' }} />
                            <span style={{ fontWeight: 600, fontSize: '0.85rem', color: 'var(--color-text)' }}>
                              Đã nộp bài
                            </span>
                          </div>
                        )}
                        {sub.totalScore !== null && (
                          <div style={{ marginTop: 8 }}>
                            <span style={{ fontSize: '1.1rem', fontWeight: 800, color: '#8b5cf6' }}>
                              Điểm: {Number(sub.totalScore).toFixed(1)}
                            </span>
                            {sub.tutorComment && (
                              <p style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', marginTop: 4 }}>
                                💬 {sub.tutorComment}
                              </p>
                            )}
                          </div>
                        )}
                        {sub.tutorFileName && (
                          <button className="teaching-btn teaching-btn-secondary" style={{ padding: '4px 10px', fontSize: '0.76rem', marginTop: 8 }}
                            onClick={() => {
                              const url = `/api/v1/submissions/${sub.id}/tutor-download`;
                              setPreviewFile({
                                url,
                                name: sub.tutorFileName!,
                                downloadUrl: url
                              });
                            }}>
                            <Download size={12} /> Bài sửa của GS
                          </button>
                        )}
                      </div>
                    ) : (
                      <div style={{ marginTop: 14 }}>
                        <button className="teaching-btn teaching-btn-primary"
                          onClick={() => setSubmitTarget(a)}
                          disabled={overdue || notStarted}>
                          <Upload size={14} /> Nộp bài
                        </button>
                        {notStarted && (
                          <span style={{ fontSize: '0.78rem', color: '#f59e0b', marginLeft: 8 }}>
                            <AlertCircle size={12} style={{ verticalAlign: -2 }} /> Chưa tới giờ làm bài
                          </span>
                        )}
                        {overdue && (
                          <span style={{ fontSize: '0.78rem', color: '#ef4444', marginLeft: 8 }}>
                            <AlertCircle size={12} style={{ verticalAlign: -2 }} /> Đã quá hạn
                          </span>
                        )}
                      </div>
                    )}

                    {/* Nút xem all submissions (PH vẫn xem được tất cả bài nộp) */}
                    <div style={{ marginTop: 10, borderTop: '1px solid var(--color-border, #e2e8f0)', paddingTop: 10 }}>
                      <button
                        className="teaching-btn teaching-btn-secondary"
                        style={{ fontSize: '0.78rem' }}
                        onClick={() => setSelectedAssessment(a)}
                      >
                        <Eye size={13} /> Xem tất cả bài nộp
                      </button>
                    </div>
                  </div>
                );
              })
            )
          )}

          {/* ── Materials Tab ── */}
          {tab === 'materials' && (
            materials.length === 0 ? (
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
                      <button className="teaching-btn teaching-btn-secondary" style={{ padding: '6px 12px', fontSize: '0.78rem' }}
                        onClick={(e) => {
                          e.stopPropagation();
                          handleDownload(m.downloadUrl, m.fileName);
                        }}>
                        <Download size={13} /> Tải
                      </button>
                    </div>
                  </div>
                );
              })
            )
          )}
        </>
      )}

      {/* Submit Modal */}
      {submitTarget && (
        <SubmitModal
          assessment={submitTarget}
          onClose={() => setSubmitTarget(null)}
          onSubmitted={() => {
            setSubmitTarget(null);
            loadData();
          }}
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
