import { BookOpen, MapPin, Clock, Calendar, Users, Settings, AlertCircle } from 'lucide-react';
import { useState, useEffect, useMemo } from 'react';

import { tutorApi } from '../../services/tutorApi';
import type { TutorClassDTO, ScheduleSlot } from '../../services/tutorApi';
import { DashboardHeader } from '../../components/layout/DashboardHeader';
import { TutorSidebar } from '../../components/tutor/TutorSidebar';
import { ScheduleEditor } from '../../components/tutor/ScheduleEditor';
import '../../components/tutor/ScheduleEditor.css';
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

function parseScheduleSlots(raw: string): ScheduleSlot[] {
  try {
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) return parsed;
    return [];
  } catch {
    return [];
  }
}

function formatScheduleDisplay(raw: string): string {
  const slots = parseScheduleSlots(raw);
  if (slots.length === 0) return 'Chưa có lịch';
  return slots.map(s => `${s.dayOfWeek} ${s.startTime}-${s.endTime}`).join(' • ');
}

const EN_TO_VN: Record<string, string> = {
  Monday: 'T2', Tuesday: 'T3', Wednesday: 'T4',
  Thursday: 'T5', Friday: 'T6', Saturday: 'T7', Sunday: 'CN',
};
function normalizeDay(d: string) { return EN_TO_VN[d] ?? d; }

function timeToMin(t: string) {
  const [h, m] = t.split(':').map(Number);
  return h * 60 + m;
}

/** Detect cross-class schedule conflicts.
 *  Trả về map: classId → danh sách slot bị trùng từ lớp khác */
function detectConflicts(classes: TutorClassDTO[]): Map<string, string[]> {
  const map = new Map<string, string[]>();
  const parsed = classes.map(c => ({
    id: c.id,
    slots: parseScheduleSlots(c.schedule).map(s => ({
      ...s, dayOfWeek: normalizeDay(s.dayOfWeek),
    })),
  }));

  for (let i = 0; i < parsed.length; i++) {
    for (let j = i + 1; j < parsed.length; j++) {
      const a = parsed[i], b = parsed[j];
      for (const sa of a.slots) {
        for (const sb of b.slots) {
          if (sa.dayOfWeek !== sb.dayOfWeek) continue;
          const aStart = timeToMin(sa.startTime), aEnd = timeToMin(sa.endTime);
          const bStart = timeToMin(sb.startTime), bEnd = timeToMin(sb.endTime);
          if (aStart < bEnd && aEnd > bStart) {
            // Lớp A thấy slot bị trùng từ lớp B
            if (!map.has(a.id)) map.set(a.id, []);
            map.get(a.id)!.push(`${sb.dayOfWeek} ${sb.startTime}-${sb.endTime}`);
            // Lớp B thấy slot bị trùng từ lớp A
            if (!map.has(b.id)) map.set(b.id, []);
            map.get(b.id)!.push(`${sa.dayOfWeek} ${sa.startTime}-${sa.endTime}`);
          }
        }
      }
    }
  }
  return map;
}

/* ── Main Page ───────────────────────────────────────── */
export function TutorClassesPage() {
  const [classes, setClasses] = useState<TutorClassDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [scheduleWarning, setScheduleWarning] = useState(false);
  const [draftCount, setDraftCount] = useState(0);
  const [editingClassId, setEditingClassId] = useState<string | null>(null);

  useEffect(() => {
    fetchAll();
  }, []);

  const fetchAll = async () => {
    try {
      const [classesData, statusData] = await Promise.all([
        tutorApi.getMyClasses(),
        tutorApi.getScheduleStatus().catch(() => ({ hasNextWeekSessions: true, hasDraftSessions: false, draftCount: 0 })),
      ]);
      setClasses(classesData);
      setScheduleWarning(statusData.hasDraftSessions);
      setDraftCount(statusData.draftCount);
    } catch { /* ignore */ }
    finally { setLoading(false); }
  };

  const handleSaveSchedule = async (classId: string, slots: ScheduleSlot[]) => {
    await tutorApi.setClassSchedule(classId, slots);
    setEditingClassId(null);
    await fetchAll();
  };

  const conflictMap = useMemo(() => detectConflicts(classes), [classes]);

  return (
    <div className="dash-page">
      <TutorSidebar active="classes" showScheduleWarning={scheduleWarning} draftCount={draftCount} />
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
                const hasSchedule = parseScheduleSlots(cls.schedule).length > 0;
                const isEditing = editingClassId === cls.id;
                const conflictSlots = conflictMap.get(cls.id) ?? [];
                const hasConflict = conflictSlots.length > 0;

                return (
                  <div key={cls.id} className={`tclass-card ${hasConflict ? 'tclass-card--conflict' : ''}`}>
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
                    {cls.classCode && (
                      <div style={{ fontSize: '0.75rem', color: '#6366f1', fontWeight: 600, marginBottom: 4 }}>
                        🏷️ #{cls.classCode}
                      </div>
                    )}
                    <div className="tclass-card-subject">{cls.subject} • {cls.grade}</div>

                    {/* Conflict warning */}
                    {hasConflict && (
                      <div className="tclass-conflict-banner">
                        <AlertCircle size={14} />
                        <span>Trùng lịch {conflictSlots.join(', ')}</span>
                      </div>
                    )}

                    {/* Schedule warning banner */}
                    {!hasSchedule && (
                      <div className="tclass-schedule-warning">
                        <AlertCircle size={14} />
                        <span>Chưa có lịch dạy. Hãy thiết lập lịch để bắt đầu!</span>
                      </div>
                    )}

                    {/* Schedule Editor */}
                    {isEditing ? (
                      <ScheduleEditor
                        initialSlots={parseScheduleSlots(cls.schedule)}
                        sessionDurationMin={cls.sessionDurationMin}
                        onSave={(slots) => handleSaveSchedule(cls.id, slots)}
                        onCancel={() => setEditingClassId(null)}
                      />
                    ) : (
                      <>
                        <div className="tclass-card-details">
                          <div className="tclass-detail-row">
                            <Calendar size={14} />
                            <span>{formatScheduleDisplay(cls.schedule)}</span>
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
                            <span className="tclass-fee-label">Lương</span>
                            <span className="tclass-fee-value">{formatCurrency(cls.tutorFee)}/tháng</span>
                          </div>
                          <button
                            className="tclass-edit-schedule-btn"
                            onClick={() => setEditingClassId(cls.id)}
                          >
                            <Settings size={13} />
                            {hasSchedule ? 'Sửa lịch' : 'Thiết lập lịch'}
                          </button>
                        </div>
                      </>
                    )}
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
