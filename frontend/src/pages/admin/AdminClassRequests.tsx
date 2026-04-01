import { CheckCircle, XCircle, Clock, User, Phone, MapPin, Calendar, ChevronDown, ChevronUp, AlertCircle } from 'lucide-react';
import { useState, useEffect, useCallback } from 'react';

import { adminApi } from '../../services/adminApi';
import type { AdminClassListItem } from '../../services/adminApi';
import './AdminClassRequests.css';

const MODE_LABEL: Record<string, string> = {
  ONLINE: 'Online',
  OFFLINE: 'Tại nhà',
  BOTH: 'Linh hoạt',
};

function fmtDate(iso: string | null | undefined) {
  if (!iso) return '—';
  const d = new Date(iso);
  return `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}/${d.getFullYear()}`;
}

function fmtCurrency(n: number | null | undefined) {
  if (n == null) return '—';
  return n.toLocaleString('vi-VN') + ' ₫';
}

/* ── Reject Modal ── */
function RejectModal({ className, onConfirm, onCancel }: {
  className: string;
  onConfirm: (reason: string) => void;
  onCancel: () => void;
}) {
  const [reason, setReason] = useState('');

  return (
    <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.45)', zIndex: 2000, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 20 }}>
      <div style={{ background: 'var(--color-surface)', borderRadius: 16, padding: 28, maxWidth: 440, width: '100%', boxShadow: '0 20px 60px rgba(0,0,0,0.2)' }}>
        <h3 style={{ margin: '0 0 6px', fontSize: '1rem', fontWeight: 800, color: 'var(--color-text)' }}>Từ chối yêu cầu mở lớp</h3>
        <p style={{ margin: '0 0 16px', fontSize: '0.85rem', color: 'var(--color-text-muted)' }}>Lớp: <strong>{className}</strong></p>
        <textarea
          placeholder="Lý do từ chối (tuỳ chọn)..."
          value={reason}
          onChange={e => setReason(e.target.value)}
          rows={3}
          style={{ width: '100%', borderRadius: 10, border: '1.5px solid var(--color-border, #e5e7eb)', padding: '10px 12px', fontSize: '0.88rem', resize: 'vertical', fontFamily: 'inherit', outline: 'none', boxSizing: 'border-box', background: 'var(--color-bg)', color: 'var(--color-text)' }}
        />
        <div style={{ display: 'flex', gap: 10, marginTop: 16 }}>
          <button
            onClick={() => onConfirm(reason)}
            style={{ flex: 1, padding: '9px', borderRadius: 10, background: '#ef4444', color: '#fff', border: 'none', fontWeight: 700, cursor: 'pointer', fontSize: '0.88rem' }}
          >
            Xác nhận từ chối
          </button>
          <button
            onClick={onCancel}
            style={{ flex: 1, padding: '9px', borderRadius: 10, background: 'var(--color-bg, #f3f4f6)', color: 'var(--color-text)', border: 'none', fontWeight: 600, cursor: 'pointer', fontSize: '0.88rem' }}
          >
            Hủy
          </button>
        </div>
      </div>
    </div>
  );
}

/* ── Class Request Card ── */
function ClassRequestCard({ cls, onApprove, onReject }: {
  cls: AdminClassListItem;
  onApprove: (id: string, tutorFee?: number, levelFees?: string, tutorProposals?: string, platformPct?: number) => void;
  onReject: (id: string, name: string) => void;
}) {
  const [expanded, setExpanded] = useState(false);

  // Parse levelFees từ JSON
  const parsedLevelFees: { level: string; fee: number }[] = (() => {
    try { return JSON.parse(cls.levelFees ?? '[]'); }
    catch { return []; }
  })();

  // State editable: admin set lương GS cho từng level
  const [adminFees, setAdminFees] = useState<{ level: string; parentFee: number; adminFee: string }[]>(
    () => parsedLevelFees.map(lf => {
      const feeVal = lf.fee || (lf as any).parent_fee; // fallback cho DB data dở dang test
      return {
        level: lf.level,
        parentFee: feeVal,  // số PH đề xuất
        adminFee: String(feeVal), // admin có thể sửa, default = PH proposal
      };
    })
  );

  // Nếu không có levelFees → single tutorFee
  const defaultSingleFee = parsedLevelFees.length === 0
    ? String(cls.tutorFee != null && cls.tutorFee > 0
      ? cls.tutorFee
      : Math.round(Number(cls.parentFee) * 0.7))
    : '';
  const [singleFee, setSingleFee] = useState(defaultSingleFee);

  // Admin điền % TT nhận (platform fee %); default từ DB hoặc 30%
  const [platformPct, setPlatformPct] = useState(String(cls.feePercentage ?? 30));

  const parentFeeNum = Number(cls.parentFee) || 0;

  const buildApproveData = () => {
    const pct = Number(platformPct) || 0;
    if (parsedLevelFees.length > 0) {
      const updatedTutorProposals = adminFees.map(af => ({
        level: af.level,
        fee: Number(af.adminFee) || af.parentFee,
      }));
      // levelFees: undefined (không gửi đè của PH), gửi tutorProposals
      return { tutorFee: undefined, levelFees: undefined, tutorProposals: JSON.stringify(updatedTutorProposals), platformPct: pct };
    }
    return { tutorFee: Number(singleFee) || undefined, levelFees: undefined, tutorProposals: undefined, platformPct: pct };
  };

  const updateAdminFee = (idx: number, value: string) => {
    setAdminFees(prev => prev.map((af, i) => i === idx ? { ...af, adminFee: value } : af));
  };

  return (
    <div className="acr-card">
      <div className="acr-card__header" onClick={() => setExpanded(e => !e)}>
        <div className="acr-card__info">
          <div className="acr-card__badge">{cls.subject}</div>
          <h3 className="acr-card__title">{cls.title}</h3>
          <div className="acr-card__meta">
            <span><User size={13} /> {cls.parentName ?? '—'}</span>
            <span><Phone size={13} /> {cls.parentPhone ?? '—'}</span>
            <span><Calendar size={13} /> {fmtDate(cls.createdAt)}</span>
          </div>
        </div>
        <button className="acr-card__expand">
          {expanded ? <ChevronUp size={18} /> : <ChevronDown size={18} />}
        </button>
      </div>

      {/* Detail */}
      {expanded && (
        <div className="acr-card__detail">
          {/* Info cơ bản — không lặp fee vì đã có trong section bên dưới */}
          <div className="acr-detail-grid">
            <div className="acr-detail-item"><span className="acr-detail-label">Khối lớp</span><span>{cls.grade}</span></div>
            <div className="acr-detail-item"><span className="acr-detail-label">Hình thức</span><span>{MODE_LABEL[cls.mode ?? ''] ?? cls.mode}</span></div>
            <div className="acr-detail-item"><span className="acr-detail-label">Buổi/tuần</span><span>{cls.sessionsPerWeek} buổi</span></div>
            <div className="acr-detail-item"><span className="acr-detail-label">Thời lượng</span><span>{cls.sessionDurationMin} phút</span></div>
            {cls.address && <div className="acr-detail-item acr-detail-item--full"><span className="acr-detail-label"><MapPin size={12} /> Địa chỉ</span><span>{cls.address}</span></div>}
            {cls.timeFrame && <div className="acr-detail-item"><span className="acr-detail-label">Khung giờ</span><span>{cls.timeFrame}</span></div>}
            {cls.genderRequirement && <div className="acr-detail-item"><span className="acr-detail-label">Giới tính GS</span><span>{cls.genderRequirement}</span></div>}
          </div>

          {/* Editable lương GS theo loại */}
          <div className="acr-level-fees-section">
            {/* Header: % nhận lớp một lần */}
            <div className="acr-lf-summary-row">
              <div className="acr-lf-summary-item">
                <span className="acr-lf-summary-label">% phí nhận lớp (1 lần)</span>
                <div className="acr-tfs-row" style={{ gap: 6 }}>
                  <input
                    type="number"
                    className="acr-tfs-input acr-tfs-input--sm"
                    value={platformPct}
                    onChange={e => setPlatformPct(e.target.value)}
                    min={0} max={100} step={5}
                    style={{ width: 64 }}
                  />
                  <span className="acr-tfs-unit">%</span>
                </div>
              </div>
              <div className="acr-lf-summary-item" style={{ justifyContent: 'center', alignItems: 'center', flexDirection: 'row' }}>
                <span style={{ fontSize: '0.73rem', color: 'var(--color-text-muted)', lineHeight: 1.5 }}>
                  💡 GS đóng phí <strong>{platformPct}%</strong> × Lương GS nhận, <strong>1 lần duy nhất</strong> khi nhận lớp<br />
                  TT giữ hàng tháng = PH đề xuất − Lương GS nhận
                </span>
              </div>
            </div>
            <div className="acr-level-fees-title">
              🎯 TT set lương cho từng loại gia sư (hiển thị cho GS khi ứng tuyển)
            </div>

            {parsedLevelFees.length > 0 ? (
              <table className="acr-level-fees-table">
                <thead>
                  <tr>
                    <th>Loại gia sư</th>
                    <th>PH đề xuất/tháng</th>
                    <th>Lương GS nhận <span style={{ color: 'var(--color-text-muted)', fontWeight: 400 }}>(TT set)</span></th>
                    <th>TT giữ/tháng</th>
                    <th>Phí nhận lớp (1 lần)</th>
                  </tr>
                </thead>
                <tbody>
                  {adminFees.map((af, i) => {
                    const adminFeeNum = Number(af.adminFee) || 0;
                    const ttGiu = af.parentFee - adminFeeNum;
                    return (
                      <tr key={i}>
                        <td><span className="acr-lf-badge">{af.level}</span></td>
                        <td style={{ fontWeight: 700, color: '#6366f1', fontSize: '0.85rem' }}>
                          {af.parentFee.toLocaleString('vi-VN')} ₫
                        </td>
                        <td>
                          <input
                            type="number"
                            className="acr-tfs-input acr-tfs-input--sm"
                            value={af.adminFee}
                            onChange={e => updateAdminFee(i, e.target.value)}
                            min={0}
                            step={100000}
                          />
                        </td>
                        <td>
                          {adminFeeNum > 0 ? (
                            ttGiu >= 0 ? (
                              <span className="acr-lf-platform">{ttGiu.toLocaleString('vi-VN')} ₫</span>
                            ) : (
                              <span style={{ color: '#ef4444', fontWeight: 700, fontSize: '0.78rem' }}>⚠ Vượt PH đề xuất</span>
                            )
                          ) : '—'}
                        </td>
                        <td>
                          {adminFeeNum > 0 && Number(platformPct) > 0 ? (
                            <span style={{ fontWeight: 700, color: '#d97706', fontSize: '0.84rem' }}>
                              {Math.round(adminFeeNum * Number(platformPct) / 100).toLocaleString('vi-VN')} ₫
                            </span>
                          ) : '—'}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            ) : (
              /* Không có levelFees → single input */
              <div style={{ padding: '12px 14px' }}>
                <p style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)', margin: '0 0 8px' }}>
                  PH không chọn theo loại GS. Nhập lương cố định hiển thị cho tất cả gia sư.
                </p>
                <div className="acr-tfs-row">
                  <input
                    type="number"
                    className="acr-tfs-input"
                    value={singleFee}
                    onChange={e => setSingleFee(e.target.value)}
                    min={0}
                    step={100000}
                    placeholder="VD: 1500000"
                  />
                  <span className="acr-tfs-unit">₫/tháng</span>
                </div>
                {Number(singleFee) > 0 && parentFeeNum > 0 && (
                  <div className="acr-tfs-calc">
                    Platform nhận: {fmtCurrency(parentFeeNum - Number(singleFee))}/tháng
                    &nbsp;({Math.round((1 - Number(singleFee) / parentFeeNum) * 100)}%)
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      )}

      {/* Actions */}
      <div className="acr-card__actions">
        <button
          className="acr-btn acr-btn--approve"
          onClick={() => {
            const { tutorFee, levelFees, tutorProposals, platformPct: pct } = buildApproveData();
            onApprove(cls.id, tutorFee, levelFees, tutorProposals, pct);
          }}
        >
          <CheckCircle size={15} /> Duyệt & Mở lớp
        </button>
        <button className="acr-btn acr-btn--reject" onClick={() => onReject(cls.id, cls.title)}>
          <XCircle size={15} /> Từ chối
        </button>
      </div>
    </div>
  );
}

/* ── Main Page ── */
export function AdminClassRequests() {
  const [requests, setRequests] = useState<AdminClassListItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [rejectTarget, setRejectTarget] = useState<{ id: string; name: string } | null>(null);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3000);
  };

  const fetchRequests = useCallback(async () => {
    try {
      setLoading(true);
      const res = await adminApi.getPendingClassRequests();
      setRequests(res.data);
    } catch {
      showToast('error', 'Không thể tải danh sách yêu cầu');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { fetchRequests(); }, [fetchRequests]);

  const [approveTarget, setApproveTarget] = useState<{ id: string; title: string; tutorFee?: number; levelFees?: string; tutorProposals?: string; platformPct?: number } | null>(null);

  const handleApprove = async () => {
    if (!approveTarget) return;
    try {
      await adminApi.approveClassRequest(approveTarget.id, approveTarget.tutorFee, approveTarget.levelFees, approveTarget.tutorProposals, approveTarget.platformPct);
      showToast('success', 'Đã duyệt! Lớp đã được mở cho gia sư đăng ký.');
      window.dispatchEvent(new Event('refetchBadgeCounts'));
      fetchRequests();
    } catch {
      showToast('error', 'Duyệt thất bại');
    } finally {
      setApproveTarget(null);
    }
  };

  const handleReject = async (reason: string) => {
    if (!rejectTarget) return;
    try {
      await adminApi.rejectClassRequest(rejectTarget.id, reason);
      showToast('success', 'Đã từ chối yêu cầu mở lớp.');
      window.dispatchEvent(new Event('refetchBadgeCounts'));
      fetchRequests();
    } catch {
      showToast('error', 'Từ chối thất bại');
    } finally {
      setRejectTarget(null);
    }
  };

  return (
    <div className="admin-class-requests">
      {/* Toast */}
      {toast && (
        <div style={{
          position: 'fixed', bottom: 24, right: 24, zIndex: 9999, padding: '10px 20px',
          borderRadius: 10, fontWeight: 600, fontSize: '0.88rem',
          background: toast.type === 'success' ? '#ecfdf5' : '#fef2f2',
          color: toast.type === 'success' ? '#065f46' : '#b91c1c',
          border: `1px solid ${toast.type === 'success' ? 'rgba(5,150,105,0.3)' : 'rgba(239,68,68,0.3)'}`,
          boxShadow: '0 4px 16px rgba(0,0,0,0.1)',
        }}>
          {toast.type === 'success' ? '✓ ' : '✕ '}{toast.msg}
        </div>
      )}

      {/* Reject modal */}
      {rejectTarget && (
        <RejectModal
          className={rejectTarget.name}
          onConfirm={handleReject}
          onCancel={() => setRejectTarget(null)}
        />
      )}

      {/* Approve modal */}
      {approveTarget && (
        <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.45)', zIndex: 2000, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: 20 }}>
          <div style={{ background: 'var(--color-surface)', borderRadius: 16, padding: '24px 28px', maxWidth: 460, width: '100%', boxShadow: '0 20px 60px rgba(0,0,0,0.2)' }}>
            <h3 style={{ margin: '0 0 10px', fontSize: '1.05rem', fontWeight: 800, color: '#059669', display: 'flex', alignItems: 'center', gap: 8 }}>
              <CheckCircle size={22} style={{ strokeWidth: 2.5 }} /> Xác nhận mở lớp
            </h3>
            <p style={{ margin: '14px 0 24px', fontSize: '0.92rem', color: 'var(--color-text)', lineHeight: 1.6 }}>
              Bạn có chắc chắn muốn duyệt và mở lớp <strong>{approveTarget.title}</strong> này không? Yêu cầu này sẽ được đưa lên sàn ngay lập tức để các gia sư đăng ký ứng tuyển.
            </p>
            <div style={{ display: 'flex', gap: 12, marginTop: 16 }}>
              <button
                onClick={handleApprove}
                style={{ flex: 1, padding: '10px', borderRadius: 10, background: '#10b981', color: '#fff', border: 'none', fontWeight: 700, cursor: 'pointer', fontSize: '0.9rem', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6 }}
              >
                <CheckCircle size={16} /> Xác nhận duyệt
              </button>
              <button
                onClick={() => setApproveTarget(null)}
                style={{ flex: 1, padding: '10px', borderRadius: 10, background: 'var(--color-bg, #f3f4f6)', color: 'var(--color-text)', border: 'none', fontWeight: 600, cursor: 'pointer', fontSize: '0.9rem' }}
              >
                Đóng để xem lại
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Header */}
      <div className="acr-header">
        <div>
          <h1 className="acr-title">Yêu cầu mở lớp</h1>
          <p className="acr-subtitle">Xem xét, duyệt hoặc từ chối các yêu cầu mở lớp mới</p>
        </div>
        <div className="acr-badge-count">
          <Clock size={16} />
          {loading ? '...' : `${requests.length} yêu cầu chờ duyệt`}
        </div>
      </div>

      {/* Content */}
      {loading ? (
        <div style={{ padding: 48, textAlign: 'center', color: 'var(--color-text-muted)' }}>Đang tải...</div>
      ) : requests.length === 0 ? (
        <div className="acr-empty">
          <AlertCircle size={48} style={{ color: 'var(--color-text-muted)', opacity: 0.4 }} />
          <p>Không có yêu cầu nào đang chờ duyệt</p>
        </div>
      ) : (
        <div className="acr-list">
          {requests.map(cls => (
            <ClassRequestCard
              key={cls.id}
              cls={cls}
              onApprove={(id, tutorFee, levelFees, tutorProposals, platformPct) => setApproveTarget({ id, title: cls.title, tutorFee, levelFees, tutorProposals, platformPct })}
              onReject={(id, name) => setRejectTarget({ id, name })}
            />
          ))}
        </div>
      )}
    </div>
  );
}
