import { BookOpen, GraduationCap, X, Phone, CheckCircle, Activity, UserCheck, Clock, XCircle, Plus, ChevronRight } from 'lucide-react';
import { useState, useEffect } from 'react';
import { useSearchParams, useLocation } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import { studentApi } from '../../services/studentApi';
import type { ParentClass, TutorApplicant } from '../../services/parentApi';
import { StudentRequestClassModal } from '../../components/student/StudentRequestClassModal';
import { SharedTutorDetailModal } from '../../components/shared/TutorDetailModal';
import { useEscapeKey } from '../../hooks/useEscapeKey';
import './Dashboard.css';

/* ─── Helpers ────────────────────────────────────────────────────────────── */
function fmtCurrency(n: number | null | undefined) {
  if (n == null) return '—';
  return n.toLocaleString('vi-VN') + ' ₫';
}

function fmtDate(iso: string | null | undefined) {
  if (!iso) return '—';
  const d = new Date(iso);
  return `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}/${d.getFullYear()}`;
}

/* ─── Status Badge ───────────────────────────────────────────────────────── */
const STATUS_CFG: Record<string, { label: string; color: string; icon: React.ReactNode }> = {
  PENDING_APPROVAL: { label: 'Chờ duyệt',  color: '#f59e0b', icon: <Clock size={11}/> },
  OPEN:             { label: 'Đang mở',     color: '#6366f1', icon: <BookOpen size={11}/> },
  ASSIGNED:         { label: 'Đã ghép GS',  color: '#8b5cf6', icon: <UserCheck size={11}/> },
  MATCHED:          { label: 'Đã ghép GS',  color: '#8b5cf6', icon: <UserCheck size={11}/> },
  ACTIVE:           { label: 'Đang dạy',    color: '#10b981', icon: <Activity size={11}/> },
  COMPLETED:        { label: 'Hoàn thành',  color: '#6b7280', icon: <CheckCircle size={11}/> },
  CANCELLED:        { label: 'Đã huỷ',      color: '#ef4444', icon: <XCircle size={11}/> },
  AUTO_CLOSED:      { label: 'Hết hạn',     color: '#f59e0b', icon: <Clock size={11}/> },
};

function StatusBadge({ status }: { status: string }) {
  const cfg = STATUS_CFG[status] ?? { label: status, color: '#6b7280', icon: null };
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 4,
      padding: '2px 8px', borderRadius: 20, fontSize: '0.7rem', fontWeight: 700,
      background: cfg.color + '18', color: cfg.color, border: `1px solid ${cfg.color}40`,
    }}>
      {cfg.icon} {cfg.label}
    </span>
  );
}

/* ─── Tutors Modal (xem GS đề xuất) ─────────────────────────────────────── */
export function TutorsModal({ cls, onClose, onSelect }: {
  cls: ParentClass;
  onClose: () => void;
  onSelect: (appId: string, name: string) => void;
}) {
  const [tutors, setTutors] = useState<TutorApplicant[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedTutor, setSelectedTutor] = useState<TutorApplicant | null>(null);

  useEffect(() => {
    studentApi.getProposedTutors(cls.id)
      .then(r => setTutors(r.data ?? []))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [cls.id]);
  useEscapeKey(onClose);

  return (
    <>
      <div className="ap-overlay" onClick={onClose}>
        <div className="ap-modal" style={{ maxWidth: 520, maxHeight: '80vh', overflowY: 'auto' }} onClick={e => e.stopPropagation()}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 4 }}>
            <h3>👨‍🏫 Gia sư đề xuất</h3>
            <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--color-text-muted)' }}>
              <X size={20}/>
            </button>
          </div>
          <p style={{ marginBottom: 16, color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>
            {cls.title} • {cls.subject} • {cls.grade}
          </p>

          {loading ? (
            <p style={{ textAlign: 'center', color: 'var(--color-text-muted)', padding: 24 }}>Đang tải...</p>
          ) : tutors.length === 0 ? (
            <div style={{ textAlign: 'center', padding: 32, color: 'var(--color-text-muted)' }}>
              <GraduationCap size={36} style={{ opacity: 0.3, marginBottom: 8 }}/>
              <p>Chưa có đề xuất nào</p>
            </div>
          ) : tutors.map(t => (
            <div key={t.applicationId} onClick={() => setSelectedTutor(t)} style={{
              display: 'flex', alignItems: 'center', gap: 12, padding: '12px', borderRadius: 12,
              borderBottom: '1px solid var(--color-border)', cursor: 'pointer',
            }} className="tutor-hover-row">
              <div style={{
                width: 40, height: 40, borderRadius: '50%', flexShrink: 0,
                background: 'linear-gradient(135deg,#6366f1,#8b5cf6)',
                color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: '1rem', fontWeight: 800,
              }}>
                {(t.tutorName ?? '?').charAt(0).toUpperCase()}
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontWeight: 700, fontSize: '0.92rem' }}>{t.tutorName ?? '—'}</div>
                <div style={{ fontSize: '0.78rem', color: 'var(--color-text-muted)', display: 'flex', gap: 8, marginTop: 2 }}>
                  {t.tutorType && <span style={{ background: 'rgba(99,102,241,0.1)', color: '#6366f1', padding: '1px 7px', borderRadius: 20, fontWeight: 600 }}>{t.tutorType}</span>}
                  {t.tutorPhone && <span><Phone size={10}/> {t.tutorPhone}</span>}
                </div>
              </div>
              <div style={{ textAlign: 'right', flexShrink: 0 }}>
                <ChevronRight size={16} style={{ color: '#9ca3af' }}/>
              </div>
            </div>
          ))}
        </div>
      </div>
      
      {selectedTutor && (
        <SharedTutorDetailModal
          tutor={selectedTutor}
          classStatus={cls.status}
          onClose={() => setSelectedTutor(null)}
          onSelect={async (id, name) => onSelect(id, name)}
        />
      )}
    </>
  );
}

/* ─── My Classes Panel (Dùng style chuẩn dash-my-class-card giống Parent) ── */
export function MyClassesPanel({ classes, loading, onViewTutors }: {
  classes: ParentClass[];
  loading: boolean;
  onViewTutors: (cls: ParentClass) => void;
}) {
  if (loading) return <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Đang tải...</p>;
  if (classes.length === 0) return (
    <div style={{ textAlign: 'center', padding: '40px 20px', color: 'var(--color-text-muted)' }}>
      <BookOpen size={40} style={{ opacity: 0.25, marginBottom: 12 }}/>
      <h3 style={{ fontSize: '1rem', fontWeight: 600 }}>Bạn chưa có lớp học nào</h3>
      <p style={{ fontSize: '0.85rem', marginTop: 6 }}>Nhấn nút "Yêu cầu mở lớp" để gửi yêu cầu tìm gia sư.</p>
    </div>
  );

  return (
    <div className="people-list" style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
      {classes.map(cls => {
        const hasProposals = cls.status === 'OPEN' || cls.hasPendingProposals;

        return (
          <div
            key={cls.id}
            className="dash-my-class-card"
            style={hasProposals ? {
              border: '2px solid rgba(99, 102, 241, 0.4)',
              boxShadow: '0 0 0 3px rgba(99, 102, 241, 0.08), 0 4px 12px rgba(99, 102, 241, 0.12)',
              position: 'relative',
            } : { position: 'relative' }}
          >
            {/* Banner nổi bật khi có GS đề xuất */}
            {cls.hasPendingProposals && (
              <div
                onClick={() => onViewTutors(cls)}
                style={{
                  position: 'absolute', top: -1, left: -1, right: -1,
                  padding: '8px 16px',
                  background: 'linear-gradient(135deg, #6366f1, #8b5cf6)',
                  color: '#fff', fontSize: '0.82rem', fontWeight: 700,
                  borderRadius: '12px 12px 0 0',
                  display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                  cursor: 'pointer',
                  animation: 'notifPulse 2s ease-in-out 3',
                }}
              >
                <span style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                  <span style={{
                    width: 8, height: 8, borderRadius: '50%',
                    background: '#fbbf24', display: 'inline-block',
                    animation: 'notifPulse 1.5s ease-in-out infinite',
                  }} />
                  🎓 Có gia sư đề xuất cho lớp này!
                </span>
                <span style={{ fontSize: '0.78rem', opacity: 0.9 }}>Nhấn để xem →</span>
              </div>
            )}

            <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginTop: cls.hasPendingProposals ? 32 : 0 }}>
              <div className="dash-my-class-icon">
                {cls.subject.slice(0, 2).toUpperCase()}
              </div>
              <div className="dash-my-class-info">
                <div style={{ display: 'flex', alignItems: 'center', gap: 6, flexWrap: 'wrap' }}>
                  <div style={{ fontWeight: 700, fontSize: '0.88rem', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                    {cls.title}
                  </div>
                  {cls.classCode && (
                    <span style={{ fontSize: '0.7rem', color: '#6366f1', fontWeight: 700, background: '#eef2ff', padding: '1px 7px', borderRadius: '10px', flexShrink: 0 }}>
                      #{cls.classCode}
                    </span>
                  )}
                </div>
                <div style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)', marginTop: 2, whiteSpace: 'normal', wordBreak: 'break-word' }}>
                  {cls.subject} • {cls.grade}{cls.parentFee > 0 ? ` • ${fmtCurrency(cls.parentFee)}/tháng` : ''} • {fmtDate(cls.createdAt)}
                </div>
                {cls.tutorName && (
                  <div style={{ fontSize: '0.75rem', color: '#10b981', marginTop: 4, fontWeight: 600, display: 'flex', alignItems: 'center', gap: 4 }}>
                    <GraduationCap size={12}/> Gia sư: {cls.tutorName}
                  </div>
                )}
              </div>
              <div className="dash-my-class-actions">
                <StatusBadge status={cls.status}/>
                {hasProposals && (
                  <button onClick={() => onViewTutors(cls)} style={{
                    display: 'flex', alignItems: 'center', gap: 5, padding: '7px 14px',
                    borderRadius: 10,
                    border: 'none',
                    background: 'linear-gradient(135deg, #6366f1, #8b5cf6)',
                    color: '#fff',
                    fontSize: '0.78rem', fontWeight: 700, cursor: 'pointer', fontFamily: 'inherit',
                    boxShadow: '0 2px 8px rgba(99,102,241,0.35)',
                    transition: 'transform 0.15s, box-shadow 0.15s',
                  }}
                  onMouseEnter={e => { e.currentTarget.style.transform = 'translateY(-1px)'; e.currentTarget.style.boxShadow = '0 4px 14px rgba(99,102,241,0.45)'; }}
                  onMouseLeave={e => { e.currentTarget.style.transform = 'translateY(0)'; e.currentTarget.style.boxShadow = '0 2px 8px rgba(99,102,241,0.35)'; }}
                  >
                    <GraduationCap size={13}/> Xem gia sư
                  </button>
                )}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}

/* ─── Main ───────────────────────────────────────────────────────────────── */
export const StudentRequestsPage = () => {
  useAuthStore();
  const [classes, setClasses] = useState<ParentClass[]>([]);
  const [loading, setLoading] = useState(true);
  const [showRequestClass, setShowRequestClass] = useState(false);
  const [tutorsModal, setTutorsModal] = useState<ParentClass | null>(null);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);
  const [classesKey, setClassesKey] = useState(0);

  useEffect(() => {
    setLoading(true);
    studentApi.getMyClasses()
      .then(res => setClasses(res.data ?? []))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [classesKey]);

  // Auto-open tutor modal khi redirect từ notification
  const [searchParams] = useSearchParams();
  const location = useLocation();
  const notifTimestamp = (location.state as any)?.notifTimestamp;
  const stateEntityId = (location.state as any)?.entityId;

  useEffect(() => {
    if (!classes.length || tutorsModal) return;

    const highlightId = searchParams.get('highlightId') || stateEntityId;
    if (!highlightId) return;

    // Tìm class theo classId trước
    let targetClass = classes.find(c => c.id === highlightId);

    // Nếu không tìm thấy theo classId → highlightId có thể là applicationId
    // → tìm class có pending proposals
    if (!targetClass) {
      targetClass = classes.find(c => c.hasPendingProposals);
    }

    if (targetClass && (targetClass.hasPendingProposals || targetClass.status === 'OPEN')) {
      setTutorsModal(targetClass);
    }
  }, [classes, searchParams, notifTimestamp]);

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3500);
  };

  const handleRequestSuccess = () => {
    setShowRequestClass(false);
    setClassesKey(k => k + 1);
    showToast('success', '✅ Đã gửi yêu cầu mở lớp thành công!');
    window.dispatchEvent(new CustomEvent('refresh-notifications'));
  };

  const handleSelectTutor = async (applicationId: string, tutorName: string) => {
    try {
      await studentApi.selectTutor(applicationId);
      showToast('success', `Đã chọn ${tutorName}! Lớp sẽ bắt đầu sớm.`);
      setTutorsModal(null);
      setClassesKey(k => k + 1);
    } catch (e: any) {
      showToast('error', e?.response?.data?.message ?? 'Chọn gia sư thất bại');
    }
  };

  return (
    <>
      <div className="dash-section-head" style={{ marginBottom: 20 }}>
        <div>
          <h2 className="dash-section-title" style={{ fontSize: '1.4rem' }}>Lớp học của tôi</h2>
          <p style={{ color: 'var(--color-text-muted)', fontSize: '0.9rem', marginTop: 4 }}>
            Quản lý các lớp học và yêu cầu tìm kiếm gia sư
          </p>
        </div>
        <button
          onClick={() => setShowRequestClass(true)}
          style={{
            display: 'flex', alignItems: 'center', gap: 8, padding: '10px 18px',
            borderRadius: 12, border: 'none', background: 'linear-gradient(135deg,#6366f1,#8b5cf6)',
            color: '#fff', fontWeight: 700, fontSize: '0.9rem', cursor: 'pointer', fontFamily: 'inherit',
            boxShadow: '0 4px 12px rgba(99,102,241,0.35)',
          }}
        >
          <Plus size={18}/> Yêu cầu mở lớp
        </button>
      </div>

      <div className="dash-panel">
        <MyClassesPanel classes={classes} loading={loading} onViewTutors={setTutorsModal} />
      </div>

      {/* Toast */}
      {toast && (
        <div style={{
          position: 'fixed', top: 24, left: '50%', transform: 'translateX(-50%)', zIndex: 99999,
          padding: '14px 28px', borderRadius: 14, fontWeight: 700, fontSize: '0.95rem',
          background: toast.type === 'success' ? '#ecfdf5' : '#fef2f2',
          color: toast.type === 'success' ? '#065f46' : '#b91c1c',
          border: `1.5px solid ${toast.type === 'success' ? 'rgba(5,150,105,0.4)' : 'rgba(239,68,68,0.4)'}`,
          boxShadow: '0 8px 32px rgba(0,0,0,0.18)',
          animation: 'slideDown 0.3s ease-out',
          maxWidth: '90vw',
        }}>
          {toast.msg}
        </div>
      )}

      {/* Modal: Request Class */}
      {showRequestClass && (
        <StudentRequestClassModal onClose={() => setShowRequestClass(false)} onSuccess={handleRequestSuccess}/>
      )}

      {/* Modal: View Tutors */}
      {tutorsModal && (
        <TutorsModal cls={tutorsModal} onClose={() => setTutorsModal(null)} onSelect={handleSelectTutor}/>
      )}
    </>
  );
};
