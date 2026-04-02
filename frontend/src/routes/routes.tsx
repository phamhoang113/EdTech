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
        path: '/tutors',
        lazy: async () => {
          const { TutorsPage } = await import('../pages/home/TutorsPage');
          return { Component: TutorsPage };
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
      {
        path: '/terms',
        lazy: async () => {
          const { TermsPage } = await import('../pages/TermsPage');
          return { Component: TermsPage };
        },
      },
      {
        path: '/privacy',
        lazy: async () => {
          const { PrivacyPage } = await import('../pages/PrivacyPage');
          return { Component: PrivacyPage };
        },
      },
      {
        path: '/faq',
        lazy: async () => {
          const { FaqPage } = await import('../pages/FaqPage');
          return { Component: FaqPage };
        },
      },
      {
        path: '/contact',
        lazy: async () => {
          const { ContactPage } = await import('../pages/ContactPage');
          return { Component: ContactPage };
        },
      },
      {
        path: '/careers',
        lazy: async () => {
          const { CareersPage } = await import('../pages/CareersPage');
          return { Component: CareersPage };
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
              const mod = await import('../pages/profile/UserProfilePage');
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
            path: '/student/schedule',
            lazy: async () => {
              const { StudentSchedulePage } = await import('../pages/dashboard/StudentSchedulePage');
              return { Component: StudentSchedulePage };
            },
          },
          {
            path: '/student/requests',
            lazy: async () => {
              const { StudentRequestsPage } = await import('../pages/dashboard/StudentRequestsPage');
              return { Component: StudentRequestsPage };
            },
          },
          {
            path: '/student/payment',
            lazy: async () => {
              const { StudentPaymentPage } = await import('../pages/dashboard/StudentPaymentPage');
              return { Component: StudentPaymentPage };
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
          {
            path: '/tutor/revenue',
            lazy: async () => {
              const { default: TutorRevenuePage } = await import('../pages/dashboard/TutorRevenuePage');
              return { Component: TutorRevenuePage };
            },
          },
          {
            path: '/messages',
            lazy: async () => {
              const { MessagesPage } = await import('../pages/messages/MessagesPage');
              return { Component: MessagesPage };
            },
          },
          {
            path: '/payment',
            lazy: async () => {
              const { ParentPaymentPage } = await import('../pages/dashboard/ParentPaymentPage');
              return { Component: ParentPaymentPage };
            },
          },
          {
            path: '/learning-report',
            lazy: async () => {
              const { ParentReportPage } = await import('../pages/dashboard/ParentReportPage');
              return { Component: ParentReportPage };
            },
          },
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
          const { AdminBillings } = await import('../pages/admin/AdminBillings');
          return { Component: AdminBillings };
        },
      },
      {
        path: 'schedules',
        lazy: async () => {
          const { default: AdminSchedules } = await import('../pages/admin/AdminSchedules');
          return { Component: AdminSchedules };
        },
      },
      {
        path: 'class-requests',
        lazy: async () => {
          const { AdminClassRequests } = await import('../pages/admin/AdminClassRequests');
          return { Component: AdminClassRequests };
        },
      },
      {
        path: 'absences',
        lazy: async () => {
          const { AdminAbsences } = await import('../pages/admin/AdminAbsences');
          return { Component: AdminAbsences };
        },
      },
      {
        path: 'messages',
        lazy: async () => {
          const { AdminMessages } = await import('../pages/admin/AdminMessages');
          return { Component: AdminMessages };
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
