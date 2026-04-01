import { Bell, Check, Users, BookOpen, CreditCard, ClockAlert, MessageSquare } from 'lucide-react';
import { useEffect, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';

import { notificationApi } from '../../services/notificationApi';
import type { NotificationResponseDTO } from '../../services/notificationApi';
import { messagingApi } from '../../services/messagingApi';
import { useWebSocket } from '../../hooks/useWebSocket';
import { useNotificationStore } from '../../store/useNotificationStore';
import { formatDistanceToNow } from 'date-fns';
import { vi } from 'date-fns/locale';
import './NotificationDropdown.css';

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
    fetchInitialData();
    
    const handleClickOutside = (e: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
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
    switch (notif.entityType) {
      case 'CLASS':
        navigate('/admin/classes');
        break;
      case 'SESSION':
        navigate('/admin/schedules');
        break;
      case 'APPLICATION':
        navigate('/admin/class-applications');
        break;
      case 'INVOICE':
        navigate('/admin/payments');
        break;
      case 'ABSENCE':
        navigate('/admin/absences');
        break;
      case 'CONVERSATION':
        navigate('/messages');
        break;
      case 'VERIFICATION':
        navigate('/admin/verification');
        break;
      default:
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
