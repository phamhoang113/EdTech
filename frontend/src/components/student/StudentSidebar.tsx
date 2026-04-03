import { LayoutDashboard, Calendar, User, Users, MessageSquare, CreditCard, LogOut, BookOpen } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import { useState, useEffect } from 'react';
import { useAuthStore } from '../../store/useAuthStore';
import { useNotificationStore } from '../../store/useNotificationStore';
import { useSidebarStore } from '../../store/useSidebarStore';
import { studentApi } from '../../services/studentApi';

interface StudentSidebarProps {
  active?: 'overview' | 'schedule' | 'messages' | 'achievements' | 'parents' | 'payments' | 'profile' | 'requests';
  hasParent?: boolean;
}

export function StudentSidebar({ active = 'overview', hasParent: initialHasParent = false }: StudentSidebarProps) {
  const { logout } = useAuthStore();
  const navigate = useNavigate();
  const { unreadMessages } = useNotificationStore();
  const { isOpen, close } = useSidebarStore();
  const [hasParent, setHasParent] = useState(initialHasParent);
  const [loadingParent, setLoadingParent] = useState(!initialHasParent);

  useEffect(() => {
    let mounted = true;
    if (!initialHasParent) {
      studentApi.getParentLinks().then((res: any) => {
        if (mounted && res.data) {
          setHasParent(res.data.some((l: any) => l.linkStatus === 'ACCEPTED'));
        }
      }).catch(console.error)
      .finally(() => {
        if (mounted) setLoadingParent(false);
      });
    } else {
      setHasParent(initialHasParent);
      setLoadingParent(false);
    }
    return () => { mounted = false; };
  }, [initialHasParent]);

  const handleLogout = () => {
    logout();
    navigate('/');
    close();
  };

  const handleNav = (path: string) => {
    navigate(path);
    close();
  };

  const handleAddParent = () => {
    navigate('/student/parents');
    close();
  };

  return (
    <>
      {isOpen && <div className="dash-sidebar-overlay" onClick={close} />}
      <aside className={`dash-sidebar ${isOpen ? 'mobile-open' : ''}`}>
        <Link to="/" className="dash-sidebar-logo" onClick={close} style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <img src="/logo.webp" alt="Gia Sư Tinh Hoa" style={{ width: '100%', height: 'auto', maxHeight: '50px', objectFit: 'contain', filter: 'var(--logo-filter, none)' }} />
        </Link>

        <div className="dash-sidebar-section">
          <span className="dash-sidebar-section-label">Học tập</span>
          <button 
            className={`dash-sidebar-item ${active === 'overview' ? 'active' : ''}`}
            onClick={() => handleNav('/student/dashboard')}
          >
            <LayoutDashboard size={18} /> Tổng quan
          </button>
          <button 
            className={`dash-sidebar-item ${active === 'schedule' ? 'active' : ''}`}
            onClick={() => handleNav('/student/schedule')}
          >
            <Calendar size={18} /> Lịch học
          </button>
          {!loadingParent && !hasParent && (
            <button 
              className={`dash-sidebar-item ${active === 'requests' ? 'active' : ''}`}
              onClick={() => handleNav('/student/requests')}
            >
              <BookOpen size={18} /> Yêu cầu học tập
            </button>
          )}
          <button 
            className={`dash-sidebar-item ${active === 'messages' ? 'active' : ''}`}
            onClick={() => handleNav('/student/messages')}
          >
            <MessageSquare size={18} /> Tin nhắn
            {unreadMessages > 0 && (
              <span className="item-badge badge-pulse" title="Tin nhắn mới">
                {unreadMessages}
              </span>
            )}
          </button>

          <span className="dash-sidebar-section-label">Tài khoản</span>
          <button 
            className={`dash-sidebar-item ${active === 'profile' ? 'active' : ''}`}
            onClick={() => handleNav('/student/profile')}
          >
            <User size={18} /> Hồ sơ cá nhân
          </button>
          <button 
            className={`dash-sidebar-item ${active === 'parents' ? 'active' : ''}`} 
            onClick={handleAddParent}
          >
            <Users size={18} /> Phụ huynh của tôi
          </button>
          {!loadingParent && !hasParent && (
            <button 
              className={`dash-sidebar-item ${active === 'payments' ? 'active' : ''}`}
              onClick={() => handleNav('/student/payment')}
            >
              <CreditCard size={18} /> Thanh toán
            </button>
          )}
        </div>

        <button className="dash-logout" onClick={handleLogout}>
          <LogOut size={16} /> Đăng xuất
        </button>
      </aside>
    </>
  );
}
