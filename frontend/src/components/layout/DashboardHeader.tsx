import { Search, Sun, Moon, UserIcon, LogOut } from 'lucide-react';
import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';

import { NotificationDropdown } from '../common/NotificationDropdown';
import '../../pages/dashboard/Dashboard.css';

export const DashboardHeader = () => {
  const { user, logout } = useAuthStore();
  const navigate = useNavigate();
  const [isDark, setIsDark] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

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
      <div className="topbar-search-wrap">
        <Search size={15} className="si" />
        <input type="text" placeholder="Tìm gia sư, môn học..." />
      </div>
      <div className="topbar-right">
        <button className="topbar-icon-btn" onClick={toggleTheme} aria-label="theme">
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
  );
};
