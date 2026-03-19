import { Link, useNavigate } from 'react-router-dom';
import { Button } from '../ui/Button';
import { Sun, Moon, LayoutDashboard, LogOut, ChevronDown, Menu, X } from 'lucide-react';
import { useState, useEffect, useRef } from 'react';
import { useAuthStore } from '../../store/useAuthStore';
import './Header.css';

interface HeaderProps {
  onLoginClick: () => void;
  onRegisterClick: () => void;
}

const roleLabel: Record<string, string> = {
  PARENT: 'Phụ huynh',
  STUDENT: 'Học sinh',
  TUTOR: 'Gia sư',
  ADMIN: 'Admin',
};

const roleEmoji: Record<string, string> = {
  PARENT: '👨‍👩‍👧',
  STUDENT: '📚',
  TUTOR: '👩‍🏫',
  ADMIN: '⚙️',
};

export const Header = ({ onLoginClick, onRegisterClick }: HeaderProps) => {
  const { isAuthenticated, user, logout } = useAuthStore();
  const [isDark, setIsDark] = useState(false);
  const [dropdownOpen, setDropdownOpen] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();

  // Đóng mobile menu khi chuyển hướng
  useEffect(() => {
    setIsMobileMenuOpen(false);
  }, [navigate]);

  useEffect(() => {
    const theme = localStorage.getItem('theme') ?? document.documentElement.getAttribute('data-theme') ?? 'light';
    setIsDark(theme === 'dark');
  }, []);

  // Đóng dropdown khi click ra ngoài
  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setDropdownOpen(false);
      }
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, []);

  const toggleTheme = () => {
    const newTheme = isDark ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    setIsDark(!isDark);
  };

  const handleLogout = () => {
    logout();
    setDropdownOpen(false);
    navigate('/');
  };

  const getInitials = (name: string) =>
    name.split(' ').map(w => w[0]).slice(-2).join('').toUpperCase();

  return (
    <header className="header">
      <div className="container header-container">
        <Link to="/" className="logo">
          <span className="logo-icon">🎓</span>
          <span className="logo-text">EdTech</span>
        </Link>

        <div className={`nav-actions-container ${isMobileMenuOpen ? 'mobile-open' : ''}`}>
          <nav className="nav-links">
            <Link to="/" className="nav-link" onClick={() => setIsMobileMenuOpen(false)}>Trang Chủ</Link>
            <Link to="/search" className="nav-link" onClick={() => setIsMobileMenuOpen(false)}>Tìm Gia Sư</Link>
            <Link to="/classes" className="nav-link" onClick={() => setIsMobileMenuOpen(false)}>Lớp Học Hiện Có</Link>
            <Link to="/about" className="nav-link" onClick={() => setIsMobileMenuOpen(false)}>Về Chúng Tôi</Link>
          </nav>

          <div className="header-actions">
            {isAuthenticated && user && (
              <Link to="/dashboard" className="header-dash-link" title="Vào Dashboard" onClick={() => setIsMobileMenuOpen(false)}>
                <LayoutDashboard size={18} />
                <span className="hd-text">Dashboard</span>
              </Link>
            )}

            {isAuthenticated && user ? (
              /* ── Đã đăng nhập: hiện avatar + dropdown ── */
              <div className="header-user-menu" ref={dropdownRef}>
                <button
                  className="header-avatar-btn"
                  onClick={() => setDropdownOpen(prev => !prev)}
                  aria-label="User menu"
                >
                  <div className="header-avatar">
                    {getInitials(user.fullName)}
                  </div>
                  <div className="header-user-info">
                    <span className="header-user-name">{user.fullName}</span>
                    <span className="header-user-role">
                      {roleEmoji[user.role]} {roleLabel[user.role]}
                    </span>
                  </div>
                  <ChevronDown
                    size={16}
                    className={`header-chevron${dropdownOpen ? ' open' : ''}`}
                  />
                </button>

                {dropdownOpen && (
                  <div className="header-dropdown">
                    <button
                      className="header-dropdown-item"
                      onClick={() => { navigate('/dashboard'); setDropdownOpen(false); setIsMobileMenuOpen(false); }}
                    >
                      <LayoutDashboard size={16} />
                      Vào Dashboard
                    </button>
                    <div className="header-dropdown-divider" />
                    <button
                      className="header-dropdown-item danger"
                      onClick={() => { handleLogout(); setIsMobileMenuOpen(false); }}
                    >
                      <LogOut size={16} />
                      Đăng xuất
                    </button>
                  </div>
                )}
              </div>
            ) : (
              /* ── Chưa đăng nhập: hiện 2 nút ── */
              <div className="auth-buttons">
                <Button variant="ghost" onClick={() => { onLoginClick(); setIsMobileMenuOpen(false); }}>Đăng Nhập</Button>
                <Button variant="primary" onClick={() => { onRegisterClick(); setIsMobileMenuOpen(false); }}>Đăng Ký</Button>
              </div>
            )}
          </div>
        </div>

        <div className="mobile-controls">
          <button className="theme-toggle" onClick={toggleTheme} aria-label="Toggle theme">
            {isDark ? <Sun size={20} /> : <Moon size={20} />}
          </button>
          
          <button 
            className="mobile-menu-btn" 
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            aria-label="Toggle mobile menu"
          >
            {isMobileMenuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
      </div>
    </header>
  );
};
