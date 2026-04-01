import { Search, Lock, Unlock, Trash2, ShieldAlert, X, User, Phone, Mail, Calendar, MapPin, BookOpen, Star, Award, Clock, CheckCircle, XCircle, AlertCircle, MessageSquare } from 'lucide-react';
import { useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';

import { adminApi } from '../../services/adminApi';
import type { AdminUserListItem, AdminUserDetail, UserRole } from '../../services/adminApi';
import './AdminUsers.css';

/* ── Constants ── */
const ROLE_LABEL: Record<UserRole, string> = {
  ADMIN: 'Admin',
  TUTOR: 'Gia sư',
  PARENT: 'Phụ huynh',
  STUDENT: 'Học sinh',
};

const VERIFICATION_LABEL: Record<string, { label: string; color: string }> = {
  UNVERIFIED: { label: 'Chưa xác minh', color: '#6b7280' },
  PENDING:    { label: 'Đang chờ duyệt', color: '#f59e0b' },
  APPROVED:   { label: 'Đã duyệt', color: '#10b981' },
  REJECTED:   { label: 'Từ chối', color: '#ef4444' },
};

const ITEMS_PER_PAGE = 15;

function avatarColor(name: string) {
  let h = 0;
  for (let i = 0; i < name.length; i++) h = name.charCodeAt(i) + ((h << 5) - h);
  return `hsl(${Math.abs(h) % 360}, 55%, 48%)`;
}

function initials(name: string) {
  const parts = name.trim().split(' ');
  return parts[parts.length - 1]?.charAt(0)?.toUpperCase() ?? '?';
}

function fmtDate(iso: string | null | undefined) {
  if (!iso) return '—';
  const d = new Date(iso);
  return `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}/${d.getFullYear()}`;
}

/* ── UserDetailDrawer ── */
interface UserDetailDrawerProps {
  userId: string | null;
  onClose: () => void;
  onRefresh: () => void;
}

function UserDetailDrawer({ userId, onClose, onRefresh }: UserDetailDrawerProps) {
  const [detail, setDetail] = useState<AdminUserDetail | null>(null);
  const [loading, setLoading] = useState(false);
  const [confirm, setConfirm] = useState<'delete' | null>(null);
  const [busy, setBusy] = useState(false);
  const [toast, setToast] = useState<string | null>(null);

  function showToast(msg: string) {
    setToast(msg);
    setTimeout(() => setToast(null), 2500);
  }

  useEffect(() => {
    if (!userId) { setDetail(null); return; }
    setLoading(true);
    setDetail(null);
    adminApi.getUserDetail(userId)
      .then(res => setDetail(res.data))
      .catch(() => showToast('Không thể tải thông tin người dùng'))
      .finally(() => setLoading(false));
  }, [userId]);

  if (!userId) return null;

  const handleLock = async () => {
    if (!detail) return;
    setBusy(true);
    try {
      if (detail.isActive) await adminApi.lockUser(detail.id);
      else await adminApi.unlockUser(detail.id);
      showToast(detail.isActive ? 'Đã khóa tài khoản' : 'Đã mở khóa tài khoản');
      setDetail({ ...detail, isActive: !detail.isActive });
      onRefresh();
    } catch { showToast('Thao tác thất bại'); }
    finally { setBusy(false); }
  };

  const handleDelete = async () => {
    if (!detail) return;
    setBusy(true);
    try {
      await adminApi.deleteUser(detail.id);
      showToast('Đã xóa người dùng');
      onRefresh();
      onClose();
    } catch { showToast('Không thể xóa người dùng'); }
    finally { setBusy(false); setConfirm(null); }
  };

  const vStatus = detail?.verificationStatus ? VERIFICATION_LABEL[detail.verificationStatus] : null;

  return (
    <>
      {/* Backdrop */}
      <div
        style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.35)', zIndex: 1000 }}
        onClick={onClose}
      />

      {/* Drawer */}
      <div style={{
        position: 'fixed', top: 0, right: 0, bottom: 0,
        width: 420, maxWidth: '100vw',
        background: 'var(--color-surface, #fff)',
        boxShadow: '-4px 0 30px rgba(0,0,0,0.15)',
        zIndex: 1001, display: 'flex', flexDirection: 'column',
        overflowY: 'auto',
      }}>
        {/* Header */}
        <div style={{
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          padding: '20px 24px 16px', borderBottom: '1px solid var(--color-border, #e5e7eb)',
        }}>
          <h2 style={{ margin: 0, fontSize: '1.1rem', fontWeight: 700, color: 'var(--color-text)' }}>
            Chi tiết người dùng
          </h2>
          <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--color-text-muted)', padding: 4 }}>
            <X size={20}/>
          </button>
        </div>

        {/* Toast */}
        {toast && (
          <div style={{
            margin: '12px 24px 0', padding: '8px 14px', borderRadius: 8,
            background: '#ecfdf5', color: '#065f46', fontSize: '0.82rem', fontWeight: 600,
            border: '1px solid rgba(5,150,105,0.2)',
          }}>{toast}</div>
        )}

        {/* Body */}
        {loading ? (
          <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--color-text-muted)' }}>
            Đang tải...
          </div>
        ) : detail ? (
          <div style={{ flex: 1, padding: '20px 24px', display: 'flex', flexDirection: 'column', gap: 20 }}>

            {/* Avatar + name */}
            <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
              <div style={{
                width: 60, height: 60, borderRadius: '50%', flexShrink: 0,
                background: avatarColor(detail.fullName), display: 'flex',
                alignItems: 'center', justifyContent: 'center',
                fontSize: '1.5rem', fontWeight: 700, color: '#fff',
              }}>
                {initials(detail.fullName)}
              </div>
              <div>
                <div style={{ fontWeight: 700, fontSize: '1.05rem', color: 'var(--color-text)' }}>{detail.fullName}</div>
                <div style={{ marginTop: 4, display: 'flex', gap: 8, flexWrap: 'wrap' }}>
                  <span className={`admin-role-badge admin-role-badge--${detail.role.toLowerCase()}`}>
                    {ROLE_LABEL[detail.role]}
                  </span>
                  <span style={{
                    display: 'flex', alignItems: 'center', gap: 4,
                    fontSize: '0.78rem', fontWeight: 600,
                    color: detail.isActive ? '#10b981' : '#ef4444',
                  }}>
                    {detail.isActive ? <CheckCircle size={13}/> : <XCircle size={13}/>}
                    {detail.isActive ? 'Hoạt động' : 'Bị khóa'}
                  </span>
                </div>
              </div>
            </div>

            {/* Basic info */}
            <section>
              <div style={{ fontSize: '0.75rem', fontWeight: 700, letterSpacing: '0.05em', textTransform: 'uppercase', color: 'var(--color-text-muted)', marginBottom: 10 }}>
                Thông tin cơ bản
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                {[
                  { icon: <Phone size={15}/>, label: 'Điện thoại', value: detail.phone },
                  { icon: <Mail size={15}/>, label: 'Email', value: detail.email ?? '—' },
                  { icon: <Calendar size={15}/>, label: 'Ngày tạo', value: fmtDate(detail.createdAt) },
                  { icon: <User size={15}/>, label: 'ID hệ thống', value: detail.id, small: true },
                ].map(r => (
                  <div key={r.label} style={{ display: 'flex', gap: 10, alignItems: 'flex-start' }}>
                    <span style={{ color: 'var(--color-primary, #6366f1)', marginTop: 1, flexShrink: 0 }}>{r.icon}</span>
                    <div style={{ flex: 1 }}>
                      <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', marginBottom: 1 }}>{r.label}</div>
                      <div style={{ fontSize: r.small ? '0.72rem' : '0.88rem', fontWeight: 500, color: 'var(--color-text)', wordBreak: 'break-all' }}>{r.value}</div>
                    </div>
                  </div>
                ))}
              </div>
            </section>

            {/* Tutor profile */}
            {detail.role === 'TUTOR' && (
              <section>
                <div style={{ fontSize: '0.75rem', fontWeight: 700, letterSpacing: '0.05em', textTransform: 'uppercase', color: 'var(--color-text-muted)', marginBottom: 10 }}>
                  Hồ sơ gia sư
                </div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>

                  {/* Verification status */}
                  {vStatus && (
                    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                      <AlertCircle size={15} style={{ color: vStatus.color, flexShrink: 0 }}/>
                      <div>
                        <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>Trạng thái xác minh</div>
                        <div style={{ fontSize: '0.88rem', fontWeight: 600, color: vStatus.color }}>{vStatus.label}</div>
                      </div>
                    </div>
                  )}

                  {detail.tutorType && (
                    <div style={{ display: 'flex', gap: 10 }}>
                      <Award size={15} style={{ color: 'var(--color-primary, #6366f1)', marginTop: 1, flexShrink: 0 }}/>
                      <div>
                        <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>Loại gia sư</div>
                        <div style={{ fontSize: '0.88rem', fontWeight: 500 }}>{detail.tutorType === 'STUDENT' ? 'Sinh viên' : 'Giáo viên'}</div>
                      </div>
                    </div>
                  )}

                  {detail.subjects && detail.subjects.length > 0 && (
                    <div style={{ display: 'flex', gap: 10 }}>
                      <BookOpen size={15} style={{ color: 'var(--color-primary, #6366f1)', marginTop: 1, flexShrink: 0 }}/>
                      <div>
                        <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>Môn dạy</div>
                        <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', marginTop: 4 }}>
                          {detail.subjects.map(s => (
                            <span key={s} style={{ padding: '2px 10px', borderRadius: 20, background: 'rgba(99,102,241,0.1)', color: '#6366f1', fontSize: '0.78rem', fontWeight: 600 }}>{s}</span>
                          ))}
                        </div>
                      </div>
                    </div>
                  )}

                  {detail.teachingLevels && detail.teachingLevels.length > 0 && (
                    <div style={{ display: 'flex', gap: 10 }}>
                      <BookOpen size={15} style={{ color: 'var(--color-primary, #6366f1)', marginTop: 1, flexShrink: 0 }}/>
                      <div>
                        <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>Khối lớp dạy</div>
                        <div style={{ fontSize: '0.88rem' }}>{detail.teachingLevels.join(', ')}</div>
                      </div>
                    </div>
                  )}

                  {detail.location && (
                    <div style={{ display: 'flex', gap: 10 }}>
                      <MapPin size={15} style={{ color: 'var(--color-primary, #6366f1)', marginTop: 1, flexShrink: 0 }}/>
                      <div>
                        <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>Khu vực</div>
                        <div style={{ fontSize: '0.88rem' }}>{detail.location}</div>
                      </div>
                    </div>
                  )}

                  {(detail.rating != null) && (
                    <div style={{ display: 'flex', gap: 10 }}>
                      <Star size={15} style={{ color: '#f59e0b', marginTop: 1, flexShrink: 0 }}/>
                      <div>
                        <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>Đánh giá</div>
                        <div style={{ fontSize: '0.88rem', fontWeight: 600 }}>{detail.rating?.toFixed(1)} ⭐ ({detail.ratingCount} lượt)</div>
                      </div>
                    </div>
                  )}

                  {detail.experienceYears != null && detail.experienceYears > 0 && (
                    <div style={{ display: 'flex', gap: 10 }}>
                      <Clock size={15} style={{ color: 'var(--color-primary, #6366f1)', marginTop: 1, flexShrink: 0 }}/>
                      <div>
                        <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>Kinh nghiệm</div>
                        <div style={{ fontSize: '0.88rem' }}>{detail.experienceYears} năm</div>
                      </div>
                    </div>
                  )}

                  {detail.hourlyRate != null && (
                    <div style={{ display: 'flex', gap: 10 }}>
                      <span style={{ fontSize: 15, color: 'var(--color-primary, #6366f1)', marginTop: 1, flexShrink: 0 }}>₫</span>
                      <div>
                        <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>Lương giờ đề xuất</div>
                        <div style={{ fontSize: '0.88rem', fontWeight: 600 }}>{detail.hourlyRate?.toLocaleString('vi-VN')} ₫/h</div>
                      </div>
                    </div>
                  )}

                  {detail.bio && (
                    <div>
                      <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', marginBottom: 4 }}>Giới thiệu</div>
                      <div style={{ fontSize: '0.82rem', lineHeight: 1.6, color: 'var(--color-text)', background: 'var(--color-bg, #f9fafb)', borderRadius: 8, padding: '10px 12px' }}>{detail.bio}</div>
                    </div>
                  )}

                  {detail.achievements && (
                    <div>
                      <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', marginBottom: 4 }}>Thành tích / Kinh nghiệm</div>
                      <div style={{ fontSize: '0.82rem', lineHeight: 1.6, color: 'var(--color-text)', background: 'var(--color-bg, #f9fafb)', borderRadius: 8, padding: '10px 12px' }}>{detail.achievements}</div>
                    </div>
                  )}
                </div>
              </section>
            )}

            {/* Spacer */}
            <div style={{ flex: 1 }}/>

            {/* Actions */}
            {confirm === 'delete' ? (
              <div style={{ borderRadius: 12, border: '1px solid rgba(239,68,68,0.3)', background: 'rgba(239,68,68,0.05)', padding: '16px' }}>
                <div style={{ fontWeight: 600, marginBottom: 8, color: '#b91c1c', fontSize: '0.9rem' }}>⚠️ Xác nhận xóa người dùng?</div>
                <div style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', marginBottom: 12 }}>Hành động này không thể hoàn tác. Người dùng sẽ bị xóa khỏi hệ thống.</div>
                <div style={{ display: 'flex', gap: 8 }}>
                  <button
                    onClick={handleDelete}
                    disabled={busy}
                    style={{ flex: 1, padding: '8px', borderRadius: 8, background: '#ef4444', color: '#fff', border: 'none', fontWeight: 700, cursor: 'pointer', fontSize: '0.85rem' }}
                  >
                    {busy ? 'Đang xóa...' : 'Xóa người dùng'}
                  </button>
                  <button
                    onClick={() => setConfirm(null)}
                    style={{ flex: 1, padding: '8px', borderRadius: 8, background: 'var(--color-bg, #f3f4f6)', color: 'var(--color-text)', border: 'none', fontWeight: 600, cursor: 'pointer', fontSize: '0.85rem' }}
                  >
                    Hủy
                  </button>
                </div>
              </div>
            ) : (
              <div style={{ display: 'flex', gap: 10 }}>
                <button
                  onClick={handleLock}
                  disabled={busy}
                  style={{
                    flex: 1, padding: '10px', borderRadius: 10, border: 'none', fontWeight: 700,
                    cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
                    background: detail.isActive ? 'rgba(245,158,11,0.12)' : 'rgba(16,185,129,0.12)',
                    color: detail.isActive ? '#d97706' : '#059669', fontSize: '0.88rem',
                  }}
                >
                  {detail.isActive ? <Lock size={15}/> : <Unlock size={15}/>}
                  {detail.isActive ? 'Khóa tài khoản' : 'Mở khóa'}
                </button>
                <button
                  onClick={() => setConfirm('delete')}
                  style={{
                    flex: 1, padding: '10px', borderRadius: 10, border: 'none', fontWeight: 700,
                    cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6,
                    background: 'rgba(239,68,68,0.1)', color: '#dc2626', fontSize: '0.88rem',
                  }}
                >
                  <Trash2 size={15}/> Xóa người dùng
                </button>
              </div>
            )}
          </div>
        ) : (
          <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--color-text-muted)' }}>
            Không tìm thấy thông tin
          </div>
        )}
      </div>
    </>
  );
}

/* ── Main component ── */
export function AdminUsers() {
  const navigate = useNavigate();
  const [users, setUsers] = useState<AdminUserListItem[]>([]);
  const [loading, setLoading] = useState(true);

  const [search, setSearch] = useState('');
  const [roleFilter, setRoleFilter] = useState<UserRole | 'ALL'>('ALL');
  const [statusFilter, setStatusFilter] = useState<'ALL' | 'ACTIVE' | 'LOCKED'>('ALL');
  const [currentPage, setCurrentPage] = useState(1);

  const [selectedUserId, setSelectedUserId] = useState<string | null>(null);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const res = await adminApi.getUsers(roleFilter !== 'ALL' ? roleFilter : undefined);
      setUsers(res.data);
    } catch (e) {
      console.error('Lỗi tải danh sách user:', e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchUsers(); }, [roleFilter]);

  const filtered = useMemo(() => {
    const q = search.toLowerCase();
    return users.filter(u => {
      if (q && !u.fullName.toLowerCase().includes(q) && !(u.email ?? '').toLowerCase().includes(q) && !u.phone.includes(q)) return false;
      if (statusFilter === 'ACTIVE' && !u.isActive) return false;
      if (statusFilter === 'LOCKED' && u.isActive) return false;
      return true;
    });
  }, [users, search, statusFilter]);

  const totalPages = Math.ceil(filtered.length / ITEMS_PER_PAGE);
  const paginated = filtered.slice((currentPage - 1) * ITEMS_PER_PAGE, currentPage * ITEMS_PER_PAGE);

  return (
    <div className="admin-users">
      <UserDetailDrawer
        userId={selectedUserId}
        onClose={() => setSelectedUserId(null)}
        onRefresh={fetchUsers}
      />

      {/* Header */}
      <div className="admin-users__header">
        <h1 className="admin-users__title">Quản lý người dùng</h1>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: '0.82rem', color: 'var(--color-text-muted)' }}>
          <ShieldAlert size={14}/> Tổng {users.length} người dùng
        </div>
      </div>

      {/* Filters */}
      <div className="admin-users__filters">
        <div className="admin-users__search">
          <Search size={16} style={{ color: 'var(--color-text-muted)', flexShrink: 0 }} />
          <input
            placeholder="Tìm theo tên, email, SĐT..."
            value={search}
            onChange={e => { setSearch(e.target.value); setCurrentPage(1); }}
          />
        </div>
        <select className="admin-users__filter-select" value={roleFilter} onChange={e => { setRoleFilter(e.target.value as UserRole | 'ALL'); setCurrentPage(1); }}>
          <option value="ALL">Vai trò: Tất cả</option>
          <option value="ADMIN">Admin</option>
          <option value="TUTOR">Gia sư</option>
          <option value="PARENT">Phụ huynh</option>
          <option value="STUDENT">Học sinh</option>
        </select>
        <select className="admin-users__filter-select" value={statusFilter} onChange={e => { setStatusFilter(e.target.value as 'ALL' | 'ACTIVE' | 'LOCKED'); setCurrentPage(1); }}>
          <option value="ALL">Trạng thái: Tất cả</option>
          <option value="ACTIVE">Hoạt động</option>
          <option value="LOCKED">Khóa</option>
        </select>
      </div>

      {/* Table */}
      <div className="admin-users__table-wrap">
        {loading ? (
          <div style={{ padding: 40, textAlign: 'center', color: 'var(--color-text-muted)' }}>Đang tải...</div>
        ) : paginated.length === 0 ? (
          <div style={{ padding: 40, textAlign: 'center', color: 'var(--color-text-muted)' }}>
            {search || statusFilter !== 'ALL' ? 'Không tìm thấy người dùng phù hợp' : 'Chưa có người dùng nào'}
          </div>
        ) : (
          <table className="admin-users__table">
            <thead>
              <tr>
                <th>Người dùng</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Vai trò</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th>Hành động</th>
              </tr>
            </thead>
            <tbody>
              {paginated.map(u => (
                <tr
                  key={u.id}
                  style={{ cursor: 'pointer' }}
                  onClick={() => setSelectedUserId(u.id)}
                >
                  <td>
                    <div className="admin-users__user-cell">
                      <div className="admin-users__user-avatar" style={{ background: avatarColor(u.fullName) }}>
                        {initials(u.fullName)}
                      </div>
                      {u.fullName}
                    </div>
                  </td>
                  <td>{u.email ?? '—'}</td>
                  <td>{u.phone}</td>
                  <td>
                    <span className={`admin-role-badge admin-role-badge--${u.role.toLowerCase()}`}>
                      {ROLE_LABEL[u.role]}
                    </span>
                  </td>
                  <td>
                    <span className="admin-status">
                      <span className={`admin-status__dot admin-status__dot--${u.isActive ? 'active' : 'locked'}`} />
                      {u.isActive ? 'Hoạt động' : 'Khóa'}
                    </span>
                  </td>
                  <td>{fmtDate(u.createdAt)}</td>
                  <td onClick={e => e.stopPropagation()}>
                    <div className="admin-table__actions">
                      {u.role !== 'ADMIN' && (
                        <button
                          className="admin-users__action-btn admin-users__action-btn--message"
                          title="Gửi tin nhắn"
                          onClick={() => navigate(`/admin/messages?userId=${u.id}`)}
                        >
                          <MessageSquare size={16}/>
                        </button>
                      )}
                      <button
                        className="admin-users__action-btn"
                        title={u.isActive ? 'Khóa tài khoản' : 'Mở khóa'}
                        onClick={async (e) => {
                          e.stopPropagation();
                          try {
                            if (u.isActive) await adminApi.lockUser(u.id);
                            else await adminApi.unlockUser(u.id);
                            fetchUsers();
                          } catch { alert('Thao tác thất bại'); }
                        }}
                      >
                        {u.isActive ? <Lock size={16}/> : <Unlock size={16}/>}
                      </button>
                      <button
                        className="admin-users__action-btn admin-users__action-btn--danger"
                        title="Xóa người dùng"
                        onClick={async (e) => {
                          e.stopPropagation();
                          setSelectedUserId(u.id);
                        }}
                      >
                        <Trash2 size={16}/>
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}

        {totalPages > 1 && (
          <div className="admin-users__pagination">
            <span className="admin-users__pagination-info">
              Hiển thị {(currentPage - 1) * ITEMS_PER_PAGE + 1}–{Math.min(currentPage * ITEMS_PER_PAGE, filtered.length)} / {filtered.length}
            </span>
            <div className="admin-users__pagination-pages">
              {Array.from({ length: totalPages }, (_, i) => i + 1).map(p => (
                <button
                  key={p}
                  className={`admin-users__page-btn ${p === currentPage ? 'active' : ''}`}
                  onClick={() => setCurrentPage(p)}
                >
                  {p}
                </button>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
