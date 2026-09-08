import { Bell, BellRing, Check, Users, BookOpen, CreditCard, MessageSquare, CalendarCheck, CalendarX } from 'lucide-react';
import { useEffect, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';

import { notificationApi } from '../../services/notificationApi';
import type { NotificationResponseDTO } from '../../services/notificationApi';
import { messagingApi } from '../../services/messagingApi';
import { useWebSocket } from '../../hooks/useWebSocket';
import { useNotificationStore } from '../../store/useNotificationStore';
import { useAuthStore } from '../../store/useAuthStore';
import { formatDistanceToNow } from 'date-fns';
import { vi } from 'date-fns/locale';
import './NotificationDropdown.css';

/**
 * Parse createdAt — xử lý cả ISO string lẫn array format từ WebSocket.
 * Jackson có thể serialize LocalDateTime thành [2026,9,7,15,50,0] nếu thiếu JavaTimeModule.
 */
function parseNotificationDate(createdAt: string | number[]): Date {
  if (Array.isArray(createdAt)) {
    const [year, month, day, hour = 0, minute = 0, second = 0] = createdAt;
    return new Date(year, month - 1, day, hour, minute, second);
  }
  return new Date(createdAt);
}

export function NotificationDropdown() {
  const [notifications, setNotifications] = useState<NotificationResponseDTO[]>([]);
  const { unreadNotifs: unreadCount, setUnreadNotifs: setUnreadCount } = useNotificationStore();
  const [isOpen, setIsOpen] = useState(false);
  const [pushPermission, setPushPermission] = useState<NotificationPermission>(
    'Notification' in window ? Notification.permission : 'denied'
  );
  const dropdownRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();

  /** Xin quyền push notification — phải gọi từ user gesture (tap/click) trên mobile */
  const handleEnablePush = async () => {
    try {
      const { requestNotificationPermission } = await import('../../firebase');
      const { registerPushToken } = await import('../../services/pushNotificationService');

      const token = await requestNotificationPermission();
      setPushPermission(Notification.permission);

      if (token) {
        await registerPushToken(token);
      }
    } catch (error) {
      console.error('[Push] Failed to enable:', error);
    }
  };

  // Connect to STOMP and listen for exact topics
  useWebSocket({
    onNotification: (notif) => {
      setNotifications(prev => [notif, ...prev]);
      // Fix: tăng badge count ngay khi nhận notification qua WebSocket
      if (!notif.isRead) {
        useNotificationStore.getState().setUnreadNotifs(
          useNotificationStore.getState().unreadNotifs + 1
        );
      }
    },
  });

  useEffect(() => {
    fetchInitialData();
    
    // FCM foreground listener — nhận push notification real-time
    let unsubFcm: (() => void) | null = null;
    import('../../firebase').then(({ onForegroundMessage }) => {
      unsubFcm = onForegroundMessage((payload) => {
        // Khi nhận FCM push ở foreground → refresh notification data ngay
        fetchInitialData();
        // Hiện OS notification
        if (payload.notification) {
          import('../../services/pushNotificationService').then(({ showBrowserNotification }) => {
            showBrowserNotification(
              payload.notification?.title || 'Thông báo mới',
              payload.notification?.body || '',
              payload.data?.entityType
            );
          });
        }
      });
    });

    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);

    // Lắng nghe click notification từ Service Worker (khi tab đã mở)
    const handleSwMessage = (event: MessageEvent) => {
      if (event.data?.type === 'NOTIFICATION_CLICK' && event.data.entityType) {
        navigateToNotification({
          entityType: event.data.entityType,
          entityId: event.data.entityId,
        } as NotificationResponseDTO);
      }
    };
    navigator.serviceWorker?.addEventListener('message', handleSwMessage);

    // Lắng nghe custom event refresh-notifications (khi tạo lớp, gửi form...)
    const handleRefresh = () => fetchInitialData();
    window.addEventListener('refresh-notifications', handleRefresh);

    return () => {
      unsubFcm?.();
      document.removeEventListener('mousedown', handleClickOutside);
      navigator.serviceWorker?.removeEventListener('message', handleSwMessage);
      window.removeEventListener('refresh-notifications', handleRefresh);
    };
  }, []);

  const fetchInitialData = async () => {
    try {
      const [notifRes, countRes, msgCountRes] = await Promise.all([
        notificationApi.getMyNotifications(0, 5),
        notificationApi.getUnreadCount(),
        messagingApi.getUnreadCount()
      ]);

      setNotifications(notifRes.data?.content || []);
      // Sync unread count vào Zustand store (source of truth cho badge)
      useNotificationStore.getState().setUnreadNotifs(countRes.data?.count || 0);
      useNotificationStore.getState().setUnreadMessages(msgCountRes.data?.count || 0);
    } catch (error) {
      console.error('Lỗi khi tải thông báo:', error);
    }
  };

  const handleMarkAllRead = async (e: React.MouseEvent) => {
    e.stopPropagation();
    try {
      await notificationApi.markAllAsRead();
      setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
      setUnreadCount(0);
    } catch (error) {
      console.error(error);
    }
  };

  const handleNotificationClick = async (notif: NotificationResponseDTO) => {
    if (!notif.isRead) {
      try {
        await notificationApi.markAsRead(notif.id);
        setNotifications(prev => prev.map(n => n.id === notif.id ? { ...n, isRead: true } : n));
        setUnreadCount(Math.max(0, unreadCount - 1));
      } catch (error) {
        console.error(error);
      }
    }
    
    setIsOpen(false);
    navigateToNotification(notif);
  };

  /**
   * Build redirect path dựa trên entityType + role.
   * Mỗi entityType map chính xác tới trang phù hợp cho từng role.
   */
  const buildRedirectPath = (notif: NotificationResponseDTO): string => {
    const role = useAuthStore.getState().user?.role;
    const entityParam = notif.entityId ? `?highlightId=${notif.entityId}` : '';

    // Admin — redirect về trang quản trị tương ứng
    if (role === 'ADMIN') {
      const adminMap: Record<string, string> = {
        CLASS: '/admin/classes',
        SESSION: '/admin/schedules',
        APPLICATION: '/admin/class-applications',
        INVOICE: '/admin/payments',
        ABSENCE: '/admin/absences',
        CONVERSATION: '/admin/messages',
        VERIFICATION: '/admin/verification',
        CONTACT_MESSAGE: '/admin/contact-messages',
        MATERIAL: '/admin/classes',
        ASSESSMENT: '/admin/classes',
        SUBMISSION: '/admin/classes',
      };
      return (adminMap[notif.entityType ?? ''] ?? '/admin/dashboard') + entityParam;
    }

    // Student — redirect tới trang học sinh phù hợp
    if (role === 'STUDENT') {
      const studentMap: Record<string, string> = {
        CLASS: '/student/requests',
        SESSION: '/student/schedule',
        APPLICATION: '/student/requests',
        INVOICE: '/student/payment',
        ABSENCE: '/student/schedule',
        CONVERSATION: '/student/messages',
        MATERIAL: '/student/teaching',
        ASSESSMENT: '/student/teaching',
        SUBMISSION: '/student/teaching',
      };
      return (studentMap[notif.entityType ?? ''] ?? '/student/dashboard') + entityParam;
    }

    // Parent — redirect tới trang phụ huynh phù hợp
    if (role === 'PARENT') {
      const parentMap: Record<string, string> = {
        CLASS: '/parent/dashboard',
        SESSION: '/parent/schedule',
        APPLICATION: '/parent/applicants',
        INVOICE: '/parent/payment',
        ABSENCE: '/parent/schedule',
        CONVERSATION: '/parent/messages',
        MATERIAL: '/parent/teaching',
        ASSESSMENT: '/parent/teaching',
        SUBMISSION: '/parent/teaching',
      };
      return (parentMap[notif.entityType ?? ''] ?? '/parent/dashboard') + entityParam;
    }

    // Tutor — redirect tới trang gia sư phù hợp
    const tutorMap: Record<string, string> = {
      CLASS: '/tutor/classes',
      SESSION: '/tutor/schedule',
      APPLICATION: '/tutor/classes',
      INVOICE: '/tutor/revenue',
      ABSENCE: '/tutor/schedule',
      CONVERSATION: '/tutor/messages',
      MATERIAL: '/tutor/teaching',
      ASSESSMENT: '/tutor/teaching',
      SUBMISSION: '/tutor/teaching',
    };
    return (tutorMap[notif.entityType ?? ''] ?? '/tutor/dashboard') + entityParam;
  };

  /**
   * Navigate tới notification target.
   * Dùng state.notifTimestamp để force re-render dù cùng URL.
   */
  const navigateToNotification = (notif: NotificationResponseDTO) => {
    const targetPath = buildRedirectPath(notif);
    navigate(targetPath, {
      state: { notifTimestamp: Date.now(), entityId: notif.entityId },
    });
  };

  const getIcon = (type: string) => {
    switch (type) {
      case 'CLASS_OPENED':
      case 'CLASS_CANCELLED':
        return <BookOpen size={16} className="text-blue-500" />;
      case 'APPLICATION_RECEIVED':
      case 'APPLICATION_ACCEPTED':
      case 'APPLICATION_REJECTED':
        return <Users size={16} className="text-purple-500" />;
      case 'INVOICE_RECEIPT_UPLOADED':
      case 'INVOICE_APPROVED':
      case 'INVOICE_REJECTED':
      case 'PAYOUT_TRANSFERRED':
        return <CreditCard size={16} className="text-green-500" />;
      case 'SESSION_REMINDER':
      case 'MEET_LINK_SET':
      case 'SCHEDULE_UPDATED':
      case 'SCHEDULE_CONFIRMED':
        return <CalendarCheck size={16} className="text-orange-500" />;
      case 'ABSENCE_REQUESTED':
      case 'ABSENCE_APPROVED':
      case 'ABSENCE_REJECTED':
        return <CalendarX size={16} className="text-red-500" />;
      case 'NEW_MESSAGE':
        return <MessageSquare size={16} className="text-indigo-500" />;
      default:
        return <Bell size={16} className="text-gray-500" />;
    }
  };

  return (
    <div className="notification-wrapper" ref={dropdownRef}>
      <button 
        className="notif-trigger-btn" 
        onClick={() => {
          const willOpen = !isOpen;
          setIsOpen(willOpen);
          // Refetch data khi mở dropdown để đảm bảo badge count chính xác
          if (willOpen) fetchInitialData();
        }}
        title="Thông báo"
      >
        <Bell size={18} />
        {unreadCount > 0 && (
          <span className="notif-badge">{unreadCount > 99 ? '99+' : unreadCount}</span>
        )}
      </button>

      {isOpen && (
        <div className="notification-dropdown">
          {pushPermission !== 'granted' && (
            <button className="push-enable-banner" onClick={handleEnablePush}>
              <BellRing size={16} />
              Bật thông báo đẩy để không bỏ lỡ tin mới
            </button>
          )}

          <div className="notification-header">
            <h3>Thông báo</h3>
            {unreadCount > 0 && (
              <button className="mark-read-btn" onClick={handleMarkAllRead}>
                <Check size={14} /> Đánh dấu tất cả đã đọc
              </button>
            )}
          </div>

          <div className="notification-body">
            {notifications.length === 0 ? (
              <div className="notification-empty">
                Chưa có thông báo nào
              </div>
            ) : (
              notifications.map(notif => (
                <div 
                  key={notif.id} 
                  className={`notification-item ${notif.isRead ? 'read' : 'unread'}`}
                  onClick={() => handleNotificationClick(notif)}
                >
                  <div className="notification-icon">
                    {getIcon(notif.type)}
                  </div>
                  <div className="notification-content">
                    <p className="notification-title">{notif.title}</p>
                    <p className="notification-text">{notif.body}</p>
                    <span className="notification-time">
                      {formatDistanceToNow(parseNotificationDate(notif.createdAt), { addSuffix: true, locale: vi })}
                    </span>
                  </div>
                  {!notif.isRead && <div className="notification-dot" />}
                </div>
              ))
            )}
          </div>
          
          <div className="notification-footer">
            <button onClick={() => {
              setIsOpen(false);
              const role = useAuthStore.getState().user?.role;
              const prefix = role === 'ADMIN' ? '/admin'
                : role === 'TUTOR' ? '/tutor'
                : role === 'STUDENT' ? '/student'
                : '/parent';
              navigate(`${prefix}/notifications`);
            }}>
              Xem tất cả thông báo
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
