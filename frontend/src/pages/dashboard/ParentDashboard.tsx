import { BookOpen, Award, TrendingUp, Calendar, ChevronRight, Clock, Users, X, Sparkles, Link2, Plus, GraduationCap, Phone, UserCheck, CheckCircle, XCircle, Activity } from 'lucide-react';
import { useState, useEffect } from 'react';
import { getDisplayStatus } from '../../utils/sessionStatus';
import { useEscapeKey } from '../../hooks/useEscapeKey';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';

import { DashboardHeader } from '../../components/layout/DashboardHeader';
import { RequestClassModal } from '../../components/parent/RequestClassModal';
import { ManageStudentsModal } from '../../components/parent/ManageStudentsModal';
import { ParentSidebar } from '../../components/parent/ParentSidebar';
import { SharedTutorDetailModal } from '../../components/shared/TutorDetailModal';

import { parentApi } from '../../services/parentApi';
import type { ParentClass, TutorApplicant } from '../../services/parentApi';
import { sessionApi } from '../../services/sessionApi';
import type { SessionDTO } from '../../services/sessionApi';
import './Dashboard.css';

// const activities = [
//   { text: 'Con Bảo Nguyên vừa hoàn thành bài kiểm tra Toán',   time: '1 giờ trước',  type: 'act-lesson'  },
//   { text: 'Thanh toán học phí tháng 3 — 2.400.000đ',            time: '1 ngày trước', type: 'act-payment' },
//   { text: 'Đặt lịch học Anh văn cho con vào thứ 6',             time: '2 ngày trước', type: 'act-booking' },
//   { text: 'Con Bảo Nguyên đánh giá gia sư Lan Phương ★★★★★',    time: '3 ngày trước', type: 'act-review'  },
// ];

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

function formatShortCurrency(amount: number) {
  if (amount === 0) return '0 ₫';
  if (amount >= 1_000_000) {
    const m = amount / 1_000_000;
    return Number.isInteger(m) ? `${m}M` : `${m.toFixed(1)}M`;
  }
  if (amount >= 1_000) {
    const k = amount / 1_000;
    return Number.isInteger(k) ? `${k}K` : `${k.toFixed(1)}K`;
  }
  return amount.toString();
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

/* ─── Tutors Modal (xem GS đăng ký nhận lớp) ────────────────────────────── */
function TutorsModal({ cls, onClose, onSelect }: {
  cls: ParentClass;
  onClose: () => void;
  onSelect: (appId: string, name: string) => void;
}) {
  const [tutors, setTutors] = useState<TutorApplicant[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedTutor, setSelectedTutor] = useState<TutorApplicant | null>(null);

  useEffect(() => {
    parentApi.getTutorApplicants(cls.id)
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

/* ─── My Classes Panel ───────────────────────────────────────────────────── */
function MyClassesPanel({ classes, loading, onViewTutors, onManageStudents }: { classes: ParentClass[], loading: boolean, onViewTutors: (cls: ParentClass) => void, onManageStudents: (cls: ParentClass) => void }) {

  if (loading) return <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Đang tải...</p>;
  if (classes.length === 0) return (
    <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Bạn chưa có lớp nào. Nhấn "Yêu cầu mở lớp" để bắt đầu.</p>
  );

  return (
    <div className="people-list" style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
      {classes.map(cls => (
        <div key={cls.id} style={{
          background: 'var(--color-surface-2)', borderRadius: 12, padding: '12px 14px',
          border: '1px solid var(--color-border)', display: 'flex', alignItems: 'center', gap: 12,
        }}>
          <div style={{
            width: 36, height: 36, borderRadius: 10, background: 'linear-gradient(135deg,#6366f1,#8b5cf6)',
            color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: '0.8rem', fontWeight: 800, flexShrink: 0,
          }}>
            {cls.subject.slice(0, 2).toUpperCase()}
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
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
            <div style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)', marginTop: 2 }}>
              {cls.subject} • {cls.grade}{cls.parentFee > 0 ? ` • ${fmtCurrency(cls.parentFee)}/tháng` : ''} • {fmtDate(cls.createdAt)}
            </div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexShrink: 0 }}>
            <StatusBadge status={cls.status}/>
            {cls.status !== 'CANCELLED' && cls.status !== 'COMPLETED' && (
              <button onClick={() => onManageStudents(cls)} style={{
                display: 'flex', alignItems: 'center', gap: 5, padding: '5px 10px',
                borderRadius: 8, border: '1px solid rgba(139,92,246,0.3)',
                background: 'rgba(139,92,246,0.06)', color: '#8b5cf6',
                fontSize: '0.75rem', fontWeight: 700, cursor: 'pointer'
              }}>
                <Users size={12}/> Đổi HS
              </button>
            )}
            {(cls.status === 'OPEN' || cls.hasPendingProposals) && (
              <button onClick={() => onViewTutors(cls)} style={{
                display: 'flex', alignItems: 'center', gap: 5, padding: '5px 10px',
                borderRadius: 8, border: '1.5px solid rgba(99,102,241,0.3)',
                background: 'rgba(99,102,241,0.06)', color: '#6366f1',
                fontSize: '0.75rem', fontWeight: 700, cursor: 'pointer', fontFamily: 'inherit',
              }}>
                <GraduationCap size={12}/> GS đề xuất
              </button>
            )}
          </div>
        </div>
      ))}
    </div>
  );
}

/* ─── Main ───────────────────────────────────────────────────────────────── */
export const ParentDashboard = () => {
  const { user } = useAuthStore();
  const navigate = useNavigate();
  const [studentsCount, setStudentsCount] = useState<number>(0);
  const [hasTutor, setHasTutor] = useState<boolean>(false);
  const [showRequestClass, setShowRequestClass] = useState(false);
  const [tutorsModal, setTutorsModal] = useState<ParentClass | null>(null);
  const [manageStudentsModal, setManageStudentsModal] = useState<ParentClass | null>(null);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);
  const [classesKey, setClassesKey] = useState(0);
  const [upcomingSessions, setUpcomingSessions] = useState<SessionDTO[]>([]);

  // Lifted state for MyClasses
  const [myClasses, setMyClasses] = useState<ParentClass[]>([]);
  const [loadingClasses, setLoadingClasses] = useState(true);

  useEffect(() => {
    parentApi.getMyChildren().then(res => setStudentsCount(res.data?.length ?? 0)).catch(() => {});
    
    setLoadingClasses(true);
    parentApi.getMyClasses().then(res => {
      const data = res.data ?? [];
      setMyClasses(data);
      setHasTutor(data.length > 0);
    }).catch(() => {})
    .finally(() => setLoadingClasses(false));

    // Fetch upcoming sessions
    sessionApi.getSessions().then(res => {
      const data = Array.isArray(res.data) ? res.data : (res.data as unknown as { data: SessionDTO[] })?.data ?? [];
      const now = new Date();
      const upcoming = data
        .filter(s => getDisplayStatus(s.status, s.sessionDate, s.endTime) === 'SCHEDULED' && new Date(s.sessionDate) >= new Date(now.toDateString()))
        .sort((a, b) => new Date(a.sessionDate).getTime() - new Date(b.sessionDate).getTime())
        .slice(0, 4);
      setUpcomingSessions(upcoming);
    }).catch(() => {});
  }, [classesKey]);

  const hasLinkedStudent = studentsCount > 0;

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3500);
  };

  const handleRequestSuccess = () => {
    setShowRequestClass(false);
    setClassesKey(k => k + 1);
    showToast('success', 'Đã gửi yêu cầu mở lớp! Admin sẽ xem xét sớm.');
  };

  const handleSelectTutor = async (applicationId: string, tutorName: string) => {
    try {
      await parentApi.selectTutor(applicationId);
      showToast('success', `Đã chọn ${tutorName}! Lớp sẽ bắt đầu sớm.`);
      setTutorsModal(null);
      setClassesKey(k => k + 1);
    } catch (e: any) {
      showToast('error', e?.response?.data?.message ?? 'Chọn gia sư thất bại');
    }
  };

  const name = user?.fullName ?? 'Phụ huynh';
  const h = new Date().getHours();
  const greeting = h < 12 ? 'Chào buổi sáng' : h < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';

  // Calculate Monthly Cost dynamically
  const activeClasses = myClasses.filter(c => 
    ['PENDING_APPROVAL', 'OPEN', 'ASSIGNED', 'MATCHED', 'ACTIVE'].includes(c.status)
  );
  const totalFeeRaw = activeClasses.reduce((sum, c) => sum + (c.parentFee || 0), 0);
  const totalFeeFormatted = formatShortCurrency(totalFeeRaw);

  return (
    <div className="dash-page">
      {/* ===== SIDEBAR ===== */}
      <ParentSidebar active="overview" onRequestClass={() => setShowRequestClass(true)} />

      {/* ===== MAIN ===== */}
      <main className="dash-main">
        <DashboardHeader />

        <div className="dash-body">
          {/* Greeting */}
          <div className="dash-greeting">
            <div className="greeting-left">
              <p className="greeting-hi">{greeting} 👋</p>
              <h1 className="greeting-name">{name}</h1>
              <span className="greeting-tag">👨‍👩‍👧 Phụ huynh</span>
            </div>
            <div className="greeting-emoji" style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
              <button onClick={() => setShowRequestClass(true)} style={{
                display: 'flex', alignItems: 'center', gap: 8, padding: '10px 18px',
                borderRadius: 12, border: 'none', background: 'linear-gradient(135deg,#6366f1,#8b5cf6)',
                color: '#fff', fontWeight: 700, fontSize: '0.9rem', cursor: 'pointer', fontFamily: 'inherit',
                boxShadow: '0 4px 12px rgba(99,102,241,0.35)',
              }}>
                <Plus size={16}/> Yêu cầu mở lớp
              </button>
              <span>🏠</span>
            </div>
          </div>

          {/* Onboarding banners */}
          {(!hasLinkedStudent || !hasTutor) && (
            <div className="onboard-banners">
              {!hasLinkedStudent && (
                <div className="onboard-card onboard-student" onClick={() => navigate('/my-children')}>
                  <div className="onboard-card-glow" />
                  <div className="onboard-icon-wrap"><Link2 size={26} /></div>
                  <div className="onboard-content">
                    <p className="onboard-step">Bước 1 · Bắt đầu ngay</p>
                    <h3 className="onboard-title">Liên kết học sinh</h3>
                    <p className="onboard-desc">Thêm con em để theo dõi lịch học, tiến độ và thanh toán tập trung.</p>
                  </div>
                  <div className="onboard-arrow"><ChevronRight size={22} /></div>
                </div>
              )}
              {!hasTutor && (
                <div className="onboard-card onboard-tutor" onClick={() => setShowRequestClass(true)}>
                  <div className="onboard-card-glow" />
                  <div className="onboard-icon-wrap"><Sparkles size={26} /></div>
                  <div className="onboard-content">
                    <p className="onboard-step">{hasLinkedStudent ? 'Bước 2 · Tiếp theo' : 'Bước 2'} · Quan trọng</p>
                    <h3 className="onboard-title">Yêu cầu mở lớp</h3>
                    <p className="onboard-desc">Gửi yêu cầu mở lớp để admin xét duyệt và gia sư đăng ký nhận lớp.</p>
                  </div>
                  <div className="onboard-arrow"><ChevronRight size={22} /></div>
                </div>
              )}
            </div>
          )}

          {/* Stats */}
          <section>
            <div className="dash-stats-grid">
              {[
                { val: `${studentsCount}`, lbl: 'Con em đang học', icon: <Users size={20}/>,      cls: 'color-indigo'  },
                { val: `${activeClasses.length}`, lbl: 'Lớp học',  icon: <Calendar size={20}/>,   cls: 'color-violet'  },
                { val: totalFeeFormatted,     lbl: 'Chi phí tháng',  icon: <TrendingUp size={20}/>, cls: 'color-amber'   },
                { val: `${upcomingSessions.length}`, lbl: 'Buổi sắp tới', icon: <Award size={20}/>,      cls: 'color-emerald' },
              ].map((s, i) => (
                <div key={i} className={`dash-stat-card ${s.cls}`}>
                  <div className="stat-icon-box">{s.icon}</div>
                  <div className="stat-info">
                    <span className="stat-val">{s.val}</span>
                    <span className="stat-lbl">{s.lbl}</span>
                  </div>
                </div>
              ))}
            </div>
          </section>

          {/* My Classes panel */}
          <div className="dash-panel">
            <div className="dash-section-head">
              <h2 className="dash-section-title" style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                <BookOpen size={16} className="text-secondary"/> Lớp học của tôi
              </h2>
              <button className="dash-see-all" onClick={() => setShowRequestClass(true)}>
                <Plus size={14}/> Yêu cầu mới
              </button>
            </div>
            <MyClassesPanel classes={myClasses} loading={loadingClasses} onViewTutors={setTutorsModal} onManageStudents={setManageStudentsModal} />
          </div>

          {/* Two cols */}
          <div className="dash-cols">
            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">📅 Lịch học sắp tới</span>
                <button className="dash-see-all" onClick={() => navigate('/schedule')}>Xem tất cả <ChevronRight size={14}/></button>
              </div>
              <div className="upcoming-list">
                {upcomingSessions.length === 0 ? (
                  <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Không có buổi học nào sắp tới.</p>
                ) : (
                  upcomingSessions.map(s => (
                    <div key={s.id} className="upcoming-item">
                      <span className="upcoming-avatar">📚</span>
                      <div className="upcoming-info">
                        <p className="upcoming-subj">{s.classTitle}</p>
                        <p className="upcoming-who">{s.tutorName} · {s.subject}</p>
                      </div>
                      <div className="upcoming-time"><Clock size={12}/><span>{s.startTime?.substring(0, 5) ?? '--:--'}</span></div>
                    </div>
                  ))
                )}
              </div>
            </div>

            {/* 
            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">⚡ Hoạt động</span>
              </div>
              <div className="activity-list">
                {activities.map((a, i) => (
                  <div key={i} className={`activity-item ${a.type}`}>
                    <div className="activity-icon-box">
                      {a.type === 'act-lesson'  && <BookOpen size={14}/>}
                      {a.type === 'act-payment' && <TrendingUp size={14}/>}
                      {a.type === 'act-review'  && <Award size={14}/>}
                      {a.type === 'act-booking' && <Calendar size={14}/>}
                    </div>
                    <div className="activity-body">
                      <p className="activity-text">{a.text}</p>
                      <span className="activity-time">{a.time}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
            */}
          </div>

          {/* Quick actions */}
          <section>
            <div className="dash-section-head">
              <span className="dash-section-title">⚡ Thao tác nhanh</span>
            </div>
            <div className="dash-qa-grid">
              {[
                { emoji: '📋', label: 'Yêu cầu mở lớp', onClick: () => setShowRequestClass(true) },
                { emoji: '👶', label: 'Quản lý con',     onClick: () => navigate('/my-children') },
                { emoji: '📊', label: 'Báo cáo học tập', onClick: () => navigate('/learning-report') },
                { emoji: '💳', label: 'Thanh toán',      onClick: () => navigate('/payment')  },
              ].map((a, i) => (
                <button key={i} className="dash-qa-card" onClick={a.onClick}>
                  <span className="qa-emoji">{a.emoji}</span>
                  <span className="qa-label">{a.label}</span>
                  <ChevronRight size={15} className="qa-arr"/>
                </button>
              ))}
            </div>
          </section>
        </div>
      </main>

      {/* Toast */}
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

      {/* Modal: Request Class */}
      {showRequestClass && (
        <RequestClassModal onClose={() => setShowRequestClass(false)} onSuccess={handleRequestSuccess}/>
      )}

      {/* Modal: View Tutors */}
      {tutorsModal && (
        <TutorsModal cls={tutorsModal} onClose={() => setTutorsModal(null)} onSelect={handleSelectTutor}/>
      )}

      {/* Modal: Manage Students */}
      {manageStudentsModal && (
        <ManageStudentsModal cls={manageStudentsModal} onClose={() => setManageStudentsModal(null)} onSuccess={() => {
          setManageStudentsModal(null);
          setClassesKey(k => k + 1);
          showToast('success', 'Đã cập nhật danh sách học sinh cho lớp');
        }}/>
      )}
    </div>
  );
};
