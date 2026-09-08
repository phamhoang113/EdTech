import { useState } from 'react';
import { Outlet, useLocation } from 'react-router-dom';

import { StudentSidebar } from './StudentSidebar';
import { DashboardHeader } from '../layout/DashboardHeader';
import { StudentRequestClassModal } from './StudentRequestClassModal';
import '../../pages/dashboard/Dashboard.css';

/**
 * Layout wrapper cho tất cả trang Học sinh.
 * Sidebar + Header render 1 lần, chỉ đổi nội dung qua <Outlet />.
 * Giống pattern TutorLayout — chuyển tab tức thì, không flash.
 */
export function StudentLayout() {
  const location = useLocation();
  const [showReqClass, setShowReqClass] = useState(false);

  // Xác định tab active từ URL
  const resolveActiveTab = (): 'overview' | 'schedule' | 'teaching' | 'messages' | 'achievements' | 'parents' | 'payments' | 'profile' | 'requests' | 'ai' | 'notifications' => {
    const path = location.pathname;
    if (path.includes('/student/schedule')) return 'schedule';
    if (path.includes('/student/teaching')) return 'teaching';
    if (path.includes('/student/messages')) return 'messages';
    if (path.includes('/student/notifications')) return 'notifications';
    if (path.includes('/student/profile')) return 'profile';
    if (path.includes('/student/parents')) return 'parents';
    if (path.includes('/student/payment')) return 'payments';
    if (path.includes('/student/requests')) return 'requests';
    if (path.includes('/student/ai')) return 'ai';
    return 'overview';
  };

  return (
    <div className="dash-page">
      <StudentSidebar active={resolveActiveTab()} onRequestClass={() => setShowReqClass(true)} />
      <main className="dash-main">
        <DashboardHeader />
        <div className="dash-body">
          <Outlet />
        </div>
      </main>

      {/* Global Modal — Yêu cầu mở lớp (cho HS không có PH) */}
      {showReqClass && (
        <StudentRequestClassModal
          onClose={() => setShowReqClass(false)}
          onSuccess={() => {
            setShowReqClass(false);
            window.dispatchEvent(new Event('refresh-notifications'));
          }}
        />
      )}
    </div>
  );
}

