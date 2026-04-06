import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider } from 'react-router-dom'
import { HelmetProvider } from 'react-helmet-async'
import { router } from './routes/routes'
import './index.css'

// Apply persisted theme BEFORE first render to avoid flash
const savedTheme = localStorage.getItem('theme') ?? 'light';
document.documentElement.setAttribute('data-theme', savedTheme);

// Auto-login from mobile deep link
// Priority: hash fragment (#token=xxx) > query parameter (?token=xxx)
// Hash fragment is more secure as it's NEVER sent to the server in HTTP requests
const hashString = window.location.hash.startsWith('#') ? window.location.hash.substring(1) : '';
const hashParams = new URLSearchParams(hashString);
const urlParams = new URLSearchParams(window.location.search);

// Read token from hash fragment first (secure), fallback to query param (legacy)
const mobileToken = hashParams.get('token') || urlParams.get('token');
const mobileRefreshToken = hashParams.get('refreshToken') || urlParams.get('refreshToken');
const tokenSource = hashParams.get('token') ? 'hash' : 'query';

if (mobileToken && !sessionStorage.getItem('mobileTokenProcessed')) {
  sessionStorage.setItem('mobileTokenProcessed', '1');
  localStorage.setItem('accessToken', mobileToken);
  if (mobileRefreshToken) localStorage.setItem('refreshToken', mobileRefreshToken);

  // Đọc fullName + role từ hash params (mobile gửi trực tiếp) — ưu tiên hơn JWT
  const mobileFullName = hashParams.get('fullName') || urlParams.get('fullName') || '';
  const mobileRole = hashParams.get('role') || urlParams.get('role') || '';

  console.log('[MobileAuth] hashString:', hashString);
  console.log('[MobileAuth] fullName from hash:', mobileFullName);
  console.log('[MobileAuth] role from hash:', mobileRole);
  console.log('[MobileAuth] token (first 30):', mobileToken?.substring(0, 30));

  try {
    const payloadBase64 = mobileToken.split('.')[1];
    const payloadStr = atob(payloadBase64);
    const payload = JSON.parse(payloadStr);
    const tempUser = {
      phone: payload.sub ?? '',
      role: mobileRole || payload.role || 'PARENT',
      fullName: decodeURIComponent(mobileFullName) || payload.fullName || '',
    };
    localStorage.setItem('authUser', JSON.stringify(tempUser));
  } catch {
    // Ignore parse errors
  }

  // Clean URL trước khi reload
  if (tokenSource === 'hash') {
    const cleanUrl = window.location.pathname + window.location.search;
    window.history.replaceState({}, '', cleanUrl);
  } else {
    urlParams.delete('token');
    urlParams.delete('refreshToken');
    const cleanSearch = urlParams.toString();
    const cleanUrl = window.location.pathname + (cleanSearch ? `?${cleanSearch}` : '');
    window.history.replaceState({}, '', cleanUrl);
  }

  // Reload để Zustand store khởi tạo lại với token mới từ localStorage.
  // Không reload sẽ bị bug: useAuthStore đã khởi tạo isAuthenticated=false
  // trước khi main.tsx ghi token (do module import order).
  window.location.reload();
}

// Post-reload: nếu vừa login từ mobile → fetch profile đầy đủ (avatar, etc.)
const storedToken = localStorage.getItem('accessToken');
const isMobileLogin = sessionStorage.getItem('mobileTokenProcessed') === '1';
if (storedToken && isMobileLogin) {
  // Clear flag để chỉ fetch 1 lần
  sessionStorage.removeItem('mobileTokenProcessed');
  fetch(`${import.meta.env.VITE_API_URL || 'http://localhost:8080'}/api/v1/users/profile`, {
    headers: { Authorization: `Bearer ${storedToken}` },
  })
    .then(r => r.json())
    .then(res => {
      if (res.data) {
        // Giữ fullName từ mobile hash params (đã lưu trước reload),
        // chỉ bổ sung avatar + fields mà mobile không truyền
        const existingUser = JSON.parse(localStorage.getItem('authUser') || '{}');
        const userData = {
          phone: res.data.phone ?? existingUser.phone ?? '',
          role: res.data.role ?? existingUser.role ?? 'PARENT',
          fullName: existingUser.fullName || res.data.fullName || res.data.name || '',
          avatarBase64: res.data.avatarBase64 ?? undefined,
        };
        localStorage.setItem('authUser', JSON.stringify(userData));
        // Cập nhật Zustand store trực tiếp để UI re-render
        import('./store/useAuthStore').then(({ useAuthStore }) => {
          useAuthStore.getState().updateUser(userData);
        });
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
