/**
 * DashboardPage — Role dispatcher
 * Renders the correct dashboard based on the authenticated user's role.
 * Auth guard is handled by ProtectedRoute in routes.tsx.
 */
import { Navigate } from 'react-router-dom';
import { useAuthStore } from '../store/useAuthStore';
export const DashboardPage = () => {
  const { user } = useAuthStore();

  if (!user) return null;

  switch (user.role) {
    case 'ADMIN':   return <Navigate to="/admin/dashboard" replace />;
    case 'TUTOR':   return <Navigate to="/tutor/dashboard" replace />;
    case 'PARENT':  return <Navigate to="/parent/dashboard" replace />;
    case 'STUDENT': return <Navigate to="/student/dashboard" replace />;
    default:        return <Navigate to="/parent/dashboard" replace />;
  }
};
