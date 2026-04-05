import { Bell, Check, Users, BookOpen, CreditCard, ClockAlert, MessageSquare } from 'lucide-react';
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

const DAILY_RESET_KEY = 'notif_last_reset_date';

/**
 * Kiểm tra xem đã sang ngày mới chưa → nếu rồi thì mark all as read
 */
async function checkDailyReset() {
  const today = new Date().toISOString().slice(0, 10); // YYYY-MM-DD
  const lastReset = localStorage.getItem(DAILY_RESET_KEY);

  if (lastReset !== today) {
    try {
      await notificationApi.markAllAsRead();
      localStorage.setItem(DAILY_RESET_KEY, today);
    } catch {
      // Nếu lỗi thì bỏ qua, sẽ thử lại lần sau
    }
  }
}

export function NotificationDropdown() {
  const [notifications, setNotifications] = useState<NotificationResponseDTO[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const navigate = useNavigate();

  // Connect to STOMP and listen for exact topics
  useWebSocket({
    onNotification: (notif) => {
      setNotifications(prev => [notif, ...prev]);
    },
    onUnreadCountUpdate: (count) => {
      setUnreadCount(count);
    }
  });

  useEffect(() => {
    checkDailyReset().then(() => fetchInitialData());
    
    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);

    // Lắng nghe click notification từ Service Worker (khi tab đã mở)
    const handleSwMessage = (event: MessageEvent) => {
      if (event.data?.type === 'NOTIFICATION_CLICK' && event.data.entityType) {
        navigateByEntityType({ entityType: event.data.entityType } as NotificationResponseDTO);
      }
    };
    navigator.serviceWorker?.addEventListener('message', handleSwMessage);

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      navigator.serviceWorker?.removeEventListener('message', handleSwMessage);
    };
  }, []);

  const fetchInitialData = async () => {
    try {
      const [notifRes, countRes, msgCountRes] = await Promise.all([
        notificationApi.getMyNotifications(0, 5),
        notificationApi.getUnreadCount(),
        messagingApi.getUnreadCount()
      ]);
      setNotifications(notifRes.data.content || []);
      setUnreadCount(countRes.data.count || 0);
      useNotificationStore.getState().setUnreadMessages(msgCountRes.data.count || 0);
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
      // Cập nhật daily reset timestamp
      localStorage.setItem(DAILY_RESET_KEY, new Date().toISOString().slice(0, 10));
    } catch (error) {
      console.error(error);
    }
  };

  const handleNotificationClick = async (notif: NotificationResponseDTO) => {
    if (!notif.isRead) {
      try {
        await notificationApi.markAsRead(notif.id);
        setNotifications(prev => prev.map(n => n.id === notif.id ? { ...n, isRead: true } : n));
        setUnreadCount(prev => Math.max(0, prev - 1));
      } catch (error) {
        console.error(error);
      }
    }
    
    setIsOpen(false);
    navigateByEntityType(notif);
  };

  const navigateByEntityType = (notif: NotificationResponseDTO) => {
    const role = useAuthStore.getState().user?.role;
    const rolePrefix = role === 'ADMIN' ? '/admin'
      : role === 'TUTOR' ? '/tutor'
      : role === 'STUDENT' ? '/student'
      : '/parent';

    switch (notif.entityType) {
      case 'CLASS':
        navigate(role === 'ADMIN' ? '/admin/classes' : `${rolePrefix}/dashboard`);
        break;
      case 'SESSION':
        navigate(role === 'ADMIN' ? '/admin/schedules' : `${rolePrefix}/schedule`);
        break;
      case 'APPLICATION':
        navigate(role === 'ADMIN' ? '/admin/class-applications' : `${rolePrefix}/dashboard`);
        break;
      case 'INVOICE':
        navigate(role === 'ADMIN' ? '/admin/payments' : `${rolePrefix}/payment`);
        break;
      case 'ABSENCE':
        navigate(role === 'ADMIN' ? '/admin/absences' : `${rolePrefix}/schedule`);
        break;
      case 'CONVERSATION':
        navigate(role === 'ADMIN' ? '/admin/messages' : `${rolePrefix}/messages`);
        break;
      case 'VERIFICATION':
        navigate('/admin/verification');
        break;
      default:
        navigate(`${rolePrefix}/dashboard`);
        break;
    }
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
        return <ClockAlert size={16} className="text-orange-500" />;
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
        onClick={() => setIsOpen(!isOpen)}
        title="Thông báo"
      >
        <Bell size={18} />
        {unreadCount > 0 && (
          <span className="notif-badge">{unreadCount > 99 ? '99+' : unreadCount}</span>
        )}
      </button>

      {isOpen && (
        <div className="notification-dropdown">
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
                      {formatDistanceToNow(new Date(notif.createdAt), { addSuffix: true, locale: vi })}
                    </span>
                  </div>
                  {!notif.isRead && <div className="notification-dot" />}
                </div>
              ))
            )}
          </div>
          
          <div className="notification-footer">
            <button onClick={() => { setIsOpen(false); navigate('/notifications'); }}>
              Xem tất cả thông báo
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
