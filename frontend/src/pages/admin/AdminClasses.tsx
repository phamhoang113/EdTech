import { BookOpen, Search, Trash2, ChevronRight, Phone, MapPin, GraduationCap, User, X, DollarSign, Clock, CheckCircle, XCircle, AlertCircle, Activity, Calendar, RefreshCw, PauseCircle, PlayCircle } from 'lucide-react';
import { useState, useEffect, useMemo } from 'react';
import { AdminCreateClassModal } from './AdminCreateClassModal';

// Add state `const [showCreateModal, setShowCreateModal] = useState(false);` around line 286. 
// Just find a safe spot for state. I'll need to do it precisely.
import type { ReactElement } from 'react';

import { adminApi } from '../../services/adminApi';
import type { AdminClassListItem, ClassStatus, AdminClassScheduleStatsDTO } from '../../services/adminApi';
import './AdminClasses.css';

/* ─── Helpers ───────────────────────────────────────────────────────────── */
function fmtVnd(n?: number | null) {
  if (n == null) return '—';
  return n.toLocaleString('vi-VN') + 'đ';
}

/* ─── Status config ─────────────────────────────────────────────────────── */
const STATUS_CFG: Record<string, { label: string; cls: string; icon: ReactElement }> = {
  PENDING_APPROVAL: { label: 'Chờ duyệt', cls: 'status-open',      icon: <Clock size={11}/> },
  OPEN:      { label: 'Đang mở',    cls: 'status-open',      icon: <BookOpen size={11}/> },
  ASSIGNED:  { label: 'Đang mở',    cls: 'status-open',      icon: <BookOpen size={11}/> },
  MATCHED:   { label: 'Đang mở',    cls: 'status-open',      icon: <BookOpen size={11}/> },
  ACTIVE:    { label: 'Đang dạy',   cls: 'status-active',    icon: <Activity size={11}/> },
  COMPLETED: { label: 'Hoàn thành', cls: 'status-completed', icon: <CheckCircle size={11}/> },
  CANCELLED: { label: 'Đã huỷ',    cls: 'status-cancelled', icon: <XCircle size={11}/> },
  AUTO_CLOSED: { label: 'Hết hạn',  cls: 'status-cancelled', icon: <Clock size={11}/> },
  SUSPENDED: { label: 'Tạm hoãn',  cls: 'status-suspended', icon: <PauseCircle size={11}/> },
};

function StatusBadge({ status }: { status: ClassStatus }) {
  const cfg = STATUS_CFG[status];
  return <span className={`acl-badge ${cfg.cls}`}>{cfg.icon} {cfg.label}</span>;
}

/* ─── Next status options (valid transitions) ────────────────────────────── */
const NEXT_STATUS: Partial<Record<ClassStatus, ClassStatus[]>> = {
  OPEN:      ['ACTIVE', 'CANCELLED'],
  ACTIVE:    ['COMPLETED', 'CANCELLED'],
  SUSPENDED: ['ACTIVE', 'COMPLETED', 'CANCELLED'],
};

/* ─── Class Card ─────────────────────────────────────────────────────────── */
function ClassCard({
  cls,
  onClick,
  onDelete,
}: {
  cls: AdminClassListItem;
  onClick: (c: AdminClassListItem) => void;
  onDelete: (c: AdminClassListItem) => void;
}) {
  return (
    <div className="acl-card" onClick={() => onClick(cls)} role="button" tabIndex={0}
      onKeyDown={e => e.key === 'Enter' && onClick(cls)}>
      <div className="acl-card-top">
        <div className="acl-card-code">{cls.classCode}</div>
        <StatusBadge status={cls.status} />
        {cls.status === 'OPEN' && cls.hasPendingProposals && (
          <span className="acl-pending-badge" style={{background:'rgba(139,92,246,0.12)',color:'#8b5cf6'}}>
            ⏳ Chờ PH chọn
          </span>
        )}
        {cls.pendingApplicationCount > 0 && (
          <span className="acl-pending-badge">
            <AlertCircle size={10}/> {cls.pendingApplicationCount} đơn chờ
          </span>
        )}
        {cls.missingSessionsThisWeek != null && cls.missingSessionsThisWeek > 0 && (
          <span className="acl-pending-badge" style={{background:'rgba(239, 68, 68, 0.12)',color:'#ef4444', border: '1px solid currentColor'}}>
             ⚠️ Thiếu {cls.missingSessionsThisWeek} lịch tuần này
          </span>
        )}
        {cls.status === 'ACTIVE' && !cls.learningStartDate && (
          <span className="acl-pending-badge" style={{background:'rgba(99,102,241,0.1)',color:'#6366f1', border: '1px solid currentColor'}}>
            📅 Chưa set ngày bắt đầu học
          </span>
        )}
        {cls.pendingMakeupCount != null && cls.pendingMakeupCount > 0 && (
          <span className="acl-pending-badge" style={{background:'rgba(245, 158, 11, 0.12)',color:'#f59e0b', border: '1px solid currentColor'}}>
            ⏳ Nợ {cls.pendingMakeupCount} buổi bù
          </span>
        )}
      </div>

      <h3 className="acl-card-title">{cls.title}</h3>

      <div className="acl-card-meta">
        <span><BookOpen size={12}/> {cls.subject} — {cls.grade}</span>
        <span><MapPin size={12}/> {cls.mode === 'ONLINE' ? 'Online' : (cls.address ?? 'OFFLINE')}</span>
        {cls.sessionsPerWeek && <span><Clock size={12}/> {cls.sessionsPerWeek} buổi/tuần</span>}
      </div>

      <div className="acl-card-people">
        <div className="acl-person">
          <User size={12}/>
          <span>PH: <strong>{cls.parentName ?? '—'}</strong></span>
          {cls.parentPhone && <span className="acl-phone"><Phone size={11}/>{cls.parentPhone}</span>}
        </div>
        {cls.tutorName ? (
          <div className="acl-person acl-tutor">
            <GraduationCap size={12}/>
            <span>GS: <strong>{cls.tutorName}</strong></span>
            {cls.tutorPhone && <span className="acl-phone"><Phone size={11}/>{cls.tutorPhone}</span>}
          </div>
        ) : (
          <div className="acl-person acl-no-tutor">
            <GraduationCap size={12}/> Chưa có gia sư
          </div>
        )}
      </div>

      <div className="acl-card-footer">
        {cls.status === 'ACTIVE' ? (
          <div className="acl-fee-row">
            <span className="acl-fee-label">Học phí PH</span>
            <span className="acl-fee-val">{cls.parentFee > 0 ? fmtVnd(cls.parentFee) : 'Chưa chốt'}</span>
            {cls.tutorFee != null && cls.tutorFee > 0 && <>
              <span className="acl-fee-sep">|</span>
              <span className="acl-fee-label">GS nhận</span>
              <span className="acl-fee-val acl-green">{fmtVnd(cls.tutorFee)}</span>
            </>}
          </div>
        ) : (
          <div className="acl-fee-row">
            <span style={{ fontSize: '0.78rem', color: 'var(--color-text-muted)', fontStyle: 'italic' }}>Chưa chốt phí — chờ gia sư nhận lớp</span>
          </div>
        )}
        <div className="acl-card-actions" onClick={e => e.stopPropagation()}>
          <button className="acl-btn-icon-danger" onClick={() => onDelete(cls)}><Trash2 size={14}/></button>
        </div>
        <ChevronRight size={15} className="acl-chevron"/>
      </div>
    </div>
  );
}

/* ─── Detail Drawer ─────────────────────────────────────────────────────── */
function ClassDetailDrawer({
  cls,
  onClose,
  onDelete,
  onStatusChange,
  onRefresh,
  onSuspend,
  onResume,
}: {
  cls: AdminClassListItem;
  onClose: () => void;
  onDelete: (c: AdminClassListItem) => void;
  onStatusChange: (c: AdminClassListItem, s: ClassStatus) => void;
  onRefresh: () => void;
  onSuspend: (c: AdminClassListItem) => void;
  onResume: (c: AdminClassListItem) => void;
}) {
  const [stats, setStats] = useState<AdminClassScheduleStatsDTO | null>(null);
  const [loadingStats, setLoadingStats] = useState(false);
  const [editingDate, setEditingDate] = useState(false);
  const todayStr = new Date().toISOString().split('T')[0];
  const [dateDraft, setDateDraft] = useState(cls.learningStartDate ?? todayStr);
  const [savingDate, setSavingDate] = useState(false);
  const { toast, show } = useToast();

  const handleSaveDate = async () => {
    if (!dateDraft) {
      show('error', 'Vui lòng chọn ngày hợp lệ');
      return;
    }
    setSavingDate(true);
    try {
      await adminApi.updateLearningStartDate(cls.id, dateDraft);
      show('success', 'Đã lưu ngày bắt đầu học!');
      setEditingDate(false);
      onRefresh();
    } catch {
      show('error', 'Lỗi lưu ngày bắt đầu học');
    } finally {
      setSavingDate(false);
    }
  };

  useEffect(() => {
    if (cls.status === 'ACTIVE' || cls.status === 'COMPLETED') {
      setLoadingStats(true);
      adminApi.getClassScheduleStats(cls.id)
        .then(res => setStats(res.data))
        .catch(err => console.error('Failed to load schedule stats', err))
        .finally(() => setLoadingStats(false));
    }
  }, [cls.id, cls.status]);

  const nextOptions = NEXT_STATUS[cls.status] ?? [];
  let schedule: any[] = [];
  try { schedule = JSON.parse(cls.schedule ?? '[]'); } catch {}

  const dayLabel: Record<string, string> = {
    MONDAY:'Thứ 2', TUESDAY:'Thứ 3', WEDNESDAY:'Thứ 4',
    THURSDAY:'Thứ 5', FRIDAY:'Thứ 6', SATURDAY:'Thứ 7', SUNDAY:'CN',
  };

  return (
    <div className="acl-drawer-overlay" onClick={onClose}>
      {toast && <div className={`acl-toast acl-toast-${toast.type}`} style={{ zIndex: 99999 }}>{toast.msg}</div>}
      <aside className="acl-drawer" onClick={e => e.stopPropagation()} style={{ width: 620 }}>
        {/* Header */}
        <div className="acl-drawer-header">
          <div className="acl-drawer-code">{cls.classCode}</div>
          <div className="acl-drawer-title-wrap">
            <h2>{cls.title}</h2>
            <div style={{display:'flex',gap:6,flexWrap:'wrap'}}>
              <StatusBadge status={cls.status}/>
              {cls.status === 'OPEN' && cls.hasPendingProposals && (
                <span className="acl-pending-badge" style={{background:'rgba(139,92,246,0.12)',color:'#8b5cf6'}}>
                  ⏳ Đang chờ PH chọn gia sư
                </span>
              )}
              {cls.pendingApplicationCount > 0 && (
                <span className="acl-pending-badge"><AlertCircle size={10}/> {cls.pendingApplicationCount} đơn chờ</span>
              )}
              {cls.status === 'OPEN' && (
                <button
                  onClick={() => {
                    let feeStr = 'Thỏa thuận';
                    if ((cls.tutorFee ?? 0) > 0) {
                      feeStr = (cls.tutorFee ?? 0).toLocaleString('vi-VN') + 'đ/tháng';
                    } else {
                      let levels: any[] = [];
                      let proposals: any[] = [];
                      try { 
                        if (cls.levelFees) {
                          const parsed = JSON.parse(cls.levelFees);
                          levels = Array.isArray(parsed) ? parsed : [];
                        }
                      } catch {}
                      try { 
                        if (cls.tutorProposals) {
                          const parsed = JSON.parse(cls.tutorProposals);
                          proposals = Array.isArray(parsed) ? parsed : [];
                        }
                      } catch {}
                      
                      const combinedFees = levels.length > 0 ? levels.map(lv => {
                        const p = proposals.find(pr => pr.level === lv.level);
                        return { fee: p ? (p.fee || 0) : 0 };
                      }) : proposals.map(p => ({ fee: p.fee || 0 }));
                      
                      const validFees = combinedFees.filter(f => f.fee > 0).map(f => f.fee);
                      if (validFees.length > 0) {
                        const minFee = Math.min(...validFees);
                        const maxFee = Math.max(...validFees);
                        if (minFee === maxFee) {
                          feeStr = `${minFee.toLocaleString('vi-VN')}đ/tháng`;
                        } else {
                          feeStr = `${minFee.toLocaleString('vi-VN')}đ - ${maxFee.toLocaleString('vi-VN')}đ/tháng`;
                        }
                      }
                    }

                    const modeLabel = cls.mode === 'ONLINE' ? 'Online' : 'Tại nhà';
                    const timeFramePart = cls.timeFrame ? ` (${cls.timeFrame})` : '';
                    const text = `Mã lớp: ${cls.classCode}
🔯Dạy: ${cls.subject.toUpperCase()} LỚP ${cls.grade}
- Hình thức: ${modeLabel}
- Số học viên: 1hs
- Số buổi/ tuần: ${cls.sessionsPerWeek ?? '—'}b${timeFramePart}
- Tgian: ${cls.sessionDurationMin ?? '—'} phút
- Học phí: ${feeStr}
- Địa chỉ: ${cls.address || 'Học Online'}
👉Yêu cầu: ${cls.genderRequirement || 'Không yêu cầu'}`;
                    navigator.clipboard.writeText(text);
                    show('success', 'Đã copy tin đăng!');
                  }}
                  style={{ marginLeft: 'auto', padding: '4px 10px', fontSize: '0.8rem', borderRadius: 6, background: 'rgba(99,102,241,0.1)', color: '#6366f1', border: '1px solid currentColor', cursor: 'pointer', fontWeight: 600 }}
                >
                 📋 Copy đăng bài
                </button>
              )}
            </div>
          </div>
          <button className="acl-close-btn" onClick={onClose}><X size={18}/></button>
        </div>

        <div className="acl-drawer-body">
          {/* Summary grid */}
          <section className="acl-drawer-section">
            <h3><BookOpen size={13}/> Thông tin lớp</h3>
            <div className="acl-dgrid">
              <div className="acl-dfield" style={{ gridColumn: '1 / -1', background: 'linear-gradient(135deg, rgba(99,102,241,0.06), rgba(139,92,246,0.06))', padding: '12px 14px', borderRadius: 8, border: '1px solid rgba(99,102,241,0.15)' }}>
                <span style={{ display: 'flex', alignItems: 'center', gap: 6, fontWeight: 600, fontSize: '0.82rem', color: '#6366f1' }}>
                  <Calendar size={13}/> Ngày bắt đầu học
                </span>
                {editingDate ? (
                  <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 8 }}>
                    <input type="date" value={dateDraft} onChange={e => setDateDraft(e.target.value)}
                      style={{ padding: '6px 10px', border: '1.5px solid #6366f1', borderRadius: 6, fontSize: '0.85rem', outline: 'none', color: '#1e1b4b', fontWeight: 500 }} />
                    <button style={{ padding: '6px 14px', fontSize: '0.8rem', background: '#6366f1', color: '#fff', border: 'none', borderRadius: 6, fontWeight: 600, cursor: 'pointer' }} onClick={handleSaveDate} disabled={savingDate}>
                      {savingDate ? '...' : '✓ Lưu'}
                    </button>
                    <button style={{ padding: '6px 12px', fontSize: '0.8rem', background: 'transparent', color: '#6b7280', border: '1px solid #d1d5db', borderRadius: 6, cursor: 'pointer' }} onClick={() => setEditingDate(false)}>Huỷ</button>
                  </div>
                ) : (
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginTop: 6 }}>
                    <strong style={{ fontSize: '0.95rem', color: cls.learningStartDate ? '#1e1b4b' : '#9ca3af' }}>
                      {cls.learningStartDate ? new Date(cls.learningStartDate).toLocaleDateString('vi-VN', { weekday: 'long', day: '2-digit', month: '2-digit', year: 'numeric' }) : 'Chưa thiết lập'}
                    </strong>
                    <button style={{ padding: '3px 10px', fontSize: '0.75rem', background: 'rgba(99,102,241,0.1)', color: '#6366f1', border: '1px solid rgba(99,102,241,0.25)', borderRadius: 5, cursor: 'pointer', fontWeight: 600 }} onClick={() => setEditingDate(true)}>
                      ✏️ Sửa
                    </button>
                  </div>
                )}
              </div>
              <div className="acl-dfield"><span>Môn</span><strong>{cls.subject}</strong></div>
              <div className="acl-dfield"><span>Khối</span><strong>{cls.grade}</strong></div>
              <div className="acl-dfield"><span>Hình thức</span><strong>{cls.mode === 'ONLINE' ? '🌐 Online' : '📍 Offline'}</strong></div>
              {cls.address && <div className="acl-dfield"><span>Địa chỉ</span><strong>{cls.address}</strong></div>}
              {cls.timeFrame && <div className="acl-dfield"><span>Khung giờ</span><strong>{cls.timeFrame}</strong></div>}
              <div className="acl-dfield"><span>Buổi/tuần</span><strong>{cls.sessionsPerWeek ?? '—'}</strong></div>
              <div className="acl-dfield"><span>Thời lượng</span><strong>{cls.sessionDurationMin ? `${cls.sessionDurationMin} phút` : '—'}</strong></div>
              {cls.genderRequirement && <div className="acl-dfield"><span>Yêu cầu GS</span><strong>{cls.genderRequirement}</strong></div>}
            </div>
          </section>

          {/* Schedule */}
          {schedule.length > 0 && (
            <section className="acl-drawer-section">
              <h3><Calendar size={13}/> Lịch học</h3>
              <div className="acl-schedule-list">
                {schedule.map((s: any, i: number) => (
                  <div key={i} className="acl-schedule-item">
                    <span className="acl-day">{dayLabel[s.dayOfWeek] ?? s.dayOfWeek}</span>
                    <span>{s.startTime} – {s.endTime}</span>
                  </div>
                ))}
              </div>
            </section>
          )}

          {/* People */}
          <section className="acl-drawer-section">
            <h3><User size={13}/> Phụ huynh & Gia sư</h3>
            <div className="acl-dgrid">
              <div className="acl-dfield"><span>Phụ huynh</span><strong>{cls.parentName ?? '—'}</strong></div>
              <div className="acl-dfield"><span>SĐT PH</span><strong>{cls.parentPhone ?? '—'}</strong></div>
              <div className="acl-dfield"><span>Gia sư</span><strong>{cls.tutorName ?? 'Chưa có'}</strong></div>
              <div className="acl-dfield"><span>SĐT GS</span><strong>{cls.tutorPhone ?? '—'}</strong></div>
              {cls.tutorType && <div className="acl-dfield"><span>Loại GS</span><strong>{cls.tutorType}</strong></div>}
            </div>
          </section>

          {/* Schedule Stats */}
          {(cls.status === 'ACTIVE' || cls.status === 'COMPLETED') && (
            <section className="acl-drawer-section">
              <h3><Activity size={13}/> Thống kê Lịch Dạy</h3>
              {loadingStats ? (
                <div style={{ padding: 12, fontSize: '0.85rem', color: '#6b7280' }}>Đang tải dữ liệu...</div>
              ) : stats ? (
                <div className="acl-dgrid">
                  <div className="acl-dfield"><span>Tổng số buổi</span><strong>{stats.totalSessions}</strong></div>
                  <div className="acl-dfield"><span>Đã hoàn thành</span><strong className="acl-green">{stats.completedSessions}</strong></div>
                  <div className="acl-dfield"><span>Sắp học (Scheduled)</span><strong>{stats.upcomingSessions}</strong></div>
                  
                  <div className="acl-dfield"><span>Học chính</span><strong>{stats.regularCount}</strong></div>
                  <div className="acl-dfield"><span>Dạy bù</span><strong style={{color: '#f59e0b'}}>{stats.makeupCount}</strong></div>
                  <div className="acl-dfield"><span>Tăng cường</span><strong style={{color: '#8b5cf6'}}>{stats.extraCount}</strong></div>
                  
                  <div className="acl-dfield"><span>Đã huỷ</span><strong style={{color: '#ef4444'}}>{stats.cancelledCount}</strong></div>
                  <div className="acl-dfield"><span>Nợ buổi bù</span><strong style={{color: '#dc2626'}}>{stats.pendingMakeupCount}</strong></div>
                </div>
              ) : (
                <div style={{ padding: 12, fontSize: '0.85rem', color: '#6b7280' }}>Không thể tải dữ liệu thống kê.</div>
              )}
            </section>
          )}

          {/* Fees */}
          <section className="acl-drawer-section">
            <h3><DollarSign size={13}/> Các mức chi phí</h3>

            {/* Chưa ACTIVE (OPEN / Chờ PH chọn): hiển thị bảng theo từng level vì chưa xác định phí */}
            {cls.status !== 'ACTIVE' && (cls.levelFees || cls.tutorProposals) ? (() => {
              let levels: Array<{ level: string; fee?: number }> = [];
              let proposals: Array<{ level: string; fee?: number }> = [];
              try { 
                if (cls.levelFees) {
                  const parsed = JSON.parse(cls.levelFees);
                  levels = Array.isArray(parsed) ? parsed : [];
                }
              } catch {}
              try { 
                if (cls.tutorProposals) {
                  const parsed = JSON.parse(cls.tutorProposals);
                  proposals = Array.isArray(parsed) ? parsed : [];
                }
              } catch {}
              
              const combinedFees = levels.length > 0 ? levels.map(lv => {
                const p = proposals.find(pr => pr.level === lv.level);
                return {
                  level: lv.level,
                  parent_fee: lv.fee || 0,
                  tutor_fee: p ? (p.fee || 0) : (lv.fee || 0)
                };
              }) : proposals.map(p => ({
                level: p.level,
                parent_fee: 0,
                tutor_fee: p.fee || 0
              }));

              return combinedFees.length > 0 ? (
                <div className="acl-level-fees-table" style={{ background: '#fff', borderRadius: 8, padding: 12, border: '1px solid #e5e7eb', overflowX: 'auto' }}>
                  <div className="acl-level-fees-head" style={{ display: 'grid', gridTemplateColumns: 'minmax(120px, 1.5fr) minmax(100px, 1.2fr) minmax(100px, 1.2fr) minmax(90px, 1fr) minmax(110px, 1.3fr)', gap: 16, fontSize: '0.8rem', paddingBottom: 10, borderBottom: '1px solid #e5e7eb', marginBottom: 8, fontWeight: 700, color: '#6b7280' }}>
                    <span>Loại GS</span>
                    <span style={{ textAlign: 'right' }}>Lương PH</span>
                    <span style={{ textAlign: 'right' }}>Lương TT set</span>
                    <span style={{ textAlign: 'right' }}>TT giữ</span>
                    <span style={{ textAlign: 'right' }}>Phí nhận lớp</span>
                  </div>
                  {combinedFees.map((lv, i) => {
                    const ph = lv.parent_fee || 0;
                    const tutorFee = lv.tutor_fee || 0;
                    const commission = (ph > 0 && tutorFee > 0) ? ph - tutorFee : 0;
                    const phiNl = Math.round(tutorFee * (cls.feePercentage ?? 30) / 100);
                    return (
                      <div key={i} className="acl-level-fees-row" style={{ display: 'grid', gridTemplateColumns: 'minmax(120px, 1.5fr) minmax(100px, 1.2fr) minmax(100px, 1.2fr) minmax(90px, 1fr) minmax(110px, 1.3fr)', gap: 16, fontSize: '0.85rem', padding: '10px 0', borderBottom: i < combinedFees.length - 1 ? '1px dashed #e5e7eb' : 'none', alignItems: 'center' }}>
                        <span className="acl-level-tag">{lv.level}</span>
                        <span style={{ textAlign: 'right', fontWeight: 600 }}>{ph > 0 ? fmtVnd(ph) : '—'}</span>
                        <span className="acl-green" style={{ textAlign: 'right', fontWeight: 600 }}>{tutorFee > 0 ? fmtVnd(tutorFee) : '—'}</span>
                        <span style={{ textAlign: 'right' }}>{commission > 0 ? fmtVnd(commission) : '—'}</span>
                        <span style={{ textAlign: 'right', color: '#db2777' }}>
                          {phiNl > 0 ? fmtVnd(phiNl) : '—'} <div style={{fontSize: 10, color: '#9ca3af', fontWeight: 'normal', marginTop: 2}}>({cls.feePercentage ?? 30}%)</div>
                        </span>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <p style={{color:'var(--color-text-muted)',fontSize:'0.85rem'}}>Chưa cấu hình học phí theo level.</p>
              );
            })() : (
              /* Lớp ACTIVE/khác: hiển thị fees thực tế đã xác định */
              <div className="acl-dgrid">
                <div className="acl-dfield"><span>Lương PH</span><strong>{(cls.parentFee ?? 0) > 0 ? fmtVnd(cls.parentFee) : '—'}</strong></div>
                <div className="acl-dfield"><span>Lương TT set</span><strong className="acl-green">{(cls.tutorFee ?? 0) > 0 ? fmtVnd(cls.tutorFee) : '—'}</strong></div>
                <div className="acl-dfield">
                  <span>TT giữ/tháng</span>
                  <strong>{(cls.parentFee ?? 0) > 0 && (cls.tutorFee ?? 0) > 0 ? fmtVnd((cls.parentFee ?? 0) - (cls.tutorFee ?? 0)) : '—'}</strong>
                </div>
                <div className="acl-dfield">
                  <span>Phí nhận lớp ({cls.feePercentage ?? 30}%)</span>
                  <strong style={{color: '#db2777'}}>{(cls.tutorFee ?? 0) > 0 ? fmtVnd(Math.round((cls.tutorFee ?? 0) * (cls.feePercentage ?? 30) / 100)) : '—'}</strong>
                </div>
              </div>
            )}
          </section>

          {/* Suspend Info */}
          {cls.status === 'SUSPENDED' && (
            <section className="acl-drawer-section">
              <h3><PauseCircle size={13}/> Thông tin tạm hoãn</h3>
              <div className="acl-dgrid">
                <div className="acl-dfield"><span>Từ ngày</span><strong>{cls.suspendStartDate ?? '—'}</strong></div>
                <div className="acl-dfield"><span>Đến ngày</span><strong>{cls.suspendEndDate ?? '—'}</strong></div>
                <div className="acl-dfield" style={{ gridColumn: '1 / -1' }}><span>Lý do</span><strong>{cls.suspendReason ?? 'Không có'}</strong></div>
              </div>
            </section>
          )}

          {/* Status change */}
          <section className="acl-drawer-section">
            <h3><RefreshCw size={13}/> Hành động</h3>
            <div style={{display:'flex',gap:8,flexWrap:'wrap'}}>
              {cls.status === 'ACTIVE' && (
                <button className="acl-status-btn acl-status-btn--suspended"
                  onClick={() => onSuspend(cls)}>
                  <PauseCircle size={13}/> Tạm hoãn lớp
                </button>
              )}
              {cls.status === 'SUSPENDED' && (
                <button className="acl-status-btn acl-status-btn--active"
                  onClick={() => onResume(cls)}>
                  <PlayCircle size={13}/> Kích hoạt lại
                </button>
              )}
              {nextOptions.filter(s => s !== 'SUSPENDED').map(s => (
                <button key={s} className={`acl-status-btn acl-status-btn--${s.toLowerCase()}`}
                  onClick={() => onStatusChange(cls, s)}>
                  {STATUS_CFG[s].icon} Chuyển sang {STATUS_CFG[s].label}
                </button>
              ))}
            </div>
          </section>
        </div>

        <div className="acl-drawer-footer">
          <button className="acl-btn-danger" onClick={() => { onClose(); onDelete(cls); }}>
            <Trash2 size={14}/> Xóa lớp
          </button>
        </div>
      </aside>
    </div>
  );
}

/* ─── Toast ─────────────────────────────────────────────────────────────── */
function useToast() {
  const [toast, setToast] = useState<{ type: 'success'|'error'; msg: string } | null>(null);
  const show = (type: 'success'|'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3200);
  };
  return { toast, show };
}

/* ─── Delete Confirm ─────────────────────────────────────────────────────── */
function DeleteModal({ cls, onConfirm, onCancel }: {
  cls: AdminClassListItem;
  onConfirm: () => Promise<void>;
  onCancel: () => void;
}) {
  const [sub, setSub] = useState(false);
  return (
    <div className="acl-modal-overlay" onClick={onCancel}>
      <div className="acl-modal acl-modal--sm" onClick={e => e.stopPropagation()}>
        <div className="acl-modal-header"><X size={16} className="acl-warn-icon"/> <span>Xác nhận xóa lớp</span>
          <button className="acl-close-btn" onClick={onCancel}><X size={15}/></button>
        </div>
        <div className="acl-modal-body">
          <p>Xóa lớp <strong>{cls.classCode} — {cls.title}</strong>?</p>
          <p style={{color:'var(--color-text-muted)',fontSize:'0.85rem',marginTop:6}}>
            Thao tác này sẽ xóa mềm lớp và hủy các đề xuất gia sư đang chờ.
          </p>
        </div>
        <div className="acl-modal-footer">
          <button className="acl-btn-ghost" onClick={onCancel}>Huỷ</button>
          <button className="acl-btn-danger" disabled={sub} onClick={async() => { setSub(true); await onConfirm(); setSub(false); }}>
            <Trash2 size={13}/> {sub ? 'Đang xóa...' : 'Xác nhận xóa'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ─── Suspend Modal ───────────────────────────────────────────────────────────── */
function SuspendModal({ cls, onConfirm, onCancel }: {
  cls: AdminClassListItem;
  onConfirm: (startDate: string, endDate: string, reason: string) => Promise<void>;
  onCancel: () => void;
}) {
  const todayStr = new Date().toISOString().split('T')[0];
  const [startDate, setStartDate] = useState(todayStr);
  const [endDate, setEndDate] = useState('');
  const [reason, setReason] = useState('');
  const [submitting, setSubmitting] = useState(false);

  return (
    <div className="acl-modal-overlay" onClick={onCancel}>
      <div className="acl-modal" onClick={e => e.stopPropagation()} style={{ maxWidth: 480 }}>
        <div className="acl-modal-header">
          <PauseCircle size={16} style={{ color: '#f59e0b' }}/>
          <span>Tạm hoãn lớp {cls.classCode}</span>
          <button className="acl-close-btn" onClick={onCancel}><X size={15}/></button>
        </div>
        <div className="acl-modal-body">
          <p style={{ fontSize: '0.85rem', color: '#6b7280', marginBottom: 16 }}>
            Chọn khoảng thời gian tạm hoãn. Các buổi DRAFT/SCHEDULED trong khoảng này sẽ bị hủy tự động.
          </p>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, marginBottom: 14 }}>
            <label style={{ fontSize: '0.82rem', fontWeight: 600, color: '#374151' }}>
              Từ ngày
              <input type="date" value={startDate} onChange={e => setStartDate(e.target.value)}
                style={{ width: '100%', marginTop: 4, padding: '8px 10px', border: '1.5px solid #d1d5db', borderRadius: 6, fontSize: '0.85rem' }} />
            </label>
            <label style={{ fontSize: '0.82rem', fontWeight: 600, color: '#374151' }}>
              Đến ngày
              <input type="date" value={endDate} onChange={e => setEndDate(e.target.value)}
                style={{ width: '100%', marginTop: 4, padding: '8px 10px', border: '1.5px solid #d1d5db', borderRadius: 6, fontSize: '0.85rem' }} />
            </label>
          </div>
          <label style={{ fontSize: '0.82rem', fontWeight: 600, color: '#374151' }}>
            Lý do (tùy chọn)
            <textarea value={reason} onChange={e => setReason(e.target.value)}
              placeholder="VD: Nghỉ hè, lý do cá nhân..."
              rows={2}
              style={{ width: '100%', marginTop: 4, padding: '8px 10px', border: '1.5px solid #d1d5db', borderRadius: 6, fontSize: '0.85rem', resize: 'vertical' }} />
          </label>
        </div>
        <div className="acl-modal-footer">
          <button className="acl-btn-ghost" onClick={onCancel}>Huỷ</button>
          <button
            className="acl-status-btn acl-status-btn--suspended"
            disabled={submitting || !startDate || !endDate}
            onClick={async () => {
              setSubmitting(true);
              await onConfirm(startDate, endDate, reason);
              setSubmitting(false);
            }}
            style={{ padding: '8px 18px' }}
          >
            <PauseCircle size={13}/> {submitting ? 'Đang xử lý...' : 'Xác nhận tạm hoãn'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ─── Main Page ─────────────────────────────────────────────────────────── */
type FilterKey = 'ALL' | ClassStatus | 'PENDING_PROPOSAL';

const STATUS_TABS: FilterKey[] = ['ALL', 'OPEN', 'PENDING_PROPOSAL', 'ACTIVE', 'SUSPENDED', 'COMPLETED', 'CANCELLED', 'AUTO_CLOSED'];
const STATUS_LABELS: Record<FilterKey, string> = {
  ALL: 'Tất cả', OPEN: 'Đang mở', PENDING_PROPOSAL: 'Chờ PH chọn',
  ASSIGNED: 'Đang mở', MATCHED: 'Đang mở',
  ACTIVE: 'Đang dạy', SUSPENDED: 'Tạm hoãn', COMPLETED: 'Hoàn thành', CANCELLED: 'Đã huỷ',
  AUTO_CLOSED: 'Hết hạn',
};

export function AdminClasses() {
  const [classes, setClasses] = useState<AdminClassListItem[]>([]);
  const [stats, setStats] = useState<Record<string, number>>({});
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<FilterKey>('ALL');
  const [search, setSearch] = useState('');
  const [selected, setSelected] = useState<AdminClassListItem | null>(null);
  const [pendingDelete, setPendingDelete] = useState<AdminClassListItem | null>(null);
  const [pendingSuspend, setPendingSuspend] = useState<AdminClassListItem | null>(null);
  const [showCreateModal, setShowCreateModal] = useState(false);
  const { toast, show: showToast } = useToast();

  const fetchAll = async () => {
    setLoading(true);
    try {
      const [clsRes, statRes] = await Promise.all([
        adminApi.getAllClasses(),
        adminApi.getClassStats(),
      ]);
      setClasses(clsRes.data ?? []);
      setStats(statRes.data ?? {});
    } catch {
      showToast('error', 'Không thể tải danh sách lớp');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchAll(); }, []);

  const handleDelete = async () => {
    if (!pendingDelete) return;
    try {
      await adminApi.deleteClass(pendingDelete.id);
      showToast('success', `Đã xóa lớp ${pendingDelete.classCode}`);
      setPendingDelete(null);
      setSelected(null);
      await fetchAll();
    } catch (e: any) {
      showToast('error', e?.response?.data?.message ?? 'Xóa thất bại');
      setPendingDelete(null);
    }
  };

  const handleStatusChange = async (cls: AdminClassListItem, newStatus: ClassStatus) => {
    try {
      await adminApi.updateClassStatus(cls.id, newStatus);
      showToast('success', `Đã chuyển lớp ${cls.classCode} sang ${STATUS_CFG[newStatus].label}`);
      setSelected(null);
      await fetchAll();
    } catch (e: any) {
      showToast('error', e?.response?.data?.message ?? 'Chuyển trạng thái thất bại');
    }
  };

  const displayed = useMemo(() => {
    let list: AdminClassListItem[];
    if (filter === 'ALL') {
      list = classes;
    } else if (filter === 'PENDING_PROPOSAL') {
      list = classes.filter(c => c.hasPendingProposals && c.status === 'OPEN');
    } else {
      list = classes.filter(c => c.status === filter);
    }
    if (search.trim()) {
      const q = search.toLowerCase();
      list = list.filter(c =>
        c.title.toLowerCase().includes(q) ||
        c.classCode.toLowerCase().includes(q) ||
        c.subject.toLowerCase().includes(q) ||
        (c.parentName ?? '').toLowerCase().includes(q) ||
        (c.tutorName ?? '').toLowerCase().includes(q)
      );
    }
    return list;
  }, [classes, filter, search]);

  return (
    <div className="acl-page">
      {toast && <div className={`acl-toast acl-toast-${toast.type}`}>{toast.msg}</div>}
      {pendingDelete && <DeleteModal cls={pendingDelete} onConfirm={handleDelete} onCancel={() => setPendingDelete(null)}/>}
      {selected && (
        <ClassDetailDrawer cls={selected} onClose={() => setSelected(null)}
          onDelete={c => { setSelected(null); setPendingDelete(c); }}
          onRefresh={fetchAll}
          onStatusChange={handleStatusChange}
          onSuspend={c => { setSelected(null); setPendingSuspend(c); }}
          onResume={async c => {
            try {
              await adminApi.resumeClass(c.id);
              showToast('success', `Lớp ${c.classCode} đã hoạt động trở lại!`);
              setSelected(null);
              await fetchAll();
            } catch (e: any) {
              showToast('error', e?.response?.data?.message ?? 'Kích hoạt lại thất bại');
            }
          }}
        />
      )}
      {pendingSuspend && (
        <SuspendModal
          cls={pendingSuspend}
          onCancel={() => setPendingSuspend(null)}
          onConfirm={async (startDate, endDate, reason) => {
            try {
              const res = await adminApi.suspendClass(pendingSuspend.id, startDate, endDate, reason);
              const data = res.data;
              const warnings = data?.completedWarnings ?? [];
              if (warnings.length > 0) {
                showToast('error', `⚠️ Có ${warnings.length} buổi COMPLETED trong khoảng - kiểm tra lại!`);
              } else {
                showToast('success', `Đã tạm hoãn lớp ${pendingSuspend.classCode} (hủy ${data?.cancelledSessions ?? 0} buổi)`);
              }
              setPendingSuspend(null);
              setSelected(null);
              await fetchAll();
            } catch (e: any) {
              showToast('error', e?.response?.data?.message ?? 'Tạm hoãn thất bại');
            }
          }}
        />
      )}
      {showCreateModal && (
        <AdminCreateClassModal 
          onClose={() => setShowCreateModal(false)} 
          onSuccess={() => { setShowCreateModal(false); fetchAll(); }}
          showToast={showToast} 
        />
      )}

      {/* Header */}
      <div className="acl-header">
        <div>
          <h1 className="acl-title">Quản lý Lớp học</h1>
          <p className="acl-subtitle">Theo dõi và quản lý tất cả lớp học trong hệ thống</p>
        </div>
        <button 
          onClick={() => setShowCreateModal(true)}
          style={{ whiteSpace: 'nowrap', padding: '10px 16px', borderRadius: '8px', background: '#6366f1', color: '#fff', border: 'none', fontWeight: 600, display: 'flex', alignItems: 'center', gap: 6, cursor: 'pointer', boxShadow: '0 4px 6px rgba(99,102,241,0.2)' }}>
          <BookOpen size={16}/> Mở lớp hộ PH
        </button>
      </div>

      {/* Stats */}
      {(() => {
        const pendingProposalCount = classes.filter(c => c.hasPendingProposals && c.status === 'OPEN').length;
        const statItems: Array<{ key: string; label: string; cls: string; filterKey: FilterKey }> = [
          { key: 'open',      label: 'Đang mở',       cls: 'acl-stat--blue',   filterKey: 'OPEN' },
          { key: 'pending',   label: 'Chờ PH chọn',   cls: 'acl-stat--violet', filterKey: 'PENDING_PROPOSAL' },
          { key: 'active',    label: 'Đang dạy',      cls: 'acl-stat--green',  filterKey: 'ACTIVE' },
          { key: 'suspended', label: 'Tạm hoãn',      cls: 'acl-stat--amber',  filterKey: 'SUSPENDED' },
          { key: 'completed', label: 'Hoàn thành',    cls: '',                 filterKey: 'COMPLETED' },
          { key: 'cancelled', label: 'Đã huỷ',        cls: 'acl-stat--red',    filterKey: 'CANCELLED' },
        ];
        return (
          <div className="acl-stats">
            {statItems.map(s => (
              <div key={s.key}
                className={`acl-stat-card ${s.cls} ${filter === s.filterKey ? 'acl-stat--active' : ''}`}
                style={{ cursor: 'pointer' }}
                onClick={() => setFilter(f => f === s.filterKey ? 'ALL' : s.filterKey)}
              >
                <span className="acl-stat-num">
                  {s.key === 'pending' ? pendingProposalCount : (stats[s.key] ?? 0)}
                </span>
                <span className="acl-stat-lbl">{s.label}</span>
              </div>
            ))}
            <div className="acl-stat-card acl-stat--total" style={{ cursor: 'pointer' }} onClick={() => setFilter('ALL')}>
              <span className="acl-stat-num">{stats['total'] ?? classes.length}</span>
              <span className="acl-stat-lbl">Tổng lớp</span>
            </div>
          </div>
        );
      })()}

      {/* Toolbar */}
      <div className="acl-toolbar">
        <div className="acl-search-box">
          <Search size={14}/>
          <input placeholder="Tìm mã lớp, tên, môn, phụ huynh, gia sư..."
            value={search} onChange={e => setSearch(e.target.value)}/>
        </div>
        <div className="acl-tab-bar">
          {STATUS_TABS.map(t => (
            <button key={t} className={`acl-tab ${filter === t ? 'active' : ''}`}
              onClick={() => setFilter(t)}>
              {STATUS_LABELS[t]}
              {t !== 'ALL' && stats[t.toLowerCase()] != null && (
                <span className="acl-tab-count">{stats[t.toLowerCase()]}</span>
              )}
            </button>
          ))}
        </div>
      </div>

      {/* List */}
      {loading ? (
        <div className="acl-empty"><BookOpen size={36} className="spin"/><span>Đang tải...</span></div>
      ) : displayed.length === 0 ? (
        <div className="acl-empty"><BookOpen size={36}/><span>Không có lớp nào</span></div>
      ) : (
        <div className="acl-grid">
          {displayed.map(c => (
            <ClassCard key={c.id} cls={c} onClick={setSelected} onDelete={setPendingDelete}/>
          ))}
        </div>
      )}
    </div>
  );
}
