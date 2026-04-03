import { createBrowserRouter } from 'react-router-dom';
import App from '../App';
import { ProtectedRoute } from '../components/auth/ProtectedRoute';
import ErrorPage from '../pages/ErrorPage';

import { PublicLayout } from '../components/layout/PublicLayout';

/* ====================================================
   Route config
   PUBLIC  → /, /register, /admin/login
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
        element: <PublicLayout />,
        children: [
          {
            path: '/',
            lazy: async () => {
              const { LandingPage } = await import('../pages/home/LandingPage');
              return { Component: LandingPage };
            },
          },
          {
            path: '/pricing',
            lazy: async () => {
              const { PricingPage } = await import('../pages/PricingPage');
              return { Component: PricingPage };
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

          /* ── Blog / Bài viết SEO ── */
          {
            path: '/bai-viet',
            lazy: async () => {
              const { BlogListPage } = await import('../pages/blog/BlogListPage');
              return { Component: BlogListPage };
            },
          },
          {
            path: '/bai-viet/tai-sao-con-hoc-hoai-khong-vo',
            lazy: async () => {
              const { HocHoaiKhongVoPage } = await import('../pages/blog/HocHoaiKhongVoPage');
              return { Component: HocHoaiKhongVoPage };
            },
          },
          {
            path: '/bai-viet/phuong-phap-day-con-hoc-tai-nha',
            lazy: async () => {
              const { DayConHocTaiNhaPage } = await import('../pages/blog/DayConHocTaiNhaPage');
              return { Component: DayConHocTaiNhaPage };
            },
          },
          {
            path: '/bai-viet/cach-chon-gia-su-gioi',
            lazy: async () => {
              const { CachChonGiaSuPage } = await import('../pages/blog/CachChonGiaSuPage');
              return { Component: CachChonGiaSuPage };
            },
          },
          {
            path: '/bai-viet/loi-ich-hoc-1-kem-1',
            lazy: async () => {
              const { LoiIchHoc1Kem1Page } = await import('../pages/blog/LoiIchHoc1Kem1Page');
              return { Component: LoiIchHoc1Kem1Page };
            },
          },
        ]
      },
      {
        path: '/register',
        lazy: async () => {
          const { RegisterPage } = await import('../pages/RegisterPage');
          return { Component: RegisterPage };
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
          /* ── Parent Layout ── */
          {
            lazy: async () => {
              const { ParentLayout } = await import('../components/parent/ParentLayout');
              return { Component: ParentLayout };
            },
            children: [
              {
                path: '/parent/dashboard',
                lazy: async () => {
                  const { ParentDashboard } = await import('../pages/dashboard/ParentDashboard');
                  return { Component: ParentDashboard };
                },
              },
              {
                path: '/parent/profile',
                lazy: async () => {
                  const mod = await import('../pages/profile/UserProfilePage');
                  return { Component: mod.default };
                },
              },
              {
                path: '/parent/children',
                lazy: async () => {
                  const { MyChildrenPage } = await import('../pages/dashboard/MyChildrenPage');
                  return { Component: MyChildrenPage };
                },
              },
              {
                path: '/parent/applicants',
                lazy: async () => {
                  const { ApplicantsPage } = await import('../pages/dashboard/ApplicantsPage');
                  return { Component: ApplicantsPage };
                },
              },
              {
                path: '/parent/schedule',
                lazy: async () => {
                  const { ParentSchedulePage } = await import('../pages/dashboard/ParentSchedulePage');
                  return { Component: ParentSchedulePage };
                },
              },
              {
                path: '/parent/messages',
                lazy: async () => {
                  const { MessagesPage } = await import('../pages/messages/MessagesPage');
                  return { Component: MessagesPage };
                },
              },
              {
                path: '/parent/payment',
                lazy: async () => {
                  const { ParentPaymentPage } = await import('../pages/dashboard/ParentPaymentPage');
                  return { Component: ParentPaymentPage };
                },
              },
              {
                path: '/parent/report',
                lazy: async () => {
                  const { ParentReportPage } = await import('../pages/dashboard/ParentReportPage');
                  return { Component: ParentReportPage };
                },
              },
            ],
          },

          /* ── Student Layout ── */
          {
            lazy: async () => {
              const { StudentLayout } = await import('../components/student/StudentLayout');
              return { Component: StudentLayout };
            },
            children: [
              {
                path: '/student/dashboard',
                lazy: async () => {
                  const { StudentDashboard } = await import('../pages/dashboard/StudentDashboard');
                  return { Component: StudentDashboard };
                },
              },
              {
                path: '/student/profile',
                lazy: async () => {
                  const mod = await import('../pages/profile/UserProfilePage');
                  return { Component: mod.default };
                },
              },
              {
                path: '/student/parents',
                lazy: async () => {
                  const { StudentParentsPage } = await import('../pages/dashboard/StudentParentsPage');
                  return { Component: StudentParentsPage };
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
                path: '/student/messages',
                lazy: async () => {
                  const { MessagesPage } = await import('../pages/messages/MessagesPage');
                  return { Component: MessagesPage };
                },
              },
            ],
          },

          /* ── Tutor Layout (shared sidebar + header) ── */
          {
            lazy: async () => {
              const { TutorLayout } = await import('../components/tutor/TutorLayout');
              return { Component: TutorLayout };
            },
            children: [
              {
                path: '/tutor/dashboard',
                lazy: async () => {
                  const { TutorDashboard } = await import('../pages/dashboard/TutorDashboard');
                  return { Component: TutorDashboard };
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
                path: '/tutor/messages',
                lazy: async () => {
                  const { MessagesPage } = await import('../pages/messages/MessagesPage');
                  return { Component: MessagesPage };
                },
              },
              {
                path: '/tutor/profile',
                lazy: async () => {
                  const mod = await import('../pages/profile/UserProfilePage');
                  return { Component: mod.default };
                },
              },
            ],
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
