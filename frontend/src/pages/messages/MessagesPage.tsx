import { Send, MessageSquare, ImageIcon, X, Images } from 'lucide-react';
import { useState, useEffect, useRef, useCallback } from 'react';
import { createPortal } from 'react-dom';

import { messagingApi } from '../../services/messagingApi';
import type { ConversationResponseDTO, MessageResponseDTO } from '../../services/messagingApi';
import { useWebSocket } from '../../hooks/useWebSocket';
import { formatDistanceToNow } from 'date-fns';
import { vi } from 'date-fns/locale';
import { DashboardHeader } from '../../components/layout/DashboardHeader';
import { TutorSidebar } from '../../components/tutor/TutorSidebar';
import { ParentSidebar } from '../../components/parent/ParentSidebar';
import { StudentSidebar } from '../../components/student/StudentSidebar';
import { useAuthStore } from '../../store/useAuthStore';
import './MessagesPage.css';

export function MessagesPage() {
  const { user } = useAuthStore();
  const [conversation, setConversation] = useState<ConversationResponseDTO | null>(null);
  const [messages, setMessages] = useState<MessageResponseDTO[]>([]);
  const [inputText, setInputText] = useState('');
  const [isLoading, setIsLoading] = useState(true);
  const [isSendingImage, setIsSendingImage] = useState(false);
  const [previewImage, setPreviewImage] = useState<string | null>(null);
  const [showGallery, setShowGallery] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const scrollToMessage = (msgId: string) => {
    const el = document.getElementById(`msg-${msgId}`);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth', block: 'center' });
      el.classList.add('highlight-msg');
      setTimeout(() => el.classList.remove('highlight-msg'), 2000);
    }
  };

  const { isConnected, subscribe, unsubscribe } = useWebSocket();

  // Ref giữ logic xử lý tin nhắn mới nhất (tránh closure stale)
  const convIdRef = useRef<string | undefined>(undefined);
  convIdRef.current = conversation?.id;

  const userNameRef = useRef(user?.fullName);
  userNameRef.current = user?.fullName;

  // Stable callback — reference KHÔNG đổi qua các lần render
  const handleIncomingMessage = useCallback((msg: MessageResponseDTO) => {
    setMessages(prev => {
      if (prev.find(m => m.id === msg.id)) return prev;
      return [...prev, msg];
    });
    if (msg.senderName !== userNameRef.current && convIdRef.current) {
      markAsRead(convIdRef.current);
    }
    scrollToBottom();
  }, []);

  // Load conversation on mount
  useEffect(() => {
    fetchConversation();
  }, []);

  // Subscribe to specific conversation when active
  useEffect(() => {
    const convId = conversation?.id;
    if (!isConnected || !convId) return;
    
    const dest = `/topic/messages/${convId}`;
    subscribe(dest, handleIncomingMessage);

    return () => {
      unsubscribe(dest, handleIncomingMessage);
    };
  }, [isConnected, conversation?.id, subscribe, unsubscribe, handleIncomingMessage]);

  const fetchConversation = async () => {
    try {
      setIsLoading(true);
      const res = await messagingApi.getMyConversation();
      setConversation(res.data);
      fetchMessages(res.data.id);
      if (res.data.unreadCountUser > 0) {
        markAsRead(res.data.id);
      }
    } catch (err: any) {
      if (err.response?.status === 404) {
        // Conversation doesn't exist yet, that's fine. It will be created when we send a message.
        setIsLoading(false);
      } else {
        console.error(err);
      }
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
    } finally {
      setIsLoading(false);
    }
  };

  const markAsRead = async (convId: string) => {
    try {
      await messagingApi.markAsRead(convId);
      setConversation(prev => {
        if (prev && prev.unreadCountUser > 0) {
          return { ...prev, unreadCountUser: 0 };
        }
        return prev;
      });
    } catch (err) {
      console.error(err);
    }
  };

  const scrollToBottom = () => {
    setTimeout(() => {
      messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, 100);
  };

  const handleSend = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!inputText.trim()) return;

    const content = inputText.trim();
    setInputText('');

    try {
      const res = await messagingApi.sendMessage({ content }); // ID is not needed for non-admin, backend knows
      setMessages(prev => {
        if (prev.find(m => m.id === res.data.id)) return prev;
        return [...prev, res.data];
      });
      
      // If we didn't have a conversation loaded (first message ever), reload conversation object
      if (!conversation) {
        fetchConversation();
      } else {
        scrollToBottom();
      }
    } catch (err) {
      console.error('Failed to send message:', err);
    }
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    e.target.value = ''; // reset input

    try {
      setIsSendingImage(true);
      const res = await messagingApi.sendImageMessage(file, conversation?.id);
      setMessages(prev => {
        if (prev.find(m => m.id === res.data.id)) return prev;
        return [...prev, res.data];
      });
      if (!conversation) {
        fetchConversation();
      } else {
        scrollToBottom();
      }
    } catch (err) {
      console.error('Failed to send image:', err);
    } finally {
      setIsSendingImage(false);
    }
  };

  const renderSidebar = () => {
    switch (user?.role) {
      case 'TUTOR': return <TutorSidebar active="messages" />;
      case 'PARENT': return <ParentSidebar active="messages" />;
      case 'STUDENT': return <StudentSidebar active="messages" />;
      default: return null;
    }
  };

  return (
    <div className="dash-page user-msg-page">
      {renderSidebar()}
      
      <main className="dash-main">
        <DashboardHeader />
        
        <div className="dash-body chat-wrapper">
          <div className="msg-chat-panel support-chat">
            {/* Chat Header */}
            <div className="chat-header">
              <div className="chat-header-info">
                <div className="msg-avatar support-avatar">
                  <div className="msg-avatar-placeholder">HT</div>
                </div>
                <div>
                  <h3 className="chat-name">Hỗ trợ Gia Sư Tinh Hoa</h3>
                  <span className="chat-role text-sm text-gray-500">Chúng tôi sẵn sàng giải đáp thắc mắc</span>
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
                    <img key={m.id} src={m.content} alt="" onClick={() => scrollToMessage(m.id)} />
                  ))}
                </div>
              </div>
            )}

            {/* Chat Messages */}
            <div className="chat-messages support-board">
              {isLoading ? (
                <div className="chat-empty">Đang tải biểu lịch sử trò chuyện...</div>
              ) : messages.length === 0 ? (
                <div className="chat-empty">
                  <MessageSquare size={48} className="text-gray-300 mx-auto mb-4" />
                  <p>Để lại lời nhắn nếu bạn cần hỗ trợ, quản trị viên sẽ trả lời sớm nhất có thể.</p>
                </div>
              ) : (
                messages.map((msg) => {
                  const isMe = msg.senderName === user?.fullName;
                  
                  return (
                    <div id={`msg-${msg.id}`} key={msg.id} className={`chat-bubble-wrapper ${isMe ? 'outgoing' : 'incoming'}`}>
                      {!isMe && (
                        <div className="chat-bubble-avatar">HT</div>
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
              <button type="button" className="chat-image-btn" onClick={() => fileInputRef.current?.click()} disabled={conversation?.isClosed || isSendingImage} title="Gửi ảnh">
                <ImageIcon size={18} />
              </button>
              <input 
                type="text" 
                placeholder="Nhập câu hỏi, vấn đề bạn gặp phải..." 
                value={inputText}
                onChange={e => setInputText(e.target.value)}
                disabled={conversation?.isClosed}
              />
              <button type="submit" disabled={!inputText.trim() || conversation?.isClosed}>
                <Send size={18} />
              </button>
            </form>
          </div>
        </div>
      </main>

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
