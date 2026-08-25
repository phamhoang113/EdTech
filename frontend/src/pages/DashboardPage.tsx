/**
 * DashboardPage — Role dispatcher
 * Renders the correct dashboard based on the authenticated user's role.
 * Shows onboarding modal for first-time users.
 * Auth guard is handled by ProtectedRoute in routes.tsx.
 */
import { Navigate } from 'react-router-dom';
import { useAuthStore } from '../store/useAuthStore';
import { OnboardingModal } from '../components/onboarding/OnboardingModal';

export const DashboardPage = () => {
  const { user } = useAuthStore();

  if (!user) return null;

  const showOnboarding = !user.hasCompletedOnboarding && user.role !== 'ADMIN';

  // Khi user mới → chỉ hiện OnboardingModal (fullscreen overlay).
  // Sau khi complete → re-render → redirect bình thường.
  if (showOnboarding) {
    return (
      <OnboardingModal
        role={user.role as Exclude<typeof user.role, 'ADMIN'>}
        fullName={user.fullName}
      />
    );
  }

  switch (user.role) {
    case 'ADMIN':   return <Navigate to="/admin/dashboard" replace />;
    case 'TUTOR':   return <Navigate to="/tutor/dashboard" replace />;
    case 'PARENT':  return <Navigate to="/parent/dashboard" replace />;
    case 'STUDENT': return <Navigate to="/student/dashboard" replace />;
    default:        return <Navigate to="/parent/dashboard" replace />;
  }
};

