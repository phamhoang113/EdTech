import { useState } from 'react';
import { Search, Edit3, Lock, Trash2 } from 'lucide-react';
import './AdminUsers.css';

type Role = 'ADMIN' | 'TUTOR' | 'PARENT' | 'STUDENT';

interface MockUser {
  id: number;
  name: string;
  email: string;
  phone: string;
  role: Role;
  active: boolean;
  createdAt: string;
  bg: string;
}

const ROLE_LABEL: Record<Role, string> = {
  ADMIN: 'Admin',
  TUTOR: 'Gia sư',
  PARENT: 'Phụ huynh',
  STUDENT: 'Học sinh',
};

const MOCK_USERS: MockUser[] = [
  { id: 1, name: 'Nguyễn Hoàng', email: 'hoang@edtech.vn', phone: '0912345678', role: 'ADMIN', active: true, createdAt: '01/01/2026', bg: '#ef4444' },
  { id: 2, name: 'Trần Thị Hoa', email: 'hoa@gmail.com', phone: '0923456789', role: 'TUTOR', active: true, createdAt: '05/01/2026', bg: '#6366f1' },
  { id: 3, name: 'Lê Văn Tùng', email: 'tung@gmail.com', phone: '0934567890', role: 'TUTOR', active: true, createdAt: '10/01/2026', bg: '#8b5cf6' },
  { id: 4, name: 'Phạm Ngọc Mai', email: 'mai@gmail.com', phone: '0945678901', role: 'PARENT', active: true, createdAt: '15/01/2026', bg: '#10b981' },
  { id: 5, name: 'Đỗ Minh Khôi', email: 'khoi@gmail.com', phone: '0956789012', role: 'STUDENT', active: false, createdAt: '20/01/2026', bg: '#f59e0b' },
  { id: 6, name: 'Vũ Thanh Hằng', email: 'hang@gmail.com', phone: '0967890123', role: 'TUTOR', active: true, createdAt: '25/01/2026', bg: '#6366f1' },
  { id: 7, name: 'Bùi Quốc Dũng', email: 'dung@gmail.com', phone: '0978901234', role: 'PARENT', active: true, createdAt: '01/02/2026', bg: '#10b981' },
  { id: 8, name: 'Ngô Thị Lan', email: 'lan@gmail.com', phone: '0989012345', role: 'STUDENT', active: true, createdAt: '05/02/2026', bg: '#f59e0b' },
  { id: 9, name: 'Hoàng Văn Nam', email: 'nam@gmail.com', phone: '0990123456', role: 'TUTOR', active: false, createdAt: '10/02/2026', bg: '#8b5cf6' },
  { id: 10, name: 'Đinh Thị Yến', email: 'yen@gmail.com', phone: '0901234567', role: 'STUDENT', active: true, createdAt: '15/02/2026', bg: '#f59e0b' },
];

export function AdminUsers() {
  const [search, setSearch] = useState('');
  const [roleFilter, setRoleFilter] = useState('ALL');
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [currentPage, setCurrentPage] = useState(1);

  const filtered = MOCK_USERS.filter((u) => {
    if (search && !u.name.toLowerCase().includes(search.toLowerCase()) && !u.email.toLowerCase().includes(search.toLowerCase())) return false;
    if (roleFilter !== 'ALL' && u.role !== roleFilter) return false;
    if (statusFilter === 'ACTIVE' && !u.active) return false;
    if (statusFilter === 'LOCKED' && u.active) return false;
    return true;
  });

  return (
    <div className="admin-users">
      {/* Header */}
      <div className="admin-users__header">
        <h1 className="admin-users__title">Quản lý người dùng</h1>
        <button className="admin-users__export">📥 Xuất Excel</button>
      </div>

      {/* Filters */}
      <div className="admin-users__filters">
        <div className="admin-users__search">
          <Search size={16} style={{ color: 'var(--color-text-muted)', flexShrink: 0 }} />
          <input
            placeholder="Tìm theo tên, email..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <select
          className="admin-users__filter-select"
          value={roleFilter}
          onChange={(e) => setRoleFilter(e.target.value)}
        >
          <option value="ALL">Vai trò: Tất cả</option>
          <option value="ADMIN">Admin</option>
          <option value="TUTOR">Gia sư</option>
          <option value="PARENT">Phụ huynh</option>
          <option value="STUDENT">Học sinh</option>
        </select>
        <select
          className="admin-users__filter-select"
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
        >
          <option value="ALL">Trạng thái: Tất cả</option>
          <option value="ACTIVE">Hoạt động</option>
          <option value="LOCKED">Khóa</option>
        </select>
      </div>

      {/* Table */}
      <div className="admin-users__table-wrap">
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
            {filtered.map((u) => (
              <tr key={u.id}>
                <td>
                  <div className="admin-users__user-cell">
                    <div className="admin-users__user-avatar" style={{ background: u.bg }}>
                      {u.name.charAt(u.name.lastIndexOf(' ') + 1)}
                    </div>
                    {u.name}
                  </div>
                </td>
                <td>{u.email}</td>
                <td>{u.phone}</td>
                <td>
                  <span className={`admin-role-badge admin-role-badge--${u.role.toLowerCase()}`}>
                    {ROLE_LABEL[u.role]}
                  </span>
                </td>
                <td>
                  <span className="admin-status">
                    <span className={`admin-status__dot admin-status__dot--${u.active ? 'active' : 'locked'}`} />
                    {u.active ? 'Hoạt động' : 'Khóa'}
                  </span>
                </td>
                <td>{u.createdAt}</td>
                <td>
                  <div className="admin-table__actions">
                    <button className="admin-users__action-btn" title="Chỉnh sửa"><Edit3 size={16} /></button>
                    <button className="admin-users__action-btn" title="Khóa tài khoản"><Lock size={16} /></button>
                    <button className="admin-users__action-btn admin-users__action-btn--danger" title="Xóa"><Trash2 size={16} /></button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {/* Pagination */}
        <div className="admin-users__pagination">
          <span className="admin-users__pagination-info">
            Hiển thị 1-{filtered.length} của {MOCK_USERS.length}
          </span>
          <div className="admin-users__pagination-pages">
            {[1, 2, 3].map((p) => (
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
      </div>
    </div>
  );
}
