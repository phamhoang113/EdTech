import { useState, useEffect, useMemo } from 'react';
import {
  GraduationCap, Phone, MapPin, Trash2, Search,
  CheckCircle, XCircle, Clock, AlertTriangle, X, BookOpen,
  DollarSign, ChevronRight, User, FileText, Calendar,
} from 'lucide-react';
import { adminApi } from '../../services/adminApi';
import type { AdminTutorListItem, AdminTutorVerificationResponse } from '../../services/adminApi';
import './AdminTutors.css';

/* ─── Helpers ───────────────────────────────────────────────────────────── */
function formatVnd(amount: number | undefined | null): string {
  if (amount == null) return '—';
  return amount.toLocaleString('vi-VN') + 'đ';
}

/* ─── Status badge utils ────────────────────────────────────────────────── */
function VerificationBadge({ status }: { status: AdminTutorListItem['verificationStatus'] }) {
  const map = {
    APPROVED:   { label: 'Đã duyệt',      cls: 'badge-approved',   icon: <CheckCircle size={11} /> },
    PENDING:    { label: 'Chờ duyệt',     cls: 'badge-pending',    icon: <Clock size={11} /> },
    REJECTED:   { label: 'Từ chối',       cls: 'badge-rejected',   icon: <XCircle size={11} /> },
    UNVERIFIED: { label: 'Chưa xác minh', cls: 'badge-unverified', icon: <AlertTriangle size={11} /> },
  };
  const s = map[status];
  return <span className={`at-badge ${s.cls}`}>{s.icon} {s.label}</span>;
}

/* ─── Delete Confirm Modal ──────────────────────────────────────────────── */
function DeleteModal({
  tutor,
  onConfirm,
  onCancel,
}: {
  tutor: AdminTutorListItem;
  onConfirm: () => Promise<void>;
  onCancel: () => void;
}) {
  const [submitting, setSubmitting] = useState(false);

  const handleConfirm = async () => {
    setSubmitting(true);
    await onConfirm();
    setSubmitting(false);
  };

  return (
    <div className="at-modal-overlay" onClick={onCancel}>
      <div className="at-modal" onClick={e => e.stopPropagation()}>
        <div className="at-modal-header">
          <AlertTriangle size={18} className="at-modal-warn-icon" />
          <span>Xác nhận xóa gia sư</span>
          <button className="at-modal-close" onClick={onCancel}><X size={16} /></button>
        </div>
        <div className="at-modal-body">
          <p className="at-modal-name">{tutor.fullName}</p>
          <p className="at-modal-phone"><Phone size={12} /> {tutor.phone}</p>
          <div className="at-modal-warning">
            <p>Hành động này sẽ:</p>
            <ul>
              <li>Vô hiệu hóa tài khoản gia sư (mất đăng nhập)</li>
              <li>Trả lại <strong>{tutor.activeClassCount} lớp</strong> đang phụ trách về trạng thái chờ duyệt</li>
              <li>Từ chối tất cả đơn đang chờ của gia sư</li>
              <li>Dữ liệu gia sư vẫn được lưu với trạng thái "Đã xóa"</li>
            </ul>
          </div>
        </div>
        <div className="at-modal-footer">
          <button className="at-btn at-btn-ghost" onClick={onCancel}>Huỷ</button>
          <button className="at-btn at-btn-danger" onClick={handleConfirm} disabled={submitting}>
            <Trash2 size={14} /> {submitting ? 'Đang xóa...' : 'Xác nhận xóa'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ─── Detail Drawer ─────────────────────────────────────────────────────── */
function TutorDetailDrawer({
  tutor,
  detail,
  onClose,
  onDelete,
}: {
  tutor: AdminTutorListItem;
  detail: AdminTutorVerificationResponse | null;
  onClose: () => void;
  onDelete: (t: AdminTutorListItem) => void;
}) {
  return (
    <div className="at-drawer-overlay" onClick={onClose}>
      <aside className="at-drawer" onClick={e => e.stopPropagation()}>
        {/* Header */}
        <div className="at-drawer-header">
          <div className="at-drawer-avatar">{tutor.fullName.trim().split(' ').pop()?.charAt(0).toUpperCase()}</div>
          <div className="at-drawer-title">
            <h2>{tutor.fullName}</h2>
            <div className="at-drawer-badges">
              <VerificationBadge status={tutor.verificationStatus} />
              {tutor.isDeleted && <span className="at-badge at-badge-deleted"><Trash2 size={10}/> Đã xóa</span>}
            </div>
          </div>
          <button className="at-modal-close" onClick={onClose}><X size={18} /></button>
        </div>

        <div className="at-drawer-body">
          {/* Basic info */}
          <section className="at-drawer-section">
            <h3><User size={14}/> Thông tin cơ bản</h3>
            <div className="at-drawer-grid">
              <div className="at-drawer-field"><span>SĐT</span><strong>{tutor.phone}</strong></div>
              <div className="at-drawer-field"><span>Loại GS</span><strong>{tutor.tutorType ?? '—'}</strong></div>
              <div className="at-drawer-field"><span>Khu vực</span><strong>{tutor.location ?? '—'}</strong></div>
              <div className="at-drawer-field"><span>Đang dạy</span><strong>{tutor.activeClassCount} lớp</strong></div>
              <div className="at-drawer-field">
                <span>Thu nhập/tháng</span>
                <strong className="at-green at-big">{formatVnd(tutor.estimatedMonthlyEarnings)}</strong>
              </div>
            </div>
          </section>

          {/* Subjects */}
          {tutor.subjects && tutor.subjects.length > 0 && (
            <section className="at-drawer-section">
              <h3><BookOpen size={14}/> Môn dạy</h3>
              <div className="at-card-subjects">
                {tutor.subjects.map(s => <span key={s} className="at-subject-tag">{s}</span>)}
              </div>
            </section>
          )}

          {/* Verification detail */}
          {detail && (
            <>
              <section className="at-drawer-section">
                <h3><FileText size={14}/> Hồ sơ xác minh</h3>
                <div className="at-drawer-grid">
                  <div className="at-drawer-field"><span>Ngày sinh</span><strong>{detail.dob}</strong></div>
                  <div className="at-drawer-field"><span>CCCD</span><strong>{detail.idCardNumber ?? '—'}</strong></div>
                  <div className="at-drawer-field"><span>Trình độ</span><strong>{detail.degree}</strong></div>
                  <div className="at-drawer-field"><span>Cơ sở đào tạo</span><strong>{detail.university}</strong></div>
                  <div className="at-drawer-field"><span>Kinh nghiệm</span><strong>{detail.experience}</strong></div>
                  <div className="at-drawer-field"><span>Cấp dạy</span><strong>{detail.levels}</strong></div>
                </div>
              </section>

            </>
          )}

          {/* Registration date */}
          <section className="at-drawer-section">
            <h3><Calendar size={14}/> Ngày đăng ký</h3>
            <p className="at-drawer-date">{tutor.createdAt ? new Date(tutor.createdAt).toLocaleDateString('vi-VN') : '—'}</p>
          </section>
        </div>

        {/* Footer actions */}
        {!tutor.isDeleted && (
          <div className="at-drawer-footer">
            <button
              className="at-btn at-btn-danger"
              onClick={() => { onClose(); onDelete(tutor); }}
            >
              <Trash2 size={14} /> Xóa gia sư
            </button>
          </div>
        )}
      </aside>
    </div>
  );
}

/* ─── Tutor Card ────────────────────────────────────────────────────────── */
function TutorCard({
  tutor,
  onDelete,
  onClick,
}: {
  tutor: AdminTutorListItem;
  onDelete: (t: AdminTutorListItem) => void;
  onClick: (t: AdminTutorListItem) => void;
}) {
  const initial = tutor.fullName.trim().split(' ').pop()?.charAt(0).toUpperCase() ?? '?';

  return (
    <div
      className={`at-card ${tutor.isDeleted ? 'at-card--deleted' : ''}`}
      onClick={() => onClick(tutor)}
      role="button"
      tabIndex={0}
      onKeyDown={e => e.key === 'Enter' && onClick(tutor)}
    >
      <div className="at-card-main">
        <div className={`at-avatar ${tutor.isDeleted ? 'at-avatar--deleted' : ''}`}>{initial}</div>
        <div className="at-card-info">
          <div className="at-card-name-row">
            <span className="at-card-name">{tutor.fullName}</span>
            {tutor.isDeleted && <span className="at-badge at-badge-deleted"><Trash2 size={10} /> Đã xóa</span>}
          </div>
          <div className="at-card-meta">
            <span><Phone size={12} />{tutor.phone}</span>
            {tutor.location && <span><MapPin size={12} />{tutor.location}</span>}
            {tutor.tutorType && <span><GraduationCap size={12} />{tutor.tutorType}</span>}
            {tutor.activeClassCount > 0 && (
              <span className="stat-active"><BookOpen size={12} />{tutor.activeClassCount} lớp đang dạy</span>
            )}
            {tutor.estimatedMonthlyEarnings != null && tutor.estimatedMonthlyEarnings > 0 && (
              <span className="stat-monthly"><DollarSign size={12} />{formatVnd(tutor.estimatedMonthlyEarnings)}/tháng</span>
            )}
          </div>
          {tutor.subjects && tutor.subjects.length > 0 && (
            <div className="at-card-subjects">
              {tutor.subjects.map(s => <span key={s} className="at-subject-tag">{s}</span>)}
            </div>
          )}
        </div>
        <div className="at-card-right">
          <VerificationBadge status={tutor.verificationStatus} />
          <div className="at-card-actions" onClick={e => e.stopPropagation()}>
            {!tutor.isDeleted && (
              <button className="at-btn at-btn-icon-danger" title="Xóa gia sư" onClick={() => onDelete(tutor)}>
                <Trash2 size={15} />
              </button>
            )}
          </div>
          <ChevronRight size={16} className="at-chevron" />
        </div>
      </div>
    </div>
  );
}

/* ─── Toast ─────────────────────────────────────────────────────────────── */
type ToastType = 'success' | 'error';
function useToast() {
  const [toast, setToast] = useState<{ type: ToastType; msg: string } | null>(null);
  const show = (type: ToastType, msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3500);
  };
  return { toast, show };
}

/* ─── Main Page ─────────────────────────────────────────────────────────── */
type FilterKey = 'all' | 'active' | 'deleted';

export function AdminTutors() {
  const [tutors, setTutors] = useState<AdminTutorListItem[]>([]);
  const [verifications, setVerifications] = useState<AdminTutorVerificationResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState<FilterKey>('all');
  const [pendingDelete, setPendingDelete] = useState<AdminTutorListItem | null>(null);
  const [selectedTutor, setSelectedTutor] = useState<AdminTutorListItem | null>(null);
  const { toast, show: showToast } = useToast();

  const fetchData = async () => {
    setLoading(true);
    try {
      const [tutorRes, verRes] = await Promise.all([
        adminApi.getAllTutors(),
        adminApi.getTutorVerifications(),
      ]);
      setTutors(tutorRes.data ?? []);
      setVerifications(verRes.data ?? []);
    } catch {
      showToast('error', 'Không thể tải danh sách gia sư');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchData(); }, []);

  const handleDelete = async () => {
    if (!pendingDelete) return;
    try {
      await adminApi.deleteTutor(pendingDelete.userId);
      showToast('success', `Đã xóa gia sư ${pendingDelete.fullName}`);
      setPendingDelete(null);
      setSelectedTutor(null);
      await fetchData();
    } catch (err: any) {
      showToast('error', err?.response?.data?.message ?? 'Xóa thất bại');
      setPendingDelete(null);
    }
  };

  const getVerificationDetail = (userId: string): AdminTutorVerificationResponse | null =>
    verifications.find(v => v.id === userId) ?? null;

  const FILTERS: { key: FilterKey; label: string }[] = [
    { key: 'all',     label: 'Tất cả' },
    { key: 'active',  label: 'Đang hoạt động' },
    { key: 'deleted', label: 'Đã xóa' },
  ];

  const displayed = useMemo(() => {
    let list = tutors;
    if (filter === 'active')  list = list.filter(t => !t.isDeleted);
    if (filter === 'deleted') list = list.filter(t => t.isDeleted);
    if (search.trim()) {
      const q = search.trim().toLowerCase();
      list = list.filter(t =>
        t.fullName.toLowerCase().includes(q) ||
        t.phone.includes(q) ||
        (t.tutorType ?? '').toLowerCase().includes(q) ||
        (t.subjects ?? []).some(s => s.toLowerCase().includes(q))
      );
    }
    return list;
  }, [tutors, filter, search]);

  const stats = useMemo(() => {
    const activeTutors = tutors.filter(t => !t.isDeleted);
    const totalPlatformFee = activeTutors.reduce((sum, t) => sum + (t.platformFeePerMonth ?? 0), 0);
    return {
      total: tutors.length,
      active: activeTutors.length,
      deleted: tutors.filter(t => t.isDeleted).length,
      approved: activeTutors.filter(t => t.verificationStatus === 'APPROVED').length,
      totalPlatformFee,
    };
  }, [tutors]);

  return (
    <div className="at-page">
      {toast && <div className={`at-toast at-toast-${toast.type}`}>{toast.msg}</div>}

      {pendingDelete && (
        <DeleteModal
          tutor={pendingDelete}
          onConfirm={handleDelete}
          onCancel={() => setPendingDelete(null)}
        />
      )}

      {selectedTutor && (
        <TutorDetailDrawer
          tutor={selectedTutor}
          detail={getVerificationDetail(selectedTutor.userId)}
          onClose={() => setSelectedTutor(null)}
          onDelete={t => { setSelectedTutor(null); setPendingDelete(t); }}
        />
      )}

      {/* Header */}
      <div className="at-header">
        <div>
          <h1 className="at-title">Quản lý Gia sư</h1>
          <p className="at-subtitle">Xem và quản lý tất cả gia sư trong hệ thống</p>
        </div>
      </div>

      {/* Stats */}
      <div className="at-stats">
        <div className="at-stat-card">
          <span className="at-stat-num">{stats.total}</span>
          <span className="at-stat-lbl">Tổng gia sư</span>
        </div>
        <div className="at-stat-card">
          <span className="at-stat-num at-stat-green">{stats.active}</span>
          <span className="at-stat-lbl">Đang hoạt động</span>
        </div>
        <div className="at-stat-card">
          <span className="at-stat-num at-stat-indigo">{stats.approved}</span>
          <span className="at-stat-lbl">Đã xác minh</span>
        </div>
        <div className="at-stat-card at-stat-card--highlight">
          <span className="at-stat-num at-stat-green">
            {stats.totalPlatformFee.toLocaleString('vi-VN')}đ
          </span>
          <span className="at-stat-lbl">Phí nền tảng/tháng (est.)</span>
        </div>
      </div>

      {/* Toolbar */}
      <div className="at-toolbar">
        <div className="at-search-box">
          <Search size={15} />
          <input
            placeholder="Tìm theo tên, SĐT, môn học..."
            value={search}
            onChange={e => setSearch(e.target.value)}
          />
        </div>
        <div className="at-filters">
          {FILTERS.map(f => (
            <button
              key={f.key}
              className={`at-filter-btn ${filter === f.key ? 'active' : ''}`}
              onClick={() => setFilter(f.key)}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      {/* List */}
      {loading ? (
        <div className="at-empty"><GraduationCap size={36} className="spin" /><span>Đang tải...</span></div>
      ) : displayed.length === 0 ? (
        <div className="at-empty"><GraduationCap size={36} /><span>Không tìm thấy gia sư nào</span></div>
      ) : (
        <div className="at-list">
          {displayed.map(t => (
            <TutorCard
              key={t.userId}
              tutor={t}
              onDelete={setPendingDelete}
              onClick={setSelectedTutor}
            />
          ))}
        </div>
      )}
    </div>
  );
}
