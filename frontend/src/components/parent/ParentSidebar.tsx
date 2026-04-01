import { LayoutDashboard, Users, PlusCircle, Calendar, MessageSquare, BarChart3, LogOut, CreditCard, UserCheck, User } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import { useBadgeCounts } from '../../hooks/useBadgeCounts';
import { useNotificationStore } from '../../store/useNotificationStore';

export function ParentSidebar({ active, onRequestClass }: {
  active: 'overview' | 'children' | 'applicants' | 'schedule' | 'messages' | 'profile' | 'report' | 'payment';
  onRequestClass?: () => void;
}) {
  const navigate = useNavigate();
  const { logout } = useAuthStore();
  const badgeCounts = useBadgeCounts();
  const { unreadMessages } = useNotificationStore();
  const proposedCount = badgeCounts['proposedApplicants'] ?? 0;
  const unpaidCount = badgeCounts['unpaidBillings'] ?? 0;

  return (
    <aside className="dash-sidebar">
      <Link to="/" className="dash-sidebar-logo" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
        <img src="/logo.png" alt="Gia Sư Tinh Hoa" style={{ width: '100%', height: 'auto', maxHeight: '50px', objectFit: 'contain', filter: 'var(--logo-filter, none)' }} />
      </Link>

      <div className="dash-sidebar-section">
        <div style={{ padding: '0 10px', marginBottom: '16px' }}>
          <button 
            className="dash-sidebar-cta" 
            onClick={onRequestClass}
          >
            <PlusCircle size={18}/><span> Yêu cầu mở lớp</span>
          </button>
        </div>

        <span className="dash-sidebar-section-label">Quản lý lớp học</span>
        <button 
          className={`dash-sidebar-item ${active === 'overview' ? 'active' : ''}`} 
          onClick={() => navigate('/dashboard')}
        >
          <LayoutDashboard size={18}/> Tổng quan
        </button>
        <button 
          className={`dash-sidebar-item ${active === 'children' ? 'active' : ''}`} 
          onClick={() => navigate('/my-children')}
        >
          <Users size={18}/> Con em của tôi
        </button>
        <button 
          className={`dash-sidebar-item ${active === 'applicants' ? 'active' : ''}`} 
          onClick={() => navigate('/applicants')}
        >
          <UserCheck size={18}/> Gia sư ứng tuyển
          {proposedCount > 0 && (
            <span className="item-badge badge-pulse">{proposedCount > 99 ? '99+' : proposedCount}</span>
          )}
        </button>
        <button 
          className={`dash-sidebar-item ${active === 'schedule' ? 'active' : ''}`} 
          onClick={() => navigate('/schedule')}
        >
          <Calendar size={18}/> Lịch học
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

        <span className="dash-sidebar-section-label">Tiện ích & Tài chính</span>
        <button 
          className={`dash-sidebar-item ${active === 'profile' ? 'active' : ''}`}
          onClick={() => navigate('/profile')}
        >
          <User size={18}/> Hồ sơ cá nhân
        </button>
        <button 
          className={`dash-sidebar-item ${active === 'payment' ? 'active' : ''}`}
          onClick={() => navigate('/payment')}
        >
          <CreditCard size={18}/> Thanh toán
          {unpaidCount > 0 && (
            <span className="item-badge badge-pulse" style={{ backgroundColor: '#EF4444' }} title="Học phí chưa thanh toán">
              {unpaidCount > 99 ? '99+' : unpaidCount}
            </span>
          )}
        </button>
        <button 
          className={`dash-sidebar-item ${active === 'report' ? 'active' : ''}`}
          onClick={() => navigate('/learning-report')}
        >
          <BarChart3 size={18}/> Báo cáo học tập
        </button>
      </div>

      <button className="dash-logout" onClick={() => { logout(); navigate('/'); }}>
        <LogOut size={16}/> Đăng xuất
      </button>
    </aside>
  );
}
