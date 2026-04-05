import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getMessaging, getToken, onMessage, isSupported } from 'firebase/messaging';
import type { MessagePayload } from 'firebase/messaging';

const firebaseConfig = {
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);

// Cấu hình ngôn ngữ mặc định về Tiếng Việt cho SMS
auth.languageCode = 'vi';

// ============================================================
// Firebase Cloud Messaging (FCM) — Web Push Notification
// ============================================================

/**
 * Xin quyền notification + lấy FCM token.
 * Trả về token string nếu thành công, null nếu user từ chối hoặc browser không hỗ trợ.
 */
export async function requestNotificationPermission(): Promise<string | null> {
  try {
    // Kiểm tra browser hỗ trợ FCM (Safari cũ không hỗ trợ)
    const supported = await isSupported();
    if (!supported) {
      console.warn('[FCM] Browser does not support Firebase Messaging');
      return null;
    }

    // Xin quyền notification từ user
    const permission = await Notification.requestPermission();
    if (permission !== 'granted') {
      console.info('[FCM] Notification permission denied by user');
      return null;
    }

    // Đăng ký Service Worker
    const swRegistration = await navigator.serviceWorker.register('/firebase-messaging-sw.js');

    const messaging = getMessaging(app);
    const vapidKey = import.meta.env.VITE_FIREBASE_VAPID_KEY;

    if (!vapidKey) {
      console.warn('[FCM] VITE_FIREBASE_VAPID_KEY not set — cannot get FCM token');
      return null;
    }

    const token = await getToken(messaging, {
      vapidKey,
      serviceWorkerRegistration: swRegistration
    });

    if (token) {
      console.info('[FCM] Token obtained successfully');
      return token;
    }

    console.warn('[FCM] No registration token available');
    return null;
  } catch (error) {
    console.error('[FCM] Error getting notification permission:', error);
    return null;
  }
}

/**
 * Lắng nghe notification khi app đang ở foreground.
 * FCM sẽ KHÔNG tự hiện OS notification khi foreground — phải xử lý thủ công.
 */
export function onForegroundMessage(callback: (payload: MessagePayload) => void): (() => void) | null {
  try {
    const messaging = getMessaging(app);
    const unsubscribe = onMessage(messaging, callback);
    return unsubscribe;
  } catch {
    return null;
  }
}
