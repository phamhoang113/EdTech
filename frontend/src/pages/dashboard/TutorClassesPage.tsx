import { useState, useEffect } from 'react';
import { BookOpen, MapPin, Clock, Calendar, Users } from 'lucide-react';
import { tutorApi } from '../../services/tutorApi';
import type { TutorClassDTO } from '../../services/tutorApi';
import { DashboardHeader } from '../../components/layout/DashboardHeader';
import { TutorSidebar } from '../../components/tutor/TutorSidebar';
import '../dashboard/Dashboard.css';
import './TutorClasses.css';

/* ── Helpers ─────────────────────────────────────────── */
const MODE_LABELS: Record<string, string> = {
  ONLINE: '🌐 Online',
  OFFLINE: '🏠 Tại nhà',
  HYBRID: '🔄 Linh hoạt',
};

const STATUS_CFG: Record<string, { label: string; color: string }> = {
  ASSIGNED:  { label: 'Đã ghép',  color: '#8b5cf6' },
  MATCHED:   { label: 'Đã ghép',  color: '#8b5cf6' },
  ACTIVE:    { label: 'Đang dạy', color: '#10b981' },
  COMPLETED: { label: 'Hoàn thành', color: '#6b7280' },
  CANCELLED: { label: 'Đã huỷ',  color: '#ef4444' },
};

function formatCurrency(n: number | null | undefined) {
  if (n == null || n === 0) return '—';
  return n.toLocaleString('vi-VN') + ' ₫';
}

function parseSchedule(raw: string): string {
  try {
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) {
      return parsed.map((s: { day: string; time: string }) => `${s.day} ${s.time}`).join(' • ');
    }
    return raw;
  } catch {
    return raw || '—';
  }
}

/* ── Main Page ───────────────────────────────────────── */
export function TutorClassesPage() {
  const [classes, setClasses] = useState<TutorClassDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [scheduleWarning, setScheduleWarning] = useState(false);

  useEffect(() => {
    tutorApi.getMyClasses()
      .then(setClasses)
      .catch(() => {})
      .finally(() => setLoading(false));

    checkScheduleWarning();
  }, []);

  const checkScheduleWarning = async () => {
    const dayOfWeek = new Date().getDay();
    const isWeekend = dayOfWeek === 0 || dayOfWeek === 5 || dayOfWeek === 6;
    if (!isWeekend) return;

    try {
      const status = await tutorApi.getScheduleStatus();
      setScheduleWarning(!status.hasNextWeekSessions);
    } catch { /* ignore */ }
  };

  return (
    <div className="dash-page">
      <TutorSidebar active="classes" showScheduleWarning={scheduleWarning} />
      <main className="dash-main">
        <DashboardHeader />
        <div className="dash-body">
          <div className="tclass-header">
            <h1 className="tclass-title">📚 Lớp học của tôi</h1>
            <p className="tclass-subtitle">Danh sách các lớp bạn đang phụ trách giảng dạy</p>
          </div>

          {loading ? (
            <div className="tclass-empty">Đang tải...</div>
          ) : classes.length === 0 ? (
            <div className="tclass-empty">
              <BookOpen size={40} style={{ opacity: 0.3, marginBottom: 16 }} />
              <p>Bạn chưa được phân công lớp nào.</p>
            </div>
          ) : (
            <div className="tclass-grid">
              {classes.map(cls => {
                const statusCfg = STATUS_CFG[cls.status] ?? { label: cls.status, color: '#6b7280' };
                return (
                  <div key={cls.id} className="tclass-card">
                    <div className="tclass-card-header">
                      <div className="tclass-card-icon">
                        {cls.subject.slice(0, 2).toUpperCase()}
                      </div>
                      <span className="tclass-status" style={{
                        color: statusCfg.color,
                        background: statusCfg.color + '15',
                        border: `1px solid ${statusCfg.color}40`,
                      }}>
                        {statusCfg.label}
                      </span>
                    </div>

                    <h3 className="tclass-card-title">{cls.title}</h3>
                    <div className="tclass-card-subject">{cls.subject} • {cls.grade}</div>

                    <div className="tclass-card-details">
                      <div className="tclass-detail-row">
                        <Calendar size={14} />
                        <span>{parseSchedule(cls.schedule)}</span>
                      </div>
                      <div className="tclass-detail-row">
                        <Clock size={14} />
                        <span>{cls.sessionsPerWeek} buổi/tuần • {cls.sessionDurationMin} phút/buổi</span>
                      </div>
                      <div className="tclass-detail-row">
                        <Users size={14} />
                        <span>{MODE_LABELS[cls.mode] || cls.mode}</span>
                      </div>
                      {cls.address && (
                        <div className="tclass-detail-row">
                          <MapPin size={14} />
                          <span>{cls.address}</span>
                        </div>
                      )}
                    </div>

                    <div className="tclass-card-footer">
                      <div className="tclass-fee">
                        <span className="tclass-fee-label">Thù lao</span>
                        <span className="tclass-fee-value">{formatCurrency(cls.tutorFee)}/tháng</span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
