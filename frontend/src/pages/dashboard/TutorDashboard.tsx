import { BookOpen, Star, TrendingUp, Users, ChevronRight, Clock, Calendar, AlertCircle } from 'lucide-react';
import { useState, useEffect } from 'react';
import { getDisplayStatus } from '../../utils/sessionStatus';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';

import { TutorVerificationModal } from './TutorVerificationModal';
import { DashboardHeader } from '../../components/layout/DashboardHeader';
import { TutorSidebar } from '../../components/tutor/TutorSidebar';
import { tutorApi } from '../../services/tutorApi';
import type { TutorClassDTO, TutorSessionDTO } from '../../services/tutorApi';
import apiClient from '../../services/apiClient';
import './Dashboard.css';

/* ── Helpers ─────────────────────────────────────────── */
function formatCurrency(n: number) {
  if (n === 0) return '0';
  if (n >= 1_000_000) {
    const m = n / 1_000_000;
    return Number.isInteger(m) ? `${m}M` : `${m.toFixed(1)}M`;
  }
  if (n >= 1_000) {
    const k = n / 1_000;
    return Number.isInteger(k) ? `${k}K` : `${k.toFixed(1)}K`;
  }
  return n.toString();
}

function formatSessionTime(s: TutorSessionDTO): string {
  const d = new Date(s.sessionDate);
  const today = new Date();
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);

  const timeStr = s.startTime?.substring(0, 5) ?? '--:--';

  if (d.toDateString() === today.toDateString()) return `Hôm nay, ${timeStr}`;
  if (d.toDateString() === tomorrow.toDateString()) return `Ngày mai, ${timeStr}`;

  const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
  return `${dayNames[d.getDay()]}, ${timeStr}`;
}

/* ── Main Dashboard ──────────────────────────────────── */
export const TutorDashboard = () => {
  const { user } = useAuthStore();
  const navigate = useNavigate();

  // Verification
  const [verificationStatus, setVerificationStatus] = useState<string | null>(null);
  const [isLoadingProfile, setIsLoadingProfile] = useState(true);

  // Real data
  const [classes, setClasses] = useState<TutorClassDTO[]>([]);
  const [upcomingSessions, setUpcomingSessions] = useState<TutorSessionDTO[]>([]);
  const [scheduleWarning, setScheduleWarning] = useState(false);
  const [draftCount, setDraftCount] = useState(0);

  useEffect(() => {
    fetchProfileStatus();
    fetchDashboardData();
  }, []);

  const fetchProfileStatus = async () => {
    try {
      const res = await apiClient.get('/api/v1/tutors/profile/me');
      setVerificationStatus(res.data?.data?.verificationStatus ?? 'UNVERIFIED');
    } catch (err: any) {
      if (err.response?.status === 404) {
        setVerificationStatus('UNVERIFIED');
      } else {
        setVerificationStatus(null);
      }
    } finally {
      setIsLoadingProfile(false);
    }
  };

  const fetchDashboardData = async () => {
    try {
      const [classesData, sessionsData] = await Promise.all([
        tutorApi.getMyClasses(),
        tutorApi.getMySessions(),
      ]);
      setClasses(classesData);

      // Get upcoming sessions (status = SCHEDULED, future only — exclude past endTime)
      const now = new Date();
      const upcoming = sessionsData
        .filter(s => getDisplayStatus(s.status, s.sessionDate, s.endTime) === 'SCHEDULED' && new Date(s.sessionDate) >= new Date(now.toDateString()))
        .slice(0, 4);
      setUpcomingSessions(upcoming);

      // Check schedule warning (draft sessions)
      try {
        const status = await tutorApi.getScheduleStatus();
        setScheduleWarning(status.hasDraftSessions);
        setDraftCount(status.draftCount);
      } catch { /* ignore */ }
    } catch { /* ignore on dashboard */ }
  };

  const name = user?.fullName ?? 'Gia sư';
  const h = new Date().getHours();
  const greeting = h < 12 ? 'Chào buổi sáng' : h < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';

  const totalRevenue = classes.reduce((sum, c) => sum + (c.tutorFee || 0), 0);

  return (
    <div className="dash-page">
      {/* SIDEBAR */}
      <TutorSidebar active="overview" showScheduleWarning={scheduleWarning} draftCount={draftCount} />

      {/* MAIN */}
      <main className="dash-main">
        <DashboardHeader />

        <div className="dash-body">
          {/* Greeting */}
          <div className="dash-greeting">
            <div className="greeting-left">
              <p className="greeting-hi">{greeting} 👋</p>
              <h1 className="greeting-name">{name}</h1>
              <span className="greeting-tag">👩‍🏫 Gia sư</span>
            </div>
            <div className="greeting-emoji">📖</div>
          </div>

          {/* Verification Warning */}
          {verificationStatus === 'PENDING' && (
            <div className="verification-warning" style={{
              background: 'rgba(234, 179, 8, 0.1)',
              color: '#ca8a04',
              padding: '12px 16px',
              borderRadius: '8px',
              marginBottom: '0',
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              fontSize: '0.95rem'
            }}>
              <AlertCircle size={20} />
              <div>
                <strong>Hồ sơ đang chờ duyệt!</strong> Bạn đã gửi thông tin xác thực, vui lòng chờ Quản trị viên phê duyệt để bắt đầu nhận lớp.
              </div>
            </div>
          )}

          {/* Verification Modal */}
          {(!isLoadingProfile && verificationStatus === 'UNVERIFIED') && (
            <TutorVerificationModal onSuccess={fetchProfileStatus} />
          )}

          {/* Stats */}
          <section>
            <div className="dash-stats-grid">
              {[
                { val: `${classes.length}`, lbl: 'Lớp đang dạy', icon: <BookOpen size={20} />, cls: 'color-indigo' },
                { val: `${upcomingSessions.length}`, lbl: 'Buổi sắp tới', icon: <Calendar size={20} />, cls: 'color-violet' },
                { val: '— ★', lbl: 'Đánh giá', icon: <Star size={20} />, cls: 'color-amber' },
                { val: formatCurrency(totalRevenue), lbl: 'Thù lao/tháng', icon: <TrendingUp size={20} />, cls: 'color-emerald' },
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

          {/* Two cols */}
          <div className="dash-cols">
            {/* Upcoming sessions */}
            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">📅 Lịch dạy sắp tới</span>
                <button className="dash-see-all" onClick={() => navigate('/tutor/schedule')}>
                  Xem tất cả <ChevronRight size={14} />
                </button>
              </div>
              <div className="upcoming-list">
                {upcomingSessions.length === 0 ? (
                  <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Không có buổi dạy nào sắp tới.</p>
                ) : (
                  upcomingSessions.map(s => (
                    <div key={s.id} className="upcoming-item">
                      <span className="upcoming-avatar">📚</span>
                      <div className="upcoming-info">
                        <p className="upcoming-subj">{s.classTitle}</p>
                        <p className="upcoming-who">{s.subject}</p>
                      </div>
                      <div className="upcoming-time">
                        <Clock size={12} /><span>{formatSessionTime(s)}</span>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </div>

            {/* My classes */}
            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">📚 Lớp học</span>
                <button className="dash-see-all" onClick={() => navigate('/tutor/classes')}>
                  Xem tất cả <ChevronRight size={14} />
                </button>
              </div>
              <div className="upcoming-list">
                {classes.length === 0 ? (
                  <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Chưa có lớp nào được phân công.</p>
                ) : (
                  classes.slice(0, 4).map(cls => (
                    <div key={cls.id} className="upcoming-item">
                      <span className="upcoming-avatar" style={{
                        width: 36, height: 36, borderRadius: 10,
                        background: 'linear-gradient(135deg,#6366f1,#8b5cf6)',
                        color: '#fff', display: 'flex',
                        alignItems: 'center', justifyContent: 'center',
                        fontSize: '0.75rem', fontWeight: 800,
                      }}>
                        {cls.subject.slice(0, 2).toUpperCase()}
                      </span>
                      <div className="upcoming-info">
                        <p className="upcoming-subj">{cls.title}</p>
                        <p className="upcoming-who">{cls.subject} • {cls.grade}</p>
                      </div>
                      <div className="upcoming-time" style={{ color: '#10b981' }}>
                        <Users size={12} /><span>{cls.sessionsPerWeek} buổi/tuần</span>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </div>
          </div>

          {/* Quick actions */}
          <section>
            <div className="dash-section-head">
              <span className="dash-section-title">⚡ Thao tác nhanh</span>
            </div>
            <div className="dash-qa-grid">
              {[
                { emoji: '📅', label: 'Lịch dạy', onClick: () => navigate('/tutor/schedule') },
                { emoji: '📚', label: 'Lớp học', onClick: () => navigate('/tutor/classes') },
                { emoji: '👤', label: 'Hồ sơ gia sư', onClick: () => navigate('/profile') },
                { emoji: '📊', label: 'Báo cáo', onClick: () => navigate('/reports') },
              ].map((a, i) => {
                const isDisabled = (a.label === 'Lịch dạy' || a.label === 'Lớp học') && verificationStatus !== 'APPROVED';
                return (
                  <button
                    key={i}
                    className="dash-qa-card"
                    onClick={a.onClick}
                    disabled={isDisabled}
                    style={{ opacity: isDisabled ? 0.5 : 1, cursor: isDisabled ? 'not-allowed' : 'pointer' }}
                  >
                    <span className="qa-emoji">{a.emoji}</span>
                    <span className="qa-label">{a.label}</span>
                    <ChevronRight size={15} className="qa-arr" />
                  </button>
                );
              })}
            </div>
          </section>
        </div>
      </main>
    </div>
  );
};
