import { CheckCircle, XCircle, Clock, BookOpen, User, Phone, FileText, MapPin, Calendar, GraduationCap, X, Users, Briefcase, ListTodo, ArrowLeft, DollarSign } from 'lucide-react';
import { useState, useEffect, useMemo } from 'react';

import { adminApi } from '../../services/adminApi';
import type { ClassApplicationItem } from '../../services/adminApi';
import './AdminClassApplications.css';

type FilterStatus = 'ALL' | 'PENDING' | 'APPROVED' | 'REJECTED';

/* ─── Helpers ──────────────────────────────────────────────────────────────── */

function formatVnd(amount: number) {
  return amount.toLocaleString('vi-VN') + 'đ';
}

function parseSchedule(raw?: string): string {
  if (!raw) return '';
  try {
    if (raw.startsWith('[')) {
      const slots = JSON.parse(raw);
      if (Array.isArray(slots) && slots.length > 0) {
        return slots.map((s: any) => {
          const day = s.dayOfWeek.charAt(0).toUpperCase() + s.dayOfWeek.slice(1).toLowerCase();
          return `${day} ${s.startTime?.substring(0, 5)}–${s.endTime?.substring(0, 5)}`;
        }).join(' • ');
      }
    }
  } catch { /* ignore */ }
  return '';
}

function parseFeeArray(raw?: string) {
  if (!raw) return [];
  try { return JSON.parse(raw) as { level: string; fee: number }[]; }
  catch { return []; }
}

function getCombinedFees(levelFeesStr?: string, tutorProposalsStr?: string) {
  const levels = parseFeeArray(levelFeesStr);
  const proposals = parseFeeArray(tutorProposalsStr);

  if (levels.length === 0 && proposals.length === 0) return [];
  if (levels.length > 0) {
    return levels.map(lv => {
      const p = proposals.find(pr => pr.level === lv.level);
      return {
        level: lv.level,
        parent_fee: lv.fee || 0,
        tutor_fee: p ? (p.fee || 0) : (lv.fee || 0)
      };
    });
  }
  return proposals.map(p => ({
    level: p.level,
    parent_fee: 0,
    tutor_fee: p.fee || 0
  }));
}

function formatDate(iso: string) {
  return new Date(iso).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' });
}

function groupByClass(apps: ClassApplicationItem[]): Map<string, ClassApplicationItem[]> {
  const map = new Map<string, ClassApplicationItem[]>();
  for (const app of apps) {
    if (!map.has(app.classId)) map.set(app.classId, []);
    map.get(app.classId)!.push(app);
  }
  return map;
}

/* ─── Status badge ─────────────────────────────────────────────────────────── */
function StatusBadge({ status }: { status: ClassApplicationItem['status'] }) {
  const map = {
    PENDING:  { label: 'Chờ duyệt',  cls: 'badge-pending' },
    APPROVED: { label: 'Đề xuất PH', cls: 'badge-approved' },
    REJECTED: { label: 'Từ chối',    cls: 'badge-rejected' },
  };
  const s = map[status];
  return <span className={`aca-status-badge ${s.cls}`}>{s.label}</span>;
}

/* ─── Approve Modal ────────────────────────────────────────────────────────── */
function ApproveModal({
  app,
  defaultSalary,
  onConfirm,
  onCancel,
}: {
  app: ClassApplicationItem;
  defaultSalary: number | null;
  onConfirm: (id: string, salary: number) => Promise<void>;
  onCancel: () => void;
}) {
  const [salary, setSalary] = useState<string>(defaultSalary != null ? String(defaultSalary) : '');
  const [submitting, setSubmitting] = useState(false);

  const handleConfirm = async () => {
    const parsed = parseInt(salary.replace(/[^0-9]/g, ''), 10);
    if (!parsed || parsed <= 0) return;
    setSubmitting(true);
    await onConfirm(app.applicationId, parsed);
    setSubmitting(false);
  };

  return (
    <div className="aca-modal-overlay" onClick={onCancel}>
      <div className="aca-modal" onClick={e => e.stopPropagation()}>
        <div className="aca-modal-header">
          <DollarSign size={18} />
          <span>Đề xuất gia sư cho Phụ huynh</span>
          <button className="aca-modal-close" onClick={onCancel}><X size={16} /></button>
        </div>
        <div className="aca-modal-body">
          <p className="aca-modal-tutor-name">{app.tutorName}</p>
          <p className="aca-modal-tutor-meta">
            {app.tutorType || 'Chưa xác nhận'} &nbsp;•&nbsp; <Phone size={11} /> {app.tutorPhone}
          </p>
          <label className="aca-modal-label">Mức lương thực tế (đ/tháng)</label>
          <input
            className="aca-modal-input"
            type="number"
            min={0}
            step={50000}
            value={salary}
            onChange={e => setSalary(e.target.value)}
            placeholder="Nhập mức lương..."
            autoFocus
          />
          {defaultSalary != null && (
            <p className="aca-modal-hint">Mặc định theo trình độ: {defaultSalary.toLocaleString('vi-VN')}đ/tháng</p>
          )}
        </div>
        <div className="aca-modal-footer">
          <button className="aca-btn aca-btn-ghost" onClick={onCancel}>Huỷ</button>
          <button
            className="aca-btn aca-btn-approve"
            onClick={handleConfirm}
            disabled={submitting || !salary}
          >
            <CheckCircle size={14} /> {submitting ? 'Đang xử lý...' : 'Đề xuất cho PH'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ─── Class Detail View (Tách trang) ───────────────────────────────────────── */
function ClassApplicationDetail({
  applications,
  onBack,
  onApprove,
  onReject,
  submittingId,
}: {
  applications: ClassApplicationItem[];
  onBack: () => void;
  onApprove: (id: string, salary: number) => Promise<void>;
  onReject: (id: string) => Promise<void>;
  submittingId: string | null;
}) {
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [pendingApproveApp, setPendingApproveApp] = useState<ClassApplicationItem | null>(null);

  const cls = applications[0];
  const levelFees = useMemo(() => getCombinedFees(cls.levelFees, cls.tutorProposals), [cls.levelFees, cls.tutorProposals]);
  const scheduleDisplay = parseSchedule(cls.schedule);
  const durationH = cls.sessionDurationMin ? (cls.sessionDurationMin / 60).toFixed(1).replace('.0', '') : '?';
  const pendingApps = applications.filter(a => a.status === 'PENDING');

  const toggleId = (id: string) => {
    setSelectedIds(prev => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  };

  const getDefaultSalary = (app: ClassApplicationItem): number | null => {
    if (!app.tutorType || levelFees.length === 0) return null;
    const match = levelFees.find(f => f.level === app.tutorType || f.level.includes(app.tutorType!));
    return match ? match.tutor_fee : null;
  };

  const handleApproveSelected = async () => {
    // Bulk approve: dùng default salary theo loại GS
    for (const id of selectedIds) {
      const app = applications.find(a => a.applicationId === id);
      const salary = app ? getDefaultSalary(app) : null;
      await onApprove(id, salary ?? 0);
    }
    setSelectedIds(new Set());
  };

  return (
    <>
    {pendingApproveApp && (
      <ApproveModal
        app={pendingApproveApp}
        defaultSalary={getDefaultSalary(pendingApproveApp)}
        onConfirm={async (id, salary) => { await onApprove(id, salary); setPendingApproveApp(null); }}
        onCancel={() => setPendingApproveApp(null)}
      />
    )}
    <div className="aca-detail-view">
      <div className="aca-detail-header">
        <button className="aca-btn-back" onClick={onBack}>
          <ArrowLeft size={18} /> Quay lại danh sách
        </button>
      </div>

      <div className="aca-detail-content">
        {/* Lớp information */}
        <div className="aca-detail-class-box">
          <div className="aca-detail-class-header">
            <div style={{ display: 'flex', gap: '8px', alignItems: 'center' }}>
              <span className="aca-card-code"><BookOpen size={14} />#{cls.classCode}</span>
              {cls.isMockClass && (
                <span style={{ backgroundColor: '#ec4899', color: 'white', padding: '2px 6px', borderRadius: '4px', fontSize: '10px', fontWeight: 'bold' }}>
                  LỚP ẢO / MOCK
                </span>
              )}
            </div>
            <h2 className="aca-detail-class-title">{cls.classTitle}</h2>
          </div>

          {cls.description && (
            <div className="aca-detail-desc">
              <span className="aca-info-label">Mô tả lớp</span>
              <p>{cls.description}</p>
            </div>
          )}

          <div className="aca-detail-grid">
            <div className="aca-info-box">
              <span className="aca-info-label"><GraduationCap size={14} /> MÔN / CẤP ĐỘ</span>
              <span className="aca-info-value">{cls.subject} – {cls.grade}</span>
            </div>
            {cls.location && (
              <div className="aca-info-box">
                <span className="aca-info-label"><MapPin size={14} /> ĐỊA ĐIỂM</span>
                <span className="aca-info-value">{cls.location}</span>
              </div>
            )}
            <div className="aca-info-box">
              <span className="aca-info-label"><Calendar size={14} /> KHUNG GIỜ</span>
              <span className="aca-info-value">{cls.timeFrame || 'Linh hoạt'}</span>
            </div>
            {scheduleDisplay && (
              <div className="aca-info-box">
                <span className="aca-info-label"><Clock size={14} /> LỊCH HỌC</span>
                <span className="aca-info-value">{scheduleDisplay}</span>
              </div>
            )}
            {cls.sessionsPerWeek && (
              <div className="aca-info-box">
                <span className="aca-info-label"><Clock size={14} /> BUỔI / TUẦN</span>
                <span className="aca-info-value">{cls.sessionsPerWeek} buổi ({durationH}h/buổi)</span>
              </div>
            )}
            <div className="aca-info-box">
              <span className="aca-info-label"><Users size={14} /> SỐ HỌC SINH</span>
              <span className="aca-info-value">{cls.studentCount ?? 1} em</span>
            </div>
            <div className="aca-info-box">
              <span className="aca-info-label"><User size={14} /> YÊU CẦU GIỚI TÍNH</span>
              <span className="aca-info-value">{cls.genderRequirement || 'Không yêu cầu'}</span>
            </div>
            <div className="aca-info-box">
              <span className="aca-info-label"><Phone size={14} /> SĐT PHỤ HUYNH</span>
              <span className="aca-info-value">
                {cls.parentPhone
                  ? <a href={`tel:${cls.parentPhone}`} style={{ color: 'var(--color-primary)', textDecoration: 'none' }}>{cls.parentPhone}</a>
                  : 'Chưa cập nhật'
                }
              </span>
            </div>
          </div>

          {/* Fees & Requirements */}
          {levelFees.length > 0 && (
            <div className="aca-detail-fees">
              <span className="aca-section-label">Học phí theo trình độ</span>
              <div className="aca-fee-rows">
                {levelFees.map(f => (
                  <div key={f.level} className="aca-fee-row">
                    <span className="aca-fee-level">{f.level}</span>
                    <span className="aca-fee-salary">{formatVnd(f.tutor_fee)}/tháng</span>
                    {f.parent_fee != null && (
                      <span className="aca-fee-admission">Phí gốc: {formatVnd(f.parent_fee)}</span>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}

          {cls.tutorLevelRequirement && cls.tutorLevelRequirement.length > 0 && (
            <div className="aca-detail-reqs">
              <span className="aca-section-label"><Users size={13} /> Yêu cầu trình độ</span>
              <div className="aca-req-tags">
                {cls.tutorLevelRequirement.map(r => <span key={r} className="aca-req-tag">{r}</span>)}
              </div>
            </div>
          )}
        </div>

        {/* Tutors applying */}
        <div className="aca-detail-tutors-box">
          <h3 className="aca-tutors-header">
            GIA SƯ ĐĂNG KÝ ({applications.length})
            {pendingApps.length > 0 && <span className="aca-pending-dot">{pendingApps.length} CHỜ DUYỆT</span>}
          </h3>

          {pendingApps.length > 1 && (
            <div className="aca-toolbar">
              <label className="aca-checkbox-label">
                <input
                  type="checkbox"
                  checked={selectedIds.size === pendingApps.length}
                  onChange={() => {
                    if (selectedIds.size === pendingApps.length) setSelectedIds(new Set());
                    else setSelectedIds(new Set(pendingApps.map(a => a.applicationId)));
                  }}
                />
                Chọn tất cả {pendingApps.length} chờ duyệt
              </label>
              {selectedIds.size > 0 && (
                <button className="aca-btn aca-btn-approve" onClick={handleApproveSelected} disabled={submittingId !== null}>
                  <CheckCircle size={14} />
                  Duyệt {selectedIds.size} gia sư đã chọn
                </button>
              )}
            </div>
          )}

          <div className="aca-tutor-list-full">
            {applications.map(app => {
              // Calculate specific fee for this tutor's type
              let matchedFeeItem = null;
              if (app.tutorType) {
                matchedFeeItem = levelFees.find(f => f.level === app.tutorType || f.level.includes(app.tutorType!));
              }

              return (
                <div key={app.applicationId} className={`aca-tutor-card ${app.status !== 'PENDING' ? 'processed' : ''}`}>
                  <div className="aca-tutor-card-main">
                    
                    {app.status === 'PENDING' && (
                      <div className="aca-tutor-check">
                        <input
                          type="checkbox"
                          checked={selectedIds.has(app.applicationId)}
                          onChange={() => toggleId(app.applicationId)}
                        />
                      </div>
                    )}

                    <div className="aca-avatar">{(app.tutorName || '?').charAt(0).toUpperCase()}</div>

                    <div className="aca-tutor-details">
                      <span className="aca-tutor-name-text">{app.tutorName || 'Chưa cập nhật'}</span>
                      <span className="aca-tutor-phone-text">
                        <Phone size={11} /> {app.tutorPhone}
                        &nbsp;•&nbsp;
                        <span className="aca-tutor-type-tag">{app.tutorType || 'Chưa XN'}</span>
                      </span>
                      
                      <div className="aca-tutor-stats-inline">
                        <span title="Lớp đang dạy" className="stat-active"><Briefcase size={11} /> {app.tutorActiveClassesCount ?? 0}</span>
                        <span title="Đơn chờ duyệt" className="stat-pending"><ListTodo size={11} /> {app.tutorPendingApplicationsCount ?? 0}</span>
                      </div>
                    </div>

                    <div className="aca-tutor-fee-info">
                      {matchedFeeItem ? (
                        <>
                          <div className="tutor-salary-expected">
                            <span className="fee-lbl">Lương:</span> {formatVnd(matchedFeeItem.tutor_fee)}
                          </div>
                          {cls.feePercentage && (
                            <div className="tutor-admission-expected">
                              <span className="fee-lbl">Phí:</span> {formatVnd(Math.round(matchedFeeItem.tutor_fee * cls.feePercentage / 100))}
                            </div>
                          )}
                        </>
                      ) : (
                        <div className="tutor-fee-na">Chưa rõ mức lương cho loại GS này</div>
                      )}
                    </div>

                    <div className="aca-tutor-right">
                      <StatusBadge status={app.status} />
                      <span className="aca-date">{formatDate(app.appliedAt)}</span>
                    </div>

                    {app.status === 'PENDING' && (
                      <div className="aca-actions">
                        <button
                          className="aca-btn aca-btn-approve"
                          onClick={() => setPendingApproveApp(app)}
                          disabled={submittingId === app.applicationId}
                        >
                          <CheckCircle size={13} /> Duyệt
                        </button>
                        <button
                          className="aca-btn aca-btn-reject"
                          onClick={() => onReject(app.applicationId)}
                          disabled={submittingId === app.applicationId}
                        >
                          <XCircle size={13} /> Từ chối
                        </button>
                      </div>
                    )}
                  </div>

                  {app.note && (
                    <div className="aca-tutor-card-note">
                      <FileText size={12} />
                      <span className="note-lbl">Ghi chú gia sư:</span> {app.note}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
    </>
  );
}

/* ─── Compact class card (Main list view) ──────────────────────────────────── */
function ClassCard({
  applications,
  onClick,
}: {
  applications: ClassApplicationItem[];
  onClick: () => void;
}) {
  const cls = applications[0];
  const pendingCount = applications.filter(a => a.status === 'PENDING').length;

  return (
    <div className="aca-class-card" onClick={onClick}>
      <div className="aca-class-card-left">
        <div style={{ display: 'flex', gap: '8px', alignItems: 'center', marginBottom: '4px' }}>
          <div className="aca-card-code" style={{ margin: 0 }}><BookOpen size={13} />#{cls.classCode}</div>
          {cls.isMockClass && (
            <span style={{ backgroundColor: '#ec4899', color: 'white', padding: '2px 6px', borderRadius: '4px', fontSize: '10px', fontWeight: 'bold' }}>
              LỚP ẢO / MOCK
            </span>
          )}
        </div>
        <h3 className="aca-card-title">{cls.classTitle}</h3>
        <div className="aca-card-meta">
          <span><GraduationCap size={12} />{cls.subject} – {cls.grade}</span>
          {cls.location && <span><MapPin size={12} />{cls.location}</span>}
        </div>
        {cls.tutorLevelRequirement && cls.tutorLevelRequirement.length > 0 && (
          <div className="aca-card-reqs">
            {cls.tutorLevelRequirement.map(r => (
              <span key={r} className="aca-req-tag">{r}</span>
            ))}
          </div>
        )}
      </div>
      <div className="aca-class-card-right">
        <span className="aca-applicant-count">
          <Users size={14} /> {applications.length} gia sư
        </span>
        {pendingCount > 0 && (
          <span className="aca-pending-dot">{pendingCount} chờ duyệt</span>
        )}
        <span className="aca-card-arrow">Chi tiết →</span>
      </div>
    </div>
  );
}

/* ─── Main component ────────────────────────────────────────────────────────── */
export function AdminClassApplications() {
  const [applications, setApplications] = useState<ClassApplicationItem[]>([]);
  const [filter, setFilter] = useState<FilterStatus>('PENDING');
  const [loading, setLoading] = useState(true);
  const [submittingId, setSubmittingId] = useState<string | null>(null);
  const [selectedClassId, setSelectedClassId] = useState<string | null>(null);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3000);
  };

  const fetchApplications = async () => {
    try {
      setLoading(true);
      const status = filter === 'ALL' ? undefined : filter;
      const res = await adminApi.getClassApplications(status);
      setApplications(res.data || []);
    } catch (err) {
      console.error('Lỗi tải đơn:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchApplications(); }, [filter]);

  const handleApprove = async (applicationId: string, actualSalary: number) => {
    if (submittingId) return;
    setSubmittingId(applicationId);
    try {
      await adminApi.approveClassApplication(applicationId, actualSalary || undefined);
      showToast('success', 'Đã duyệt đơn và giao lớp cho gia sư!');
      window.dispatchEvent(new Event('refetchBadgeCounts'));
      await fetchApplications();
    } catch (err: any) {
      showToast('error', err?.response?.data?.message || 'Duyệt thất bại!');
    } finally {
      setSubmittingId(null);
    }
  };

  const handleReject = async (applicationId: string) => {
    if (submittingId) return;
    setSubmittingId(applicationId);
    try {
      await adminApi.rejectClassApplication(applicationId);
      showToast('success', 'Đã từ chối đơn.');
      window.dispatchEvent(new Event('refetchBadgeCounts'));
      await fetchApplications();
    } catch (err: any) {
      showToast('error', err?.response?.data?.message || 'Từ chối thất bại!');
    } finally {
      setSubmittingId(null);
    }
  };

  const grouped = useMemo(() => groupByClass(applications), [applications]);
  const classGroups = Array.from(grouped.entries());
  
  // Find selected apps
  const selectedApps = selectedClassId ? (grouped.get(selectedClassId) ?? null) : null;

  // Render detail view if selected
  if (selectedApps) {
    return (
      <div className="aca-page aca-page-detail">
        <ClassApplicationDetail
          applications={selectedApps}
          onBack={() => setSelectedClassId(null)}
          onApprove={handleApprove}
          onReject={handleReject}
          submittingId={submittingId}
        />
        {toast && <div className={`aca-toast aca-toast-${toast.type}`}>{toast.msg}</div>}
      </div>
    );
  }

  const filters: { label: string; value: FilterStatus }[] = [
    { label: 'Chờ duyệt', value: 'PENDING' },
    { label: 'Đã duyệt', value: 'APPROVED' },
    { label: 'Từ chối', value: 'REJECTED' },
    { label: 'Tất cả', value: 'ALL' },
  ];

  return (
    <div className="aca-page">
      <div className="aca-header">
        <h2 className="aca-title">📋 Đơn Nhận Lớp</h2>
        <p className="aca-subtitle">Chọn một lớp để xem chi tiết và danh sách gia sư đăng ký</p>
      </div>

      <div className="aca-tabs">
        {filters.map(f => (
          <button
            key={f.value}
            className={`aca-tab ${filter === f.value ? 'active' : ''}`}
            onClick={() => setFilter(f.value)}
          >
            {f.label}
          </button>
        ))}
      </div>

      {loading ? (
        <div className="aca-empty"><Clock size={32} className="spin" /> Đang tải...</div>
      ) : classGroups.length === 0 ? (
        <div className="aca-empty">
          <FileText size={48} style={{ color: 'var(--color-text-muted)', marginBottom: 12 }} />
          <p>Không có đơn nào.</p>
        </div>
      ) : (
        <div className="aca-card-list">
          {classGroups.map(([classId, apps]) => (
            <ClassCard
              key={classId}
              applications={apps}
              onClick={() => setSelectedClassId(classId)}
            />
          ))}
        </div>
      )}

      {toast && (
        <div className={`aca-toast aca-toast-${toast.type}`}>
          {toast.type === 'success' ? '✓ ' : '✕ '}{toast.msg}
        </div>
      )}
    </div>
  );
}
