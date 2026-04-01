import { LayoutDashboard, BookOpen, Calendar, MessageSquare, User, BarChart3, LogOut } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import { useNotificationStore } from '../../store/useNotificationStore';

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

  return (
    <aside className="dash-sidebar">
      <Link to="/" className="dash-sidebar-logo" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <img src="/logo.png" alt="Gia Sư Tinh Hoa" className="dash-logo-img" style={{ width: '100%', height: 'auto', maxHeight: '50px', objectFit: 'contain' }} />
      </Link>

      <div className="dash-sidebar-section">
        <span className="dash-sidebar-section-label">Dạy học</span>
        <button
          className={`dash-sidebar-item ${active === 'overview' ? 'active' : ''}`}
          onClick={() => navigate('/dashboard')}
        >
          <LayoutDashboard size={18} /> Tổng quan
        </button>
        <button
          className={`dash-sidebar-item ${active === 'classes' ? 'active' : ''}`}
          onClick={() => navigate('/tutor/classes')}
        >
          <BookOpen size={18} /> Lớp học
        </button>
        <button
          className={`dash-sidebar-item ${active === 'schedule' ? 'active' : ''}`}
          onClick={() => navigate('/tutor/schedule')}
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
          onClick={() => navigate('/messages')}
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
          onClick={() => navigate('/profile')}
        >
          <User size={18} /> Hồ sơ gia sư
        </button>
        <button 
          className={`dash-sidebar-item ${active === 'revenue' ? 'active' : ''}`}
          onClick={() => navigate('/tutor/revenue')}
        >
          <BarChart3 size={18} /> Doanh thu & Báo cáo
        </button>
      </div>

      <button className="dash-logout" onClick={() => { logout(); navigate('/'); }}>
        <LogOut size={16} /> Đăng xuất
      </button>
    </aside>
  );
}
