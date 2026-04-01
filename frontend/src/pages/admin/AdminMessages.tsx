import { Send, MessageSquare, UserPlus, X, Phone, Mail, Calendar, MapPin, Star, Shield, ImageIcon, Images } from 'lucide-react';
import { useState, useEffect, useRef, useCallback } from 'react';
import { createPortal } from 'react-dom';
import { useSearchParams } from 'react-router-dom';

import { messagingApi } from '../../services/messagingApi';
import type { ConversationResponseDTO, MessageResponseDTO } from '../../services/messagingApi';
import { useWebSocket } from '../../hooks/useWebSocket';
import { formatDistanceToNow, format } from 'date-fns';
import { vi } from 'date-fns/locale';
import { adminApi } from '../../services/adminApi';
import type { AdminUserDetail } from '../../services/adminApi';
import './AdminMessages.css';

/** Pending new conversation state when admin initiates chat with a user */
interface PendingNewConversation {
  userId: string;
  fullName: string;
  role: string;
}

export function AdminMessages() {
  const [searchParams, setSearchParams] = useSearchParams();

  const [conversations, setConversations] = useState<ConversationResponseDTO[]>([]);
  const [activeConv, setActiveConv] = useState<ConversationResponseDTO | null>(null);
  const [pendingNew, setPendingNew] = useState<PendingNewConversation | null>(null);
  const [messages, setMessages] = useState<MessageResponseDTO[]>([]);
  const [inputText, setInputText] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [userDetail, setUserDetail] = useState<AdminUserDetail | null>(null);
  const [isDetailLoading, setIsDetailLoading] = useState(false);
  const [isSendingImage, setIsSendingImage] = useState(false);
  const [previewImage, setPreviewImage] = useState<string | null>(null);

  const scrollToMessage = (msgId: string) => {
    const el = document.getElementById(`msg-${msgId}`);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'center' });
      el.classList.add('highlight-msg');
      setTimeout(() => el.classList.remove('highlight-msg'), 2000);
    }
  };

  const [showGallery, setShowGallery] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const processedParamRef = useRef(false);
  
  const { isConnected, subscribe, unsubscribe } = useWebSocket();

  // Refs cho stable callbacks (tránh closure stale)
  const activeConvRef = useRef(activeConv);
  activeConvRef.current = activeConv;

  // Stable callback: khi nhận unread admin → refresh danh sách
  const handleUnreadAdmin = useCallback(() => {
    fetchConversations(true);
  }, []);

  // Stable callback: khi nhận tin nhắn mới trong conversation đang mở
  const handleConversationMessage = useCallback((msg: MessageResponseDTO) => {
    setMessages(prev => {
      if (prev.find(m => m.id === msg.id)) return prev;
      return [...prev, msg];
    });
    const conv = activeConvRef.current;
    if (conv) {
      updateConversationList(conv.id, msg);
      if (msg.senderId !== conv.userId) {
        markAsRead(conv);
      }
    }
  }, []);

  // Load conversations on mount
  useEffect(() => {
    fetchConversations();
  }, []);

  // Handle userId query param after conversations are loaded
  useEffect(() => {
    if (isLoading || processedParamRef.current) return;

    const targetUserId = searchParams.get('userId');
    if (!targetUserId) return;

    processedParamRef.current = true;

    // Try to find existing conversation
    const match = conversations.find(c => c.userId === targetUserId);
    if (match) {
      setActiveConv(match);
      setPendingNew(null);
    } else {
      // No existing conversation — fetch user info for new conversation panel
      setActiveConv(null);
      loadPendingUser(targetUserId);
    }

    // Clear query param from URL
    setSearchParams({}, { replace: true });
  }, [isLoading, conversations, searchParams]);

  // When activeConv changes, fetch messages
  useEffect(() => {
    if (activeConv) {
      setPendingNew(null);
      setShowGallery(false);
      fetchMessages(activeConv.id);
      markAsRead(activeConv);
    }
  }, [activeConv]);

  // STOMP subscription: unread badge cho admin
  useEffect(() => {
    if (!isConnected) return;
    const dest = '/topic/messages/unread/admin';
    subscribe(dest, handleUnreadAdmin);
    return () => {
      unsubscribe(dest, handleUnreadAdmin);
    };
  }, [isConnected, subscribe, unsubscribe, handleUnreadAdmin]);

  // STOMP subscription: tin nhắn conversation đang mở
  useEffect(() => {
    if (!isConnected || !activeConv) return;
    
    const dest = `/topic/messages/${activeConv.id}`;
    subscribe(dest, handleConversationMessage);

    return () => {
      unsubscribe(dest, handleConversationMessage);
    };
  }, [isConnected, activeConv?.id, subscribe, unsubscribe, handleConversationMessage]);

  const loadPendingUser = async (userId: string) => {
    try {
      const res = await adminApi.getUserDetail(userId);
      const user = res.data;
      setPendingNew({
        userId: user.id,
        fullName: user.fullName,
        role: user.role,
      });
    } catch {
      console.error('Không thể tải thông tin người dùng');
      setPendingNew(null);
    }
  };

  const fetchConversations = async (silent = false) => {
    try {
      if (!silent) setIsLoading(true);
      const res = await messagingApi.getConversations(0, 50);
      const convList = res.data?.content ?? [];
      setConversations(convList);
      
      // Auto-select first conversation only on initial load (no active conv yet)
      if (convList.length > 0 && !activeConvRef.current && !searchParams.get('userId')) {
        setActiveConv(convList[0]);
      }
    } catch (err) {
      console.error(err);
    } finally {
      if (!silent) setIsLoading(false);
    }
  };

  const fetchMessages = async (convId: string) => {
    try {
      const res = await messagingApi.getMessages(convId, 0, 100);
      const items = res.data?.content ?? [];
      setMessages(items.reverse());
      scrollToBottom();
    } catch (err) {
      console.error(err);
    }
  };

  const markAsRead = async (conv: ConversationResponseDTO) => {
    if (conv.unreadCountAdmin > 0) {
      try {
        await messagingApi.markAsRead(conv.id);
        setConversations(prev => prev.map(c => 
          c.id === conv.id ? { ...c, unreadCountAdmin: 0 } : c
        ));
      } catch (err) {
        console.error(err);
      }
    }
  };

  const updateConversationList = (convId: string, msg: MessageResponseDTO) => {
    setConversations(prev => {
      const updated = prev.map(c => {
        if (c.id === convId) {
          return { ...c, lastMessagePreview: msg.content, lastMessageAt: msg.createdAt };
        }
        return c;
      });
      return updated.sort((a, b) => 
        new Date(b.lastMessageAt || 0).getTime() - new Date(a.lastMessageAt || 0).getTime()
      );
    });
    scrollToBottom();
  };

  const scrollToBottom = () => {
    requestAnimationFrame(() => {
      messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    });
  };

  /** Send message to existing conversation */
  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!inputText.trim() || !activeConv) return;

    const content = inputText.trim();
    setInputText('');

    try {
      const res = await messagingApi.sendMessage({
        content,
        conversationId: activeConv.id,
      });
      setMessages(prev => {
        if (prev.find(m => m.id === res.data.id)) return prev;
        return [...prev, res.data];
      });
      updateConversationList(activeConv.id, res.data);
      scrollToBottom();
    } catch (err) {
      console.error('Failed to send message:', err);
    }
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    e.target.value = '';

    const convId = activeConv?.id;
    const targetId = pendingNew?.userId;

    try {
      setIsSendingImage(true);
      const res = await messagingApi.sendImageMessage(file, convId, targetId);
      setMessages(prev => {
        if (prev.find(m => m.id === res.data.id)) return prev;
        return [...prev, res.data];
      });
      if (convId) {
        updateConversationList(convId, res.data);
      } else if (targetId) {
        // New conversation created — reload
        setPendingNew(null);
        const convRes = await messagingApi.getConversations(0, 50);
        const convList = convRes.data?.content ?? [];
        setConversations(convList);
        const newConv = convList.find(c => c.userId === targetId);
        if (newConv) setActiveConv(newConv);
      }
      scrollToBottom();
    } catch (err) {
      console.error('Failed to send image:', err);
    } finally {
      setIsSendingImage(false);
    }
  };

  /** Send first message to a new user (creates conversation) */
  const handleSendNew = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!inputText.trim() || !pendingNew) return;

    const content = inputText.trim();
    setInputText('');

    try {
      await messagingApi.sendMessage({
        content,
        targetUserId: pendingNew.userId,
      });
      // Reload conversations and select the new one
      setPendingNew(null);
      const res = await messagingApi.getConversations(0, 50);
      const convList = res.data?.content ?? [];
      setConversations(convList);
      const newConv = convList.find(c => c.userId === pendingNew.userId);
      if (newConv) {
        setActiveConv(newConv);
      }
    } catch (err) {
      console.error('Failed to send first message:', err);
    }
  };

  const formatRoleLabel = (role: string) => {
    switch(role) {
      case 'TUTOR': return 'Gia sư';
      case 'PARENT': return 'Phụ huynh';
      case 'STUDENT': return 'Học viên';
      default: return role;
    }
  };

  const handleAvatarClick = async (userId: string, e: React.MouseEvent) => {
    e.stopPropagation();
    setIsDetailLoading(true);
    setUserDetail(null);
    try {
      const res = await adminApi.getUserDetail(userId);
      setUserDetail(res.data);
    } catch (err) {
      console.error('Failed to load user detail:', err);
    } finally {
      setIsDetailLoading(false);
    }
  };

  /** Render the right-side chat panel */
  const renderChatPanel = () => {
    // Case 1: Active existing conversation
    if (activeConv) {
      return (
        <>
          {/* Chat Header */}
          <div className="chat-header">
            <div className="chat-header-info">
              <div className="msg-avatar clickable" onClick={(e) => handleAvatarClick(activeConv.userId, e)} title="Xem thông tin người dùng">
                {activeConv.userAvatarBase64 ? (
                  <img src={activeConv.userAvatarBase64} alt="avt" />
                ) : (
                  <div className="msg-avatar-placeholder">{activeConv.userFullName.charAt(0)}</div>
                )}
              </div>
              <div>
                <h3 className="chat-name">{activeConv.userFullName}</h3>
                <span className="chat-role text-sm text-gray-500">{formatRoleLabel(activeConv.userRole)}</span>
              </div>
            </div>
            {messages.some(m => m.messageType === 'IMAGE') && (
              <button className="chat-gallery-btn" onClick={() => setShowGallery(!showGallery)} title="Xem ảnh đã gửi">
                <Images size={20} />
              </button>
            )}
          </div>

          {/* Image Gallery Panel */}
          {showGallery && (
            <div className="chat-gallery">
              <div className="chat-gallery-header">
                <span>Ảnh đã gửi ({messages.filter(m => m.messageType === 'IMAGE').length})</span>
                <button onClick={() => setShowGallery(false)}><X size={16} /></button>
              </div>
              <div className="chat-gallery-grid">
                {messages.filter(m => m.messageType === 'IMAGE').map(m => (
                  <img key={m.id} src={m.content} alt="" onClick={() => scrollToMessage(m.id.toString())} />
                ))}
              </div>
            </div>
          )}

          {/* Chat Messages */}
          <div className="chat-messages">
            {messages.length === 0 ? (
              <div className="chat-empty">
                <MessageSquare size={48} className="text-gray-300 mx-auto mb-4" />
                <p>Hãy gửi lời chào đến {activeConv.userFullName}</p>
              </div>
            ) : (
              messages.map((msg) => {
                const isAdmin = msg.senderId !== activeConv.userId;
                return (
                  <div id={`msg-${msg.id}`} key={msg.id} className={`chat-bubble-wrapper ${isAdmin ? 'outgoing' : 'incoming'}`}>
                    {!isAdmin && (
                      <div className="chat-bubble-avatar">
                        {activeConv.userAvatarBase64 ? (
                          <img src={activeConv.userAvatarBase64} alt="avt" />
                        ) : (
                          activeConv.userFullName.charAt(0)
                        )}
                      </div>
                    )}
                    <div className="chat-bubble">
                      {msg.messageType === 'IMAGE' ? (
                        <img
                          src={msg.content}
                          alt="Ảnh"
                          className="chat-image"
                          onClick={() => setPreviewImage(msg.content)}
                        />
                      ) : (
                        <div className="chat-bubble-content">{msg.content}</div>
                      )}
                      <div className="chat-bubble-meta">
                        {formatDistanceToNow(new Date(msg.createdAt), { locale: vi })}
                      </div>
                    </div>
                  </div>
                );
              })
            )}
            <div ref={messagesEndRef} />
          </div>

          {/* Chat Input */}
          <form className="chat-input-area" onSubmit={handleSend}>
            <input type="file" ref={fileInputRef} accept="image/*" style={{ display: 'none' }} onChange={handleImageUpload} />
            <button type="button" className="chat-image-btn" onClick={() => fileInputRef.current?.click()} disabled={activeConv.isClosed || isSendingImage} title="Gửi ảnh">
              <ImageIcon size={18} />
            </button>
            <input 
              type="text" 
              placeholder="Nhập tin nhắn..." 
              value={inputText}
              onChange={e => setInputText(e.target.value)}
              disabled={activeConv.isClosed}
            />
            <button type="submit" disabled={!inputText.trim() || activeConv.isClosed}>
              <Send size={18} />
            </button>
          </form>
        </>
      );
    }

    // Case 2: New conversation with a specific user
    if (pendingNew) {
      return (
        <>
          <div className="chat-header">
            <div className="chat-header-info">
              <div className="msg-avatar">
                <div className="msg-avatar-placeholder">{pendingNew.fullName.charAt(0)}</div>
              </div>
              <div>
                <h3 className="chat-name">{pendingNew.fullName}</h3>
                <span className="chat-role text-sm text-gray-500">
                  {formatRoleLabel(pendingNew.role)} — Cuộc trò chuyện mới
                </span>
              </div>
            </div>
          </div>

          <div className="chat-messages">
            <div className="chat-empty">
              <UserPlus size={48} style={{ color: 'var(--color-primary, #6366f1)', marginBottom: 16 }} />
              <p style={{ fontWeight: 600, marginBottom: 4 }}>Bắt đầu trò chuyện với {pendingNew.fullName}</p>
              <p style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)' }}>
                Gửi tin nhắn đầu tiên để tạo cuộc trò chuyện.
              </p>
            </div>
          </div>

          <form className="chat-input-area" onSubmit={handleSendNew}>
            <input type="file" ref={fileInputRef} accept="image/*" style={{ display: 'none' }} onChange={handleImageUpload} />
            <button type="button" className="chat-image-btn" onClick={() => fileInputRef.current?.click()} disabled={isSendingImage} title="Gửi ảnh">
              <ImageIcon size={18} />
            </button>
            <input 
              type="text" 
              placeholder={`Nhắn tin cho ${pendingNew.fullName}...`}
              value={inputText}
              onChange={e => setInputText(e.target.value)}
              autoFocus
            />
            <button type="submit" disabled={!inputText.trim()}>
              <Send size={18} />
            </button>
          </form>
        </>
      );
    }

    // Case 3: No conversation selected
    return (
      <div className="chat-unselected">
        <MessageSquare size={64} className="text-gray-200 mb-4" />
        <h3>Chưa chọn cuộc trò chuyện</h3>
        <p>Chọn một cuộc trò chuyện từ danh sách bên trái để bắt đầu nhắn tin.</p>
      </div>
    );
  };

  return (
    <div className="admin-page msg-page">
      <div className="admin-page__header">
        <h1 className="admin-page__title">Hộp thư hỗ trợ</h1>
        <p className="admin-page__subtitle">Quản lý tin nhắn từ Gia sư, Phụ huynh và Học sinh.</p>
      </div>

      <div className="msg-container">
        {/* INBOX LIST */}
        <div className="msg-list-panel">
          <div className="msg-list-header">
            <h3>Danh sách trò chuyện</h3>
          </div>
          <div className="msg-list">
            {isLoading ? (
              <p className="msg-info">Đang tải...</p>
            ) : conversations.length === 0 ? (
              <p className="msg-info">Không có cuộc trò chuyện nào.</p>
            ) : (
              conversations.map(conv => (
                <div 
                  key={conv.id} 
                  className={`msg-list-item ${activeConv?.id === conv.id ? 'active' : ''} ${conv.unreadCountAdmin > 0 ? 'has-unread' : ''}`}
                  onClick={() => { setActiveConv(conv); setPendingNew(null); }}
                >
                  <div className="msg-avatar clickable" onClick={(e) => handleAvatarClick(conv.userId, e)} title="Xem thông tin">
                    {conv.userAvatarBase64 ? (
                      <img src={conv.userAvatarBase64} alt="avt" />
                    ) : (
                      <div className="msg-avatar-placeholder">{conv.userFullName.charAt(0)}</div>
                    )}
                    {conv.unreadCountAdmin > 0 && <span className="msg-unread-badge">{conv.unreadCountAdmin}</span>}
                  </div>
                  <div className="msg-list-content">
                    <div className="msg-list-top">
                      <span className="msg-name">{conv.userFullName}</span>
                      {conv.lastMessageAt && (
                        <span className="msg-time">{formatDistanceToNow(new Date(conv.lastMessageAt), { locale: vi, addSuffix: true })}</span>
                      )}
                    </div>
                    <div className="msg-list-bottom">
                      <span className="msg-role px-2 py-0.5 rounded text-xs bg-gray-100 text-gray-600">{formatRoleLabel(conv.userRole)}</span>
                      <span className={`msg-preview ${conv.unreadCountAdmin > 0 ? 'unread' : ''}`}>
                        {conv.lastMessageSenderName ? `${conv.lastMessageSenderName}: ` : ''}
                        {conv.lastMessagePreview === '[IMAGE]' ? '🖼️ Ảnh' : (conv.lastMessagePreview || 'Chưa có tin nhắn')}
                      </span>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* CHAT PANEL */}
        <div className="msg-chat-panel">
          {renderChatPanel()}
        </div>
      </div>

      {/* User Detail Popup */}
      {(userDetail || isDetailLoading) && (
        <div className="user-detail-overlay" onClick={() => setUserDetail(null)}>
          <div className="user-detail-popup" onClick={(e) => e.stopPropagation()}>
            <button className="popup-close" onClick={() => setUserDetail(null)}>
              <X size={20} />
            </button>

            {isDetailLoading ? (
              <div className="popup-loading">Đang tải thông tin...</div>
            ) : userDetail && (
              <>
                <div className="popup-header">
                  <div className="popup-avatar">
                    {activeConv?.userAvatarBase64 ? (
                      <img src={activeConv.userAvatarBase64} alt="avt" />
                    ) : (
                      <div className="popup-avatar-placeholder">{userDetail.fullName.charAt(0)}</div>
                    )}
                  </div>
                  <h3 className="popup-name">{userDetail.fullName}</h3>
                  <span className={`popup-role-badge role-${userDetail.role.toLowerCase()}`}>
                    {formatRoleLabel(userDetail.role)}
                  </span>
                </div>

                <div className="popup-body">
                  <div className="popup-info-row">
                    <Phone size={16} />
                    <span>{userDetail.phone || 'Chưa cập nhật'}</span>
                  </div>
                  <div className="popup-info-row">
                    <Mail size={16} />
                    <span>{userDetail.email || 'Chưa cập nhật'}</span>
                  </div>
                  <div className="popup-info-row">
                    <Calendar size={16} />
                    <span>Tham gia: {format(new Date(userDetail.createdAt), 'dd/MM/yyyy')}</span>
                  </div>
                  <div className="popup-info-row">
                    <Shield size={16} />
                    <span>Trạng thái: {userDetail.isActive ? '✅ Hoạt động' : '🔒 Đã khóa'}</span>
                  </div>

                  {/* Tutor-specific info */}
                  {userDetail.role === 'TUTOR' && (
                    <div className="popup-tutor-section">
                      <h4>Thông tin Gia sư</h4>
                      {userDetail.subjects && userDetail.subjects.length > 0 && (
                        <div className="popup-info-row">
                          <Star size={16} />
                          <span>Môn: {userDetail.subjects.join(', ')}</span>
                        </div>
                      )}
                      {userDetail.location && (
                        <div className="popup-info-row">
                          <MapPin size={16} />
                          <span>{userDetail.location}</span>
                        </div>
                      )}
                      {userDetail.hourlyRate && (
                        <div className="popup-info-row">
                          <span className="popup-rate">{userDetail.hourlyRate.toLocaleString('vi-VN')}đ/giờ</span>
                        </div>
                      )}
                      {userDetail.verificationStatus && (
                        <div className="popup-info-row">
                          <span className={`popup-verification ${userDetail.verificationStatus.toLowerCase()}`}>
                            {userDetail.verificationStatus === 'VERIFIED' ? '✅ Đã xác minh' :
                             userDetail.verificationStatus === 'PENDING' ? '⏳ Chờ xác minh' : '❌ Chưa xác minh'}
                          </span>
                        </div>
                      )}
                      {userDetail.bio && (
                        <p className="popup-bio">{userDetail.bio}</p>
                      )}
                    </div>
                  )}
                </div>
              </>
            )}
          </div>
        </div>
      )}

      {/* Image Lightbox — portal to body */}
      {previewImage && createPortal(
        <div className="image-lightbox" onClick={() => setPreviewImage(null)}>
          <button className="lightbox-close" onClick={() => setPreviewImage(null)}><X size={24} /></button>
          <img src={previewImage} alt="Preview" onClick={e => e.stopPropagation()} />
        </div>,
        document.body
      )}
    </div>
  );
}
