import { Search, Sun, Moon, UserIcon, LogOut, Menu, Home, Key } from 'lucide-react';
import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import { useSidebarStore } from '../../store/useSidebarStore';

import { NotificationDropdown } from '../common/NotificationDropdown';
import { ChangePasswordModal } from '../auth/ChangePasswordModal';
import '../../pages/dashboard/Dashboard.css';

export const DashboardHeader = () => {
  const { user, logout } = useAuthStore();
  const navigate = useNavigate();
  const [isDark, setIsDark] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const [showChangePassword, setShowChangePassword] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const { toggle: toggleSidebar } = useSidebarStore();

  useEffect(() => {
    setIsDark(localStorage.getItem('theme') === 'dark');
    
    // Close dropdown when clicking outside
    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setShowDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const toggleTheme = () => {
    const next = isDark ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('theme', next);
    setIsDark(!isDark);
  };

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  const name = user?.fullName ?? 'Người dùng';
  const initial = name.charAt(0).toUpperCase();

  return (
    <header className="dash-topbar">
      <div className="topbar-left" style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
        <button className="topbar-icon-btn mobile-menu-btn" onClick={toggleSidebar} aria-label="Menu">
          <Menu size={20} />
        </button>
        <div className="topbar-search-wrap">
          <Search size={15} className="si" />
          <input type="text" placeholder="Tìm kiếm..." />
        </div>
      </div>
      <div className="topbar-right">
        {/* MOBILE ONLY: Home Button */}
        <button className="topbar-icon-btn dash-mobile-only" onClick={() => navigate('/')} aria-label="Trang chủ" title="Về trang chủ">
          <Home size={17} />
        </button>

        {/* DESKTOP ONLY: Theme Toggle */}
        <button className="topbar-icon-btn dash-desktop-only" onClick={toggleTheme} aria-label="theme">
          {isDark ? <Sun size={17} /> : <Moon size={17} />}
        </button>
        
        <NotificationDropdown />

        <div className="topbar-profile-wrap" ref={dropdownRef}>
          <button 
            className="topbar-avatar" 
            onClick={() => setShowDropdown(!showDropdown)}
            aria-label="Profile menu"
          >
            {user?.avatarBase64 ? (
              <img src={user.avatarBase64} alt="Avatar" className="topbar-avatar-img" />
            ) : (
              initial
            )}
          </button>

          {showDropdown && (
            <div className="profile-dropdown">
              <div className="profile-dropdown-header">
                <p className="profile-dropdown-name">{name}</p>
                <p className="profile-dropdown-role">
                  {user?.role === 'STUDENT' ? 'Học sinh' 
                   : user?.role === 'TUTOR' ? 'Gia sư' 
                   : user?.role === 'PARENT' ? 'Phụ huynh' : user?.role}
                </p>
              </div>
              <div className="profile-dropdown-divider"></div>
              
              {/* MOBILE ONLY: Theme Toggle in dropdown */}
              <button 
                className="profile-dropdown-item dash-mobile-only-flex" 
                onClick={toggleTheme}
              >
                {isDark ? <Sun size={16} /> : <Moon size={16} />} 
                {isDark ? 'Giao diện Sáng' : 'Giao diện Tối'}
              </button>
              
              <button 
                className="profile-dropdown-item" 
                onClick={() => { 
                  setShowDropdown(false); 
                  if (user?.role === 'TUTOR') navigate('/tutor/profile');
                  else if (user?.role === 'STUDENT') navigate('/student/profile');
                  else navigate('/parent/profile');
                }}
              >
                <UserIcon size={16} /> Hồ sơ cá nhân
              </button>
              
              <button 
                className="profile-dropdown-item" 
                onClick={() => { 
                  setShowDropdown(false); 
                  setShowChangePassword(true);
                }}
              >
                <Key size={16} /> Đổi mật khẩu
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

      {showChangePassword && (
        <ChangePasswordModal 
          onClose={() => setShowChangePassword(false)} 
        />
      )}
      {user?.mustChangePassword && !showChangePassword && (
        <ChangePasswordModal 
          onClose={() => {
            useAuthStore.getState().updateUser({ mustChangePassword: false });
          }}
          isMandatory={true}
        />
      )}
    </header>
  );
};
