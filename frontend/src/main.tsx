import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider } from 'react-router-dom'
import { HelmetProvider } from 'react-helmet-async'
import { router } from './routes/routes'
import { useAuthStore } from './store/useAuthStore'
import './index.css'

// Apply persisted theme BEFORE first render to avoid flash
const savedTheme = localStorage.getItem('theme') ?? 'light';
document.documentElement.setAttribute('data-theme', savedTheme);

// ═══════════════════════════════════════════════════════════════
// Auto-login from mobile deep link
// Priority: hash fragment (#token=xxx) > query parameter (?token=xxx)
// Hash fragment is more secure as it's NEVER sent to server
// ═══════════════════════════════════════════════════════════════
const hashString = window.location.hash.startsWith('#') ? window.location.hash.substring(1) : '';
const hashParams = new URLSearchParams(hashString);
const urlParams = new URLSearchParams(window.location.search);

const mobileToken = hashParams.get('token') || urlParams.get('token');
const mobileRefreshToken = hashParams.get('refreshToken') || urlParams.get('refreshToken');

if (mobileToken) {
  const mobileFullName = hashParams.get('fullName') || urlParams.get('fullName') || '';
  const mobileRole = hashParams.get('role') || urlParams.get('role') || '';

  console.log('[MobileAuth] fullName:', mobileFullName, 'role:', mobileRole);
  console.log('[MobileAuth] token (first 30):', mobileToken.substring(0, 30));

  // Parse JWT to build user object
  let tempUser = { phone: '', role: mobileRole || 'PARENT', fullName: decodeURIComponent(mobileFullName) };
  try {
    const payload = JSON.parse(atob(mobileToken.split('.')[1]));
    tempUser = {
      phone: payload.sub ?? '',
      role: mobileRole || payload.role || 'PARENT',
      fullName: decodeURIComponent(mobileFullName) || payload.fullName || '',
    };
  } catch {
    // Ignore parse errors
  }

  // Directly update Zustand store — NO reload needed!
  // This sets isAuthenticated=true immediately so ProtectedRoute passes.
  useAuthStore.getState().login(tempUser as any, mobileToken, mobileRefreshToken || '');

  // Save intended path BEFORE cleaning URL
  const intendedPath = window.location.pathname;

  // Clean hash/query from URL (cosmetic, remove token from address bar)
  const cleanUrl = window.location.pathname + window.location.search.replace(/[?&]token=[^&]*/g, '').replace(/[?&]refreshToken=[^&]*/g, '').replace(/^\?$/, '');
  window.history.replaceState({}, '', cleanUrl);

  // Navigate to intended path after React mounts
  setTimeout(() => {
    console.log('[MobileAuth] Navigating to:', intendedPath);
    router.navigate(intendedPath, { replace: true });
  }, 100);

  // Fetch full profile in background (avatar, etc.)
  fetch(`${import.meta.env.VITE_API_URL || 'http://localhost:8080'}/api/v1/users/profile`, {
    headers: { Authorization: `Bearer ${mobileToken}` },
  })
    .then(r => r.json())
    .then(res => {
      if (res.data) {
        const userData = {
          phone: res.data.phone ?? tempUser.phone,
          role: res.data.role ?? tempUser.role,
          fullName: tempUser.fullName || res.data.fullName || '',
          avatarBase64: res.data.avatarBase64 ?? undefined,
        };
        useAuthStore.getState().updateUser(userData);
      }
    })
    .catch(() => {});
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <HelmetProvider>
      <RouterProvider router={router} />
    </HelmetProvider>
  </StrictMode>,
)
