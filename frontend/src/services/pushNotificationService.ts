import apiClient from './apiClient';

const FCM_TOKEN_KEY = 'fcm_push_token';

/**
 * Gửi FCM token lên backend để lưu vào DB
 */
export async function registerPushToken(token: string): Promise<void> {
  try {
    await apiClient.post('/api/v1/push/register', {
      token,
      deviceType: 'WEB'
    });
    localStorage.setItem(FCM_TOKEN_KEY, token);
  } catch (error) {
    console.error('[Push] Failed to register token:', error);
  }
}

/**
 * Xóa FCM token khỏi backend (gọi khi logout)
 */
export async function unregisterPushToken(): Promise<void> {
  const token = localStorage.getItem(FCM_TOKEN_KEY);
  if (!token) return;

  try {
    await apiClient.delete('/api/v1/push/unregister', {
      params: { token }
    });
  } catch (error) {
    console.error('[Push] Failed to unregister token:', error);
  } finally {
    localStorage.removeItem(FCM_TOKEN_KEY);
  }
}

/**
 * Hiển thị OS notification bằng Web Notification API (Cấp 1 fallback).
 * Dùng khi tab đang mở nhưng không ở foreground.
 */
export function showBrowserNotification(title: string, body: string, entityType?: string): void {
  if (!('Notification' in window)) return;
  if (Notification.permission !== 'granted') return;

  // Chỉ hiện khi tab không ở foreground
  if (document.visibilityState === 'visible') return;

  const notification = new Notification(title, {
    body,
    icon: '/logo.webp',
    badge: '/logo.webp',
    tag: entityType || 'general',
    requireInteraction: false
  });

  notification.onclick = () => {
    window.focus();
    notification.close();
  };

  // Tự đóng sau 8 giây
  setTimeout(() => notification.close(), 8000);
}

/**
 * Check xem browser có hỗ trợ push notification không
 */
export function isPushSupported(): boolean {
  return 'Notification' in window && 'serviceWorker' in navigator;
}
