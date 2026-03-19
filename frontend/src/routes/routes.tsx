import { createBrowserRouter } from 'react-router-dom';
import App from '../App';
import { ProtectedRoute } from '../components/auth/ProtectedRoute';

/* ====================================================
   Route config
   PUBLIC  → /, /register, /verify-otp, /admin/login
   PROTECTED → /dashboard (+ future pages)
   ADMIN → /admin/* (AdminLayout)
   ==================================================== */
export const router = createBrowserRouter([
  {
    path: '/',
    element: <App />,
    children: [
      /* ── Public routes ── */
      {
        path: '/',
        lazy: async () => {
          const { LandingPage } = await import('../pages/home/LandingPage');
          return { Component: LandingPage };
        },
      },
      {
        path: '/register',
        lazy: async () => {
          const { RegisterPage } = await import('../pages/RegisterPage');
          return { Component: RegisterPage };
        },
      },
      {
        path: '/verify-otp',
        lazy: async () => {
          const { OtpVerifyPage } = await import('../pages/OtpVerifyPage');
          return { Component: OtpVerifyPage };
        },
      },
      {
        path: '/about',
        lazy: async () => {
          const { AboutPage } = await import('../pages/AboutPage');
          return { Component: AboutPage };
        },
      },
      {
        path: '/classes',
        lazy: async () => {
          const { ClassesPage } = await import('../pages/classes/ClassesPage');
          return { Component: ClassesPage };
        },
      },

      /* ── Protected routes (requires auth) ── */
      {
        element: <ProtectedRoute />,
        children: [
          {
            path: '/dashboard',
            lazy: async () => {
              const { DashboardPage } = await import('../pages/DashboardPage');
              return { Component: DashboardPage };
            },
          },
          {
            path: '/profile',
            lazy: async () => {
              const mod = await import('../pages/profile/TutorProfilePage');
              return { Component: mod.default };
            },
          },
          // Thêm các route mới vào đây khi phát triển thêm:
          // { path: '/profile',   lazy: ... },
          // { path: '/schedule',  lazy: ... },
          // { path: '/messages',  lazy: ... },
          // { path: '/payment',   lazy: ... },
        ],
      },
    ],
  },

  /* ════════════════════════════════════════════════════
     ADMIN ROUTES  —  /admin/*
     ════════════════════════════════════════════════════ */
  {
    path: '/admin/login',
    lazy: async () => {
      const { AdminLoginPage } = await import('../pages/admin/AdminLoginPage');
      return { Component: AdminLoginPage };
    },
  },
  {
    path: '/admin',
    lazy: async () => {
      const { AdminLayout } = await import('../components/admin/AdminLayout');
      return { Component: AdminLayout };
    },
    children: [
      {
        path: 'dashboard',
        lazy: async () => {
          const { AdminDashboard } = await import('../pages/admin/AdminDashboard');
          return { Component: AdminDashboard };
        },
      },
      {
        path: 'users',
        lazy: async () => {
          const { AdminUsers } = await import('../pages/admin/AdminUsers');
          return { Component: AdminUsers };
        },
      },
      {
        path: 'verification',
        lazy: async () => {
          const { AdminVerification } = await import('../pages/admin/AdminVerification');
          return { Component: AdminVerification };
        },
      },
    ],
  },
]);
