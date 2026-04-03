import { Outlet, useLocation } from 'react-router-dom';
import { useState, useEffect } from 'react';

import { TutorSidebar } from './TutorSidebar';
import { DashboardHeader } from '../layout/DashboardHeader';
import { tutorApi } from '../../services/tutorApi';
import '../../pages/dashboard/Dashboard.css';

/**
 * Layout wrapper cho tất cả trang Tutor.
 * Sidebar + Header render 1 lần, chỉ đổi nội dung qua <Outlet />.
 * Giống pattern AdminLayout — chuyển tab tức thì, không flash.
 */
export function TutorLayout() {
  const location = useLocation();
  const [scheduleWarning, setScheduleWarning] = useState(false);
  const [draftCount, setDraftCount] = useState(0);

  // Fetch schedule warning 1 lần + refresh khi đổi tab
  useEffect(() => {
    tutorApi.getScheduleStatus()
      .then(status => {
        setScheduleWarning(status.hasDraftSessions);
        setDraftCount(status.draftCount);
      })
      .catch(() => { /* ignore */ });
  }, [location.pathname]);

  // Xác định tab active từ URL
  const resolveActiveTab = (): 'overview' | 'classes' | 'schedule' | 'messages' | 'profile' | 'revenue' => {
    const path = location.pathname;
    if (path.includes('/tutor/classes')) return 'classes';
    if (path.includes('/tutor/schedule')) return 'schedule';
    if (path.includes('/tutor/revenue')) return 'revenue';
    if (path.includes('/messages')) return 'messages';
    if (path.includes('/profile')) return 'profile';
    return 'overview';
  };

  return (
    <div className="dash-page">
      <TutorSidebar
        active={resolveActiveTab()}
        showScheduleWarning={scheduleWarning}
        draftCount={draftCount}
      />
      <main className="dash-main">
        <DashboardHeader />
        <div className="dash-body">
          <Outlet />
        </div>
      </main>
    </div>
  );
}
