/**
 * DashboardPage — Role dispatcher
 * Renders the correct dashboard based on the authenticated user's role.
 * Auth guard is handled by ProtectedRoute in routes.tsx.
 */
import { Navigate } from 'react-router-dom';
import { useAuthStore } from '../store/useAuthStore';
import { StudentDashboard } from './dashboard/StudentDashboard';
import { ParentDashboard }  from './dashboard/ParentDashboard';
import { TutorDashboard }   from './dashboard/TutorDashboard';

export const DashboardPage = () => {
  const { user } = useAuthStore();

  if (!user) return null;

  switch (user.role) {
    case 'ADMIN':   return <Navigate to="/admin/dashboard" replace />;
    case 'TUTOR':   return <TutorDashboard />;
    case 'PARENT':  return <ParentDashboard />;
    case 'STUDENT': return <StudentDashboard />;
    default:        return <ParentDashboard />;
  }
};
