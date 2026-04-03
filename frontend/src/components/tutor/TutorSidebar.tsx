import { LayoutDashboard, BookOpen, Calendar, MessageSquare, User, BarChart3, LogOut } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import { useNotificationStore } from '../../store/useNotificationStore';
import { useSidebarStore } from '../../store/useSidebarStore';

type SidebarTab = 'overview' | 'classes' | 'schedule' | 'messages' | 'profile' | 'revenue';

interface TutorSidebarProps {
  active: SidebarTab;
  showScheduleWarning?: boolean;
  draftCount?: number;
}

export function TutorSidebar({ active, showScheduleWarning = false, draftCount = 0 }: TutorSidebarProps) {
  const navigate = useNavigate();
  const { logout } = useAuthStore();
  const { unreadMessages } = useNotificationStore();
  const { isOpen, close } = useSidebarStore();

  const handleNav = (path: string) => {
    navigate(path);
    close();
  };

  return (
    <>
      {isOpen && <div className="dash-sidebar-overlay" onClick={close} />}
      <aside className={`dash-sidebar ${isOpen ? 'mobile-open' : ''}`}>
        <Link to="/" className="dash-sidebar-logo" onClick={close} style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <img src="/logo.webp" alt="Gia Sư Tinh Hoa" className="dash-logo-img" style={{ width: '100%', height: 'auto', maxHeight: '50px', objectFit: 'contain' }} />
        </Link>

        <div className="dash-sidebar-section">
          <span className="dash-sidebar-section-label">Dạy học</span>
          <button
            className={`dash-sidebar-item ${active === 'overview' ? 'active' : ''}`}
            onClick={() => handleNav('/tutor/dashboard')}
          >
            <LayoutDashboard size={18} /> Tổng quan
          </button>
          <button
            className={`dash-sidebar-item ${active === 'classes' ? 'active' : ''}`}
            onClick={() => handleNav('/tutor/classes')}
          >
            <BookOpen size={18} /> Lớp học
          </button>
          <button
            className={`dash-sidebar-item ${active === 'schedule' ? 'active' : ''}`}
            onClick={() => handleNav('/tutor/schedule')}
          >
            <Calendar size={18} /> Lịch dạy
            {showScheduleWarning && draftCount > 0 && (
              <span className="item-badge badge-pulse" title={`${draftCount} buổi chưa xác nhận`}>
                {draftCount}
              </span>
            )}
          </button>
          <button 
            className={`dash-sidebar-item ${active === 'messages' ? 'active' : ''}`}
            onClick={() => handleNav('/tutor/messages')}
          >
            <MessageSquare size={18} /> Tin nhắn
            {unreadMessages > 0 && (
              <span className="item-badge badge-pulse" title="Tin nhắn mới">
                {unreadMessages}
              </span>
            )}
          </button>

          <span className="dash-sidebar-section-label">Hồ sơ & Tài chính</span>
          <button
            className={`dash-sidebar-item ${active === 'profile' ? 'active' : ''}`}
            onClick={() => handleNav('/tutor/profile')}
          >
            <User size={18} /> Hồ sơ gia sư
          </button>
          <button 
            className={`dash-sidebar-item ${active === 'revenue' ? 'active' : ''}`}
            onClick={() => handleNav('/tutor/revenue')}
          >
            <BarChart3 size={18} /> Doanh thu & Báo cáo
          </button>
        </div>

        <button className="dash-logout" onClick={() => { logout(); navigate('/'); close(); }}>
          <LogOut size={16} /> Đăng xuất
        </button>
      </aside>
    </>
  );
}
