import { CalendarIcon, Clock, MapPin, ChevronLeft, ChevronRight, AlertTriangle, Video, Check, Trash2, Plus, X, Save, CalendarMinus, AlertCircle } from 'lucide-react';
import { useState, useEffect, useMemo, useRef } from 'react';
import { getDisplayStatus } from '../../utils/sessionStatus';

import { TimePicker24h } from '../../components/common/TimePicker24h';
import '../../components/common/TimePicker24h.css';
import { tutorApi } from '../../services/tutorApi';
import type { TutorSessionDTO, TutorClassDTO } from '../../services/tutorApi';
import { uploadImage } from '../../services/storageApi';
import '../dashboard/Dashboard.css';
import './TutorSchedule.css';
import { polyfill } from "mobile-drag-drop";
import { scrollBehaviourDragImageTranslateOverride } from "mobile-drag-drop/scroll-behaviour";
import "mobile-drag-drop/default.css";

// Enable mobile drag and drop polyfill
polyfill({
  dragImageTranslateOverride: scrollBehaviourDragImageTranslateOverride,
  holdToDrag: 300 // 300ms long press to drag on mobile
});

// Polyfill fix for iOS to prevent scrolling when dragging
window.addEventListener('touchmove', function() {}, {passive: false});

/* ── Helpers ─────────────────────────────────────────── */
const DAY_NAMES = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

const STATUS_CFG: Record<string, { label: string; color: string; bg: string }> = {
  DRAFT: { label: 'Bản nháp', color: 'var(--color-warning)', bg: 'rgba(245, 158, 11, 0.1)' },
  SCHEDULED: { label: 'Sắp tới', color: 'var(--color-primary)', bg: 'rgba(99, 102, 241, 0.1)' },
  LIVE: { label: 'Đang diễn ra', color: 'var(--color-success)', bg: 'rgba(16, 185, 129, 0.1)' },
  COMPLETED: { label: 'Đã hoàn thành', color: 'var(--color-text-muted)', bg: 'var(--color-surface-hover)' },
  CANCELLED: { label: 'Đã huỷ', color: 'var(--color-danger)', bg: 'rgba(239, 68, 68, 0.1)' },
  CANCELLED_BY_TUTOR: { label: 'Đã huỷ (GS)', color: 'var(--color-danger)', bg: 'rgba(239, 68, 68, 0.1)' },
  CANCELLED_BY_STUDENT: { label: 'Đã huỷ (HS)', color: 'var(--color-danger)', bg: 'rgba(239, 68, 68, 0.1)' },
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

function toLocalDateString(d: Date): string {
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

/* ── Time Edit Modal ─────────────────────────────────── */
interface TimeEditModalProps {
  session: TutorSessionDTO;
  onSave: (sessionId: string, startTime: string, endTime: string, sessionDate: string) => void;
  onClose: () => void;
}

function TimeEditModal({ session, onSave, onClose }: TimeEditModalProps) {
  // Tính duration (phút) từ session gốc
  const computeDuration = (): number => {
    const [sh, sm] = session.startTime.split(':').map(Number);
    const [eh, em] = session.endTime.split(':').map(Number);
    return (eh * 60 + em) - (sh * 60 + sm);
  };
  const durationMin = computeDuration();

  const computeEndTime = (start: string): string => {
    const [h, m] = start.split(':').map(Number);
    const total = h * 60 + m + durationMin;
    return `${String(Math.floor(total / 60) % 24).padStart(2, '0')}:${String(total % 60).padStart(2, '0')}`;
  };

  const [sessionDate, setSessionDate] = useState(session.sessionDate);
  const [startTime, setStartTime] = useState(formatTime(session.startTime));
  const [endTime, setEndTime] = useState(computeEndTime(startTime));
  const [error, setError] = useState('');
  const modalRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    setEndTime(computeEndTime(startTime));
  }, [startTime]);

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (modalRef.current && !modalRef.current.contains(e.target as Node)) {
        onClose();
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [onClose]);

  const handleSave = () => {
    if (startTime >= endTime) {
      setError('Giờ bắt đầu phải trước giờ kết thúc');
      return;
    }
    if (!sessionDate) {
      setError('Vui lòng chọn ngày học');
      return;
    }
    onSave(session.id, startTime, endTime, sessionDate);
  };

  return (
    <div className="tsched-time-modal-overlay">
      <div className="tsched-time-modal" ref={modalRef}>
        <div className="tsched-time-modal-header">
          <h4>Chỉnh lịch dạy</h4>
          <button className="tsched-time-modal-close" onClick={onClose}><X size={16} /></button>
        </div>
        <div className="tsched-time-modal-body">
          <div className="tsched-time-modal-title">{session.classTitle}</div>
          <div className="tsched-time-modal-duration">Thời lượng: <strong>{durationMin} phút</strong></div>
          <div className="tsched-time-inputs" style={{ marginBottom: 16 }}>
            <div className="tsched-time-field" style={{ width: '100%' }}>
              <label>Ngày học</label>
              <input 
                type="date" 
                value={sessionDate} 
                onChange={e => setSessionDate(e.target.value)}
                style={{ width: '100%', padding: '8px', border: '1px solid var(--color-border)', borderRadius: '4px', fontSize: '0.9rem', backgroundColor: 'var(--color-surface)', color: 'var(--color-text)', colorScheme: 'var(--color-scheme)' }}
              />
            </div>
          </div>
          <div className="tsched-time-inputs">
            <div className="tsched-time-field">
              <label>Bắt đầu</label>
              <TimePicker24h
                value={startTime}
                onChange={value => { setStartTime(value); setError(''); }}
              />
            </div>
            <span className="tsched-time-separator">→</span>
            <div className="tsched-time-field">
              <label>Kết thúc</label>
              <span className="tsched-time-computed">{endTime}</span>
            </div>
          </div>
          {error && <div className="tsched-time-error">{error}</div>}
        </div>
        <div className="tsched-time-modal-footer">
          <button className="tsched-time-cancel-btn" onClick={onClose}>Huỷ</button>
          <button className="tsched-time-save-btn" onClick={handleSave}>
            <Save size={14} /> Lưu
          </button>
        </div>
      </div>
    </div>
  );
}

/* ── Absence Request Modal ───────────────────────────── */
function AbsenceRequestModal({ session, onClose, onSubmit }: {
  session: TutorSessionDTO;
  onClose: () => void;
  onSubmit: (reason: string, makeupDate?: string, makeupTime?: string, proofFile?: File) => Promise<void>;
}) {
  const [reason, setReason] = useState('');
  const [makeupDate, setMakeupDate] = useState('');
  const [makeupTime, setMakeupTime] = useState('');
  const [proofFile, setProofFile] = useState<File | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!reason.trim()) {
      setError('Vui lòng nhập lý do nghỉ');
      return;
    }
    try {
      setSubmitting(true);
      setError('');
      await onSubmit(reason, makeupDate, makeupTime, proofFile || undefined);
    } catch (err: any) {
      setError(err.response?.data?.message || err.message || 'Có lỗi xảy ra trong quá trình gửi đơn');
      setSubmitting(false);
    }
  };

  return (
    <div className="tsched-time-modal-overlay">
      <div className="tsched-time-modal" style={{ width: '400px' }}>
        <div className="tsched-time-modal-header">
          <h4>Xin vắng mặt / Nghỉ phép</h4>
          <button className="tsched-time-modal-close" onClick={onClose}><X size={16} /></button>
        </div>
        <div className="tsched-time-modal-body">
          <div className="tsched-alert tsched-alert-warning" style={{ marginBottom: 16, display: 'flex', alignItems: 'flex-start', gap: 8, padding: 12, background: 'rgba(245, 158, 11, 0.1)', color: 'var(--color-warning)', borderRadius: 6 }}>
            <AlertTriangle size={16} style={{ flexShrink: 0, marginTop: 2 }} />
            <span style={{ fontSize: '0.85rem', lineHeight: '1.4' }}>Lưu ý: Huỷ lớp sát giờ sẽ ghi nhận 1 lỗi vi phạm và có thể bị trừ lương/KPI theo quy định của Trung tâm.</span>
          </div>
          
          <div style={{ marginBottom: 16, background: 'var(--color-surface-hover)', padding: 12, borderRadius: 6 }}>
            <div style={{ fontSize: '0.9rem', color: 'var(--color-text)', marginBottom: 4 }}>Lớp học: <strong>{session.classTitle}</strong></div>
            <div style={{ fontSize: '0.85rem', color: 'var(--color-text-secondary)' }}>Thời gian: {formatDate(new Date(session.sessionDate))} | {formatTime(session.startTime)} - {formatTime(session.endTime)}</div>
          </div>

          <form id="absence-form" onSubmit={handleSubmit}>
            <div className="tsched-time-field" style={{ width: '100%', marginBottom: 16 }}>
              <label>Lý do nghỉ <span style={{color: '#ef4444'}}>*</span></label>
              <textarea 
                value={reason} 
                onChange={e => setReason(e.target.value)}
                placeholder="Ví dụ: Bận việc gia đình đột xuất, Ốm..." 
                rows={3}
                style={{ width: '100%', padding: '8px', border: '1px solid var(--color-border)', borderRadius: '4px', resize: 'none', fontSize: '0.9rem', backgroundColor: 'var(--color-surface)', color: 'var(--color-text)' }}
              />
            </div>

            <div style={{ fontSize: '0.9rem', fontWeight: 600, marginBottom: 8, color: '#374151' }}>Đề xuất học bù (Không bắt buộc)</div>
            <div className="tsched-time-field" style={{ width: '100%', marginBottom: 16 }}>
              <label>Ngày học bù</label>
              <input 
                type="date" 
                value={makeupDate} 
                onChange={e => setMakeupDate(e.target.value)}
                style={{ width: '100%', padding: '8px', border: '1px solid var(--color-border)', borderRadius: '4px', fontSize: '0.9rem', backgroundColor: 'var(--color-surface)', color: 'var(--color-text)', colorScheme: 'var(--color-scheme)' }}
              />
            </div>
            
            <div className="tsched-time-field" style={{ width: '100%', marginBottom: 16 }}>
              <label>Giờ bắt đầu</label>
              <div style={{ marginTop: '4px', width: 'fit-content' }}>
                <TimePicker24h 
                  value={makeupTime} 
                  onChange={val => setMakeupTime(val)}
                />
              </div>
            </div>
            
            <div className="tsched-time-field" style={{ width: '100%', marginBottom: 16 }}>
              <label>Minh chứng (Ảnh)</label>
              <input 
                type="file" 
                accept="image/*" 
                style={{ fontSize: '0.85rem' }} 
                onChange={e => setProofFile(e.target.files?.[0] || null)}
              />
              <div style={{ fontSize: '0.75rem', color: '#6b7280', marginTop: 4 }}>*Hỗ trợ upload sau</div>
            </div>

            {error && <div className="tsched-time-error" style={{ marginBottom: 16 }}>{error}</div>}
          </form>
        </div>
        <div className="tsched-time-modal-footer">
          <button className="tsched-time-cancel-btn" type="button" onClick={onClose} disabled={submitting}>Huỷ</button>
          <button className="tsched-time-save-btn" form="absence-form" type="submit" disabled={submitting} style={{ background: '#ef4444', borderColor: '#ef4444' }}>
            {submitting ? 'Đang gửi...' : 'Gửi đơn cho Admin'}
          </button>
        </div>
      </div>
    </div>
  );
}

function CreateDraftModal({ onClose, onSuccess, initialDateStr, initialClassId, makeupForSessionId }: { onClose: () => void; onSuccess: () => void; initialDateStr: string; initialClassId?: string; makeupForSessionId?: string; }) {
  const [classes, setClasses] = useState<TutorClassDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');
  
  const [classId, setClassId] = useState('');
  const [sessionDate, setSessionDate] = useState(initialDateStr);
  const [startTime, setStartTime] = useState('08:00');

  // Compute duration from selected class
  const selectedClass = useMemo(() => classes.find(c => c.id === classId), [classes, classId]);
  const durationMin = selectedClass?.sessionDurationMin || 120;

  // Auto-calculate end time based on start time + duration
  const computedEndTime = useMemo(() => {
    if (!startTime) return '';
    const [h, m] = startTime.split(':').map(Number);
    const totalMin = h * 60 + m + durationMin;
    const newH = Math.floor(totalMin / 60) % 24;
    const newM = totalMin % 60;
    return `${String(newH).padStart(2, '0')}:${String(newM).padStart(2, '0')}`;
  }, [startTime, durationMin]);

  const isPast = useMemo(() => {
    if (!sessionDate || !computedEndTime) return false;
    const now = new Date();
    const sessionEndStr = `${sessionDate}T${computedEndTime}`;
    const sessionEndDate = new Date(sessionEndStr);
    return sessionEndDate < now;
  }, [sessionDate, computedEndTime]);

  useEffect(() => {
    tutorApi.getMyClasses().then(res => {
      setClasses(res);
      if (initialClassId && res.some(c => c.id === initialClassId)) {
        setClassId(initialClassId);
      } else if (res.length > 0) {
        setClassId(res[0].id);
      }
    }).catch(() => setError('Không tải được danh sách lớp'))
      .finally(() => setLoading(false));
  }, [initialClassId]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!classId || !sessionDate) return setError('Vui lòng điền đủ thông tin');
    try {
      setSubmitting(true);
      await tutorApi.createSingleDraft({ classId, sessionDate, startTime, endTime: computedEndTime, makeupForSessionId });
      onSuccess();
    } catch (err: any) {
      setError(err.response?.data?.message || 'Có lỗi xảy ra');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="tsched-time-modal-overlay">
      <div className="tsched-time-modal" style={{ width: '400px' }}>
        <div className="tsched-time-modal-header">
          <h4>{makeupForSessionId ? 'Tạo lịch bù' : 'Tạo lịch tăng cường'}</h4>
          <button className="tsched-time-modal-close" onClick={onClose}><X size={16} /></button>
        </div>
        <div className="tsched-time-modal-body">
          {loading ? (
            <div style={{ textAlign: 'center', padding: '20px' }}>Đang tải danh sách lớp...</div>
          ) : (
            <form id="create-draft-form" onSubmit={handleSubmit}>
              <div className="tsched-time-field" style={{ width: '100%', marginBottom: 16 }}>
                <label>Lớp học <span style={{color: '#ef4444'}}>*</span></label>
                <select 
                  value={classId} 
                  onChange={e => setClassId(e.target.value)}
                  style={{ width: '100%', padding: '8px', border: '1px solid var(--color-border)', borderRadius: '4px', fontSize: '0.9rem', backgroundColor: 'var(--color-surface)', color: 'var(--color-text)' }}
                >
                  {classes.map(c => <option key={c.id} value={c.id}>{c.title}{c.classCode ? ` - ${c.classCode}` : ''}</option>)}
                </select>
                {selectedClass && selectedClass.address && (
                  <div style={{ marginTop: '8px', padding: '10px 12px', background: 'var(--color-surface-hover)', border: '1px solid var(--color-border)', borderRadius: '6px', fontSize: '0.8rem', color: 'var(--color-text-secondary)', lineHeight: '1.4' }}>
                    <MapPin size={12} style={{ display: 'inline', marginRight: '4px', color: 'var(--color-text-muted)', transform: 'translateY(-1px)' }} />
                    <span style={{ fontWeight: 600 }}>Địa chỉ:</span> {selectedClass.address}
                  </div>
                )}
              </div>
              <div className="tsched-time-field" style={{ width: '100%', marginBottom: 16 }}>
                <label>Ngày học <span style={{color: '#ef4444'}}>*</span></label>
                <input 
                  type="date" 
                  value={sessionDate} 
                  onChange={e => setSessionDate(e.target.value)}
                  style={{ width: '100%', padding: '8px', border: '1px solid var(--color-border)', borderRadius: '4px', fontSize: '0.9rem', backgroundColor: 'var(--color-surface)', color: 'var(--color-text)', colorScheme: 'var(--color-scheme)' }}
                />
              </div>
              <div className="tsched-time-inputs" style={{ marginBottom: 16 }}>
                <div className="tsched-time-field">
                  <label>Giờ bắt đầu</label>
                  <TimePicker24h 
                    value={startTime} 
                    onChange={value => { setStartTime(value); setError(''); }}
                  />
                </div>
                <span className="tsched-time-separator" style={{ paddingTop: '28px' }}>→</span>
                <div className="tsched-time-field">
                  <label>Giờ kết thúc ({durationMin}p)</label>
                  <span className="tsched-time-computed" style={{ padding: '10px' }}>{computedEndTime}</span>
                </div>
              </div>
              {isPast && (
                <div style={{ marginBottom: 16, padding: '12px', background: 'rgba(245, 158, 11, 0.1)', border: '1px solid rgba(245, 158, 11, 0.2)', borderRadius: '6px', color: 'var(--color-warning)', fontSize: '0.85rem', display: 'flex', gap: '8px', alignItems: 'flex-start' }}>
                  <AlertCircle size={16} style={{ flexShrink: 0, marginTop: '2px' }} />
                  <div>
                    <strong>Lưu ý:</strong> Giờ dạy đã qua sẽ được đánh dấu là <strong>Hoàn thành</strong> để chờ Admin đối soát, thay vì "Sắp tới".
                  </div>
                </div>
              )}
              {error && <div className="tsched-time-error" style={{ marginBottom: 16 }}>{error}</div>}
            </form>
          )}
        </div>
        <div className="tsched-time-modal-footer">
          <button className="tsched-time-cancel-btn" type="button" onClick={onClose} disabled={submitting}>Huỷ</button>
          <button className="tsched-time-save-btn" form="create-draft-form" type="submit" disabled={submitting || loading || classes.length === 0}>
            {submitting ? 'Đang tạo...' : 'Tạo lịch nháp'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ── Session Detail Popup ────────────────────────────── */
function SessionDetailPopup({ session, onClose, onEditTime, onDelete, onRequestAbsence }: {
  session: TutorSessionDTO;
  onClose: () => void;
  onEditTime: () => void;
  onDelete: () => void;
  onRequestAbsence: () => void;
}) {
  const overlayRef = useRef<HTMLDivElement>(null);
  const displayStatus = getDisplayStatus(session.status, session.sessionDate, session.endTime);
  const cfg = STATUS_CFG[displayStatus] ?? { label: displayStatus, color: '#6b7280', bg: '#f3f4f6' };
  const isDraft = session.status === 'DRAFT';

  return (
    <div className="tsched-detail-overlay" ref={overlayRef} onClick={e => { if (e.target === overlayRef.current) onClose(); }}>
      <div className="tsched-detail-popup">
        <button className="tsched-detail-close" onClick={onClose}><X size={18} /></button>

        <div className="tsched-detail-header">
          <span className="tsched-detail-status" style={{ color: cfg.color, background: cfg.bg, border: `1px solid ${cfg.color}30` }}>
            {cfg.label}
          </span>
          {session.classCode && (
            <span style={{ fontSize: '0.75rem', color: '#6366f1', fontWeight: 700, background: '#eef2ff', padding: '2px 8px', borderRadius: '12px' }}>
              #{session.classCode}
            </span>
          )}
          <h3 className="tsched-detail-title">{session.classTitle}</h3>
          <p className="tsched-detail-subject">{session.subject}</p>
        </div>

        <div className="tsched-detail-body">
          <div className="tsched-detail-row">
            <Clock size={15} />
            <div>
              <div className="tsched-detail-label">Thời gian</div>
              <div className="tsched-detail-value">{formatTime(session.startTime)} – {formatTime(session.endTime)}</div>
            </div>
          </div>
          <div className="tsched-detail-row">
            <CalendarIcon size={15} />
            <div>
              <div className="tsched-detail-label">Ngày</div>
              <div className="tsched-detail-value">{session.sessionDate}</div>
            </div>
          </div>
          {session.address && (
            <div className="tsched-detail-row">
              <MapPin size={15} />
              <div>
                <div className="tsched-detail-label">Địa chỉ</div>
                <div className="tsched-detail-value">{session.address}</div>
              </div>
            </div>
          )}
          {session.tutorNote && (
            <div className="tsched-detail-row">
              <CalendarIcon size={15} />
              <div>
                <div className="tsched-detail-label">Ghi chú</div>
                <div className="tsched-detail-value">{session.tutorNote}</div>
              </div>
            </div>
          )}
        </div>

        {isDraft ? (
          <div className="tsched-detail-actions">
            <button className="tsched-detail-edit-btn" onClick={onEditTime}>
              <Clock size={14} /> Chỉnh giờ
            </button>
            <button className="tsched-detail-delete-btn" onClick={onDelete}>
              <Trash2 size={14} /> Huỷ buổi
            </button>
          </div>
        ) : session.status === 'SCHEDULED' || session.status === 'LIVE' ? (
          <div className="tsched-detail-actions" style={{ flexDirection: 'column', gap: '8px' }}>
            {session.meetLink && (
              <a href={session.meetLink} target="_blank" rel="noreferrer" className="tsched-time-save-btn" style={{ width: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px', textDecoration: 'none', background: '#10b981', borderColor: '#10b981' }}>
                <Video size={14} /> Vào lớp (Google Meet)
              </a>
            )}
            {session.status === 'SCHEDULED' && (
              session.hasPendingAbsence ? (
                <div style={{ width: '100%', textAlign: 'center', padding: '10px', borderRadius: '6px', background: 'rgba(245, 158, 11, 0.1)', color: 'var(--color-warning)', fontWeight: 600, fontSize: '0.85rem', border: '1px solid rgba(245, 158, 11, 0.2)' }}>
                  ⏳ Đơn xin nghỉ đã gửi — Chờ Admin duyệt
                </div>
              ) : (
                <button className="tsched-detail-delete-btn" onClick={onRequestAbsence} style={{ width: '100%', justifyContent: 'center' }}>
                  <CalendarMinus size={14} /> Xin vắng mặt
                </button>
              )
            )}
          </div>
        ) : null}
      </div>
    </div>
  );
}

/* ── Main Page ───────────────────────────────────────── */
export function TutorSchedulePage() {
  const [sessions, setSessions] = useState<TutorSessionDTO[]>([]);
  const [quotas, setQuotas] = useState<import('../../services/tutorApi').ClassQuotaDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentDate, setCurrentDate] = useState(new Date());
  const [confirming, setConfirming] = useState(false);
  const [generating, setGenerating] = useState(false);
  const [dragOverDate, setDragOverDate] = useState<string | null>(null);
  const [draggingId, setDraggingId] = useState<string | null>(null);
  const [editingSession, setEditingSession] = useState<TutorSessionDTO | null>(null);
  const [selectedSession, setSelectedSession] = useState<TutorSessionDTO | null>(null);
  const [showConfirmDialog, setShowConfirmDialog] = useState(false);
  const [showCancelDialog, setShowCancelDialog] = useState<string | null>(null);
  const [showAbsenceModal, setShowAbsenceModal] = useState<TutorSessionDTO | null>(null);
  const [showCreateDraft, setShowCreateDraft] = useState<{isOpen: boolean, initialClassId?: string, makeupForSessionId?: string}>({isOpen: false});

  const handleAbsenceSubmit = async (reason: string, makeupDate?: string, makeupTime?: string, proofFile?: File) => {
    if (!showAbsenceModal) return;
    try {
      let proofUrl: string | undefined = undefined;
      if (proofFile) {
        const uploadRes = await uploadImage(proofFile);
        proofUrl = uploadRes;
      }
      
      await tutorApi.createAbsenceRequest(showAbsenceModal.id, { 
        reason, 
        makeupDate: makeupDate || undefined, 
        makeupTime: makeupDate ? makeupTime : undefined, 
        proofUrl 
      });
      alert('Gửi đơn xin vắng mặt thành công. Vui lòng chờ Admin phê duyệt.');
      setShowAbsenceModal(null);
      fetchData();
    } catch (e: any) {
      throw e;
    }
  };

  useEffect(() => {
    fetchData();
  }, [currentDate]); // Reload when week changes

  const fetchData = async () => {
    try {
      setLoading(true);
      const weekMonday = getWeekRange(currentDate).start;
      const weekOfStr = toLocalDateString(weekMonday);
      const [sessionsData, quotaData] = await Promise.all([
        tutorApi.getMySessions(),
        tutorApi.getWeeklyQuotaStatus(weekOfStr).catch(() => [])
      ]);
      setSessions(sessionsData);
      setQuotas(quotaData);
    } catch {
      console.error('Failed to load');
    } finally {
      setLoading(false);
    }
  };

  const handleConfirmDrafts = async () => {
    setShowConfirmDialog(false);
    try {
      setConfirming(true);
      const weekMonday = getWeekRange(currentDate).start;
      const weekOfStr = toLocalDateString(weekMonday);
      await tutorApi.confirmDrafts(weekOfStr);
      await fetchData();
    } catch (err: any) {
      alert(err?.response?.data?.message || 'Lỗi khi xác nhận');
    } finally {
      setConfirming(false);
    }
  };

  const handleCancelDraft = async (sessionId: string) => {
    setShowCancelDialog(null);
    try {
      await tutorApi.deleteDraft(sessionId);
      await fetchData();
    } catch (err: any) {
      alert(err?.response?.data?.message || 'Lỗi khi huỷ');
    }
  };

  const handleGenerateDrafts = async () => {
    const weekMonday = getWeekRange(currentDate).start;
    const weekOfStr = toLocalDateString(weekMonday);
    try {
      setGenerating(true);
      const result = await tutorApi.generateDrafts(weekOfStr);
      const skipped: string[] = result.skippedClasses ?? [];
      if (result.createdCount === 0 && skipped.length === 0) {
        alert('Không có lịch mẫu nào để tạo. Hãy set lịch cho lớp trước (nút "Sửa lịch" trên card lớp).');
      } else if (skipped.length > 0) {
        alert(`Đã tạo ${result.createdCount} buổi.\n\n⚠️ Các lớp sau chưa có lịch dạy (đã bỏ qua): ${skipped.join(', ')}`);
      }
      await fetchData();
    } catch (err: any) {
      alert(err?.response?.data?.message || 'Lỗi khi tạo lịch');
    } finally {
      setGenerating(false);
    }
  };

  /* ── Drag & Drop ─────────────────────────────────── */
  const dragDuration = useRef(0);
  const calBodyRef = useRef<HTMLDivElement>(null);
  const GRID_START_HOUR = 6;
  const PX_PER_HOUR = 40;
  const [dragIndicator, setDragIndicator] = useState<{ dateKey: string; topPx: number; timeLabel: string } | null>(null);

  const yToMinutes = (clientY: number): number => {
    const body = calBodyRef.current;
    if (!body) return GRID_START_HOUR * 60;
    const bodyRect = body.getBoundingClientRect();
    const yInGrid = clientY - bodyRect.top + body.scrollTop;
    const rawMin = (yInGrid / PX_PER_HOUR) * 60 + (GRID_START_HOUR * 60);
    return Math.round(rawMin / 15) * 15;  // snap 15-min
  };

  const clampTime = (startMin: number) => {
    const clamped = Math.max(GRID_START_HOUR * 60, Math.min(startMin, 22 * 60 - dragDuration.current));
    const endMin = clamped + dragDuration.current;
    const startTime = `${String(Math.floor(clamped / 60)).padStart(2, '0')}:${String(clamped % 60).padStart(2, '0')}`;
    const endTime = `${String(Math.floor(endMin / 60)).padStart(2, '0')}:${String(endMin % 60).padStart(2, '0')}`;
    return { startTime, endTime, startMin: clamped };
  };

  const handleDragStart = (e: React.DragEvent, session: TutorSessionDTO) => {
    e.dataTransfer.setData('sessionId', session.id);
    e.dataTransfer.effectAllowed = 'move';
    setDraggingId(session.id);
    const [sh, sm] = session.startTime.split(':').map(Number);
    const [eh, em] = session.endTime.split(':').map(Number);
    dragDuration.current = (eh * 60 + em) - (sh * 60 + sm);
  };

  const handleDragEnd = () => {
    setDraggingId(null);
    setDragOverDate(null);
    setDragIndicator(null);
  };

  const handleDragOver = (e: React.DragEvent, dateKey: string) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
    setDragOverDate(dateKey);

    // Show time indicator
    const snappedMin = yToMinutes(e.clientY);
    const { startTime, startMin } = clampTime(snappedMin);
    const topPx = ((startMin - GRID_START_HOUR * 60) / 60) * PX_PER_HOUR;
    setDragIndicator({ dateKey, topPx, timeLabel: startTime });
  };

  const handleDragLeave = () => {
    setDragOverDate(null);
    setDragIndicator(null);
  };

  const handleDrop = async (e: React.DragEvent, targetDateKey: string) => {
    e.preventDefault();
    setDragOverDate(null);
    setDraggingId(null);
    setDragIndicator(null);

    const sessionId = e.dataTransfer.getData('sessionId');
    if (!sessionId) return;

    const snappedMin = yToMinutes(e.clientY);
    const { startTime, endTime } = clampTime(snappedMin);

    try {
      await tutorApi.updateDraft(sessionId, {
        sessionDate: targetDateKey,
        startTime,
        endTime,
      });
      await fetchData();
    } catch (err: any) {
      alert(err?.response?.data?.message || 'Lỗi khi di chuyển buổi dạy');
    }
  };

  /* ── Time Edit ───────────────────────────────────── */
  const handleTimeSave = async (sessionId: string, startTime: string, endTime: string, sessionDate: string) => {
    try {
      await tutorApi.updateDraft(sessionId, { sessionDate, startTime, endTime });
      setEditingSession(null);
      await fetchData();
    } catch (err: any) {
      alert(err?.response?.data?.message || 'Lỗi khi cập nhật giờ');
    }
  };

  const { start: weekStart, end: weekEnd } = useMemo(() => getWeekRange(currentDate), [currentDate]);

  const filteredSessions = useMemo(() => {
    return sessions.filter(s => {
      const d = new Date(s.sessionDate);
      return d >= weekStart && d <= weekEnd;
    });
  }, [sessions, weekStart, weekEnd]);

  const sessionsByDate = useMemo(() => {
    const map = new Map<string, TutorSessionDTO[]>();
    filteredSessions.forEach(s => {
      const key = s.sessionDate;
      if (!map.has(key)) map.set(key, []);
      map.get(key)!.push(s);
    });
    // Sắp xếp theo giờ bắt đầu trong mỗi ngày
    map.forEach((list) => list.sort((a, b) => a.startTime.localeCompare(b.startTime)));
    return map;
  }, [filteredSessions]);

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

  const isCurrentOrFutureWeek = useMemo(() => {
    const now = new Date();
    const { start: thisWeekStart } = getWeekRange(now);
    return weekStart >= thisWeekStart;
  }, [weekStart]);

  const isToday = (d: Date) => {
    const now = new Date();
    return d.getDate() === now.getDate() && d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear();
  };

  const draftsThisWeek = filteredSessions.filter(s => s.status === 'DRAFT').length;

  return (
    <>
      <div className="tsched-container" style={{ padding: 0 }}>
            {/* Draft warning banner */}
            {draftsThisWeek > 0 && (
              <div className="tsched-warning-banner">
                <AlertTriangle size={18} />
                <div>
                  <strong>Bạn có {draftsThisWeek} buổi dạy tuần này chưa xác nhận.</strong>
                  <span> Hãy kiểm tra và xác nhận lịch dạy!</span>
                </div>
                <button 
                  className="tsched-confirm-btn" 
                  onClick={() => setShowConfirmDialog(true)} 
                  disabled={confirming || quotas.some(q => q.excessCount > 0)}
                  title={quotas.some(q => q.excessCount > 0) ? 'Vui lòng xử lý các lớp bị dư buổi học chính' : ''}
                >
                  <Check size={14} /> {confirming ? 'Đang xác nhận...' : 'Xác nhận tất cả'}
                </button>
              </div>
            )}

            {/* Quota Warnings */}
            {quotas.filter(q => q.missingCount > 0 || q.excessCount > 0).map(q => (
              <div key={q.classId} className="tsched-warning-banner" style={{ marginTop: '10px', backgroundColor: q.excessCount > 0 ? '#fee2e2' : '#fffbeb', color: q.excessCount > 0 ? '#b91c1c' : '#d97706', borderColor: q.excessCount > 0 ? '#fca5a5' : '#fcd34d' }}>
                <AlertTriangle size={18} />
                <div>
                  <strong>{q.classTitle} {q.classCode && <span style={{fontSize: '0.85em', color: '#6366f1'}}>#{q.classCode}</span>}: </strong>
                  {q.excessCount > 0 
                    ? <span style={{color: '#991b1b'}}>Đang dư {q.excessCount} buổi học chính. Vui lòng huỷ bản nháp thừa hoặc chuyển sang Lịch tăng cường.</span>
                    : <span>Đang thiếu {q.missingCount} buổi học chính trong tuần này.</span>}
                </div>
              </div>
            ))}

            {/* Header */}
            <div className="tsched-header-section">
              <div className="tsched-header">
                <h1 className="tsched-title">📅 Lịch dạy</h1>
                <p className="tsched-subtitle">
                  Tuần {formatDate(weekStart)} — {formatDate(weekEnd)}
                  {draftsThisWeek > 0 && (
                    <span className="tsched-draft-count"> • {draftsThisWeek} bản nháp</span>
                  )}
                </p>
              </div>

              <div className="tsched-controls">
                <button
                  className="tsched-nav-btn"
                  style={{ background: 'linear-gradient(135deg, #6366f1, #8b5cf6)', color: '#fff', border: 'none', padding: '8px 16px' }}
                  onClick={() => setShowCreateDraft({isOpen: true})}
                >
                  <Plus size={16}/> Thêm lịch nháp
                </button>
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

            {/* Drag hint */}
            {draftsThisWeek > 0 && (
              <div className="tsched-drag-hint">
                💡 Kéo thả buổi dạy <strong>bản nháp</strong> sang ngày khác. Bấm vào giờ để chỉnh sửa.
              </div>
            )}

            {/* Week grid */}
            <div className="tsched-body">
              {loading ? (
                <div className="tsched-empty">Đang tải lịch dạy...</div>
              ) : filteredSessions.length === 0 && isCurrentOrFutureWeek ? (
                <div className="tsched-empty-future">
                  <CalendarIcon size={40} style={{ color: '#6366f1', marginBottom: 12 }} />
                  <p className="tsched-empty-future-text">Chưa có buổi dạy nào trong tuần này</p>
                  <p className="tsched-empty-future-sub">Tạo lịch dạy từ schedule lớp đã set sẵn</p>
                  <button
                    className="tsched-generate-btn"
                    onClick={handleGenerateDrafts}
                    disabled={generating}
                  >
                    <Plus size={16} />
                    {generating ? 'Đang tạo...' : 'Tạo lịch tuần này'}
                  </button>
                </div>
              ) : (
                <div className="tsched-cal" ref={calBodyRef}>
                  {/* Day header columns */}
                  <div className="tsched-cal-header">
                    <div className="tsched-cal-time-gutter"></div>
                    {weekDays.map(day => {
                      const dayIndex = day.getDay();
                      const today = isToday(day);
                      return (
                        <div key={toLocalDateString(day)} className={`tsched-cal-dayhead ${today ? 'tsched-cal-dayhead--today' : ''}`}>
                          <span className="tsched-cal-dayname">{DAY_NAMES[dayIndex]}</span>
                          <span className={`tsched-cal-daynum ${today ? 'tsched-cal-daynum--today' : ''}`}>
                            {day.getDate()}
                          </span>
                        </div>
                      );
                    })}
                  </div>

                  {/* Time grid body */}
                  <div className="tsched-cal-body">
                    {/* Time gutter (6:00 – 22:00) */}
                    <div className="tsched-cal-time-gutter">
                      {Array.from({ length: 17 }, (_, i) => i + 6).map(hour => (
                        <div key={hour} className="tsched-cal-hour-label" style={{ top: `${(hour - GRID_START_HOUR) * PX_PER_HOUR}px` }}>
                          {String(hour).padStart(2, '0')}:00
                        </div>
                      ))}
                    </div>

                    {/* Day columns */}
                    {weekDays.map(day => {
                      const dateKey = toLocalDateString(day);
                      const daySessions = sessionsByDate.get(dateKey) || [];
                      const today = isToday(day);

                      return (
                        <div
                          key={dateKey}
                          className={`tsched-cal-daycol ${today ? 'tsched-cal-daycol--today' : ''} ${dragOverDate === dateKey ? 'tsched-cal-daycol--drag-over' : ''}`}
                          onDragOver={e => handleDragOver(e, dateKey)}
                          onDragLeave={handleDragLeave}
                          onDrop={e => handleDrop(e, dateKey)}
                        >
                          {/* Hour grid lines */}
                          {Array.from({ length: 17 }, (_, i) => (
                            <div key={i} className="tsched-cal-gridline" style={{ top: `${i * PX_PER_HOUR}px` }} />
                          ))}

                          {/* Drag time indicator */}
                          {dragIndicator && dragIndicator.dateKey === dateKey && (
                            <div className="tsched-cal-drop-indicator" style={{ top: `${dragIndicator.topPx}px` }}>
                              <span className="tsched-cal-drop-label">{dragIndicator.timeLabel}</span>
                            </div>
                          )}

                          {/* Session blocks */}
                          {daySessions.map(s => {
                            const [sh, sm] = s.startTime.split(':').map(Number);
                            const [eh, em] = s.endTime.split(':').map(Number);
                            const startMin = sh * 60 + sm;
                            const endMin = eh * 60 + em;
                            const topPx = ((startMin - GRID_START_HOUR * 60) / 60) * PX_PER_HOUR;
                            const heightPx = Math.max(((endMin - startMin) / 60) * PX_PER_HOUR, 18);
                            const isDraft = s.status === 'DRAFT';
                            const isDragging = draggingId === s.id;
                            const isCancelled = s.status.startsWith('CANCELLED');
                            const isPending = s.hasPendingAbsence === true;
                            const isRequiresMakeup = isCancelled && s.requiresMakeup;
                            const displayStatus = getDisplayStatus(s.status, s.sessionDate, s.endTime);
                            const cfg = isPending
                              ? { color: 'var(--color-warning)', bg: 'rgba(245, 158, 11, 0.1)' }
                              : STATUS_CFG[displayStatus] ?? { color: 'var(--color-text-muted)', bg: 'var(--color-surface-hover)' };

                            return (
                              <div
                                key={s.id}
                                className={`tsched-cal-block ${isDraft ? 'tsched-cal-block--draft' : ''} ${isDragging ? 'tsched-cal-block--dragging' : ''} ${isCancelled && !isRequiresMakeup ? 'tsched-cal-block--cancelled' : ''}`}
                                style={{
                                  top: `${topPx}px`,
                                  height: `${heightPx}px`,
                                  borderLeftColor: isRequiresMakeup ? 'var(--color-danger)' : cfg.color,
                                  background: isRequiresMakeup ? 'rgba(239, 68, 68, 0.1)' : cfg.bg,
                                  boxShadow: isRequiresMakeup ? '0 0 0 2px var(--color-danger)' : undefined,
                                  opacity: isRequiresMakeup ? 1 : undefined
                                }}
                                draggable={isDraft}
                                onDragStart={isDraft ? e => handleDragStart(e, s) : undefined}
                                onDragEnd={isDraft ? handleDragEnd : undefined}
                                onClick={() => {
                                  if (isRequiresMakeup) {
                                    setShowCreateDraft({isOpen: true, initialClassId: s.classId, makeupForSessionId: s.id});
                                  } else {
                                    setSelectedSession(s);
                                  }
                                }}
                              >
                                <div className="tsched-cal-block-time">
                                  {formatTime(s.startTime)} – {formatTime(s.endTime)}
                                </div>
                                <div className="tsched-cal-block-title">
                                  {isPending ? '⏳ ' : ''}
                                  {s.sessionType === 'MAKEUP' ? <span style={{color: '#fff', background: '#ef4444', padding: '1px 4px', borderRadius: '4px', fontSize: '0.65rem', marginRight: '4px'}}>Bù</span> : ''}
                                  {s.sessionType === 'EXTRA' ? <span style={{color: '#fff', background: '#8b5cf6', padding: '1px 4px', borderRadius: '4px', fontSize: '0.65rem', marginRight: '4px'}}>Tăng cường</span> : ''}
                                  {s.classCode && <span style={{color: '#6366f1', fontSize: '0.65rem', marginRight: '4px'}}>#{s.classCode}</span>}
                                  {s.classTitle}
                                </div>
                                {isRequiresMakeup && (
                                  <div style={{ fontSize: '0.75rem', color: '#ef4444', fontWeight: 600, marginTop: 2 }}>
                                    🔴 Cần xếp lịch bù
                                  </div>
                                )}
                                {heightPx > (isRequiresMakeup ? 65 : 50) && s.address && (
                                  <div className="tsched-cal-block-addr">{s.address}</div>
                                )}
                              </div>
                            );
                          })}
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>

            {/* Summary */}
            {!loading && (
              <div className="tsched-summary">
                {draftsThisWeek > 0 && (
                  <div className="tsched-summary-item" style={{ borderColor: '#d97706' }}>
                    <span className="tsched-summary-val" style={{ color: '#d97706' }}>{draftsThisWeek}</span>
                    <span className="tsched-summary-lbl">Bản nháp</span>
                  </div>
                )}
                <div className="tsched-summary-item">
                  <span className="tsched-summary-val">{filteredSessions.filter(s => getDisplayStatus(s.status, s.sessionDate, s.endTime) === 'SCHEDULED').length}</span>
                  <span className="tsched-summary-lbl">Sắp tới</span>
                </div>
                <div className="tsched-summary-item">
                  <span className="tsched-summary-val">{filteredSessions.filter(s => getDisplayStatus(s.status, s.sessionDate, s.endTime) === 'COMPLETED').length}</span>
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

      {/* Session Detail Popup */}
      {selectedSession && (
        <SessionDetailPopup
          session={selectedSession}
          onClose={() => setSelectedSession(null)}
          onEditTime={() => {
            setEditingSession(selectedSession);
            setSelectedSession(null);
          }}
          onDelete={() => {
            setShowCancelDialog(selectedSession.id);
            setSelectedSession(null);
          }}
          onRequestAbsence={() => {
            setShowAbsenceModal(selectedSession);
            setSelectedSession(null);
          }}
        />
      )}

      {/* Time Edit Modal */}
      {editingSession && (
        <TimeEditModal
          session={editingSession}
          onSave={handleTimeSave}
          onClose={() => setEditingSession(null)}
        />
      )}

      {/* Absence Request Modal */}
      {showAbsenceModal && (
        <AbsenceRequestModal
          session={showAbsenceModal}
          onClose={() => setShowAbsenceModal(null)}
          onSubmit={handleAbsenceSubmit}
        />
      )}

      {/* Confirm All Drafts Dialog */}
      {showConfirmDialog && (
        <div className="tsched-detail-overlay" onClick={() => setShowConfirmDialog(false)}>
          <div className="tsched-confirm-dialog" onClick={e => e.stopPropagation()}>
            <AlertTriangle size={32} style={{ color: '#d97706' }} />
            <h3>Xác nhận lịch dạy</h3>
            <p>Bạn có chắc muốn xác nhận tất cả <strong>{draftsThisWeek} buổi dạy</strong> tuần này?</p>
            <p className="tsched-confirm-dialog-sub">Sau khi xác nhận, lịch sẽ được gửi đến phụ huynh.</p>
            <div className="tsched-confirm-dialog-actions">
              <button className="tsched-time-cancel-btn" onClick={() => setShowConfirmDialog(false)}>Huỷ</button>
              <button className="tsched-confirm-btn" onClick={handleConfirmDrafts}>
                <Check size={14} /> Xác nhận tất cả
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Cancel Draft Dialog */}
      {showCancelDialog && (
        <div className="tsched-detail-overlay" onClick={() => setShowCancelDialog(null)}>
          <div className="tsched-confirm-dialog" onClick={e => e.stopPropagation()}>
            <Trash2 size={32} style={{ color: '#ef4444' }} />
            <h3>Huỷ buổi dạy</h3>
            <p>Bạn có chắc muốn huỷ buổi dạy này?</p>
            <div className="tsched-confirm-dialog-actions">
              <button className="tsched-time-cancel-btn" onClick={() => setShowCancelDialog(null)}>Không</button>
              <button className="tsched-detail-delete-btn" onClick={() => handleCancelDraft(showCancelDialog)}>
                <Trash2 size={14} /> Huỷ buổi dạy
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Create Draft Modal */}
      {showCreateDraft.isOpen && (
        <CreateDraftModal
          initialDateStr={toLocalDateString(currentDate)}
          initialClassId={showCreateDraft.initialClassId}
          makeupForSessionId={showCreateDraft.makeupForSessionId}
          onClose={() => setShowCreateDraft({isOpen: false})}
          onSuccess={() => {
            setShowCreateDraft({isOpen: false});
            fetchData();
          }}
        />
      )}
    </>
  );
}
