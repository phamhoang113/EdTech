import { useState, useEffect, useMemo } from 'react';
import {
  Calendar as CalendarIcon, Clock, Video, 
  ChevronLeft, ChevronRight, Info, AlertTriangle
} from 'lucide-react';
import { tutorApi } from '../../services/tutorApi';
import type { TutorSessionDTO } from '../../services/tutorApi';
import { DashboardHeader } from '../../components/layout/DashboardHeader';
import { TutorSidebar } from '../../components/tutor/TutorSidebar';
import '../dashboard/Dashboard.css';
import './TutorSchedule.css';

/* ── Helpers ─────────────────────────────────────────── */
const DAY_NAMES = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

const STATUS_CFG: Record<string, { label: string; color: string; bg: string }> = {
  SCHEDULED: { label: 'Sắp tới',       color: '#6366f1', bg: '#eef2ff' },
  LIVE:      { label: 'Đang diễn ra',   color: '#10b981', bg: '#d1fae5' },
  COMPLETED: { label: 'Đã hoàn thành', color: '#6b7280', bg: '#f3f4f6' },
  CANCELLED: { label: 'Đã huỷ',        color: '#ef4444', bg: '#fee2e2' },
};

function formatTime(t: string) {
  return t ? t.substring(0, 5) : '--:--';
}

function getWeekRange(date: Date): { start: Date; end: Date } {
  const dayOfWeek = date.getDay() === 0 ? 7 : date.getDay();
  const start = new Date(date);
  start.setDate(date.getDate() - dayOfWeek + 1);
  start.setHours(0, 0, 0, 0);

  const end = new Date(start);
  end.setDate(start.getDate() + 6);
  end.setHours(23, 59, 59, 999);

  return { start, end };
}

function formatDate(d: Date) {
  return `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}`;
}

function isWeekendDay(): boolean {
  const day = new Date().getDay();
  return day === 0 || day === 5 || day === 6;
}

/* ── Main Page ───────────────────────────────────────── */
export function TutorSchedulePage() {
  const [sessions, setSessions] = useState<TutorSessionDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentDate, setCurrentDate] = useState(new Date());
  const [scheduleWarning, setScheduleWarning] = useState(false);

  useEffect(() => {
    fetchSessions();
    checkScheduleWarning();
  }, []);

  const fetchSessions = async () => {
    try {
      setLoading(true);
      const data = await tutorApi.getMySessions();
      setSessions(data);
    } catch {
      console.error('Failed to load sessions');
    } finally {
      setLoading(false);
    }
  };

  const checkScheduleWarning = async () => {
    if (!isWeekendDay()) return;
    try {
      const status = await tutorApi.getScheduleStatus();
      setScheduleWarning(!status.hasNextWeekSessions);
    } catch { /* ignore */ }
  };

  const { start: weekStart, end: weekEnd } = useMemo(() => getWeekRange(currentDate), [currentDate]);

  const filteredSessions = useMemo(() => {
    return sessions.filter(s => {
      const d = new Date(s.sessionDate);
      return d >= weekStart && d <= weekEnd;
    });
  }, [sessions, weekStart, weekEnd]);

  // Group sessions by date
  const sessionsByDate = useMemo(() => {
    const map = new Map<string, TutorSessionDTO[]>();
    filteredSessions.forEach(s => {
      const key = s.sessionDate;
      if (!map.has(key)) map.set(key, []);
      map.get(key)!.push(s);
    });
    return map;
  }, [filteredSessions]);

  // Build week days array
  const weekDays = useMemo(() => {
    const days = [];
    for (let i = 0; i < 7; i++) {
      const d = new Date(weekStart);
      d.setDate(weekStart.getDate() + i);
      days.push(d);
    }
    return days;
  }, [weekStart]);

  const navigateWeek = (delta: number) => {
    const next = new Date(currentDate);
    next.setDate(next.getDate() + delta * 7);
    setCurrentDate(next);
  };

  const goToThisWeek = () => setCurrentDate(new Date());

  const isToday = (d: Date) => {
    const now = new Date();
    return d.getDate() === now.getDate() && d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear();
  };

  return (
    <div className="dash-page">
      <TutorSidebar active="schedule" showScheduleWarning={scheduleWarning} />
      <main className="dash-main">
        <DashboardHeader />
        <div className="dash-body" style={{ padding: 0 }}>
          <div className="tsched-container">
            {/* Warning banner */}
            {scheduleWarning && (
              <div className="tsched-warning-banner">
                <AlertTriangle size={18} />
                <div>
                  <strong>Chưa có lịch dạy tuần sau!</strong>
                  <span> Hãy liên hệ admin hoặc phụ huynh để xác nhận lịch tuần tới.</span>
                </div>
              </div>
            )}

            {/* Header */}
            <div className="tsched-header-section">
              <div className="tsched-header">
                <h1 className="tsched-title">📅 Lịch dạy</h1>
                <p className="tsched-subtitle">
                  Tuần {formatDate(weekStart)} — {formatDate(weekEnd)}
                </p>
              </div>

              <div className="tsched-controls">
                <button className="tsched-nav-btn" onClick={() => navigateWeek(-1)}>
                  <ChevronLeft size={16} />
                </button>
                <button
                  className={`tsched-nav-btn ${isToday(currentDate) ? 'tsched-nav-btn--active' : ''}`}
                  onClick={goToThisWeek}
                >
                  <CalendarIcon size={14} /> Tuần này
                </button>
                <button className="tsched-nav-btn" onClick={() => navigateWeek(1)}>
                  <ChevronRight size={16} />
                </button>
              </div>
            </div>

            {/* Week view */}
            <div className="tsched-body">
              {loading ? (
                <div className="tsched-empty">Đang tải lịch dạy...</div>
              ) : (
                <div className="tsched-week-grid">
                  {weekDays.map(day => {
                    const dateKey = day.toISOString().split('T')[0];
                    const daySessions = sessionsByDate.get(dateKey) || [];
                    const dayIndex = day.getDay();
                    const todayClass = isToday(day) ? 'tsched-day--today' : '';

                    return (
                      <div key={dateKey} className={`tsched-day-col ${todayClass}`}>
                        <div className="tsched-day-header">
                          <span className="tsched-day-name">{DAY_NAMES[dayIndex]}</span>
                          <span className={`tsched-day-date ${isToday(day) ? 'tsched-day-date--today' : ''}`}>
                            {day.getDate()}
                          </span>
                        </div>

                        <div className="tsched-day-sessions">
                          {daySessions.length === 0 ? (
                            <div className="tsched-no-session">—</div>
                          ) : (
                            daySessions.map(s => {
                              const cfg = STATUS_CFG[s.status] ?? { label: s.status, color: '#6b7280', bg: '#f3f4f6' };
                              return (
                                <div key={s.id} className={`tsched-session-card ${s.status === 'CANCELLED' ? 'tsched-session--cancelled' : ''}`}>
                                  <div className="tsched-session-time">
                                    <Clock size={12} />
                                    <span>{formatTime(s.startTime)} - {formatTime(s.endTime)}</span>
                                  </div>
                                  <div className="tsched-session-title">{s.classTitle}</div>
                                  <div className="tsched-session-subject">{s.subject}</div>
                                  <span className="tsched-session-status" style={{
                                    color: cfg.color,
                                    background: cfg.bg,
                                    border: `1px solid ${cfg.color}30`,
                                  }}>
                                    {cfg.label}
                                  </span>
                                  {s.meetLink && s.status !== 'CANCELLED' && (
                                    <a href={s.meetLink} target="_blank" rel="noreferrer" className="tsched-meet-link">
                                      <Video size={12} /> Meet
                                    </a>
                                  )}
                                  {s.tutorNote && (
                                    <div className="tsched-session-note">
                                      <Info size={11} />
                                      <span>{s.tutorNote}</span>
                                    </div>
                                  )}
                                </div>
                              );
                            })
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>

            {/* Stats summary */}
            {!loading && (
              <div className="tsched-summary">
                <div className="tsched-summary-item">
                  <span className="tsched-summary-val">{filteredSessions.filter(s => s.status === 'SCHEDULED').length}</span>
                  <span className="tsched-summary-lbl">Sắp tới</span>
                </div>
                <div className="tsched-summary-item">
                  <span className="tsched-summary-val">{filteredSessions.filter(s => s.status === 'COMPLETED').length}</span>
                  <span className="tsched-summary-lbl">Đã dạy</span>
                </div>
                <div className="tsched-summary-item">
                  <span className="tsched-summary-val">{filteredSessions.filter(s => s.status === 'CANCELLED').length}</span>
                  <span className="tsched-summary-lbl">Đã huỷ</span>
                </div>
                <div className="tsched-summary-item">
                  <span className="tsched-summary-val">{filteredSessions.length}</span>
                  <span className="tsched-summary-lbl">Tổng</span>
                </div>
              </div>
            )}
          </div>
        </div>
      </main>
    </div>
  );
}
