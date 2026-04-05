/* eslint-disable no-restricted-globals */

// Firebase Messaging Service Worker
// Xử lý push notification khi browser ở background hoặc tab đã đóng

importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js');

// Firebase config — phải khớp với firebase.ts
firebase.initializeApp({
  apiKey: 'AIzaSyBy-s5QojwrSC4OT2F35ngulyCsyzETanQ',
  authDomain: 'giasutinhhoa-auth-77fbd.firebaseapp.com',
  projectId: 'giasutinhhoa-auth-77fbd',
  storageBucket: 'giasutinhhoa-auth-77fbd.firebasestorage.app',
  messagingSenderId: '1028500397829',
  appId: '1:1028500397829:web:b9d035f7c68e0685fe616c'
});

const messaging = firebase.messaging();

// Xử lý notification khi browser ở background
messaging.onBackgroundMessage((payload) => {
  console.log('[SW] Background message:', payload);

  const notificationTitle = payload.notification?.title || 'Gia Sư Tinh Hoa';
  const notificationOptions = {
    body: payload.notification?.body || 'Bạn có thông báo mới',
    icon: '/logo.webp',
    badge: '/logo.webp',
    tag: payload.data?.entityType || 'general',
    data: {
      entityType: payload.data?.entityType,
      entityId: payload.data?.entityId,
      url: buildNavigationUrl(payload.data?.entityType)
    },
    // Tự động đóng sau 10 giây
    requireInteraction: false,
    vibrate: [200, 100, 200]
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});

// Click notification → gửi message cho tab React xử lý navigation (role-aware)
self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  const entityType = event.notification.data?.entityType || '';

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((windowClients) => {
      // Nếu đã có tab mở → focus và gửi message để React navigate
      for (const client of windowClients) {
        if (client.url.includes(self.location.origin)) {
          client.focus();
          client.postMessage({
            type: 'NOTIFICATION_CLICK',
            entityType: entityType
          });
          return;
        }
      }
      // Nếu chưa có tab → mở trang chủ (React sẽ redirect nếu đã login)
      return clients.openWindow('/');
    })
  );
});
