import { ChevronRight, ChevronLeft, Phone, Briefcase, DollarSign, Calendar, Clock, Users, CheckCircle, AlertCircle, Star, BookOpen, X, GraduationCap, MapPin, Wifi, Home, Award, Trash2 } from 'lucide-react';
import { useState, useEffect } from 'react';
import { useEscapeKey } from '../../hooks/useEscapeKey';

import { RequestClassModal } from '../../components/parent/RequestClassModal';
import { ManageStudentsModal } from '../../components/parent/ManageStudentsModal';
import { parentApi } from '../../services/parentApi';
import type { ParentClass, TutorApplicant } from '../../services/parentApi';
import './ApplicantsPage.css';
import '../dashboard/Dashboard.css';

/* ── Helpers ──────────────────────────────────────────────────────────────── */
function fmtCurrency(n: number | null) {
  if (!n) return '—';
  return n.toLocaleString('vi-VN') + ' ₫';
}
function fmtDate(iso: string | null | undefined) {
  if (!iso) return '—';
  const d = new Date(iso);
  if (isNaN(d.getTime())) return '—';
  return d.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' });
}
function fmtBirthYear(iso: string | null | undefined) {
  if (!iso) return '—';
  // dateOfBirth là LocalDate ("yyyy-MM-dd"), chỉ cần năm
  return iso.split('-')[0] ?? '—';
}
function statusLabel(s: string): { label: string; color: string } {
  switch (s) {
    case 'PENDING':   return { label: 'Chờ xem xét', color: '#f59e0b' };
    case 'PROPOSED':  return { label: 'Đề xuất',      color: '#6366f1' };
    case 'SELECTED':  return { label: 'Đã chọn',      color: '#22c55e' };
    case 'REJECTED':  return { label: 'Từ chối',       color: '#ef4444' };
    default:           return { label: s,              color: '#9ca3af' };
  }
}
function classStatusLabel(s: string): { label: string; bg: string; text: string } {
  switch (s) {
    case 'PENDING_APPROVAL': return { label: 'Chờ duyệt',  bg: '#fef9c3', text: '#92400e' };
    case 'OPEN':             return { label: 'Đang mở',     bg: '#dcfce7', text: '#166534' };
    case 'ASSIGNED':
    case 'MATCHED':          return { label: 'Đã ghép GS', bg: '#ede9fe', text: '#4c1d95' };
    case 'ACTIVE':           return { label: 'Đang học',    bg: '#dbeafe', text: '#1e40af' };
    case 'COMPLETED':        return { label: 'Hoàn thành',  bg: '#f3f4f6', text: '#374151' };
    case 'CANCELLED':        return { label: 'Đã huỷ',      bg: '#fee2e2', text: '#991b1b' };
    case 'AUTO_CLOSED':      return { label: 'Hết hạn',     bg: '#fef3c7', text: '#92400e' };
    default:                  return { label: s,            bg: '#f3f4f6', text: '#374151' };
  }
}

/* ── Tutor Detail Modal ───────────────────────────────────────────────────── */
function TutorDetailModal({ tutor, onClose, onSelect, classStatus }: {
  tutor: TutorApplicant;
  onClose: () => void;
  onSelect: (id: string) => void;
  classStatus?: string;
}) {
  const [selecting, setSelecting] = useState(false);
  const [error, setError] = useState('');
  const [zoomImg, setZoomImg] = useState<string | null>(null);
  const st = statusLabel(tutor.status);
  useEscapeKey(() => zoomImg ? setZoomImg(null) : onClose());

  const handleSelect = async () => {
    setSelecting(true); setError('');
    try {
      await parentApi.selectTutor(tutor.applicationId);
      onSelect(tutor.applicationId);
      onClose();
    } catch (e: unknown) {
      const err = e as { response?: { data?: { message?: string } } };
      setError(err?.response?.data?.message ?? 'Có lỗi xảy ra. Vui lòng thử lại.');
    } finally {
      setSelecting(false);
    }
  };

  const toSrc = (img: string) => img.startsWith('data:') ? img : `data:image/png;base64,${img}`;

  return (
    <div className="ap-overlay" onClick={onClose}>
      <div className="ap-modal" onClick={e => e.stopPropagation()}>
        <button className="ap-modal-close" onClick={onClose}><X size={16}/></button>

        {/* Header */}
        <div className="ap-modal-head">
          <div className="ap-modal-avatar">
            {tutor.tutorName?.split(' ').pop()?.charAt(0) ?? '?'}
          </div>
          <div className="ap-modal-meta">
            <h2 className="ap-modal-name">{tutor.tutorName ?? 'Gia sư'}</h2>
            <div className="ap-modal-badge" style={{ background: st.color + '20', color: st.color }}>
              {st.label}
            </div>
          </div>
        </div>

        {/* Info rows */}
        <div className="ap-modal-body">
          <div className="ap-info-grid">
            <InfoRow icon={<Phone size={15}/>} label="SĐT" value={tutor.tutorPhone ?? '—'}/>
            <InfoRow icon={<Briefcase size={15}/>} label="Loại GS" value={tutor.tutorType ?? '—'}/>
            <InfoRow icon={<Calendar size={15}/>} label="Năm sinh" value={fmtBirthYear(tutor.dateOfBirth)}/>
            <InfoRow icon={<Calendar size={15}/>} label="Ngày ứng tuyển" value={fmtDate(tutor.appliedAt)}/>
          </div>

          {/* ⭐ Star rating */}
          {(() => {
            const hasReviews = tutor.ratingCount != null && tutor.ratingCount > 0;
            const displayRating = hasReviews ? Number(tutor.rating) : 5.0;
            return (
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, margin: '12px 0', padding: '8px 14px', borderRadius: 10, background: 'rgba(251,191,36,0.08)' }}>
                <Star size={16} style={{ color: '#f59e0b', fill: '#f59e0b' }}/>
                <span style={{ fontWeight: 700, color: '#b45309', fontSize: '1rem' }}>{displayRating.toFixed(1)}</span>
                <span style={{ fontSize: '0.8rem', color: '#78716c' }}>/ 5</span>
                {hasReviews ? (
                  <span style={{ fontSize: '0.78rem', color: '#a8a29e', marginLeft: 4 }}>({tutor.ratingCount} đánh giá)</span>
                ) : (
                  <span style={{ fontSize: '0.78rem', color: '#a8a29e', marginLeft: 4 }}>Mới</span>
                )}
                <div style={{ display: 'flex', gap: 2, marginLeft: 'auto' }}>
                  {[1,2,3,4,5].map(s => (
                    <Star key={s} size={14} style={{
                      color: s <= Math.round(displayRating) ? '#f59e0b' : '#d6d3d1',
                      fill: s <= Math.round(displayRating) ? '#f59e0b' : 'none',
                    }}/>
                  ))}
                </div>
              </div>
            );
          })()}

          {tutor.achievements && (
            <div className="ap-note-box" style={{ borderColor: '#a5b4fc', marginBottom: 12 }}>
              <div className="ap-note-label" style={{ color: '#6366f1' }}>
                <GraduationCap size={12}/> Bằng cấp / kinh nghiệm
              </div>
              <p className="ap-note-text">{tutor.achievements}</p>
            </div>
          )}

          {tutor.note && (
            <div className="ap-note-box" style={{ borderColor: '#10b981', background: '#ecfdf5', marginBottom: 12 }}>
              <div className="ap-note-label" style={{ color: '#059669', display: 'flex', alignItems: 'center', gap: 6, fontWeight: 700, fontSize: '0.8rem', marginBottom: 6 }}>
                 Lời nhắn từ Admin trung tâm
              </div>
              <p className="ap-note-text" style={{ color: '#065f46', fontSize: '0.9rem', lineHeight: 1.5, margin: 0 }}>{tutor.note}</p>
            </div>
          )}

          {/* 🖼️ Ảnh bằng cấp — click phóng to lightbox */}
          {(() => {
            const validCerts = (tutor.certBase64s || []).filter(img => img && img.trim().length > 50);
            if (validCerts.length === 0) return null;
            return (
              <div style={{ margin: '10px 0' }}>
                <div style={{ fontSize: '0.78rem', fontWeight: 700, color: '#6366f1', marginBottom: 8, display: 'flex', alignItems: 'center', gap: 6 }}>
                  <Award size={12}/> Hình ảnh bằng cấp ({validCerts.length})
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(120px, 1fr))', gap: 8 }}>
                  {validCerts.map((img, idx) => (
                    <button key={idx} onClick={() => setZoomImg(toSrc(img))}
                      style={{ padding: 0, border: '1.5px solid #e5e7eb', borderRadius: 10, overflow: 'hidden', cursor: 'zoom-in', aspectRatio: '4/3', background: '#f9fafb' }}>
                      <img src={toSrc(img)} alt={`Bằng cấp ${idx + 1}`}
                        style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}/>
                    </button>
                  ))}
                </div>
              </div>
            );
          })()}

          {error && (
            <div className="ap-error"><AlertCircle size={13}/> {error}</div>
          )}
        </div>

        {/* Actions */}
        <div className="ap-modal-footer">
          <button className="ap-btn-cancel" onClick={onClose}>Đóng</button>
          {classStatus === 'OPEN' && tutor.status !== 'SELECTED' && tutor.status !== 'REJECTED' && (
            <button className="ap-btn-select" onClick={handleSelect} disabled={selecting}>
              <CheckCircle size={15}/>
              {selecting ? 'Đang chọn...' : 'Chọn gia sư này'}
            </button>
          )}
          {tutor.status === 'SELECTED' && (
            <div className="ap-selected-badge"><CheckCircle size={14}/> Đã chọn</div>
          )}
        </div>

        {/* Lightbox phóng to ảnh bằng cấp */}
        {zoomImg && (
          <div onClick={() => setZoomImg(null)} style={{
            position: 'fixed', inset: 0, zIndex: 9999,
            background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(6px)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'zoom-out', padding: 24,
          }}>
            <button onClick={() => setZoomImg(null)} style={{
              position: 'absolute', top: 16, right: 16, width: 40, height: 40, borderRadius: '50%',
              border: 'none', background: 'rgba(255,255,255,0.9)', color: '#111', cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '1.2rem',
              boxShadow: '0 2px 10px rgba(0,0,0,0.3)',
            }}>✕</button>
            <img src={zoomImg} alt="Phóng to bằng cấp" style={{
              maxWidth: '90vw', maxHeight: '85vh', objectFit: 'contain',
              borderRadius: 12, boxShadow: '0 8px 40px rgba(0,0,0,0.5)',
            }}/>
          </div>
        )}
      </div>
    </div>
  );
}

function InfoRow({ icon, label, value, highlight }: {
  icon: React.ReactNode; label: string; value: string; highlight?: boolean;
}) {
  return (
    <div className="ap-info-row">
      <div className="ap-info-icon">{icon}</div>
      <div className="ap-info-content">
        <span className="ap-info-label">{label}</span>
        <span className={`ap-info-value${highlight ? ' highlight' : ''}`}>{value}</span>
      </div>
    </div>
  );
}

/* ── Applicant Card ───────────────────────────────────────────────────────── */
function ApplicantCard({ tutor, onClick }: { tutor: TutorApplicant; onClick: () => void }) {
  const st = statusLabel(tutor.status);
  return (
    <button className="ap-tutor-card" onClick={onClick}>
      <div className="ap-tutor-avatar">
        {tutor.tutorName?.split(' ').pop()?.charAt(0) ?? '?'}
      </div>
      <div className="ap-tutor-info">
        <div className="ap-tutor-name">{tutor.tutorName ?? 'Gia sư'}</div>
        <div className="ap-tutor-meta">
          {tutor.tutorType && <span className="ap-tag type"><Briefcase size={10}/> {tutor.tutorType}</span>}
        </div>
      </div>
      <div className="ap-tutor-right">
        <span className="ap-status-dot" style={{ background: st.color }}/>
        <span className="ap-status-label" style={{ color: st.color }}>{st.label}</span>
        <ChevronRight size={14} className="ap-chevron"/>
      </div>
    </button>
  );
}

/* ── Class Card ───────────────────────────────────────────────────────────── */
function ClassCard({ cls, onClick, isActive, onDelete, isConfirmDelete }: {
  cls: ParentClass; onClick: () => void; isActive: boolean;
  onDelete?: (id: string) => void; isConfirmDelete?: boolean;
}) {
  const st = classStatusLabel(cls.status);
  const isCancelled = cls.status === 'CANCELLED';
  return (
    <div
      className={`ap-class-card${isActive ? ' active' : ''}`}
      style={{ position: 'relative', cursor: 'pointer' }}
      onClick={onClick}
    >
      <div className="ap-class-card-top">
        <div className="ap-class-subject">{cls.subject}</div>
        <span className="ap-class-status" style={{ background: st.bg, color: st.text }}>{st.label}</span>
      </div>
      <div className="ap-class-title">
        {cls.title}
        {cls.classCode && <span style={{ marginLeft: 6, fontSize: '0.75rem', fontWeight: 700, color: '#6366f1', background: '#eef2ff', padding: '1px 6px', borderRadius: 8 }}>#{cls.classCode}</span>}
      </div>
      <div className="ap-class-meta">
        <span><BookOpen size={10}/> {cls.grade}</span>
        <span><Clock size={10}/> {cls.sessionsPerWeek} buổi/tuần</span>
        <span><Users size={10}/> {cls.pendingApplicationCount} GS</span>
      </div>
      <ChevronRight size={14} className="ap-class-chevron"/>
      {isCancelled && onDelete && (
        <button
          title={isConfirmDelete ? 'Nhấn lần nữa để xóa' : 'Xóa lớp đã hủy'}
          onClick={(e) => { e.preventDefault(); e.stopPropagation(); onDelete(cls.id); }}
          style={{
            position: 'absolute', bottom: 10, right: 10,
            height: 28, minWidth: 28, padding: isConfirmDelete ? '0 10px' : '0',
            borderRadius: 8, border: 'none', cursor: 'pointer',
            background: isConfirmDelete ? '#ef4444' : 'rgba(239,68,68,0.1)',
            color: isConfirmDelete ? '#fff' : '#ef4444',
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 4,
            transition: 'all 0.2s', zIndex: 2,
            fontSize: '0.75rem', fontWeight: 700,
            animation: isConfirmDelete ? 'ap-pulse 1s ease infinite' : 'none',
          }}
        >
          <Trash2 size={13} style={{ pointerEvents: 'none', flexShrink: 0 }}/>
          {isConfirmDelete && <span style={{ pointerEvents: 'none' }}>Xóa?</span>}
        </button>
      )}
    </div>
  );
}

/* ── Class Detail Section ─────────────────────────────────────────── */
function ClassDetailSection({ cls, onManageStudents, hasChildren }: { cls: ParentClass; onManageStudents: () => void; hasChildren: boolean }) {
  const st = classStatusLabel(cls.status);
  const scheduleEntries = (() => {
    try { return JSON.parse(cls.schedule ?? '[]') as { dayOfWeek: string; ca: string; startTime: string; endTime: string }[]; }
    catch { return []; }
  })();
  const levelFees = (() => {
    try { return JSON.parse(cls.levelFees ?? '[]') as { level: string; fee: number }[]; }
    catch { return []; }
  })();

  const dayMap: Record<string, string> = {
    Monday:'T2', Tuesday:'T3', Wednesday:'T4', Thursday:'T5',
    Friday:'T6', Saturday:'T7', Sunday:'CN',
  };

  return (
    <div className="ap-class-detail">
      {/* Title row */}
      <div className="ap-cd-header">
        <div className="ap-cd-left">
          <div className="ap-cd-subject">{cls.subject}</div>
          <h2 className="ap-cd-title" style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            {cls.title}
            {cls.classCode && <span style={{ fontSize: '1rem', fontWeight: 700, color: '#6366f1', background: '#eef2ff', padding: '2px 8px', borderRadius: 8 }}>#{cls.classCode}</span>}
          </h2>
        </div>
        <span className="ap-class-status" style={{ background: st.bg, color: st.text }}>{st.label}</span>
      </div>

      {/* Missing Students warning */}
      {hasChildren && (!cls.studentIds || cls.studentIds.length === 0) && (
        <div style={{
          margin: '12px 0', padding: '12px 16px', borderRadius: 12,
          background: 'rgba(239,68,68,0.08)', border: '1.5px solid rgba(239,68,68,0.25)',
          display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 10
        }}>
          <div style={{ display: 'flex', gap: 10 }}>
            <span style={{ fontSize: '1.2rem', color: '#dc2626', marginTop: 2 }}><AlertCircle size={20}/></span>
            <div>
              <div style={{ fontSize: '0.85rem', fontWeight: 800, color: '#dc2626', marginBottom: 4 }}>
                Lớp này chưa có Học sinh
              </div>
              <div style={{ fontSize: '0.8rem', color: '#991b1b', lineHeight: 1.4 }}>
                Vui lòng gán học sinh vào để bắt đầu quá trình học.
              </div>
            </div>
          </div>
          <button onClick={onManageStudents} style={{
            padding: '8px 14px', background: '#dc2626', color: '#fff', flexShrink: 0,
            border: 'none', borderRadius: 8, fontSize: '0.8rem', fontWeight: 700, cursor: 'pointer'
          }}>
            Gán ngay
          </button>
        </div>
      )}

      {/* Show Assigned Students summary if they exist */}
      {(cls.studentIds && cls.studentIds.length > 0) && (
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 12 }}>
          <Users size={14} style={{ color: '#8b5cf6' }}/>
          <span style={{ fontSize: '0.85rem', fontWeight: 600, color: '#4b5563' }}>Đã gán học sinh ({cls.studentIds.length})</span>
          <button onClick={onManageStudents} style={{
            marginLeft: 'auto', background: 'none', border: 'none',
            color: '#6366f1', fontSize: '0.8rem', fontWeight: 700, cursor: 'pointer'
          }}>Sửa Học Sinh</button>
        </div>
      )}

      {/* Banner lý do hủy — chỉ hiện khi CANCELLED */}
      {cls.status === 'CANCELLED' && (
        <div style={{
          margin: '12px 0',
          padding: '12px 16px',
          borderRadius: 12,
          background: 'rgba(239,68,68,0.08)',
          border: '1.5px solid rgba(239,68,68,0.25)',
          display: 'flex',
          gap: 10,
          alignItems: 'flex-start',
        }}>
          <span style={{ fontSize: '1rem', flexShrink: 0 }}>❌</span>
          <div>
            <div style={{ fontSize: '0.8rem', fontWeight: 800, color: '#dc2626', marginBottom: 4 }}>
              Yêu cầu mở lớp đã bị từ chối
            </div>
            <div style={{ fontSize: '0.84rem', color: '#991b1b', lineHeight: 1.6 }}>
              {cls.rejectionReason
                ? cls.rejectionReason
                : 'Admin không để lại lý do cụ thể. Vui lòng liên hệ hỗ trợ nếu cần thêm thông tin.'}
            </div>
          </div>
        </div>
      )}

      {/* Meta chips */}
      <div className="ap-cd-chips">
        <span className="ap-cd-chip">
          <BookOpen size={12}/> {cls.grade}
        </span>
        <span className="ap-cd-chip">
          {cls.mode === 'ONLINE' ? <Wifi size={12}/> : <Home size={12}/>}
          {cls.mode === 'ONLINE' ? 'Online' : 'Tại nhà'}
        </span>
        <span className="ap-cd-chip">
          <Clock size={12}/> {cls.sessionsPerWeek} buổi/tuần · {cls.sessionDurationMin} phút
        </span>
        {cls.genderRequirement && (
          <span className="ap-cd-chip"><Users size={12}/> GS {cls.genderRequirement}</span>
        )}
      </div>

      {/* Cột Học Phí chỉ hiển thị khi đã chọn GS (parentFee > 0 và trạng thái khác Mở/Chờ duyệt) */}
      {cls.parentFee > 0 && cls.status !== 'OPEN' && cls.status !== 'PENDING_APPROVAL' && (
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 16 }}>
          <DollarSign size={14} style={{ color: '#8b5cf6' }}/>
          <span>Học phí: <strong style={{ color: '#6366f1' }}>{fmtCurrency(cls.parentFee)}/tháng</strong></span>
        </div>
      )}

      {/* Address */}
      {cls.address && (
        <div className="ap-cd-row">
          <MapPin size={13} className="ap-cd-row-icon"/>
          <span>{cls.address}</span>
        </div>
      )}

      {/* Schedule */}
      {scheduleEntries.length > 0 && (
        <div className="ap-cd-row">
          <Calendar size={13} className="ap-cd-row-icon"/>
          <div className="ap-cd-schedule">
            {scheduleEntries.slice(0, 6).map((e, i) => (
              <span key={i} className="ap-cd-sched-chip">
                {dayMap[e.dayOfWeek] ?? e.dayOfWeek} {e.startTime && `${e.startTime}–${e.endTime}`}
              </span>
            ))}
          </div>
        </div>
      )}

      {/* Level fees */}
      {levelFees.length > 0 && (
        <div className="ap-cd-row">
          <Award size={13} className="ap-cd-row-icon"/>
          <div className="ap-cd-level-fees">
            {levelFees.map((lf, i) => (
              <span key={i} className="ap-cd-fee-chip">
                {lf.level}: {lf.fee?.toLocaleString('vi-VN')} ₫
              </span>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   ApplicantsPage — trang chinh
══════════════════════════════════════════════════════════════════════════ */
export function ApplicantsPage() {
  const [classes, setClasses]         = useState<ParentClass[]>([]);
  const [selectedClass, setSelectedClass] = useState<ParentClass | null>(null);
  const [applicants, setApplicants]   = useState<TutorApplicant[]>([]);
  const [loadingClasses, setLoadingClasses] = useState(true);
  const [loadingApplicants, setLoadingApplicants] = useState(false);
  const [selectedTutor, setSelectedTutor] = useState<TutorApplicant | null>(null);
  const [showRequestClass, setShowRequestClass] = useState(false);
  const [showManageStudents, setShowManageStudents] = useState(false);
  const [hasChildren, setHasChildren] = useState(true); // default true để không flash

  /* Load danh sách lớp */
  useEffect(() => {
    parentApi.getMyClasses()
      .then(res => setClasses(res.data ?? []))
      .catch(() => {})
      .finally(() => setLoadingClasses(false));
    // Check PH có con không — nếu không thì không bắt gán HS
    parentApi.getMyChildren()
      .then(res => setHasChildren((res.data ?? []).length > 0))
      .catch(() => {});
  }, []);

  /* Load GS ứng tuyển khi chọn lớp */
  const handleSelectClass = async (cls: ParentClass) => {
    setSelectedClass(cls);
    setApplicants([]);
    setLoadingApplicants(true);
    try {
      const res = await parentApi.getTutorApplicants(cls.id);
      setApplicants(res.data ?? []);
    } finally {
      setLoadingApplicants(false);
    }
  };

  /* Sau khi chọn GS — refresh applicants */
  const handleTutorSelected = () => {
    if (selectedClass) handleSelectClass(selectedClass);
  };

  const [deleteConfirmId, setDeleteConfirmId] = useState<string | null>(null);

  /* Xóa lớp đã hủy — 2 bước: set confirm → thực hiện xóa */
  const handleDeleteClass = async (classId: string) => {
    // Bước 1: yêu cầu xác nhận
    if (deleteConfirmId !== classId) {
      setDeleteConfirmId(classId);
      // Tự hủy confirm sau 5s
      setTimeout(() => setDeleteConfirmId(prev => prev === classId ? null : prev), 5000);
      return;
    }
    // Bước 2: xác nhận xóa
    setDeleteConfirmId(null);
    try {
      await parentApi.deleteClass(classId);
      setClasses(prev => prev.filter(c => c.id !== classId));
      if (selectedClass?.id === classId) {
        setSelectedClass(null);
        setApplicants([]);
      }
      // Toast xanh bottom-right
      const el = document.createElement('div');
      el.textContent = '✅ Đã xóa bản ghi lớp thành công!';
      Object.assign(el.style, {
        position: 'fixed', bottom: '24px', right: '24px', zIndex: '999999',
        padding: '14px 24px', borderRadius: '12px', fontWeight: '700', fontSize: '0.92rem',
        background: '#ecfdf5', color: '#065f46',
        border: '1.5px solid rgba(5,150,105,0.4)',
        boxShadow: '0 8px 32px rgba(0,0,0,0.15)',
        transition: 'opacity 0.3s', opacity: '0',
        fontFamily: 'Inter, sans-serif',
      });
      document.body.appendChild(el);
      requestAnimationFrame(() => { el.style.opacity = '1'; });
      setTimeout(() => { el.style.opacity = '0'; setTimeout(() => el.remove(), 300); }, 4000);
    } catch {
      alert('Xóa thất bại. Chỉ lớp đã hủy mới được xóa.');
    }
  };

  return (
    <>
      <div className="ap-page-body">
          {/* Page header */}
          <div className="ap-page-header">
            <div className="ap-page-header-left">
              <div className="ap-page-icon">👨‍🏫</div>
              <div>
                <h1 className="ap-page-title">Gia sư ứng tuyển</h1>
                <p className="ap-page-sub">Xem và chọn gia sư phù hợp cho các lớp của bạn</p>
              </div>
            </div>
            <button className="ap-open-class-btn" onClick={() => setShowRequestClass(true)}>
              + Yêu cầu mở lớp
            </button>
          </div>

          <div className="ap-content-area">
            {/* Left: danh sách lớp */}
            <div className="ap-class-list">
              <div className="ap-panel-label">📋 Lớp của bạn</div>
              {loadingClasses ? (
                <div className="ap-loading"><div className="ap-spinner"/></div>
              ) : classes.length === 0 ? (
                <div className="ap-empty-small">
                  <BookOpen size={32} strokeWidth={1.2}/>
                  <p>Chưa có lớp nào</p>
                  <button className="ap-open-class-btn small" onClick={() => setShowRequestClass(true)}>
                    + Tạo lớp đầu tiên
                  </button>
                </div>
              ) : (
                classes.map(cls => (
                  <ClassCard
                    key={cls.id} cls={cls}
                    isActive={selectedClass?.id === cls.id}
                    onClick={() => handleSelectClass(cls)}
                    onDelete={handleDeleteClass}
                    isConfirmDelete={deleteConfirmId === cls.id}
                  />
                ))
              )}
            </div>

            {/* Divider */}
            <div className="ap-divider"/>

            {/* Right: thông tin lớp + GS ứng tuyển theo chiều dọc */}
            <div className="ap-tutor-list">
              {!selectedClass ? (
                <div className="ap-empty-right">
                  <ChevronLeft size={32} strokeWidth={1.2}/>
                  <p>Chọn một lớp để xem thông tin và gia sư ứng tuyển</p>
                </div>
              ) : (
                <>
                  {/* Thông tin lớp */}
                  <ClassDetailSection cls={selectedClass} onManageStudents={() => setShowManageStudents(true)} hasChildren={hasChildren} />

                  {/* Danh sách GS ứng tuyển */}
                  <div className="ap-panel-label" style={{ marginTop: 24 }}>
                    👨‍🏫 Gia sư ứng tuyển <span style={{ fontWeight: 400, textTransform: 'none', color: 'var(--color-text-secondary, #4b5563)' }}>({applicants.length})</span>
                  </div>

                  {loadingApplicants ? (
                    <div className="ap-loading"><div className="ap-spinner"/></div>
                  ) : applicants.length === 0 ? (
                    <div className="ap-empty-small">
                      <Users size={28} strokeWidth={1.2}/>
                      <p>Chưa có gia sư ứng tuyển lớp này</p>
                    </div>
                  ) : (
                    applicants.map(t => (
                      <ApplicantCard
                        key={t.applicationId} tutor={t}
                        onClick={() => setSelectedTutor(t)}
                      />
                    ))
                  )}
                </>
              )}
            </div>
          </div>
      </div>

      {selectedTutor && (
        <TutorDetailModal
          tutor={selectedTutor}
          classStatus={selectedClass?.status}
          onClose={() => setSelectedTutor(null)}
          onSelect={handleTutorSelected}
        />
      )}

      {/* Request Class Modal */}
      {showRequestClass && (
        <RequestClassModal
          onClose={() => setShowRequestClass(false)}
          onSuccess={() => {
            setShowRequestClass(false);
            parentApi.getMyClasses().then(res => setClasses(res.data ?? []));
            window.dispatchEvent(new CustomEvent('refresh-notifications'));
            // Toast xanh bottom-right
            const el = document.createElement('div');
            el.textContent = '✅ Đã gửi yêu cầu mở lớp thành công! Admin sẽ xem xét sớm.';
            Object.assign(el.style, {
              position: 'fixed', bottom: '24px', right: '24px', zIndex: '999999',
              padding: '14px 24px', borderRadius: '12px', fontWeight: '700', fontSize: '0.92rem',
              background: '#ecfdf5', color: '#065f46',
              border: '1.5px solid rgba(5,150,105,0.4)',
              boxShadow: '0 8px 32px rgba(0,0,0,0.15)',
              transition: 'opacity 0.3s', opacity: '0',
              fontFamily: 'Inter, sans-serif',
            });
            document.body.appendChild(el);
            requestAnimationFrame(() => { el.style.opacity = '1'; });
            setTimeout(() => { el.style.opacity = '0'; setTimeout(() => el.remove(), 300); }, 5000);
          }}
        />
      )}

      {/* Manage Students Modal */}
      {showManageStudents && selectedClass && (
        <ManageStudentsModal
          cls={selectedClass}
          onClose={() => setShowManageStudents(false)}
          onSuccess={() => {
            setShowManageStudents(false);
            parentApi.getMyClasses().then(res => {
              setClasses(res.data ?? []);
              const updated = res.data?.find(c => c.id === selectedClass.id);
              if (updated) setSelectedClass(updated);
            });
          }}
        />
      )}
    </>
  );
}
