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
  const [confirm, setConfirm] = useState<'delete' | 'reset' | null>(null);
  const [busy, setBusy] = useState(false);
  const [toast, setToast] = useState<string | null>(null);
  const [newPassword, setNewPassword] = useState<string | null>(null);

  function showToast(msg: string) {
    setToast(msg);
    setTimeout(() => setToast(null), 2500);
  }

  useEffect(() => {
    if (!userId) { 
      setDetail(null); 
      setNewPassword(null);
      setConfirm(null);
      return; 
    }
    setLoading(true);
    setDetail(null);
    setNewPassword(null);
    setConfirm(null);
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

  const handleResetPassword = async () => {
    if (!detail) return;
    setBusy(true);
    try {
      const res = await adminApi.resetUserPassword(detail.id);
      setNewPassword(res.data.newPassword);
      showToast('Đã tạo mật khẩu mới thành công');
    } catch { showToast('Không thể tạo mật khẩu mới'); }
    finally { setBusy(false); setConfirm(null); }
  };

  const vStatus = detail?.verificationStatus ? VERIFICATION_LABEL[detail.verificationStatus] : null;

  return (
    <>
      <div className="admin-drawer-backdrop" onClick={onClose} />

      <div className="admin-drawer">
        <div className="admin-drawer__header">
          <h2 className="admin-drawer__title">Chi tiết người dùng</h2>
          <button onClick={onClose} className="admin-drawer__close">
            <X size={20}/>
          </button>
        </div>

        {toast && (
          <div className="admin-drawer__toast">
            <CheckCircle size={16} />
            {toast}
          </div>
        )}

        {loading ? (
          <div className="admin-loader">
            <User size={32} />
            <div style={{ fontSize: '0.9rem', fontWeight: 500 }}>Đang tải dữ liệu...</div>
          </div>
        ) : detail ? (
          <div className="admin-drawer__content">
            <div className="admin-drawer__user-header">
              <div className="admin-drawer__avatar" style={{ background: avatarColor(detail.fullName) }}>
                {initials(detail.fullName)}
              </div>
              <div>
                <div className="admin-drawer__name">{detail.fullName}</div>
                <div className="admin-drawer__tags">
                  <span className={`admin-role-badge admin-role-badge--${detail.role.toLowerCase()}`}>
                    {ROLE_LABEL[detail.role]}
                  </span>
                  <span className={`admin-drawer__status admin-drawer__status--${detail.isActive ? 'active' : 'locked'}`}>
                    {detail.isActive ? <CheckCircle size={13}/> : <XCircle size={13}/>}
                    {detail.isActive ? 'Hoạt động' : 'Bị khóa'}
                  </span>
                </div>
              </div>
            </div>

            <section>
              <div className="admin-drawer__section-title">Thông tin cơ bản</div>
              <div className="admin-drawer__info-list">
                {[
                  { icon: <Phone size={15}/>, label: 'Điện thoại', value: detail.phone },
                  { icon: <Mail size={15}/>, label: 'Email', value: detail.email ?? '—' },
                  { icon: <Calendar size={15}/>, label: 'Ngày tạo', value: fmtDate(detail.createdAt) },
                  { icon: <User size={15}/>, label: 'ID hệ thống', value: detail.id },
                ].map(r => (
                  <div key={r.label} className="admin-drawer__info-item">
                    <span className="admin-drawer__info-icon">{r.icon}</span>
                    <div>
                      <div className="admin-drawer__info-label">{r.label}</div>
                      <div className="admin-drawer__info-value">{r.value}</div>
                    </div>
                  </div>
                ))}
              </div>
            </section>

            {detail.role === 'TUTOR' && (
              <section>
                <div className="admin-drawer__section-title">Hồ sơ gia sư</div>
                <div className="admin-drawer__info-list">

                  {vStatus && (
                    <div className="admin-drawer__info-item">
                      <AlertCircle size={15} className="admin-drawer__info-icon" style={{ color: vStatus.color }}/>
                      <div>
                        <div className="admin-drawer__info-label">Trạng thái xác minh</div>
                        <div className="admin-drawer__info-value" style={{ color: vStatus.color }}>{vStatus.label}</div>
                      </div>
                    </div>
                  )}

                  {detail.tutorType && (
                    <div className="admin-drawer__info-item">
                      <Award size={15} className="admin-drawer__info-icon"/>
                      <div>
                        <div className="admin-drawer__info-label">Loại gia sư</div>
                        <div className="admin-drawer__info-value">{detail.tutorType === 'STUDENT' ? 'Sinh viên' : 'Giáo viên'}</div>
                      </div>
                    </div>
                  )}

                  {detail.subjects && detail.subjects.length > 0 && (
                    <div className="admin-drawer__info-item">
                      <BookOpen size={15} className="admin-drawer__info-icon"/>
                      <div>
                        <div className="admin-drawer__info-label">Môn dạy</div>
                        <div className="admin-drawer__info-tags">
                          {detail.subjects.map(s => (
                            <span key={s} className="admin-drawer__info-tag">{s}</span>
                          ))}
                        </div>
                      </div>
                    </div>
                  )}

                  {detail.teachingLevels && detail.teachingLevels.length > 0 && (
                    <div className="admin-drawer__info-item">
                      <BookOpen size={15} className="admin-drawer__info-icon"/>
                      <div>
                        <div className="admin-drawer__info-label">Khối lớp dạy</div>
                        <div className="admin-drawer__info-value">{detail.teachingLevels.join(', ')}</div>
                      </div>
                    </div>
                  )}

                  {detail.location && (
                    <div className="admin-drawer__info-item">
                      <MapPin size={15} className="admin-drawer__info-icon"/>
                      <div>
                        <div className="admin-drawer__info-label">Khu vực</div>
                        <div className="admin-drawer__info-value">{detail.location}</div>
                      </div>
                    </div>
                  )}

                  {(detail.rating != null) && (
                    <div className="admin-drawer__info-item">
                      <Star size={15} className="admin-drawer__info-icon" style={{ color: '#f59e0b' }}/>
                      <div>
                        <div className="admin-drawer__info-label">Đánh giá</div>
                        <div className="admin-drawer__info-value">{detail.rating?.toFixed(1)} ⭐ ({detail.ratingCount} lượt)</div>
                      </div>
                    </div>
                  )}

                  {detail.experienceYears != null && detail.experienceYears > 0 && (
                    <div className="admin-drawer__info-item">
                      <Clock size={15} className="admin-drawer__info-icon"/>
                      <div>
                        <div className="admin-drawer__info-label">Kinh nghiệm</div>
                        <div className="admin-drawer__info-value">{detail.experienceYears} năm</div>
                      </div>
                    </div>
                  )}

                  {detail.hourlyRate != null && (
                    <div className="admin-drawer__info-item">
                      <span className="admin-drawer__info-icon" style={{ fontSize: 16, fontWeight: 600 }}>₫</span>
                      <div>
                        <div className="admin-drawer__info-label">Lương giờ đề xuất</div>
                        <div className="admin-drawer__info-value">{detail.hourlyRate?.toLocaleString('vi-VN')} ₫/h</div>
                      </div>
                    </div>
                  )}

                  {detail.bio && (
                    <div>
                      <div className="admin-drawer__info-label" style={{ marginBottom: 4 }}>Giới thiệu</div>
                      <div className="admin-drawer__info-box">{detail.bio}</div>
                    </div>
                  )}

                  {detail.achievements && (
                    <div>
                      <div className="admin-drawer__info-label" style={{ marginBottom: 4 }}>Thành tích / Kinh nghiệm</div>
                      <div className="admin-drawer__info-box">{detail.achievements}</div>
                    </div>
                  )}
                </div>
              </section>
            )}

            <div className="admin-drawer__actions">
              {newPassword ? (
                <div className="admin-drawer__confirm-box" style={{ width: '100%', borderColor: '#10b981', background: '#ecfdf5' }}>
                  <div className="admin-drawer__confirm-title" style={{ color: '#059669' }}>
                    <CheckCircle size={16}/> Mật khẩu mới đã được tạo
                  </div>
                  <div className="admin-drawer__confirm-desc" style={{ color: '#047857' }}>
                    Hãy copy mật khẩu dưới đây và gửi cho khách hàng. Mật khẩu này sẽ có hiệu lực ngay lập tức.
                  </div>
                  <div style={{ padding: '12px', background: '#fff', border: '1px dashed #10b981', borderRadius: '8px', fontSize: '1.25rem', fontFamily: 'monospace', textAlign: 'center', fontWeight: 'bold', color: '#000', marginBottom: '8px' }}>
                    {newPassword}
                  </div>
                  <button onClick={() => {
                    navigator.clipboard.writeText(newPassword);
                    showToast('Đã copy mật khẩu!');
                  }} className="admin-drawer__btn admin-drawer__btn--secondary" style={{ width: '100%' }}>
                    Copy Mật Khẩu
                  </button>
                </div>
              ) : confirm === 'delete' ? (
                <div className="admin-drawer__confirm-box" style={{ width: '100%' }}>
                  <div className="admin-drawer__confirm-title"><ShieldAlert size={16}/> Xác nhận xóa người dùng?</div>
                  <div className="admin-drawer__confirm-desc">Hành động này không thể hoàn tác. Người dùng sẽ bị xóa khỏi hệ thống.</div>
                  <div style={{ display: 'flex', gap: 8 }}>
                    <button onClick={handleDelete} disabled={busy} className="admin-drawer__btn admin-drawer__btn--solid-danger">
                      {busy ? 'Đang xóa...' : 'Xóa người dùng'}
                    </button>
                    <button onClick={() => setConfirm(null)} className="admin-drawer__btn admin-drawer__btn--secondary">
                      Hủy
                    </button>
                  </div>
                </div>
              ) : confirm === 'reset' ? (
                <div className="admin-drawer__confirm-box" style={{ width: '100%' }}>
                  <div className="admin-drawer__confirm-title" style={{ color: '#f59e0b' }}><Lock size={16}/> Cấp lại mật khẩu ngẫu nhiên?</div>
                  <div className="admin-drawer__confirm-desc">Hành động này sẽ thay đổi mật khẩu hiện tại của khách hàng thành một chuỗi tự động ngẫu nhiên và bắt buộc khách hàng phải đổi lại mật khẩu trong lần Đăng nhập tới. Bạn có chắc không?</div>
                  <div style={{ display: 'flex', gap: 8 }}>
                    <button onClick={handleResetPassword} disabled={busy} className="admin-drawer__btn" style={{ background: '#f59e0b', color: '#fff', border: 'none' }}>
                      {busy ? 'Đang xử lý...' : 'Xác nhận Cấp lại'}
                    </button>
                    <button onClick={() => setConfirm(null)} className="admin-drawer__btn admin-drawer__btn--secondary">
                      Hủy
                    </button>
                  </div>
                </div>
              ) : (
                <>
                  <button onClick={handleLock} disabled={busy} className={`admin-drawer__btn ${detail.isActive ? 'admin-drawer__btn--lock' : 'admin-drawer__btn--unlock'}`}>
                    {detail.isActive ? <Lock size={15}/> : <Unlock size={15}/>}
                    {detail.isActive ? 'Khóa tài khoản' : 'Mở khóa'}
                  </button>
                  <button onClick={() => setConfirm('reset')} className="admin-drawer__btn admin-drawer__btn--secondary">
                    <Lock size={15}/> Cấp mật khẩu
                  </button>
                  <button onClick={() => setConfirm('delete')} className="admin-drawer__btn admin-drawer__btn--danger">
                    <Trash2 size={15}/> Xóa
                  </button>
                </>
              )}
            </div>
          </div>
        ) : (
          <div className="admin-users__empty" style={{ flex: 1 }}>
            <User size={48} />
            <div className="admin-users__empty-title">Không tìm thấy thông tin</div>
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
          <div className="admin-loader">
            <User size={32} />
            <div style={{ fontSize: '0.9rem', fontWeight: 500 }}>Đang tải danh sách...</div>
          </div>
        ) : paginated.length === 0 ? (
          <div className="admin-users__empty">
            <User size={48} />
            <div className="admin-users__empty-title">
              {search || statusFilter !== 'ALL' || roleFilter !== 'ALL' ? 'Không tìm thấy người dùng phù hợp' : 'Chưa có người dùng nào'}
            </div>
            <div className="admin-users__empty-desc">
              Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm
            </div>
          </div>
        ) : (
          <>
          <table className="admin-users__table admin-users__table--desktop">
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

          {/* Mobile Card Layout */}
          <div className="admin-users__cards">
            {paginated.map(u => (
              <div
                key={u.id}
                className="admin-users__card"
                onClick={() => setSelectedUserId(u.id)}
              >
                <div className="admin-users__card-top">
                  <div className="admin-users__user-avatar" style={{ background: avatarColor(u.fullName) }}>
                    {initials(u.fullName)}
                  </div>
                  <div className="admin-users__card-info">
                    <div className="admin-users__card-name">{u.fullName}</div>
                    <div className="admin-users__card-phone">{u.phone}</div>
                  </div>
                  <span className={`admin-role-badge admin-role-badge--${u.role.toLowerCase()}`}>
                    {ROLE_LABEL[u.role]}
                  </span>
                </div>
                <div className="admin-users__card-bottom">
                  <span className="admin-status">
                    <span className={`admin-status__dot admin-status__dot--${u.isActive ? 'active' : 'locked'}`} />
                    {u.isActive ? 'Hoạt động' : 'Khóa'}
                  </span>
                  <div className="admin-users__card-actions" onClick={e => e.stopPropagation()}>
                    {u.role !== 'ADMIN' && (
                      <button
                        className="admin-users__action-btn admin-users__action-btn--message"
                        title="Gửi tin nhắn"
                        onClick={() => navigate(`/admin/messages?userId=${u.id}`)}
                      >
                        <MessageSquare size={15}/>
                      </button>
                    )}
                    <button
                      className="admin-users__action-btn"
                      title={u.isActive ? 'Khóa' : 'Mở khóa'}
                      onClick={async () => {
                        try {
                          if (u.isActive) await adminApi.lockUser(u.id);
                          else await adminApi.unlockUser(u.id);
                          fetchUsers();
                        } catch { alert('Thao tác thất bại'); }
                      }}
                    >
                      {u.isActive ? <Lock size={15}/> : <Unlock size={15}/>}
                    </button>
                    <button
                      className="admin-users__action-btn admin-users__action-btn--danger"
                      title="Xóa"
                      onClick={() => setSelectedUserId(u.id)}
                    >
                      <Trash2 size={15}/>
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
          </>
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
