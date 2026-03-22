import { useState, useRef, useEffect } from 'react';
import { Outlet, NavLink, Link, useNavigate, useLocation } from 'react-router-dom';
import {
  LayoutDashboard, Users, GraduationCap, FileCheck, BookOpen, ClipboardList,
  CreditCard, BarChart3, Settings, LogOut, Search, Bell,
  Sun, Moon, Menu, X, User as UserIcon, ClipboardCheck,
} from 'lucide-react';
import { useAuthStore } from '../../store/useAuthStore';
import { useBadgeCounts } from '../../hooks/useBadgeCounts';
import './AdminLayout.css';

const NAV_ITEMS = [
  { to: '/admin/dashboard',          icon: LayoutDashboard, label: 'Tổng quan' },
  { to: '/admin/users',              icon: Users,           label: 'Người dùng' },
  { to: '/admin/tutors',             icon: GraduationCap,   label: 'Gia sư' },
  { to: '/admin/verification',       icon: FileCheck,       label: 'Xác minh',           badgeKey: 'pendingVerifications' },
  { to: '/admin/class-requests',     icon: ClipboardCheck,  label: 'Yêu cầu mở lớp',    badgeKey: 'pendingClassRequests' },
  { to: '/admin/classes',            icon: BookOpen,        label: 'Lớp học' },
  { to: '/admin/class-applications', icon: ClipboardList,   label: 'Đơn nhận lớp',       badgeKey: 'pendingApplications' },
  { to: '/admin/payments',           icon: CreditCard,      label: 'Thanh toán' },
  { to: '/admin/reports',            icon: BarChart3,       label: 'Báo cáo' },
  { to: '/admin/settings',           icon: Settings,        label: 'Cài đặt' },
];

const PAGE_TITLES: Record<string, string> = {
  '/admin/dashboard':          'Tổng quan',
  '/admin/users':              'Người dùng',
  '/admin/tutors':             'Gia sư',
  '/admin/verification':       'Xác minh',
  '/admin/class-requests':     'Yêu cầu mở lớp',
  '/admin/classes':            'Lớp học',
  '/admin/class-applications': 'Đơn nhận lớp',
  '/admin/payments':           'Thanh toán',
  '/admin/reports':            'Báo cáo',
  '/admin/settings':           'Cài đặt',
};

export function AdminLayout() {
  const navigate = useNavigate();
  const location = useLocation();
  const { user, logout } = useAuthStore();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const badgeCounts = useBadgeCounts();

  const adminName = user?.fullName ?? 'Admin';
  const adminInitial = adminName.trim().split(' ').pop()?.charAt(0).toUpperCase() ?? 'A';

  useEffect(() => {
    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setShowDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const [theme, setTheme] = useState<'light' | 'dark'>(
    () => (document.documentElement.getAttribute('data-theme') as 'light' | 'dark') ?? 'light'
  );

  const toggleTheme = () => {
    const next = theme === 'light' ? 'dark' : 'light';
    setTheme(next);
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('theme', next);
  };

  const handleLogout = () => {
    logout();
    navigate('/admin/login');
  };

  const currentTitle = PAGE_TITLES[location.pathname] ?? 'Admin';
  const totalBadges = Object.values(badgeCounts).reduce((s, v) => s + v, 0);

  return (
    <div className="admin-layout">
      {/* Mobile overlay */}
      <div
        className={`admin-sidebar-overlay ${sidebarOpen ? 'open' : ''}`}
        onClick={() => setSidebarOpen(false)}
      />

      {/* Sidebar */}
      <aside className={`admin-sidebar ${sidebarOpen ? 'open' : ''}`}>
        <div className="admin-sidebar__logo">
          <Link to="/" style={{ display: 'flex', alignItems: 'center', gap: '8px', textDecoration: 'none', color: 'inherit' }}>
            <span className="admin-sidebar__logo-icon">🎓</span>
            <span className="admin-sidebar__logo-text">EdTech Admin</span>
          </Link>
          <button
            className="admin-topbar__hamburger"
            onClick={() => setSidebarOpen(false)}
            style={{ marginLeft: 'auto', display: sidebarOpen ? 'flex' : undefined }}
          >
            <X size={20} />
          </button>
        </div>

        <nav className="admin-sidebar__nav">
          {NAV_ITEMS.map((item) => {
            const count = item.badgeKey ? (badgeCounts[item.badgeKey] ?? 0) : 0;
            return (
              <NavLink
                key={item.to}
                to={item.to}
                className={({ isActive }) =>
                  `admin-sidebar__nav-item ${isActive ? 'active' : ''}`
                }
                onClick={() => setSidebarOpen(false)}
              >
                <span className="admin-sidebar__nav-icon">
                  <item.icon size={18} />
                </span>
                {item.label}
                {count > 0 && (
                  <span className="admin-sidebar__badge">{count > 99 ? '99+' : count}</span>
                )}
              </NavLink>
            );
          })}
        </nav>

        <div className="admin-sidebar__footer">
          <button className="admin-sidebar__logout" onClick={handleLogout}>
            <LogOut size={18} />
            Đăng xuất
          </button>
        </div>
      </aside>

      {/* Main */}
      <div className="admin-main">
        {/* Topbar */}
        <header className="admin-topbar">
          <div className="admin-topbar__left">
            <button
              className="admin-topbar__hamburger"
              onClick={() => setSidebarOpen(true)}
            >
              <Menu size={22} />
            </button>
            <div className="admin-topbar__breadcrumb">
              Quản trị / <span>{currentTitle}</span>
            </div>
          </div>

          <div className="admin-topbar__search">
            <Search size={16} style={{ color: 'var(--color-text-muted)', flexShrink: 0 }} />
            <input placeholder="Tìm kiếm..." />
          </div>

          <div className="admin-topbar__right">
            <button className="admin-topbar__icon-btn" onClick={toggleTheme} title="Đổi giao diện">
              {theme === 'light' ? <Moon size={18} /> : <Sun size={18} />}
            </button>
            <button className="admin-topbar__icon-btn">
              <Bell size={18} />
              {totalBadges > 0 && (
                <span className="admin-topbar__notification-badge">{totalBadges > 99 ? '99+' : totalBadges}</span>
              )}
            </button>
            <div className="admin-topbar__avatar-wrap" ref={dropdownRef}>
              <button
                className="admin-topbar__avatar"
                onClick={() => setShowDropdown(s => !s)}
                aria-label="Profile menu"
              >
                {user?.avatarBase64 ? (
                  <img src={user.avatarBase64} alt="avatar" style={{ width: '100%', height: '100%', borderRadius: '50%', objectFit: 'cover' }} />
                ) : adminInitial}
              </button>
              {showDropdown && (
                <div className="profile-dropdown admin-profile-dropdown">
                  <div className="profile-dropdown-header">
                    <p className="profile-dropdown-name">{adminName}</p>
                    <p className="profile-dropdown-role">Quản trị viên</p>
                  </div>
                  <div className="profile-dropdown-divider" />
                  <button
                    className="profile-dropdown-item"
                    onClick={() => { setShowDropdown(false); navigate('/profile'); }}
                  >
                    <UserIcon size={16} /> Hồ sơ cá nhân
                  </button>
                  <button
                    className="profile-dropdown-item text-danger"
                    onClick={handleLogout}
                  >
                    <LogOut size={16} /> Đăng xuất
                  </button>
                </div>
              )}
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="admin-content">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
