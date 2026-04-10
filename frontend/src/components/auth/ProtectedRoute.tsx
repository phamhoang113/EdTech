/**
 * ProtectedRoute — Bảo vệ các route yêu cầu đăng nhập.
 * Nếu chưa auth → redirect về landing page ("/").
 * Nếu role không khớp prefix URL → redirect về dashboard đúng role.
 */
import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';

/** Map role → dashboard path prefix */
const ROLE_PATH_PREFIX: Record<string, string> = {
  ADMIN: '/admin',
  TUTOR: '/tutor',
  PARENT: '/parent',
  STUDENT: '/student',
};

/** Map role → dashboard home */
const ROLE_DASHBOARD: Record<string, string> = {
  ADMIN: '/admin/dashboard',
  TUTOR: '/tutor/dashboard',
  PARENT: '/parent/dashboard',
  STUDENT: '/student/dashboard',
};

export const ProtectedRoute = () => {
  const { isAuthenticated, user } = useAuthStore();
  const location = useLocation();

  if (!isAuthenticated) {
    return <Navigate to="/" state={{ from: location }} replace />;
  }

  // Role guard: chặn truy cập layout sai role
  const role = user?.role;
  if (role) {
    const expectedPrefix = ROLE_PATH_PREFIX[role];
    const path = location.pathname;

    // Nếu URL bắt đầu bằng prefix của role khác → redirect về dashboard đúng
    const isWrongRole = Object.entries(ROLE_PATH_PREFIX).some(
      ([r, prefix]) => r !== role && path.startsWith(prefix)
    );

    if (isWrongRole && expectedPrefix) {
      return <Navigate to={ROLE_DASHBOARD[role] ?? '/dashboard'} replace />;
    }
  }

  return <Outlet />;
};
