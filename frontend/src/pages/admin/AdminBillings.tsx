import { Receipt, Wallet, CalendarDays, CheckCircle, Clock, FileText, AlertTriangle, Trash2, ChevronsRight, Banknote, CircleDollarSign, ThumbsUp, Send } from 'lucide-react';
import { useState, useEffect, useCallback } from 'react';

import { adminApi } from '../../services/adminApi';
import type { AdminBillingItem, AdminTutorPayoutItem, BillingStatusType, PayoutStatusType } from '../../services/adminApi';
import './AdminBillings.css';

/* ── Helpers ── */
const FMT_VND = (n: number | null | undefined) => {
  if (n == null) return '—';
  return n.toLocaleString('vi-VN') + ' ₫';
};

const FMT_PERIOD = (m: number, y: number) => `T${m}/${y}`;

/* ── Status config ── */
const BILLING_STATUS_CONFIG: Record<BillingStatusType, { label: string; color: string; bg: string; icon: React.ReactNode }> = {
  DRAFT:     { label: 'Bản nháp',    color: '#64748b', bg: '#f1f5f9', icon: <FileText size={13}/> },
  UNPAID:    { label: 'Chưa TT',     color: '#dc2626', bg: '#fef2f2', icon: <AlertTriangle size={13}/> },
  VERIFYING: { label: 'Chờ xác nhận', color: '#d97706', bg: '#fffbeb', icon: <Clock size={13}/> },
  PAID:      { label: 'Đã TT',       color: '#059669', bg: '#ecfdf5', icon: <CheckCircle size={13}/> },
};

const PAYOUT_STATUS_CONFIG: Record<PayoutStatusType, { label: string; color: string; bg: string }> = {
  LOCKED:   { label: 'Đã khóa',  color: '#64748b', bg: '#f1f5f9' },
  PENDING:  { label: 'Chờ chi',   color: '#d97706', bg: '#fffbeb' },
  PAID_OUT: { label: 'Đã chi',    color: '#059669', bg: '#ecfdf5' },
};

/* ── Toast ── */
function Toast({ type, msg }: { type: 'success' | 'error'; msg: string }) {
  return (
    <div className="ab-toast" data-type={type}>
      {type === 'success' ? '✓ ' : '✕ '}{msg}
    </div>
  );
}

/* ── Status Badge ── */
function StatusBadge({ config }: { config: { label: string; color: string; bg: string; icon?: React.ReactNode } }) {
  return (
    <span className="ab-status-badge" style={{ background: config.bg, color: config.color }}>
      {config.icon} {config.label}
    </span>
  );
}

/* ══════════════════════════════════════════════════════════════════════
   Tab 1 — Hóa đơn học phí
   ══════════════════════════════════════════════════════════════════════ */
type BillingFilter = 'ALL' | BillingStatusType;
const BILLING_FILTERS: { key: BillingFilter; label: string }[] = [
  { key: 'ALL',       label: 'Tất cả' },
  { key: 'DRAFT',     label: 'Bản nháp' },
  { key: 'UNPAID',    label: 'Chưa TT' },
  { key: 'VERIFYING', label: 'Chờ xác nhận' },
  { key: 'PAID',      label: 'Đã TT' },
];

function BillingTab({ month, year }: { month: number; year: number }) {
  const [billings, setBillings] = useState<AdminBillingItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<BillingFilter>('ALL');
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);
  const [showTrigger, setShowTrigger] = useState(false);
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
  const [actionLoading, setActionLoading] = useState<string | null>(null);

  const showToastMsg = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 4000);
  };

  const fetchBillings = useCallback(async () => {
    try {
      setLoading(true);
      const res = await adminApi.getBillings(undefined, month, year);
      setBillings(res.data ?? []);
    } catch { showToastMsg('error', 'Không thể tải danh sách hóa đơn'); }
    finally { setLoading(false); }
  }, [month, year]);

  useEffect(() => { fetchBillings(); }, [fetchBillings]);

  const filtered = filter === 'ALL' ? billings : billings.filter(b => b.status === filter);

  const countByStatus = (s: BillingStatusType) => billings.filter(b => b.status === s).length;

  const selectableBillings = filtered.filter(b => b.status === 'UNPAID' || b.status === 'VERIFYING');
  const allSelected = selectableBillings.length > 0 && selectableBillings.every(b => selectedIds.has(b.id));

  const toggleSelectAll = () => {
    if (allSelected) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(selectableBillings.map(b => b.id)));
    }
  };

  const toggleSelectGroup = (group: AdminBillingItem[]) => {
    const selectables = group.filter(b => b.status === 'UNPAID' || b.status === 'VERIFYING').map(b => b.id);
    if (selectables.length === 0) return;
    const next = new Set(selectedIds);
    const allSelectedInGroup = selectables.every(id => next.has(id));
    if (allSelectedInGroup) {
      selectables.forEach(id => next.delete(id));
    } else {
      selectables.forEach(id => next.add(id));
    }
    setSelectedIds(next);
  };

  const handleBulkVerify = async () => {
    if (selectedIds.size === 0) return;
    if (!confirm(`Xác nhận đã thanh toán cho ${selectedIds.size} hóa đơn này?`)) return;
    setActionLoading('verify-bulk');
    try {
      const res = await adminApi.verifyBulk(Array.from(selectedIds));
      showToastMsg('success', res.data);
      setSelectedIds(new Set());
      fetchBillings();
    } catch { showToastMsg('error', 'Xác nhận thất bại'); }
    finally { setActionLoading(null); }
  };

  // Actions
  const handleApprove = async (id: string) => {
    setActionLoading(id);
    try {
      const res = await adminApi.approveBilling(id);
      showToastMsg('success', res.data);
      fetchBillings();
    } catch { showToastMsg('error', 'Duyệt thất bại'); }
    finally { setActionLoading(null); }
  };

  const handleDelete = async (id: string) => {
    if (!confirm('Xóa hóa đơn nháp này?')) return;
    setActionLoading(id);
    try {
      await adminApi.deleteDraftBilling(id);
      showToastMsg('success', 'Đã xóa hóa đơn nháp');
      fetchBillings();
    } catch { showToastMsg('error', 'Xóa thất bại'); }
    finally { setActionLoading(null); }
  };

  // Approve all drafts for a given period
  const drafts = billings.filter(b => b.status === 'DRAFT');
  const draftPeriods = [...new Set(drafts.map(d => `${d.month}/${d.year}`))];

  const handleApproveAll = async (month: number, year: number) => {
    setActionLoading('approve-all');
    try {
      const res = await adminApi.approveAllDraftBillings(month, year);
      showToastMsg('success', res.data);
      fetchBillings();
    } catch { showToastMsg('error', 'Duyệt hàng loạt thất bại'); }
    finally { setActionLoading(null); }
  };

  return (
    <div className="ab-tab-content">
      {toast && <Toast {...toast} />}

      {/* Stats */}
      <div className="ab-stats-bar">
        {(['DRAFT', 'UNPAID', 'VERIFYING', 'PAID'] as BillingStatusType[]).map(s => {
          const cfg = BILLING_STATUS_CONFIG[s];
          return (
            <button key={s} className={`ab-stat-chip${filter === s ? ' ab-stat-chip--active' : ''}`}
              style={{ '--chip-color': cfg.color, '--chip-bg': cfg.bg } as React.CSSProperties}
              onClick={() => { setFilter(filter === s ? 'ALL' : s); setSelectedIds(new Set()); }}
            >
              {cfg.icon} {cfg.label}: <strong>{countByStatus(s)}</strong>
            </button>
          );
        })}
      </div>

      {/* Actions bar */}
      <div className="ab-actions-bar">
        <div className="ab-filter-tabs">
          {BILLING_FILTERS.map(f => (
            <button key={f.key} className={`ab-filter-tab${filter === f.key ? ' ab-filter-tab--active' : ''}`}
              onClick={() => { setFilter(f.key); setSelectedIds(new Set()); }}>
              {f.label} {f.key !== 'ALL' && <span className="ab-filter-count">{countByStatus(f.key as BillingStatusType)}</span>}
            </button>
          ))}
        </div>
        <div className="ab-header-actions">
          {draftPeriods.length > 0 && (
            <button className="ab-btn ab-btn--approve" onClick={() => {
              const [m, y] = draftPeriods[0].split('/').map(Number);
              handleApproveAll(m, y);
            }} disabled={actionLoading === 'approve-all'}>
              <ChevronsRight size={15}/> Duyệt tất cả nháp kỳ {draftPeriods[0]}
            </button>
          )}
          {selectedIds.size > 0 && (
            <button className="ab-btn ab-btn--secondary" onClick={handleBulkVerify} disabled={actionLoading === 'verify-bulk'}>
              <CheckCircle size={15}/> Xác nhận đã thu ({selectedIds.size})
            </button>
          )}
          <button className="ab-btn ab-btn--primary" onClick={() => setShowTrigger(true)}>
            <CalendarDays size={15}/> Chốt sổ tháng
          </button>
        </div>
      </div>

      {/* Table */}
      {loading ? (
        <div className="ab-loading">Đang tải...</div>
      ) : filtered.length === 0 ? (
        <div className="ab-empty"><Receipt size={40} strokeWidth={1.5}/><p>Không có hóa đơn nào</p></div>
      ) : (
        <div className="ab-table-wrap">
          <table className="ab-table">
            <thead>
              <tr>
                <th style={{ width: 40, textAlign: 'center' }}>
                  <input type="checkbox" className="ab-checkbox" 
                    checked={allSelected} 
                    onChange={toggleSelectAll} 
                    disabled={selectableBillings.length === 0} />
                </th>
                <th>Mã giao dịch</th>
                <th>Lớp</th>
                <th>Người đóng</th>
                <th>Kỳ</th>
                <th>Số buổi</th>
                <th>Học phí</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
              </tr>
            </thead>
            <tbody>
              {(() => {
                const groupedBillings: AdminBillingItem[][] = [];
                const map = new Map<string, AdminBillingItem[]>();
                filtered.forEach(b => {
                  const key = b.transactionCode || b.id;
                  if (!map.has(key)) {
                    map.set(key, []);
                    groupedBillings.push(map.get(key)!);
                  }
                  map.get(key)!.push(b);
                });

                return groupedBillings.flatMap(group => {
                  const selectables = group.filter(b => b.status === 'UNPAID' || b.status === 'VERIFYING');
                  const isGroupSelected = selectables.length > 0 && selectables.every(b => selectedIds.has(b.id));

                  return group.map((b, idx) => (
                    <tr key={b.id} className={isGroupSelected ? 'ab-row-selected' : ''}>
                      {idx === 0 && (
                        <td rowSpan={group.length} style={{ textAlign: 'center', verticalAlign: 'middle', borderRight: '1px solid var(--color-border)' }}>
                          <input type="checkbox" className="ab-checkbox"
                            checked={isGroupSelected}
                            onChange={() => toggleSelectGroup(group)}
                            disabled={selectables.length === 0} />
                        </td>
                      )}
                      {idx === 0 && (
                        <td rowSpan={group.length} style={{ verticalAlign: 'middle', borderRight: '1px solid var(--color-border)' }}>
                          <code className="ab-tx-code">{b.transactionCode || '—'}</code>
                        </td>
                      )}
                      <td>
                        <div className="ab-cell-class">
                          <span className="ab-class-title">{b.classTitle}</span>
                          <span className="ab-class-code">{b.classCode}</span>
                        </div>
                      </td>
                      <td>{b.parentName ?? '—'}</td>
                      <td>{FMT_PERIOD(b.month, b.year)}</td>
                      <td className="ab-center">{b.totalSessions}</td>
                      <td className="ab-amount">{FMT_VND(b.parentFeeAmount)}</td>
                      <td><StatusBadge config={BILLING_STATUS_CONFIG[b.status]}/></td>
                      <td>
                        <div className="ab-row-actions">
                          {b.status === 'DRAFT' && (
                            <>
                              <button className="ab-action-btn ab-action-btn--approve"
                                onClick={() => handleApprove(b.id)} disabled={actionLoading === b.id}>
                                <CheckCircle size={14}/> Duyệt
                              </button>
                              <button className="ab-action-btn ab-action-btn--delete"
                                onClick={() => handleDelete(b.id)} disabled={actionLoading === b.id}>
                                <Trash2 size={14}/>
                              </button>
                            </>
                          )}
                          {b.status === 'PAID' && b.verifiedAt && (
                            <span className="ab-verified-info">✓ {new Date(b.verifiedAt).toLocaleDateString('vi-VN')}</span>
                          )}
                        </div>
                      </td>
                    </tr>
                  ));
                });
              })()}
            </tbody>
          </table>
        </div>
      )}

      {/* Modals */}
      {showTrigger && <TriggerModal month={month} year={year} onClose={() => setShowTrigger(false)} onSuccess={(msg) => { showToastMsg('success', msg); fetchBillings(); }} />}
    </div>
  );
}

/* ── Trigger Modal ── */
function TriggerModal({ month, year, onClose, onSuccess }: { month: number; year: number; onClose: () => void; onSuccess: (msg: string) => void }) {
  const [busy, setBusy] = useState(false);

  const handleSubmit = async () => {
    setBusy(true);
    try {
      const res = await adminApi.triggerBilling(month, year);
      onSuccess(res.data);
      onClose();
    } catch { alert('Chốt sổ thất bại'); }
    finally { setBusy(false); }
  };

  return (
    <div className="ab-modal-overlay" onClick={onClose}>
      <div className="ab-modal" onClick={e => e.stopPropagation()}>
        <h3 className="ab-modal__title"><CalendarDays size={20}/> Chốt sổ tháng {month}/{year}</h3>
        <p className="ab-modal__desc">Hệ thống sẽ tạo hóa đơn nháp cho tất cả các lớp có buổi học hoàn thành trong tháng {month}/{year}. Bạn có chắc chắn muốn tiếp tục?</p>
        <div className="ab-modal__actions" style={{ marginTop: 24 }}>
          <button className="ab-btn ab-btn--primary" onClick={handleSubmit} disabled={busy}>
            {busy ? 'Đang xử lý...' : 'Xác nhận chốt sổ'}
          </button>
          <button className="ab-btn ab-btn--ghost" onClick={onClose}>Hủy</button>
        </div>
      </div>
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════
   Tab 2 — Chi lương gia sư
   ══════════════════════════════════════════════════════════════════════ */
type PayoutFilter = 'ALL' | PayoutStatusType;
const PAYOUT_FILTERS: { key: PayoutFilter; label: string }[] = [
  { key: 'ALL',      label: 'Tất cả' },
  { key: 'LOCKED',   label: 'Đã khóa' },
  { key: 'PENDING',  label: 'Chờ chi' },
  { key: 'PAID_OUT', label: 'Đã chi' },
];

function PayoutTab({ month, year }: { month: number; year: number }) {
  const [payouts, setPayouts] = useState<AdminTutorPayoutItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState<PayoutFilter>('ALL');
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);
  const [markPaidTarget, setMarkPaidTarget] = useState<AdminTutorPayoutItem | null>(null);

  const showToastMsg = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 4000);
  };

  const fetchPayouts = useCallback(async () => {
    try {
      setLoading(true);
      const res = await adminApi.getTutorPayouts(undefined, month, year);
      setPayouts(res.data ?? []);
    } catch { showToastMsg('error', 'Không thể tải danh sách chi lương'); }
    finally { setLoading(false); }
  }, [month, year]);

  useEffect(() => { fetchPayouts(); }, [fetchPayouts]);

  const filtered = filter === 'ALL' ? payouts : payouts.filter(p => p.status === filter);
  const countByStatus = (s: PayoutStatusType) => payouts.filter(p => p.status === s).length;

  return (
    <div className="ab-tab-content">
      {toast && <Toast {...toast} />}

      {/* Stats */}
      <div className="ab-stats-bar">
        {(['LOCKED', 'PENDING', 'PAID_OUT'] as PayoutStatusType[]).map(s => {
          const cfg = PAYOUT_STATUS_CONFIG[s];
          return (
            <button key={s} className={`ab-stat-chip${filter === s ? ' ab-stat-chip--active' : ''}`}
              style={{ '--chip-color': cfg.color, '--chip-bg': cfg.bg } as React.CSSProperties}
              onClick={() => setFilter(filter === s ? 'ALL' : s)}
            >
              {cfg.label}: <strong>{countByStatus(s)}</strong>
            </button>
          );
        })}
      </div>

      {/* Filters */}
      <div className="ab-actions-bar">
        <div className="ab-filter-tabs">
          {PAYOUT_FILTERS.map(f => (
            <button key={f.key} className={`ab-filter-tab${filter === f.key ? ' ab-filter-tab--active' : ''}`}
              onClick={() => setFilter(f.key)}>
              {f.label} {f.key !== 'ALL' && <span className="ab-filter-count">{countByStatus(f.key as PayoutStatusType)}</span>}
            </button>
          ))}
        </div>
      </div>

      {/* Table */}
      {loading ? (
        <div className="ab-loading">Đang tải...</div>
      ) : filtered.length === 0 ? (
        <div className="ab-empty"><Wallet size={40} strokeWidth={1.5}/><p>Không có dữ liệu chi lương</p></div>
      ) : (
        <div className="ab-table-wrap">
          <table className="ab-table">
            <thead>
              <tr>
                <th>Mã GD</th>
                <th>Gia sư</th>
                <th>Lớp</th>
                <th>Kỳ</th>
                <th>Số tiền</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map(p => (
                <tr key={p.id}>
                  <td><code className="ab-tx-code">{p.transactionCode}</code></td>
                  <td>
                    <div className="ab-cell-class">
                      <span className="ab-class-title">{p.tutorName}</span>
                      <span className="ab-class-code">{p.tutorPhone}</span>
                    </div>
                  </td>
                  <td>{p.classTitle ?? '—'}</td>
                  <td>{FMT_PERIOD(p.month, p.year)}</td>
                  <td className="ab-amount">{FMT_VND(p.amount)}</td>
                  <td><StatusBadge config={PAYOUT_STATUS_CONFIG[p.status]}/></td>
                  <td>
                    <div className="ab-row-actions">
                      {p.status === 'PENDING' && (
                        <button className="ab-action-btn ab-action-btn--payout"
                          onClick={() => setMarkPaidTarget(p)}>
                          <Banknote size={14}/> Chi lương
                        </button>
                      )}
                      {p.status === 'PAID_OUT' && (
                        <div className="ab-payout-status-info">
                          <span className="ab-verified-info">💸 {p.paidAt ? new Date(p.paidAt).toLocaleDateString('vi-VN') : ''}</span>
                          {p.confirmedByTutorAt ? (
                            <span className="ab-confirmed-badge"><ThumbsUp size={12}/> GS đã xác nhận</span>
                          ) : (
                            <span className="ab-waiting-badge"><Clock size={12}/> Chờ GS xác nhận</span>
                          )}
                        </div>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Mark Paid Modal */}
      {markPaidTarget && (
        <MarkPaidModal
          payout={markPaidTarget}
          onClose={() => setMarkPaidTarget(null)}
          onSuccess={(msg) => { showToastMsg('success', msg); fetchPayouts(); }}
        />
      )}
    </div>
  );
}

/* ── Mark Paid Modal ── */
function MarkPaidModal({ payout, onClose, onSuccess }: {
  payout: AdminTutorPayoutItem;
  onClose: () => void;
  onSuccess: (msg: string) => void;
}) {
  const [note, setNote] = useState('');
  const [busy, setBusy] = useState(false);

  const handleSubmit = async () => {
    setBusy(true);
    try {
      const res = await adminApi.markPayoutPaid(payout.id, note || undefined);
      onSuccess(res.data);
      onClose();
    } catch { alert('Đánh dấu thất bại'); }
    finally { setBusy(false); }
  };

  return (
    <div className="ab-modal-overlay" onClick={onClose}>
      <div className="ab-modal ab-modal--payout" onClick={e => e.stopPropagation()}>
        <h3 className="ab-modal__title"><Banknote size={20}/> Chi Lương Gia Sư</h3>
        <div className="ab-payout-summary">
          <div className="ab-payout-summary__row"><span>Lớp học:</span><strong>{payout.classTitle}</strong></div>
          <div className="ab-payout-summary__row"><span>Gia sư:</span><strong>{payout.tutorName}</strong></div>
          <div className="ab-payout-summary__row"><span>Số tiền chi:</span><strong className="ab-amount">{FMT_VND(payout.amount)}</strong></div>
        </div>

        <div className="ab-payout-bank-card">
          <h4>Thông tin chuyển khoản</h4>
          {payout.tutorBankName ? (
            <div className="ab-bank-card-content">
              <div className="ab-bank-card-row">
                <span className="ab-bank-label">Ngân hàng:</span>
                <span className="ab-bank-val">{payout.tutorBankName}</span>
              </div>
              <div className="ab-bank-card-row">
                <span className="ab-bank-label">Số tài khoản:</span>
                <span className="ab-bank-val ab-bank-acc">
                  {payout.tutorBankAccount}
                  <button className="ab-copy-btn" onClick={() => navigator.clipboard.writeText(payout.tutorBankAccount!)} title="Sao chép">Sao chép</button>
                </span>
              </div>
              <div className="ab-bank-card-row">
                <span className="ab-bank-label">Chủ tài khoản:</span>
                <span className="ab-bank-val">{payout.tutorBankOwner}</span>
              </div>
              <div className="ab-bank-card-row">
                <span className="ab-bank-label">Nội dung CK:</span>
                <span className="ab-bank-val ab-bank-acc">
                  Thanh toan luong {payout.transactionCode}
                  <button className="ab-copy-btn" onClick={() => navigator.clipboard.writeText(`Thanh toan luong ${payout.transactionCode}`)} title="Sao chép">Sao chép</button>
                </span>
              </div>
            </div>
          ) : (
            <p className="ab-muted">Gia sư chưa cập nhật thông tin tài khoản ngân hàng.</p>
          )}
        </div>

        <div className="ab-modal__fields">
          <label>
            Ghi chú bộ phận kế toán (tùy chọn)
            <textarea value={note} onChange={e => setNote(e.target.value)} rows={2} placeholder="Nhập ghi chú hoặc mã giao dịch ngân hàng..."/>
          </label>
        </div>
        <div className="ab-modal__actions">
          <button className="ab-btn ab-btn--primary" onClick={handleSubmit} disabled={busy}>
            {busy ? 'Đang xử lý...' : '💸 Đã chuyển khoản thành công'}
          </button>
          <button className="ab-btn ab-btn--ghost" onClick={onClose}>Hủy</button>
        </div>
      </div>
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════
   Main Page
   ══════════════════════════════════════════════════════════════════════ */
type MainTab = 'billings' | 'payouts';

export function AdminBillings() {
  const [activeTab, setActiveTab] = useState<MainTab>('billings');
  const d = new Date();
  const defaultMonth = d.getMonth() === 0 ? 12 : d.getMonth();
  const defaultYear = d.getMonth() === 0 ? d.getFullYear() - 1 : d.getFullYear();
  const [selectedMonth, setSelectedMonth] = useState<number>(defaultMonth);
  const [selectedYear, setSelectedYear] = useState<number>(defaultYear);

  const monthString = `${selectedYear}-${selectedMonth.toString().padStart(2, '0')}`;
  const handleMonthChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.value) return;
    const [y, m] = e.target.value.split('-');
    setSelectedYear(parseInt(y, 10));
    setSelectedMonth(parseInt(m, 10));
  };

  return (
    <div className="admin-billings">
      {/* Header */}
      <div className="ab-header">
        <div>
          <h1 className="ab-page-title">Quản lý Thanh toán & Chi lương</h1>
          <p className="ab-page-subtitle">Hóa đơn học phí · Chi lương gia sư · Đối soát doanh thu</p>
        </div>
        <div className="ab-header-controls">
          <div className="ab-period-picker">
            <span className="ab-period-label"><CalendarDays size={16}/> Kỳ đối soát:</span>
            <input type="month" className="ab-period-input" value={monthString} onChange={handleMonthChange} />
          </div>
        </div>
      </div>
      <div className="ab-main-tabs">
        <button className={`ab-main-tab${activeTab === 'billings' ? ' ab-main-tab--active' : ''}`}
          onClick={() => setActiveTab('billings')}>
          <CircleDollarSign size={16}/> Hóa đơn học phí
        </button>
        <button className={`ab-main-tab${activeTab === 'payouts' ? ' ab-main-tab--active' : ''}`}
          onClick={() => setActiveTab('payouts')}>
          <Send size={16}/> Chi lương gia sư
        </button>
      </div>

      {/* Tab content */}
      {activeTab === 'billings' ? <BillingTab month={selectedMonth} year={selectedYear} /> : <PayoutTab month={selectedMonth} year={selectedYear} />}
    </div>
  );
}
