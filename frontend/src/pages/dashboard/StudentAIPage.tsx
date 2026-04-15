/* ──────────────────────────────────────────────────────────────────────────
   StudentAIPage.tsx — AI Study Companion cho học sinh
   Giao diện chat kiểu ChatGPT với sidebar conversations
   ────────────────────────────────────────────────────────────────────────── */

import { useState, useEffect, useRef, useCallback } from 'react';
import {
  Bot, Send, Plus, Trash2, Camera, Paperclip,
  Sparkles, Crown, Clock, ChevronRight, X, Loader2,
  BookOpen, Brain, AlertCircle
} from 'lucide-react';
import { aiApi } from '../../services/aiApi';
import type {
  AiConversation, AiMessage, AiSubscriptionStatusResponse
} from '../../services/aiApi';
import './StudentAIPage.css';

// ── Paywall Banner ────────────────────────────────────────────────────────

function PaywallBanner({ onUpgrade }: { onUpgrade: () => void }) {
  return (
    <div className="ai-paywall">
      <div className="ai-paywall__icon"><Crown size={48} /></div>
      <h2 className="ai-paywall__title">Thời gian dùng thử đã hết</h2>
      <p className="ai-paywall__desc">
        Bạn đã sử dụng hết 30 ngày trải nghiệm miễn phí.<br />
        Nâng cấp AI Premium để tiếp tục học tập cùng AI Tutor.
      </p>
      <div className="ai-paywall__features">
        <div className="ai-paywall__feature">
          <Camera size={18} /> Giải bài từ ảnh chụp
        </div>
        <div className="ai-paywall__feature">
          <Brain size={18} /> Hỏi đáp không giới hạn
        </div>
        <div className="ai-paywall__feature">
          <BookOpen size={18} /> Lịch sử hội thoại vĩnh viễn
        </div>
      </div>
      <button className="ai-paywall__btn" onClick={onUpgrade}>
        <Crown size={18} /> Nâng cấp 200.000đ / tháng
      </button>
      <p className="ai-paywall__note">Liên hệ admin để kích hoạt</p>
    </div>
  );
}

// ── Trial Banner ──────────────────────────────────────────────────────────

function TrialBanner({ daysRemaining }: { daysRemaining: number }) {
  if (daysRemaining > 7) return null;
  return (
    <div className={`ai-trial-banner ${daysRemaining <= 3 ? 'ai-trial-banner--urgent' : ''}`}>
      <Clock size={16} />
      <span>
        {daysRemaining <= 0
          ? 'Trial hết hạn hôm nay!'
          : `Còn ${daysRemaining} ngày dùng thử miễn phí`}
      </span>
    </div>
  );
}

// ── Message Bubble ────────────────────────────────────────────────────────

function MessageBubble({ message }: { message: AiMessage }) {
  const isUser = message.role === 'USER';

  // Render markdown đơn giản: **bold**, *italic*, code block
  const renderContent = (text: string) => {
    const lines = text.split('\n');
    return lines.map((line, i) => {
      // Code block
      if (line.startsWith('```') || line.endsWith('```')) {
        return <div key={i} className="ai-msg__code-marker">{line}</div>;
      }
      // Bold
      const boldParsed = line.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
      return (
        <p
          key={i}
          className="ai-msg__line"
          dangerouslySetInnerHTML={{ __html: boldParsed || '&nbsp;' }}
        />
      );
    });
  };

  return (
    <div className={`ai-msg ${isUser ? 'ai-msg--user' : 'ai-msg--assistant'}`}>
      {!isUser && (
        <div className="ai-msg__avatar">
          <Bot size={18} />
        </div>
      )}
      <div className="ai-msg__bubble">
        {message.imageUrl && (
          <img src={message.imageUrl} alt="Ảnh bài tập" className="ai-msg__image" />
        )}
        <div className="ai-msg__content">{renderContent(message.content)}</div>
        <span className="ai-msg__time">
          {new Date(message.createdAt).toLocaleTimeString('vi-VN', {
            hour: '2-digit', minute: '2-digit'
          })}
        </span>
      </div>
    </div>
  );
}

// ── Empty State ───────────────────────────────────────────────────────────

function EmptyChat({ subject }: { subject?: string | null }) {
  const suggestions = subject === 'Toán'
    ? ['Giải phương trình bậc 2', 'Đạo hàm là gì?', 'Tích phân bất định']
    : subject === 'Văn'
    ? ['Phân tích nhân vật', 'Cách làm bài nghị luận', 'Tìm luận điểm chính']
    : ['Giải thích định luật Newton', 'Công thức hóa học', 'Bài toán lãi suất'];

  return (
    <div className="ai-empty">
      <div className="ai-empty__icon">
        <Sparkles size={40} />
      </div>
      <h3 className="ai-empty__title">AI Study Companion</h3>
      <p className="ai-empty__desc">
        Hỏi bất kỳ điều gì, hoặc chụp ảnh bài tập để AI giải thích từng bước
      </p>
      <div className="ai-empty__suggestions">
        {suggestions.map((s, i) => (
          <button key={i} className="ai-empty__suggestion">
            <ChevronRight size={14} />
            {s}
          </button>
        ))}
      </div>
    </div>
  );
}

// ── Main Page ─────────────────────────────────────────────────────────────

export function StudentAIPage() {
  const [subscription, setSubscription] = useState<AiSubscriptionStatusResponse | null>(null);
  const [conversations, setConversations] = useState<AiConversation[]>([]);
  const [activeConv, setActiveConv] = useState<AiConversation | null>(null);
  const [messages, setMessages] = useState<AiMessage[]>([]);
  const [inputText, setInputText] = useState('');
  const [isSending, setIsSending] = useState(false);
  const [isLoadingMessages, setIsLoadingMessages] = useState(false);
  const [showUpgradeModal, setShowUpgradeModal] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // ── Load initial data ──────────────────────────────────────────────────

  useEffect(() => {
    loadSubscription();
    loadConversations();
  }, []);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const loadSubscription = async () => {
    try {
      const data = await aiApi.getSubscriptionStatus();
      setSubscription(data);
    } catch (e) {
      console.error('Failed to load subscription:', e);
    }
  };

  const loadConversations = async () => {
    try {
      const list = await aiApi.listConversations();
      setConversations(list);
      if (list.length > 0 && !activeConv) {
        selectConversation(list[0]);
      }
    } catch (e) {
      console.error('Failed to load conversations:', e);
    }
  };

  const selectConversation = useCallback(async (conv: AiConversation) => {
    setActiveConv(conv);
    setMessages([]);
    setIsLoadingMessages(true);
    try {
      const msgs = await aiApi.getMessages(conv.id);
      setMessages(msgs);
    } catch (e) {
      console.error('Failed to load messages:', e);
    } finally {
      setIsLoadingMessages(false);
    }
  }, []);

  // ── Create new conversation ────────────────────────────────────────────

  const handleNewConversation = async () => {
    if (!subscription?.canUseAi) {
      setShowUpgradeModal(true);
      return;
    }
    try {
      const conv = await aiApi.createConversation({});
      const updated = [conv, ...conversations];
      setConversations(updated);
      setActiveConv(conv);
      setMessages([]);
    } catch (e: any) {
      const msg = e?.response?.data?.message;
      if (msg?.includes('AI_ACCESS_DENIED')) setShowUpgradeModal(true);
    }
  };

  // ── Delete conversation ────────────────────────────────────────────────

  const handleDeleteConversation = async (convId: string, e: React.MouseEvent) => {
    e.stopPropagation();
    if (!confirm('Xóa cuộc trò chuyện này?')) return;
    try {
      await aiApi.deleteConversation(convId);
      const updated = conversations.filter(c => c.id !== convId);
      setConversations(updated);
      if (activeConv?.id === convId) {
        setActiveConv(updated[0] ?? null);
        setMessages([]);
      }
    } catch (e) {
      console.error('Delete failed:', e);
    }
  };

  // ── Send message ──────────────────────────────────────────────────────

  const handleSendMessage = async (imageBase64?: string, imageMimeType?: string) => {
    if (!activeConv) return;
    if (!inputText.trim() && !imageBase64) return;
    if (isSending) return;

    if (!subscription?.canUseAi) {
      setShowUpgradeModal(true);
      return;
    }

    const userContent = inputText.trim() || 'Hãy giải thích bài tập trong ảnh từng bước chi tiết.';
    setInputText('');
    setError(null);
    setIsSending(true);

    // Optimistic: hiển thị tin HS ngay
    const tempUserMsg: AiMessage = {
      id: `temp-${Date.now()}`,
      role: 'USER',
      content: userContent,
      imageUrl: imageBase64 ? `data:${imageMimeType};base64,${imageBase64}` : null,
      createdAt: new Date().toISOString(),
    };
    setMessages(prev => [...prev, tempUserMsg]);

    try {
      const replyMsg = await aiApi.sendMessage(activeConv.id, {
        content: userContent,
        imageBase64,
        imageMimeType,
      });
      // Reload full conversation để đồng bộ ID thật
      const msgs = await aiApi.getMessages(activeConv.id);
      setMessages(msgs);

      // Cập nhật title conversations nếu đã thay đổi
      loadConversations();

      // Refresh subscription usage
      loadSubscription();
    } catch (e: any) {
      const msg = e?.response?.data?.message || 'Có lỗi xảy ra, vui lòng thử lại.';
      if (msg.includes('AI_ACCESS_DENIED') || msg.includes('AI_DAILY_LIMIT_REACHED')) {
        setError(msg);
        if (msg.includes('AI_ACCESS_DENIED')) setShowUpgradeModal(true);
      } else {
        setError(msg);
      }
      // Remove optimistic message
      setMessages(prev => prev.filter(m => m.id !== tempUserMsg.id));
    } finally {
      setIsSending(false);
    }
  };

  // ── Camera / Image upload ─────────────────────────────────────────────

  const handleImageSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = () => {
      const base64 = (reader.result as string).split(',')[1];
      handleSendMessage(base64, file.type);
    };
    reader.readAsDataURL(file);
    e.target.value = '';
  };

  // ── Keyboard submit ───────────────────────────────────────────────────

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  // ── Auto-resize textarea ──────────────────────────────────────────────

  const handleTextareaChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setInputText(e.target.value);
    const ta = e.target;
    ta.style.height = 'auto';
    ta.style.height = Math.min(ta.scrollHeight, 160) + 'px';
  };

  // ── Render ────────────────────────────────────────────────────────────

  const canUse = subscription?.canUseAi ?? false;
  const isExpired = subscription && !canUse;

  return (
    <div className="ai-page">
      {/* ── Sidebar ── */}
      <aside className="ai-sidebar">
        <div className="ai-sidebar__header">
          <div className="ai-sidebar__brand">
            <Bot size={22} />
            <span>AI Study</span>
          </div>
          <button
            className="ai-sidebar__new-btn"
            onClick={handleNewConversation}
            title="Tạo cuộc trò chuyện mới"
          >
            <Plus size={18} />
          </button>
        </div>

        {/* Subscription badge */}
        {subscription && (
          <div className={`ai-sidebar__sub-badge ${subscription.status}`}>
            {subscription.isTrial ? (
              <>
                <Clock size={14} />
                Trial còn {subscription.trialDaysRemaining ?? 0} ngày
              </>
            ) : subscription.status === 'ACTIVE' ? (
              <>
                <Crown size={14} />
                AI Premium
              </>
            ) : (
              <>
                <AlertCircle size={14} />
                Hết hạn — Nâng cấp
              </>
            )}
          </div>
        )}

        {/* Conversation list */}
        <div className="ai-sidebar__convs">
          {conversations.length === 0 ? (
            <p className="ai-sidebar__empty">Chưa có cuộc trò chuyện nào</p>
          ) : (
            conversations.map(conv => (
              <button
                key={conv.id}
                className={`ai-sidebar__conv ${activeConv?.id === conv.id ? 'active' : ''}`}
                onClick={() => selectConversation(conv)}
              >
                <span className="ai-sidebar__conv-title">{conv.title}</span>
                {conv.subject && (
                  <span className="ai-sidebar__conv-subject">{conv.subject}</span>
                )}
                <button
                  className="ai-sidebar__conv-delete"
                  onClick={(e) => handleDeleteConversation(conv.id, e)}
                >
                  <Trash2 size={13} />
                </button>
              </button>
            ))
          )}
        </div>
      </aside>

      {/* ── Main chat area ── */}
      <main className="ai-main">
        {/* Trial warning */}
        {subscription?.isTrial && (
          <TrialBanner daysRemaining={subscription.trialDaysRemaining ?? 0} />
        )}

        {/* Paywall */}
        {isExpired ? (
          <PaywallBanner onUpgrade={() => setShowUpgradeModal(true)} />
        ) : (
          <>
            {/* Messages */}
            <div className="ai-messages">
              {isLoadingMessages ? (
                <div className="ai-messages__loading">
                  <Loader2 size={24} className="spinning" />
                  <span>Đang tải...</span>
                </div>
              ) : !activeConv ? (
                <EmptyChat />
              ) : messages.length === 0 ? (
                <EmptyChat subject={activeConv.subject} />
              ) : (
                messages.map(msg => <MessageBubble key={msg.id} message={msg} />)
              )}

              {/* AI typing indicator */}
              {isSending && (
                <div className="ai-msg ai-msg--assistant">
                  <div className="ai-msg__avatar"><Bot size={18} /></div>
                  <div className="ai-msg__bubble">
                    <div className="ai-typing">
                      <span /><span /><span />
                    </div>
                  </div>
                </div>
              )}

              <div ref={messagesEndRef} />
            </div>

            {/* Error */}
            {error && (
              <div className="ai-error">
                <AlertCircle size={16} />
                <span>{error}</span>
                <button onClick={() => setError(null)}><X size={14} /></button>
              </div>
            )}

            {/* Input area */}
            <div className="ai-input-area">
              {!activeConv && (
                <div className="ai-input-area__no-conv">
                  <button onClick={handleNewConversation} className="ai-input-area__start-btn">
                    <Plus size={18} /> Bắt đầu cuộc trò chuyện mới
                  </button>
                </div>
              )}
              {activeConv && (
                <div className="ai-input-box">
                  <button
                    className="ai-input-box__attach"
                    onClick={() => fileInputRef.current?.click()}
                    title="Chụp ảnh / Chọn ảnh bài tập"
                    disabled={isSending}
                  >
                    <Camera size={20} />
                  </button>
                  <input
                    ref={fileInputRef}
                    type="file"
                    accept="image/*"
                    capture="environment"
                    style={{ display: 'none' }}
                    onChange={handleImageSelect}
                  />
                  <textarea
                    ref={textareaRef}
                    className="ai-input-box__textarea"
                    placeholder="Hỏi AI bất cứ điều gì... (Enter để gửi, Shift+Enter xuống dòng)"
                    value={inputText}
                    onChange={handleTextareaChange}
                    onKeyDown={handleKeyDown}
                    disabled={isSending}
                    rows={1}
                  />
                  <button
                    className="ai-input-box__send"
                    onClick={() => handleSendMessage()}
                    disabled={isSending || (!inputText.trim())}
                  >
                    {isSending ? <Loader2 size={20} className="spinning" /> : <Send size={20} />}
                  </button>
                </div>
              )}
              <p className="ai-input-area__hint">
                AI có thể nhầm. Hãy kiểm tra lại đáp án quan trọng.
              </p>
            </div>
          </>
        )}
      </main>

      {/* ── Upgrade Modal ── */}
      {showUpgradeModal && (
        <div className="ai-modal-overlay" onClick={() => setShowUpgradeModal(false)}>
          <div className="ai-modal" onClick={e => e.stopPropagation()}>
            <button className="ai-modal__close" onClick={() => setShowUpgradeModal(false)}>
              <X size={20} />
            </button>
            <Crown size={48} className="ai-modal__icon" />
            <h2>Nâng cấp AI Premium</h2>
            <p>Giải bài 24/7, không giới hạn tin nhắn, hỗ trợ chụp ảnh bài tập</p>
            <div className="ai-modal__price">
              <span className="ai-modal__amount">200.000đ</span>
              <span className="ai-modal__period">/ tháng</span>
            </div>
            <p className="ai-modal__contact">
              📞 Liên hệ admin hoặc nhắn tin trong ứng dụng để kích hoạt
            </p>
            <button className="ai-modal__btn" onClick={() => setShowUpgradeModal(false)}>
              Đã hiểu
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
