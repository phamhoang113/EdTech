import { BookOpen, GraduationCap, X, Phone, CheckCircle, Activity, UserCheck, Clock, XCircle, Plus, ChevronRight } from 'lucide-react';
import { useState, useEffect } from 'react';
import { useAuthStore } from '../../store/useAuthStore';
import { DashboardHeader } from '../../components/layout/DashboardHeader';
import { StudentSidebar } from '../../components/student/StudentSidebar';

import { studentApi } from '../../services/studentApi';
import type { ParentClass, TutorApplicant } from '../../services/parentApi';
import { StudentRequestClassModal } from '../../components/student/StudentRequestClassModal';
import { SharedTutorDetailModal } from '../../components/shared/TutorDetailModal';
import { useEscapeKey } from '../../hooks/useEscapeKey';
import './Dashboard.css';

function fmtCurrency(n: number | null | undefined) {
  if (n == null) return '—';
  return n.toLocaleString('vi-VN') + ' ₫';
}

function fmtDate(iso: string | null | undefined) {
  if (!iso) return '—';
  const d = new Date(iso);
  return `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}/${d.getFullYear()}`;
}

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

function TutorsModal({ cls, onClose, onSelect }: {
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
    studentApi.getMyClasses().then(res => {
      setClasses(res.data ?? []);
    }).catch(() => {})
    .finally(() => setLoading(false));
  }, [classesKey]);

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3500);
  };

  const handleRequestSuccess = () => {
    setShowRequestClass(false);
    setClassesKey(k => k + 1);
    showToast('success', 'Đã gửi yêu cầu mở lớp!');
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
    <div className="dash-page">
      <StudentSidebar active="requests" />

      <main className="dash-main">
        <DashboardHeader />
        
        <div className="dash-body">
          <div className="dash-section-head" style={{ marginBottom: 20 }}>
            <div>
              <h2 className="dash-section-title" style={{ fontSize: '1.4rem' }}>Yêu cầu học tập</h2>
              <p style={{ color: 'var(--color-text-muted)', fontSize: '0.9rem', marginTop: 4 }}>
                Quản lý các yêu cầu mở lớp và tìm kiếm gia sư
              </p>
            </div>
            <button onClick={() => setShowRequestClass(true)} style={{
              display: 'flex', alignItems: 'center', gap: 8, padding: '10px 18px',
              borderRadius: 12, border: 'none', background: 'linear-gradient(135deg,#6366f1,#8b5cf6)',
              color: '#fff', fontWeight: 700, fontSize: '0.9rem', cursor: 'pointer', fontFamily: 'inherit',
              boxShadow: '0 4px 12px rgba(99,102,241,0.35)',
            }}>
              <Plus size={18}/> Tạo yêu cầu mới
            </button>
          </div>

          <div className="dash-panel">
            {loading ? (
              <p style={{ color: 'var(--color-text-muted)', padding: 24, textAlign: 'center' }}>Đang tải...</p>
            ) : classes.length === 0 ? (
              <div style={{ textAlign: 'center', padding: 48, color: 'var(--color-text-muted)' }}>
                <BookOpen size={48} style={{ opacity: 0.2, marginBottom: 16 }}/>
                <h3>Chưa có yêu cầu nào</h3>
                <p style={{ fontSize: '0.9rem', marginTop: 8 }}>Bạn có thể tạo yêu cầu mở lớp để tìm kiếm gia sư phù hợp.</p>
              </div>
            ) : (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                {classes.map(cls => (
                  <div key={cls.id} style={{
                    background: 'var(--color-surface-2)', borderRadius: 12, padding: '16px',
                    border: '1px solid var(--color-border)', display: 'flex', alignItems: 'center', gap: 16,
                  }}>
                    <div style={{
                      width: 48, height: 48, borderRadius: 12, background: 'linear-gradient(135deg,#6366f1,#8b5cf6)',
                      color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center',
                      fontSize: '1.2rem', fontWeight: 800, flexShrink: 0,
                    }}>
                      {cls.subject.slice(0, 2).toUpperCase()}
                    </div>
                    <div style={{ flex: 1, minWidth: 0 }}>
                      <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap', marginBottom: 4 }}>
                        <div style={{ fontWeight: 700, fontSize: '1rem', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>
                          {cls.title}
                        </div>
                        {cls.classCode && (
                          <span style={{ fontSize: '0.75rem', color: '#6366f1', fontWeight: 700, background: '#eef2ff', padding: '2px 8px', borderRadius: '12px', flexShrink: 0 }}>
                            #{cls.classCode}
                          </span>
                        )}
                        <StatusBadge status={cls.status}/>
                      </div>
                      <div style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)', display: 'flex', gap: 12, flexWrap: 'wrap' }}>
                        <span>📚 {cls.subject}</span>
                        <span>🎓 {cls.grade}</span>
                        {cls.parentFee > 0 && <span>💰 {fmtCurrency(cls.parentFee)}/tháng</span>}
                        <span>🕒 {fmtDate(cls.createdAt)}</span>
                      </div>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center', gap: 12, flexShrink: 0 }}>
                      {(cls.status === 'OPEN' || cls.hasPendingProposals) && (
                        <button onClick={() => setTutorsModal(cls)} style={{
                          display: 'flex', alignItems: 'center', gap: 6, padding: '8px 16px',
                          borderRadius: 8, border: '1.5px solid rgba(99,102,241,0.3)',
                          background: 'rgba(99,102,241,0.06)', color: '#6366f1',
                          fontSize: '0.85rem', fontWeight: 700, cursor: 'pointer', fontFamily: 'inherit',
                        }}>
                          <GraduationCap size={16}/> Xem đề xuất
                        </button>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </main>

      {/* Toasts & Modals */}
      {toast && (
        <div style={{
          position: 'fixed', bottom: 24, right: 24, zIndex: 9999,
          padding: '10px 20px', borderRadius: 12, fontWeight: 600, fontSize: '0.88rem',
          background: toast.type === 'success' ? '#ecfdf5' : '#fef2f2',
          color: toast.type === 'success' ? '#065f46' : '#b91c1c',
          border: `1px solid ${toast.type === 'success' ? 'rgba(5,150,105,0.3)' : 'rgba(239,68,68,0.3)'}`,
          boxShadow: '0 4px 20px rgba(0,0,0,0.12)',
        }}>
          {toast.type === 'success' ? '✓ ' : '✕ '}{toast.msg}
        </div>
      )}

      {showRequestClass && (
        <StudentRequestClassModal onClose={() => setShowRequestClass(false)} onSuccess={handleRequestSuccess}/>
      )}

      {tutorsModal && (
        <TutorsModal cls={tutorsModal} onClose={() => setTutorsModal(null)} onSelect={handleSelectTutor}/>
      )}
    </div>
  );
};
