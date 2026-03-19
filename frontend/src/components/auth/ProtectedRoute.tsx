/**
 * ProtectedRoute — Bảo vệ các route yêu cầu đăng nhập.
 * Nếu chưa auth → redirect về landing page ("/").
 */
import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';

export const ProtectedRoute = () => {
  const { isAuthenticated } = useAuthStore();
  const location = useLocation();

  if (!isAuthenticated) {
    // Lưu URL hiện tại để sau khi login có thể redirect về
    return <Navigate to="/" state={{ from: location }} replace />;
  }

  return <Outlet />;
};
