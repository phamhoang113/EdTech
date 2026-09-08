import { useState, useEffect, useCallback } from 'react';
import { Bell, BookOpen, Users, CreditCard, MessageSquare, CalendarCheck, CalendarX, CheckCheck } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { formatDistanceToNow } from 'date-fns';
import { vi } from 'date-fns/locale';

import { notificationApi } from '../../services/notificationApi';
import type { NotificationResponseDTO } from '../../services/notificationApi';
import { useNotificationStore } from '../../store/useNotificationStore';
import { useAuthStore } from '../../store/useAuthStore';
import './Dashboard.css';

/* ── Constants ── */
const PAGE_SIZE = 15;

const ENTITY_TYPE_LABELS: Record<string, string> = {
  CLASS: 'Lớp học',
  SESSION: 'Buổi học',
  APPLICATION: 'Ứng tuyển',
  INVOICE: 'Thanh toán',
  ABSENCE: 'Nghỉ phép',
  CONVERSATION: 'Tin nhắn',
  VERIFICATION: 'Xác minh',
  MATERIAL: 'Tài liệu',
  ASSESSMENT: 'Bài kiểm tra',
  SUBMISSION: 'Bài nộp',
  CONTACT_MESSAGE: 'Liên hệ',
};

/* ── Helpers ── */
function parseNotificationDate(createdAt: string | number[]): Date {
  if (Array.isArray(createdAt)) {
    const [year, month, day, hour = 0, minute = 0, second = 0] = createdAt;
    return new Date(year, month - 1, day, hour, minute, second);
  }
  return new Date(createdAt);
}

function getNotificationIcon(type: string) {
  switch (type) {
    case 'CLASS_OPENED':
    case 'CLASS_CANCELLED':
      return <BookOpen size={18} className="text-blue-500" />;
    case 'APPLICATION_RECEIVED':
    case 'APPLICATION_ACCEPTED':
    case 'APPLICATION_REJECTED':
      return <Users size={18} className="text-purple-500" />;
    case 'INVOICE_RECEIPT_UPLOADED':
    case 'INVOICE_APPROVED':
    case 'INVOICE_REJECTED':
    case 'PAYOUT_TRANSFERRED':
      return <CreditCard size={18} className="text-green-500" />;
    case 'SESSION_REMINDER':
    case 'MEET_LINK_SET':
    case 'SCHEDULE_UPDATED':
    case 'SCHEDULE_CONFIRMED':
      return <CalendarCheck size={18} className="text-orange-500" />;
    case 'ABSENCE_REQUESTED':
    case 'ABSENCE_APPROVED':
    case 'ABSENCE_REJECTED':
      return <CalendarX size={18} className="text-red-500" />;
    case 'NEW_MESSAGE':
      return <MessageSquare size={18} className="text-indigo-500" />;
    default:
      return <Bell size={18} className="text-gray-500" />;
  }
}

/* ── Component ── */
export function NotificationsPage() {
  const navigate = useNavigate();
  const { setUnreadNotifs } = useNotificationStore();
  const role = useAuthStore.getState().user?.role;

  const [notifications, setNotifications] = useState<NotificationResponseDTO[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [filterType, setFilterType] = useState<string>('ALL');

  const fetchNotifications = useCallback(async (pageNum: number) => {
    setLoading(true);
    try {
      const res = await notificationApi.getMyNotifications(pageNum, PAGE_SIZE);
      setNotifications(res.data?.content || []);
      setTotalPages(res.data?.totalPages || 0);
    } catch (error) {
      console.error('Lỗi khi tải thông báo:', error);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchNotifications(page);
  }, [page, fetchNotifications]);

  const handleMarkAllRead = async () => {
    try {
      await notificationApi.markAllAsRead();
      setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
      setUnreadNotifs(0);
    } catch (error) {
      console.error(error);
    }
  };

  const handleNotificationClick = async (notif: NotificationResponseDTO) => {
    if (!notif.isRead) {
      try {
        await notificationApi.markAsRead(notif.id);
        setNotifications(prev => prev.map(n => n.id === notif.id ? { ...n, isRead: true } : n));
        const currentCount = useNotificationStore.getState().unreadNotifs;
        setUnreadNotifs(Math.max(0, currentCount - 1));
      } catch (error) {
        console.error(error);
      }
    }

    // Navigate dựa trên entityType — mapping chính xác theo từng role
    const entityParam = notif.entityId ? `?highlightId=${notif.entityId}` : '';

    const routeMap: Record<string, Record<string, string>> = {
      ADMIN: {
        CLASS: '/admin/classes', SESSION: '/admin/schedules', APPLICATION: '/admin/class-applications',
        INVOICE: '/admin/payments', ABSENCE: '/admin/absences', CONVERSATION: '/admin/messages',
        VERIFICATION: '/admin/verification', CONTACT_MESSAGE: '/admin/contact-messages',
        MATERIAL: '/admin/classes', ASSESSMENT: '/admin/classes', SUBMISSION: '/admin/classes',
      },
      STUDENT: {
        CLASS: '/student/requests', SESSION: '/student/schedule', APPLICATION: '/student/requests',
        INVOICE: '/student/payment', ABSENCE: '/student/schedule', CONVERSATION: '/student/messages',
        MATERIAL: '/student/teaching', ASSESSMENT: '/student/teaching', SUBMISSION: '/student/teaching',
      },
      PARENT: {
        CLASS: '/parent/dashboard', SESSION: '/parent/schedule', APPLICATION: '/parent/applicants',
        INVOICE: '/parent/payment', ABSENCE: '/parent/schedule', CONVERSATION: '/parent/messages',
        MATERIAL: '/parent/teaching', ASSESSMENT: '/parent/teaching', SUBMISSION: '/parent/teaching',
      },
      TUTOR: {
        CLASS: '/tutor/classes', SESSION: '/tutor/schedule', APPLICATION: '/tutor/classes',
        INVOICE: '/tutor/revenue', ABSENCE: '/tutor/schedule', CONVERSATION: '/tutor/messages',
        MATERIAL: '/tutor/teaching', ASSESSMENT: '/tutor/teaching', SUBMISSION: '/tutor/teaching',
      },
    };

    const targetPath = routeMap[role ?? 'STUDENT']?.[notif.entityType ?? ''];
    if (targetPath) {
      navigate(targetPath + entityParam, {
        state: { notifTimestamp: Date.now(), entityId: notif.entityId },
      });
    }
  };

  // Filter notifications
  const filteredNotifications = filterType === 'ALL'
    ? notifications
    : notifications.filter(n => n.entityType === filterType);

  const unreadCount = notifications.filter(n => !n.isRead).length;

  return (
    <>
      <div className="dash-section-head" style={{ marginBottom: 0 }}>
        <h2 className="dash-section-title" style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <Bell size={20} /> Thông báo
          {unreadCount > 0 && (
            <span style={{
              display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
              minWidth: 22, height: 22, padding: '0 6px', borderRadius: 11,
              background: '#ef4444', color: '#fff', fontSize: '0.75rem', fontWeight: 800,
            }}>
              {unreadCount}
            </span>
          )}
        </h2>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
          {unreadCount > 0 && (
            <button className="dash-see-all" onClick={handleMarkAllRead} style={{ display: 'flex', alignItems: 'center', gap: 4 }}>
              <CheckCheck size={14} /> Đánh dấu tất cả đã đọc
            </button>
          )}
        </div>
      </div>

      {/* Filter chips */}
      <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap', margin: '12px 0 16px' }}>
        {['ALL', 'CLASS', 'SESSION', 'APPLICATION', 'INVOICE', 'CONVERSATION'].map(type => (
          <button
            key={type}
            onClick={() => setFilterType(type)}
            style={{
              padding: '5px 12px', borderRadius: 20, border: '1px solid var(--color-border)',
              background: filterType === type ? 'var(--color-primary, #6366f1)' : 'var(--color-surface)',
              color: filterType === type ? '#fff' : 'var(--color-text-secondary)',
              fontSize: '0.78rem', fontWeight: 600, cursor: 'pointer',
              transition: 'all 0.2s',
            }}
          >
            {type === 'ALL' ? 'Tất cả' : ENTITY_TYPE_LABELS[type] || type}
          </button>
        ))}
      </div>

      {/* Notification list */}
      <div className="dash-panel" style={{ padding: 0 }}>
        {loading ? (
          <div style={{ padding: 40, textAlign: 'center', color: 'var(--color-text-muted)' }}>
            Đang tải thông báo...
          </div>
        ) : filteredNotifications.length === 0 ? (
          <div style={{ padding: 40, textAlign: 'center', color: 'var(--color-text-muted)' }}>
            <Bell size={32} style={{ opacity: 0.3, marginBottom: 8 }} />
            <p>Chưa có thông báo nào</p>
          </div>
        ) : (
          filteredNotifications.map(notif => (
            <div
              key={notif.id}
              onClick={() => handleNotificationClick(notif)}
              style={{
                display: 'flex', gap: 14, padding: '16px 20px',
                borderBottom: '1px solid var(--color-border, #f3f4f6)',
                cursor: notif.entityType ? 'pointer' : 'default',
                background: notif.isRead ? 'transparent' : 'rgba(99, 102, 241, 0.04)',
                transition: 'background 0.2s',
                position: 'relative',
              }}
              className="notif-page-item"
            >
              <div style={{
                width: 40, height: 40, borderRadius: '50%',
                background: 'var(--color-surface-hover, #f3f4f6)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                flexShrink: 0,
              }}>
                {getNotificationIcon(notif.type)}
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <p style={{
                  margin: '0 0 4px', fontSize: '0.9rem',
                  fontWeight: notif.isRead ? 500 : 700,
                  color: 'var(--color-text)',
                }}>
                  {notif.title}
                </p>
                <p style={{
                  margin: '0 0 6px', fontSize: '0.83rem',
                  color: 'var(--color-text-secondary)',
                  lineHeight: 1.4,
                }}>
                  {notif.body}
                </p>
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)', fontWeight: 500 }}>
                    {formatDistanceToNow(parseNotificationDate(notif.createdAt), { addSuffix: true, locale: vi })}
                  </span>
                  {notif.entityType && (
                    <span style={{
                      fontSize: '0.68rem', fontWeight: 600,
                      padding: '1px 8px', borderRadius: 10,
                      background: 'rgba(99, 102, 241, 0.1)', color: '#6366f1',
                    }}>
                      {ENTITY_TYPE_LABELS[notif.entityType] || notif.entityType}
                    </span>
                  )}
                </div>
              </div>
              {!notif.isRead && (
                <div style={{
                  width: 10, height: 10, borderRadius: '50%',
                  background: '#ef4444', flexShrink: 0, alignSelf: 'center',
                }} />
              )}
            </div>
          ))
        )}
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div style={{ display: 'flex', justifyContent: 'center', gap: 8, marginTop: 16 }}>
          <button
            onClick={() => setPage(p => Math.max(0, p - 1))}
            disabled={page === 0}
            style={{
              padding: '8px 16px', borderRadius: 8,
              border: '1px solid var(--color-border)',
              background: 'var(--color-surface)',
              color: page === 0 ? 'var(--color-text-muted)' : 'var(--color-text)',
              cursor: page === 0 ? 'not-allowed' : 'pointer',
              fontWeight: 600, fontSize: '0.85rem',
            }}
          >
            ← Trước
          </button>
          <span style={{
            padding: '8px 12px', fontSize: '0.85rem',
            color: 'var(--color-text-secondary)', fontWeight: 600,
            display: 'flex', alignItems: 'center',
          }}>
            {page + 1} / {totalPages}
          </span>
          <button
            onClick={() => setPage(p => Math.min(totalPages - 1, p + 1))}
            disabled={page >= totalPages - 1}
            style={{
              padding: '8px 16px', borderRadius: 8,
              border: '1px solid var(--color-border)',
              background: 'var(--color-surface)',
              color: page >= totalPages - 1 ? 'var(--color-text-muted)' : 'var(--color-text)',
              cursor: page >= totalPages - 1 ? 'not-allowed' : 'pointer',
              fontWeight: 600, fontSize: '0.85rem',
            }}
          >
            Sau →
          </button>
        </div>
      )}
    </>
  );
}
