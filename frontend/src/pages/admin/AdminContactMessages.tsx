import { useState, useEffect } from 'react';
import { getAdminContactMessages, toggleContactMessageRead } from '../../services/contactApi';
import type { ContactMessage } from '../../services/contactApi';
import { Loader2, Mail, MailOpen, ChevronDown, ChevronUp, Inbox } from 'lucide-react';
import './AdminContactMessages.css';

export function AdminContactMessages() {
  const [messages, setMessages] = useState<ContactMessage[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [expandedId, setExpandedId] = useState<string | null>(null);

  useEffect(() => {
    fetchMessages();
  }, []);

  const fetchMessages = async () => {
    try {
      setLoading(true);
      const data = await getAdminContactMessages();
      setMessages(data);
    } catch (err) {
      console.error('Lỗi khi tải tin nhắn liên hệ', err);
      setError('Không thể lấy dữ liệu tin nhắn liên hệ.');
    } finally {
      setLoading(false);
    }
  };

  const handleToggleRead = async (id: string, currentStatus: boolean) => {
    setMessages(prev => prev.map(m => m.id === id ? { ...m, isRead: !m.isRead } : m));
    try {
      await toggleContactMessageRead(id);
    } catch (err) {
      console.error('Lỗi cập nhật trạng thái', err);
      setMessages(prev => prev.map(m => m.id === id ? { ...m, isRead: currentStatus } : m));
    }
  };

  const handleToggleExpand = (id: string) => {
    setExpandedId(prev => prev === id ? null : id);
  };

  const unreadCount = messages.filter(m => !m.isRead).length;

  return (
    <div className="admin-contact-page">
      <div className="admin-contact-header">
        <h2>Tin nhắn liên hệ</h2>
        <div className="admin-contact-stats">
          <span className="admin-contact-stat">
            <Inbox size={14} /> {messages.length} tin nhắn
          </span>
          {unreadCount > 0 && (
            <span className="admin-contact-stat unread">
              <Mail size={14} /> {unreadCount} chưa đọc
            </span>
          )}
        </div>
      </div>

      {error && <div className="admin-error-notice">{error}</div>}

      <div className="admin-contact-card">
        {loading ? (
          <div style={{ display: 'flex', justifyContent: 'center', padding: '3rem' }}>
            <Loader2 className="animate-spin" size={32} color="var(--color-primary)" />
          </div>
        ) : messages.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '3rem', color: 'var(--color-text-muted)' }}>
            Chưa có tin nhắn liên hệ nào.
          </div>
        ) : (
          <table className="admin-contact-table">
            <thead>
              <tr>
                <th>Người gửi</th>
                <th>Nội dung</th>
                <th>Thời gian</th>
                <th>Thao tác</th>
              </tr>
            </thead>
            <tbody>
              {messages.map(msg => (
                <>
                  <tr key={msg.id} className={msg.isRead ? '' : 'unread-row'} style={{ cursor: 'pointer' }} onClick={() => handleToggleExpand(msg.id)}>
                    <td>
                      <div className="contact-sender">
                        <span className="contact-sender-name">{msg.name}</span>
                        <span className="contact-sender-email">{msg.email}</span>
                      </div>
                    </td>
                    <td>
                      <div className="contact-subject">{msg.subject}</div>
                      <div className="contact-preview">{msg.message}</div>
                    </td>
                    <td>
                      <span className="contact-time">{new Date(msg.createdAt).toLocaleString('vi-VN')}</span>
                    </td>
                    <td>
                      <div style={{ display: 'flex', gap: '0.4rem', alignItems: 'center' }}>
                        <button
                          className={`contact-action-btn ${msg.isRead ? 'is-read' : ''}`}
                          onClick={(e) => { e.stopPropagation(); handleToggleRead(msg.id, msg.isRead); }}
                          title={msg.isRead ? 'Đánh dấu chưa đọc' : 'Đánh dấu đã đọc'}
                        >
                          {msg.isRead ? <MailOpen size={14} /> : <Mail size={14} />}
                          {msg.isRead ? 'Đã đọc' : 'Chưa đọc'}
                        </button>
                        {expandedId === msg.id ? <ChevronUp size={16} color="var(--color-text-muted)" /> : <ChevronDown size={16} color="var(--color-text-muted)" />}
                      </div>
                    </td>
                  </tr>
                  {expandedId === msg.id && (
                    <tr key={`${msg.id}-expanded`}>
                      <td colSpan={4} style={{ padding: 0 }}>
                        <div className="contact-expanded-message">{msg.message}</div>
                      </td>
                    </tr>
                  )}
                </>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
