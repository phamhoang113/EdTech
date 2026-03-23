import { createBrowserRouter } from 'react-router-dom';
import App from '../App';
import { ProtectedRoute } from '../components/auth/ProtectedRoute';
import ErrorPage from '../pages/ErrorPage';

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
    errorElement: <ErrorPage />,
    children: [
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
          {
            path: '/my-children',
            lazy: async () => {
              const { MyChildrenPage } = await import('../pages/dashboard/MyChildrenPage');
              return { Component: MyChildrenPage };
            },
          },
          {
            path: '/applicants',
            lazy: async () => {
              const { ApplicantsPage } = await import('../pages/dashboard/ApplicantsPage');
              return { Component: ApplicantsPage };
            },
          },
          // Thêm các route mới vào đây khi phát triển thêm:
          {
            path: '/schedule',
            lazy: async () => {
              const { ParentSchedulePage } = await import('../pages/dashboard/ParentSchedulePage');
              return { Component: ParentSchedulePage };
            },
          },
          {
            path: '/tutor/classes',
            lazy: async () => {
              const { TutorClassesPage } = await import('../pages/dashboard/TutorClassesPage');
              return { Component: TutorClassesPage };
            },
          },
          {
            path: '/tutor/schedule',
            lazy: async () => {
              const { TutorSchedulePage } = await import('../pages/dashboard/TutorSchedulePage');
              return { Component: TutorSchedulePage };
            },
          },
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
      {
        path: 'class-applications',
        lazy: async () => {
          const { AdminClassApplications } = await import('../pages/admin/AdminClassApplications');
          return { Component: AdminClassApplications };
        },
      },
      {
        path: 'tutors',
        lazy: async () => {
          const { AdminTutors } = await import('../pages/admin/AdminTutors');
          return { Component: AdminTutors };
        },
      },
      {
        path: 'classes',
        lazy: async () => {
          const { AdminClasses } = await import('../pages/admin/AdminClasses');
          return { Component: AdminClasses };
        },
      },
      {
        path: 'reports',
        lazy: async () => {
          const { AdminReports } = await import('../pages/admin/AdminReports');
          return { Component: AdminReports };
        },
      },
      {
        path: 'settings',
        lazy: async () => {
          const { AdminSettings } = await import('../pages/admin/AdminSettings');
          return { Component: AdminSettings };
        },
      },
      {
        path: 'payments',
        lazy: async () => {
          const { AdminReports } = await import('../pages/admin/AdminReports');
          return { Component: AdminReports };
        },
      },
      {
        path: 'class-requests',
        lazy: async () => {
          const { AdminClassRequests } = await import('../pages/admin/AdminClassRequests');
          return { Component: AdminClassRequests };
        },
      },
      // Catch-all 404 trong admin
      { path: '*', element: <ErrorPage /> },
    ],
    errorElement: <ErrorPage />,
  },
  // Catch-all 404 toàn cục
  { path: '*', element: <ErrorPage /> },
]);
