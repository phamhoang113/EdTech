import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import {
  LayoutDashboard, BookOpen, Calendar, MessageSquare,
  Star, BarChart3, LogOut, AlertCircle
} from 'lucide-react';

type SidebarTab = 'overview' | 'classes' | 'schedule' | 'messages' | 'profile' | 'revenue';

interface TutorSidebarProps {
  active: SidebarTab;
  showScheduleWarning?: boolean;
}

export function TutorSidebar({ active, showScheduleWarning = false }: TutorSidebarProps) {
  const navigate = useNavigate();
  const { logout } = useAuthStore();

  return (
    <aside className="dash-sidebar">
      <Link to="/" className="dash-sidebar-logo">
        <span className="dash-sidebar-logo-icon">🎓</span>
        <span className="dash-sidebar-logo-name">EdTech</span>
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
          {showScheduleWarning && (
            <span className="item-badge badge-pulse" title="Chưa set lịch tuần sau">
              <AlertCircle size={12} />
            </span>
          )}
        </button>
        <button className="dash-sidebar-item">
          <MessageSquare size={18} /> Tin nhắn
        </button>

        <span className="dash-sidebar-section-label">Hồ sơ & Tài chính</span>
        <button
          className={`dash-sidebar-item ${active === 'profile' ? 'active' : ''}`}
          onClick={() => navigate('/profile')}
        >
          <Star size={18} /> Hồ sơ gia sư
        </button>
        <button className="dash-sidebar-item">
          <BarChart3 size={18} /> Doanh thu & Báo cáo
        </button>
      </div>

      <button className="dash-logout" onClick={() => { logout(); navigate('/'); }}>
        <LogOut size={16} /> Đăng xuất
      </button>
    </aside>
  );
}
