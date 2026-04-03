import { CalendarIcon, Clock, Video, AlertCircle, XCircle, Info } from 'lucide-react';
import { useState, useEffect, useMemo } from 'react';
import { getDisplayStatus } from '../../utils/sessionStatus';

import { sessionApi } from '../../services/sessionApi';
import type { SessionDTO } from '../../services/sessionApi';

import { RequestClassModal } from '../../components/parent/RequestClassModal';
import '../dashboard/Dashboard.css';
import './ParentSchedule.css';

function getStatusBadge(status: SessionDTO['status'], sessionDate?: string, endTime?: string) {
  const displayStatus = (sessionDate && endTime) ? getDisplayStatus(status, sessionDate, endTime) : status;
  const cfg = {
    SCHEDULED: { label: 'Sắp tới', color: '#6366f1', bg: '#eef2ff' },
    LIVE: { label: 'Đang diễn ra', color: '#10b981', bg: '#d1fae5' },
    COMPLETED: { label: 'Đã hoàn thành', color: '#6b7280', bg: '#f3f4f6' },
    CANCELLED: { label: 'Đã huỷ', color: '#ef4444', bg: '#fee2e2' },
    CANCELLED_BY_TUTOR: { label: 'Đã huỷ', color: '#ef4444', bg: '#fee2e2' },
    CANCELLED_BY_STUDENT: { label: 'Đã huỷ', color: '#ef4444', bg: '#fee2e2' },
  };
  const badge = cfg[displayStatus as keyof typeof cfg] || { label: 'Chờ xác nhận', color: '#d97706', bg: '#fffbeb' };
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', padding: '2px 8px',
      borderRadius: '20px', fontSize: '0.75rem', fontWeight: 600,
      color: badge.color, background: badge.bg, border: `1px solid ${badge.color}30`
    }}>
      {badge.label}
    </span>
  );
}

function formatTime(t: string) {
  return t ? t.substring(0, 5) : '--:--';
}

export function ParentSchedulePage() {
  const [sessions, setSessions] = useState<SessionDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [currentDate, setCurrentDate] = useState(new Date());
  const [showRequestModal, setShowRequestModal] = useState(false);

  const [toast, setToast] = useState<{ type: 'success' | 'error', msg: string } | null>(null);
  const [cancelTarget, setCancelTarget] = useState<SessionDTO | null>(null);
  const [cancelReason, setCancelReason] = useState('');
  const [makeUpRequired, setMakeUpRequired] = useState(true);
  const [submitting, setSubmitting] = useState(false);

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3000);
  };

  const fetchSessions = async () => {
    try {
      setLoading(true);
      // Fetch -30 to +30 days by default (as implemented in BE)
      const res = await sessionApi.getSessions();
      setSessions(res.data);
    } catch (e: any) {
      console.error(e);
      showToast('error', 'Lỗi tải lịch học');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSessions();
  }, []);

  const filteredSessions = useMemo(() => {
    const currentWeekDay = currentDate.getDay() === 0 ? 7 : currentDate.getDay();
    const start = new Date(currentDate);
    start.setDate(currentDate.getDate() - currentWeekDay + 1);
    start.setHours(0, 0, 0, 0);

    const end = new Date(start);
    end.setDate(start.getDate() + 6);
    end.setHours(23, 59, 59, 999);

    return sessions.filter(s => {
      const d = new Date(s.sessionDate);
      return d >= start && d <= end;
    });
  }, [sessions, currentDate]);

  const handleCancelClick = (s: SessionDTO) => {
    // Client-side validation for < 2h
    setCancelTarget(s);
  };

  const submitCancel = async () => {
    if (!cancelTarget || submitting) return;
    setSubmitting(true);
    try {
      await sessionApi.cancelSession(cancelTarget.id, {
        reason: cancelReason,
        makeUpRequired,
      });
      showToast('success', 'Đã gửi yêu cầu huỷ lịch. Vui lòng chờ Admin duyệt!');
      setCancelTarget(null);
      setCancelReason('');
      fetchSessions();
    } catch (e: any) {
      showToast('error', e.response?.data?.message || 'Có lỗi xảy ra');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <>
      <div className="psched-container">
            {/* Toast */}
            {toast && (
              <div className={`psched-toast psched-toast--${toast.type}`}>
                {toast.msg}
              </div>
            )}

            <div className="psched-header-section">
              <div className="psched-header">
                <h1 className="psched-title">Lịch học của con</h1>
                <p className="psched-subtitle">Theo dõi lịch học, báo nghỉ và học bù</p>
              </div>

              <div className="psched-controls">
                <button 
                  className={`psched-nav-btn ${currentDate.toDateString() === new Date().toDateString() ? 'psched-nav-btn--today' : ''}`} 
                  onClick={() => setCurrentDate(new Date())}
                >
                  <CalendarIcon size={16} /> Tuần này
                </button>
                
                <button 
                  className={`psched-nav-btn ${currentDate.toDateString() !== new Date().toDateString() ? 'psched-nav-btn--today' : ''}`}
                  onClick={() => {
                    const nextWeek = new Date();
                    nextWeek.setDate(nextWeek.getDate() + 7);
                    setCurrentDate(nextWeek);
                  }}
                >
                  <CalendarIcon size={16} /> Tuần sau
                </button>
              </div>
            </div>

            <div className="psched-body">
              {loading ? (
                <div className="psched-empty">Đang tải lịch học...</div>
              ) : filteredSessions.length === 0 ? (
                <div className="psched-empty">
                  <CalendarIcon size={40} style={{ opacity: 0.3, marginBottom: 16 }} />
                  <p>Không có buổi học nào {currentDate.toDateString() === new Date().toDateString() ? 'trong tuần này' : 'trong tuần sau'}.</p>
                </div>
              ) : (
                <div className="psched-list">
                  {filteredSessions.map(s => {
                    const startDateTime = new Date(`${s.sessionDate}T${s.startTime}`);
                    const now = new Date();
                    const diffHours = (startDateTime.getTime() - now.getTime()) / (1000 * 60 * 60);
                    const isPast = startDateTime < now;
                    const canCancel = s.status === 'SCHEDULED' && diffHours > 2;

                    return (
                      <div key={s.id} className={`psched-card ${s.status === 'CANCELLED' ? 'psched-card--cancelled' : ''}`}>
                        <div className="psched-card-left">
                          <div className="psched-card-date">{new Date(s.sessionDate).getDate()}</div>
                          <div className="psched-card-month">Thg {new Date(s.sessionDate).getMonth() + 1}</div>
                        </div>
                        
                        <div className="psched-card-main">
                          <div className="psched-card-top">
                            <div className="psched-card-badge">{s.subject}</div>
                            {getStatusBadge(s.status, s.sessionDate, s.endTime)}
                            {s.hasPendingAbsence && (
                              <span style={{
                                display: 'inline-flex', alignItems: 'center', padding: '2px 8px',
                                borderRadius: '20px', fontSize: '0.75rem', fontWeight: 600,
                                color: '#d97706', background: '#fffbeb', border: '1px solid #d9770630'
                              }}>
                                ⏳ Chờ duyệt huỷ
                              </span>
                            )}
                          </div>
                          
                          {s.classCode && (
                            <span style={{ fontSize: '0.72rem', color: '#6366f1', fontWeight: 700, background: '#eef2ff', padding: '1px 7px', borderRadius: '10px', marginBottom: '4px', display: 'inline-block', alignSelf: 'flex-start' }}>
                              #{s.classCode}
                            </span>
                          )}
                          <h3 className="psched-card-title">{s.classTitle}</h3>
                          
                          <div className="psched-card-info-grid">
                            <div className="psched-info-item">
                              <Clock size={14} className="text-muted" />
                              <span>{formatTime(s.startTime)} - {formatTime(s.endTime)}</span>
                            </div>
                            <div className="psched-info-item">
                              <span style={{fontSize: 14}}>🧑‍🏫</span>
                              <span>{s.tutorName || 'Chưa cập nhật'}</span>
                            </div>
                            {s.meetLink && s.status !== 'CANCELLED' && (
                              <div className="psched-info-item">
                                <Video size={14} color="#6366f1" />
                                <a href={s.meetLink} target="_blank" rel="noreferrer" className="psched-link">
                                  Vào phòng học (Google Meet)
                                </a>
                              </div>
                            )}
                          </div>

                          {s.tutorNote && (
                            <div className="psched-card-note">
                              <Info size={13} style={{ flexShrink: 0, marginTop: 2 }} />
                              <span>{s.tutorNote}</span>
                            </div>
                          )}
                        </div>

                        <div className="psched-card-right">
                          {s.hasPendingAbsence ? (
                            <button 
                              className="psched-btn-cancel psched-btn-cancel--disabled"
                              disabled
                              title="Đã gửi đơn xin huỷ, chờ Admin duyệt"
                              style={{ opacity: 0.5, cursor: 'not-allowed' }}
                            >
                              ⏳ Đơn xin nghỉ đã gửi
                            </button>
                          ) : s.status === 'SCHEDULED' && !isPast && (
                            <button 
                              className={`psched-btn-cancel ${!canCancel ? 'psched-btn-cancel--disabled' : ''}`}
                              onClick={() => canCancel ? handleCancelClick(s) : alert('Chỉ được huỷ trước giờ học 2 tiếng. Vui lòng liên hệ trực tiếp!')}
                              title={!canCancel ? 'Chỉ được huỷ trước 2 tiếng' : ''}
                            >
                              <XCircle size={14} /> Báo nghỉ
                            </button>
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>
              )}
            </div>

            {/* Cancel Modal */}
            {cancelTarget && (
              <div className="psched-modal-overlay" onClick={() => setCancelTarget(null)}>
                <div className="psched-modal" onClick={e => e.stopPropagation()}>
                  <div className="psched-modal-header">
                    <AlertCircle size={20} color="#ef4444" />
                    <h3>Xin nghỉ / Huỷ buổi học</h3>
                  </div>
                  
                  <div className="psched-modal-body">
                    <div className="psched-modal-warning">
                      Vui lòng điền lý do báo nghỉ. Gia sư sẽ nhận được thông báo ngay lập tức.
                    </div>

                    <div style={{ marginBottom: 12 }}>
                      <div style={{ fontSize: '0.85rem', fontWeight: 600, marginBottom: 8 }}>Tuỳ chọn học bù:</div>
                      <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: '0.9rem', marginBottom: 6, cursor: 'pointer' }}>
                        <input type="radio" checked={makeUpRequired} onChange={() => setMakeUpRequired(true)} />
                        Yêu cầu gia sư sắp xếp lịch học bù
                      </label>
                      <label style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: '0.9rem', cursor: 'pointer' }}>
                        <input type="radio" checked={!makeUpRequired} onChange={() => setMakeUpRequired(false)} />
                        Không cần học bù (Nghỉ một buổi)
                      </label>
                    </div>

                    <textarea 
                      className="psched-modal-input" 
                      rows={3} 
                      placeholder="Lý do báo nghỉ..."
                      value={cancelReason}
                      onChange={e => setCancelReason(e.target.value)}
                    />
                  </div>
                  
                  <div className="psched-modal-footer">
                    <button 
                      className="psched-btn psched-btn--ghost" 
                      onClick={() => setCancelTarget(null)}
                    >
                      Huỷ bỏ
                    </button>
                    <button 
                      className="psched-btn psched-btn--danger"
                      onClick={submitCancel}
                      disabled={submitting}
                    >
                      {submitting ? 'Đang xử lý...' : 'Xác nhận báo nghỉ'}
                    </button>
                  </div>
                </div>
              </div>
            )}
        </div>
      {showRequestModal && (
        <RequestClassModal 
          onClose={() => setShowRequestModal(false)} 
          onSuccess={() => setShowRequestModal(false)}
        />
      )}
    </>
  );
}
