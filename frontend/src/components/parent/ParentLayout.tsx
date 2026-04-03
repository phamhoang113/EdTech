import { useState } from 'react';
import { Outlet, useLocation } from 'react-router-dom';

import { ParentSidebar } from './ParentSidebar';
import { DashboardHeader } from '../layout/DashboardHeader';
import { RequestClassModal } from './RequestClassModal';
import '../../pages/dashboard/Dashboard.css';

/**
 * Layout wrapper cho tất cả trang Phụ huynh.
 * Sidebar + Header render 1 lần, chỉ đổi nội dung qua <Outlet />.
 * Giống pattern TutorLayout — chuyển tab tức thì, không flash.
 */
export function ParentLayout() {
  const location = useLocation();
  const [showReqClass, setShowReqClass] = useState(false);

  // Xác định tab active từ URL
  const resolveActiveTab = (): 'overview' | 'children' | 'applicants' | 'schedule' | 'messages' | 'profile' | 'report' | 'payment' => {
    const path = location.pathname;
    if (path.includes('/parent/children')) return 'children';
    if (path.includes('/parent/applicants')) return 'applicants';
    if (path.includes('/parent/schedule')) return 'schedule';
    if (path.includes('/parent/messages')) return 'messages';
    if (path.includes('/parent/profile')) return 'profile';
    if (path.includes('/parent/payment')) return 'payment';
    if (path.includes('/parent/report')) return 'report';
    return 'overview';
  };

  return (
    <div className="dash-page">
      <ParentSidebar active={resolveActiveTab()} onRequestClass={() => setShowReqClass(true)} />
      <main className="dash-main">
        <DashboardHeader />
        <div className="dash-body">
          <Outlet />
        </div>
      </main>

      {/* Global Modals */}
      {showReqClass && (
        <RequestClassModal
          onClose={() => setShowReqClass(false)}
          onSuccess={() => {
            setShowReqClass(false);
            // Could add global refresh event here if needed
          }}
        />
      )}
    </div>
  );
}
