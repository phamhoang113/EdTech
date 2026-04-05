import { useEffect, useCallback, useState, useRef } from 'react';
import { Client } from '@stomp/stompjs';
import type { IMessage, StompSubscription } from '@stomp/stompjs';
import SockJS from 'sockjs-client';
import { useAuthStore } from '../store/useAuthStore';
import { useNotificationStore } from '../store/useNotificationStore';
import { showBrowserNotification, registerPushToken, isPushSupported } from '../services/pushNotificationService';
import { requestNotificationPermission, onForegroundMessage } from '../firebase';

// ============================================================
// MODULE-LEVEL SINGLETON (Observer Pattern)
// Chỉ tồn tại DUY NHẤT 1 instance StompClient cho toàn app.
// Mọi component dùng `useWebSocket()` đều share connection này.
// ============================================================

let globalClient: Client | null = null;
let globalConnected = false;
let globalToken: string | null = null;

/** Tập hợp listener để thông báo trạng thái kết nối cho mọi hook instance */
const connectionListeners = new Set<(connected: boolean) => void>();

/** Map: destination → Set<callback>. Nhiều component có thể subscribe cùng 1 topic */
const topicObservers = new Map<string, Set<(msg: any) => void>>();

/** Map: destination → StompSubscription thật (1 STOMP sub per destination) */
const activeStompSubs = new Map<string, StompSubscription>();

// ---- Internal helpers ----

function broadcastConnectionState(connected: boolean) {
  globalConnected = connected;
  connectionListeners.forEach(fn => fn(connected));
}

function dispatchStompMessage(destination: string, message: IMessage) {
  if (!message.body) return;
  try {
    const parsed = JSON.parse(message.body);
    const observers = topicObservers.get(destination);
    if (observers) {
      observers.forEach(fn => fn(parsed));
    }
  } catch (err) {
    console.error('[WS] Failed to parse message on', destination, err);
  }
}

/** Tạo STOMP subscription thật nếu chưa có cho destination */
function ensureStompSubscription(destination: string) {
  if (!globalClient?.connected) return;
  if (activeStompSubs.has(destination)) return;

  const sub = globalClient.subscribe(destination, (msg) => dispatchStompMessage(destination, msg));
  activeStompSubs.set(destination, sub);
}

let fcmInitDone = false;

/**
 * Auto-request FCM permission ngay sau login.
 * Chạy 1 lần duy nhất per session.
 */
async function initFcmAfterLogin() {
  if (fcmInitDone) return;
  fcmInitDone = true;

  if (!isPushSupported()) return;

  // Request quyền + lấy FCM token
  const token = await requestNotificationPermission();
  if (token) {
    await registerPushToken(token);

    // Lắng nghe foreground messages từ FCM
    onForegroundMessage(() => {
      // Khi nhận FCM ở foreground → refresh notification count
      // (notification list sẽ tự update qua WebSocket)
    });
  }
}

/** Kết nối singleton socket. Chỉ gọi khi đã có token hợp lệ */
export function connectGlobalSocket(token: string) {
  // Dùng `active` thay `connected` — active = đang kết nối HOẶC đã kết nối
  if (globalClient?.active && globalToken === token) return;

  // Dispose client cũ nếu có
  if (globalClient) {
    globalClient.deactivate();
    activeStompSubs.clear();
  }

  globalToken = token;

  const client = new Client({
    webSocketFactory: () => new SockJS(`${import.meta.env.VITE_API_URL || 'http://localhost:8080'}/ws`),
    connectHeaders: { Authorization: `Bearer ${token}` },
    debug: () => {},
    reconnectDelay: 5000,
    heartbeatIncoming: 4000,
    heartbeatOutgoing: 4000,
  });

  client.onConnect = () => {
    broadcastConnectionState(true);
    console.log('[WS] Global STOMP connected');

    // Khôi phục tất cả topic mà components đã đăng ký trước khi socket sẵn sàng
    topicObservers.forEach((_, dest) => ensureStompSubscription(dest));

    // Subscribe các kênh hệ thống (badge counts) — đẩy thẳng vào Zustand store
    client.subscribe('/user/queue/notifications/unread', (msg: IMessage) => {
      if (msg.body) useNotificationStore.getState().setUnreadNotifs(Number(msg.body));
    });

    // Fallback Cấp 1: Khi nhận notification qua WebSocket + tab không foreground → show OS notification
    client.subscribe('/user/queue/notifications', (msg: IMessage) => {
      if (!msg.body) return;
      try {
        const data = JSON.parse(msg.body);
        showBrowserNotification(data.title || 'Thông báo mới', data.body || '', data.entityType);
      } catch { /* ignore parse error */ }
    });
    client.subscribe('/user/queue/messages/unread', (msg: IMessage) => {
      if (msg.body) useNotificationStore.getState().setUnreadMessages(Number(msg.body));
    });
    // Admin-only: subscribe admin unread count topic
    const currentUser = useAuthStore.getState().user;
    if (currentUser?.role === 'ADMIN') {
      client.subscribe('/topic/messages/unread/admin', (msg: IMessage) => {
        if (msg.body) useNotificationStore.getState().setUnreadMessages(Number(msg.body));
      });
    }

    // Auto-request FCM push permission ngay sau khi login (không cần click chuông)
    initFcmAfterLogin();
  };

  client.onWebSocketClose = () => broadcastConnectionState(false);

  client.onStompError = (frame) => {
    console.error('[WS] STOMP error:', frame.headers['message']);
  };

  client.activate();
  globalClient = client;
}

export function disconnectGlobalSocket() {
  globalToken = null;
  if (globalClient) {
    globalClient.deactivate();
    globalClient = null;
  }
  activeStompSubs.clear();
  broadcastConnectionState(false);
}

// ============================================================
// PUBLIC API: subscribe / unsubscribe / sendMessage
// Những hàm này KHÔNG phải hook — có thể gọi bất kỳ đâu.
// ============================================================

/**
 * Đăng ký lắng nghe 1 destination. Nhiều callback có thể cùng nghe 1 topic.
 * Nếu STOMP chưa connected → callback được lưu, sẽ subscribe khi onConnect.
 */
export function globalSubscribe(destination: string, callback: (msg: any) => void) {
  if (!topicObservers.has(destination)) {
    topicObservers.set(destination, new Set());
  }
  topicObservers.get(destination)!.add(callback);
  ensureStompSubscription(destination);
}

/**
 * Gỡ 1 callback khỏi destination. PHẢI truyền đúng callback reference.
 * Chỉ khi không còn ai nghe destination nữa thì mới hủy STOMP subscription.
 */
export function globalUnsubscribe(destination: string, callback: (msg: any) => void) {
  const observers = topicObservers.get(destination);
  if (!observers) return;

  observers.delete(callback);

  // Nếu không còn ai nghe → hủy STOMP subscription thật
  if (observers.size === 0) {
    topicObservers.delete(destination);
    const sub = activeStompSubs.get(destination);
    if (sub) {
      sub.unsubscribe();
      activeStompSubs.delete(destination);
    }
  }
}

// ============================================================
// REACT HOOK — Cầu nối giữa component React và singleton socket
// ============================================================

interface UseWebSocketProps {
  onNotification?: (notification: any) => void;
  onUnreadCountUpdate?: (count: number) => void;
}

export function useWebSocket(props: UseWebSocketProps = {}) {
  const { isAuthenticated } = useAuthStore();
  const token = localStorage.getItem('accessToken');
  const [isConnected, setIsConnected] = useState(globalConnected);

  // Giữ props mới nhất trong ref (tránh re-trigger effect)
  const propsRef = useRef(props);
  propsRef.current = props;

  // Đăng ký listener trạng thái kết nối
  useEffect(() => {
    const listener = (c: boolean) => setIsConnected(c);
    connectionListeners.add(listener);
    // Sync ngay trạng thái hiện tại (phòng socket đã connected trước khi component mount)
    setIsConnected(globalConnected);
    return () => { connectionListeners.delete(listener); };
  }, []);

  // Kết nối / Ngắt kết nối theo trạng thái auth
  useEffect(() => {
    if (isAuthenticated && token) {
      connectGlobalSocket(token);
    } else if (!isAuthenticated) {
      disconnectGlobalSocket();
    }
  }, [isAuthenticated, token]);

  // Backward compat: onNotification → subscribe /user/queue/notifications
  useEffect(() => {
    const handler = propsRef.current.onNotification;
    if (!handler) return;

    const dest = '/user/queue/notifications';
    globalSubscribe(dest, handler);
    return () => { globalUnsubscribe(dest, handler); };
  }, [props.onNotification]);

  // Backward compat: onUnreadCountUpdate → bridge qua Zustand store
  useEffect(() => {
    const handler = propsRef.current.onUnreadCountUpdate;
    if (!handler) return;
    return useNotificationStore.subscribe((state: { unreadNotifs: number }) => {
      handler(state.unreadNotifs);
    });
  }, [props.onUnreadCountUpdate]);

  // Expose subscribe/unsubscribe ổn định (không đổi reference)
  const subscribe = useCallback((destination: string, callback: (msg: any) => void) => {
    globalSubscribe(destination, callback);
  }, []);

  const unsubscribe = useCallback((destination: string, callback: (msg: any) => void) => {
    globalUnsubscribe(destination, callback);
  }, []);

  const sendMessage = useCallback((destination: string, body: any) => {
    if (globalClient?.connected) {
      globalClient.publish({ destination, body: JSON.stringify(body) });
      return true;
    }
    return false;
  }, []);

  return { isConnected, subscribe, unsubscribe, sendMessage };
}
