/* ──────────────────────────────────────────────────────────────────────────
   StudentAIPage.tsx — AI Gia sư Premium
   Subject rooms: mỗi môn = 1 phòng học AI riêng biệt
   ────────────────────────────────────────────────────────────────────────── */

import { useState, useEffect, useRef, useCallback } from 'react';
import {
  Bot, Send, Plus, Trash2, Camera,
  Sparkles, Crown, Clock, ChevronRight, X, Loader2,
  BookOpen, Brain, AlertCircle, Zap, Star, Target
} from 'lucide-react';
import { aiApi } from '../../services/aiApi';
import type {
  AiConversation, AiMessage, AiSubscriptionStatusResponse
} from '../../services/aiApi';
import { MarkdownRenderer } from '../../components/shared/MarkdownRenderer';
import './StudentAIPage.css';

// ── Constants ─────────────────────────────────────────────────────────────

const DEFAULT_SUBJECTS = ['Toán', 'Văn', 'Anh'];

const ALL_SUBJECTS = ['Toán', 'Văn', 'Anh', 'Lý', 'Hóa', 'Sinh', 'Sử', 'Địa', 'Tin'];

const SUBJECT_ICONS: Record<string, string> = {
  'Toán': '📐', 'Văn': '📖', 'Anh': '🌍',
  'Lý': '⚡', 'Hóa': '🧪', 'Sinh': '🧬',
  'Sử': '📜', 'Địa': '🗺️', 'Tin': '💻',
};

const SUBJECT_SUGGESTIONS: Record<string, string[]> = {
  'Toán': ['Giải phương trình bậc 2 chi tiết', 'Đạo hàm là gì?', 'Cách tính tích phân'],
  'Văn': ['Phân tích nhân vật Chí Phèo', 'Cách làm bài nghị luận xã hội', 'Tìm luận điểm chính'],
  'Anh': ['Explain Present Perfect vs Past Simple', 'Common English mistakes', 'How to write an essay'],
  'Lý': ['Giải thích định luật Newton', 'Bài toán chuyển động ném xiên', 'Mạch điện RLC'],
  'Hóa': ['Cân bằng phương trình hóa học', 'Bài tập về mol', 'Chuỗi phản ứng hữu cơ'],
  'Sinh': ['Gen trội gen lặn là gì?', 'Bài tập di truyền', 'Quá trình nguyên phân'],
  'Sử': ['Diễn biến cách mạng tháng 8', 'So sánh 2 cuộc kháng chiến', 'Ý nghĩa chiến thắng ĐBP'],
  'Địa': ['Phân tích biểu đồ dân số', 'So sánh vùng kinh tế', 'Đặc điểm khí hậu VN'],
  'Tin': ['Thuật toán sắp xếp nổi bọt', 'Bài tập Python cơ bản', 'Cấu trúc dữ liệu mảng'],
};

const STORAGE_KEY = 'edtech_ai_subjects';
const TRIAL_DAILY_LIMIT = 50;

// ── Helpers ───────────────────────────────────────────────────────────────

function loadActiveSubjects(): string[] {
  try {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      const parsed = JSON.parse(saved) as string[];
      return parsed.filter(s => ALL_SUBJECTS.includes(s));
    }
  } catch { /* ignore */ }
  return [...DEFAULT_SUBJECTS];
}

function saveActiveSubjects(subjects: string[]) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(subjects));
}

// ── Paywall Screen (hết trial 30 ngày) ────────────────────────────────────

function PaywallScreen() {
  return (
    <div className="ai-paywall-screen">
      <div className="ai-paywall-screen__inner">
        <div className="ai-paywall-screen__glow" />
        <div className="ai-paywall-screen__icon">
          <Crown size={56} />
        </div>
        <h2 className="ai-paywall-screen__title">Thời gian dùng thử đã hết</h2>
        <p className="ai-paywall-screen__desc">
          Bạn đã sử dụng hết <strong>30 ngày trải nghiệm miễn phí</strong>.<br />
          Nâng cấp để tiếp tục học tập cùng Gia sư AI 24/7.
        </p>

        <div className="ai-paywall-screen__features">
          <div className="ai-paywall-screen__feature">
            <Zap size={20} /> <span>Hỏi đáp không giới hạn</span>
          </div>
          <div className="ai-paywall-screen__feature">
            <Camera size={20} /> <span>Giải bài từ ảnh chụp</span>
          </div>
          <div className="ai-paywall-screen__feature">
            <Brain size={20} /> <span>Gia sư AI riêng cho tất cả môn</span>
          </div>
          <div className="ai-paywall-screen__feature">
            <BookOpen size={20} /> <span>Lịch sử hội thoại vĩnh viễn</span>
          </div>
        </div>

        <div className="ai-paywall-screen__price-card">
          <div className="ai-paywall-screen__price">
            <span className="ai-paywall-screen__amount">500.000đ</span>
            <span className="ai-paywall-screen__period">/ tháng</span>
          </div>
          <p className="ai-paywall-screen__contact">
            📞 Liên hệ admin hoặc nhắn tin để kích hoạt Premium
          </p>
        </div>
      </div>
    </div>
  );
}

// ── Daily Limit Popup ─────────────────────────────────────────────────────

function DailyLimitPopup({ onClose }: { onClose: () => void }) {
  return (
    <div className="ai-limit-overlay" onClick={onClose}>
      <div className="ai-limit-popup" onClick={e => e.stopPropagation()}>
        <div className="ai-limit-popup__icon">
          <Zap size={40} />
        </div>
        <h2 className="ai-limit-popup__title">⚡ Bạn đã hết lượt hôm nay!</h2>
        <p className="ai-limit-popup__desc">
          Bạn đã dùng hết <strong>{TRIAL_DAILY_LIMIT} tin nhắn</strong> trong ngày.<br />
          Nâng cấp Gia sư AI Premium để học không giới hạn mọi lúc.
        </p>
        <div className="ai-limit-popup__price">
          <span className="ai-limit-popup__amount">500.000đ</span>
          <span className="ai-limit-popup__period">/ tháng — Unlimited</span>
        </div>
        <button className="ai-limit-popup__upgrade">🚀 Nâng cấp ngay</button>
        <button className="ai-limit-popup__close" onClick={onClose}>
          Quay lại mai nhé
        </button>
      </div>
    </div>
  );
}

// ── Trial Banner ──────────────────────────────────────────────────────────

function TrialBanner({ daysRemaining }: { daysRemaining: number }) {
  if (daysRemaining > 7) return null;
  const isUrgent = daysRemaining <= 3;
  return (
    <div className={`ai-trial-banner ${isUrgent ? 'ai-trial-banner--urgent' : ''}`}>
      <Clock size={15} />
      <span>
        {daysRemaining <= 0
          ? '⚠️ Trial hết hạn hôm nay!'
          : `Còn ${daysRemaining} ngày dùng thử miễn phí`}
      </span>
      {isUrgent && <span className="ai-trial-banner__cta">→ Nâng cấp Gia sư AI Premium 500k/tháng</span>}
    </div>
  );
}

// ── Message Bubble ────────────────────────────────────────────────────────

function MessageBubble({ message }: { message: AiMessage }) {
  const isUser = message.role === 'USER';

  return (
    <div className={`ai-msg ${isUser ? 'ai-msg--user' : 'ai-msg--assistant'}`}>
      {!isUser && (
        <div className="ai-msg__avatar">
          <Bot size={16} />
        </div>
      )}
      <div className="ai-msg__bubble">
        {message.imageUrl && (
          <img src={message.imageUrl} alt="Ảnh bài tập" className="ai-msg__image" />
        )}
        <div className="ai-msg__content">
          <MarkdownRenderer content={message.content} />
        </div>
        <span className="ai-msg__time">
          {new Date(message.createdAt).toLocaleTimeString('vi-VN', {
            hour: '2-digit', minute: '2-digit'
          })}
        </span>
      </div>
    </div>
  );
}

// ── Empty Chat ────────────────────────────────────────────────────────────

function EmptyChat({
  subject,
  onSuggestion
}: {
  subject: string;
  onSuggestion: (text: string) => void;
}) {
  const suggestions = SUBJECT_SUGGESTIONS[subject] ?? SUBJECT_SUGGESTIONS['Toán'];
  const icon = SUBJECT_ICONS[subject] ?? '📚';

  return (
    <div className="ai-empty">
      <div className="ai-empty__icon">
        <span style={{ fontSize: 36 }}>{icon}</span>
      </div>
      <h3 className="ai-empty__title">Xin chào! Tôi là Gia sư AI môn {subject} 🤖</h3>
      <p className="ai-empty__desc">
        Hỏi bất kỳ điều gì về môn {subject}, hoặc chụp ảnh bài tập để tôi giảng chi tiết!<br />
        Nói "tôi đang học chương X" để tôi dạy đúng phần bạn cần.
      </p>
      <div className="ai-empty__suggestions">
        {suggestions.map((s, i) => (
          <button key={i} className="ai-empty__suggestion" onClick={() => onSuggestion(s)}>
            <ChevronRight size={13} />
            {s}
          </button>
        ))}
      </div>
    </div>
  );
}

// ── Subscription Badge ────────────────────────────────────────────────────

function SubBadge({ subscription, loading }: {
  subscription: AiSubscriptionStatusResponse | null;
  loading: boolean;
}) {
  if (loading) {
    return (
      <div className="ai-sub-badge ai-sub-badge--loading">
        <Loader2 size={13} className="spinning" /> Đang kiểm tra...
      </div>
    );
  }
  if (!subscription) return null;

  if (subscription.trial) {
    const days = subscription.trialDaysRemaining ?? 0;
    const isLow = days <= 7;
    return (
      <div className={`ai-sub-badge ${isLow ? 'ai-sub-badge--warning' : 'ai-sub-badge--trial'}`}>
        <Clock size={13} />
        Trial còn {days} ngày
      </div>
    );
  }
  if (subscription.status === 'ACTIVE') {
    return (
      <div className="ai-sub-badge ai-sub-badge--premium">
        <Star size={13} /> Gia sư AI Premium ✨
      </div>
    );
  }
  return (
    <div className="ai-sub-badge ai-sub-badge--expired">
      <AlertCircle size={13} /> Hết hạn
    </div>
  );
}

// ── Subject Picker Modal ──────────────────────────────────────────────────

function SubjectPickerModal({
  activeSubjects,
  onAdd,
  onClose
}: {
  activeSubjects: string[];
  onAdd: (subject: string) => void;
  onClose: () => void;
}) {
  const availableSubjects = ALL_SUBJECTS.filter(s => !activeSubjects.includes(s));

  if (availableSubjects.length === 0) {
    return (
      <div className="ai-picker-overlay" onClick={onClose}>
        <div className="ai-picker-modal" onClick={e => e.stopPropagation()}>
          <h3>Đã thêm tất cả môn</h3>
          <p>Bạn đã mở đủ 9 phòng học rồi! 🎉</p>
          <button className="ai-picker-modal__close" onClick={onClose}>Đóng</button>
        </div>
      </div>
    );
  }

  return (
    <div className="ai-picker-overlay" onClick={onClose}>
      <div className="ai-picker-modal" onClick={e => e.stopPropagation()}>
        <div className="ai-picker-modal__header">
          <h3>Thêm phòng học</h3>
          <button className="ai-picker-modal__x" onClick={onClose}><X size={18} /></button>
        </div>
        <p className="ai-picker-modal__desc">Chọn môn học để tạo phòng AI Gia sư riêng</p>
        <div className="ai-picker-modal__grid">
          {availableSubjects.map(subject => (
            <button
              key={subject}
              className="ai-picker-modal__item"
              onClick={() => { onAdd(subject); onClose(); }}
            >
              <span className="ai-picker-modal__icon">{SUBJECT_ICONS[subject]}</span>
              <span className="ai-picker-modal__name">{subject}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

// ── Usage Indicator ───────────────────────────────────────────────────────

function UsageIndicator({ used, limit }: { used: number; limit: number }) {
  const percentage = Math.min((used / limit) * 100, 100);
  const isHigh = percentage >= 80;

  return (
    <div className="ai-usage">
      <div className="ai-usage__label">
        <span>{used}/{limit} tin hôm nay</span>
      </div>
      <div className="ai-usage__bar">
        <div
          className={`ai-usage__fill ${isHigh ? 'ai-usage__fill--high' : ''}`}
          style={{ width: `${percentage}%` }}
        />
      </div>
    </div>
  );
}

// ── Main Page ─────────────────────────────────────────────────────────────

export function StudentAIPage() {
  const [subscription, setSubscription] = useState<AiSubscriptionStatusResponse | null>(null);
  const [isLoadingSubscription, setIsLoadingSubscription] = useState(true);
  const [conversations, setConversations] = useState<AiConversation[]>([]);
  const [activeConv, setActiveConv] = useState<AiConversation | null>(null);
  const [messages, setMessages] = useState<AiMessage[]>([]);
  const [inputText, setInputText] = useState('');
  const [isSending, setIsSending] = useState(false);
  const [isLoadingMessages, setIsLoadingMessages] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Streaming state
  const [streamingContent, setStreamingContent] = useState('');
  const [isStreaming, setIsStreaming] = useState(false);
  const streamAbortRef = useRef<AbortController | null>(null);

  // Subject rooms
  const [activeSubjects, setActiveSubjects] = useState<string[]>(loadActiveSubjects);
  const [selectedSubject, setSelectedSubject] = useState<string>(activeSubjects[0] || 'Toán');
  const [showSubjectPicker, setShowSubjectPicker] = useState(false);
  const [showDailyLimitPopup, setShowDailyLimitPopup] = useState(false);
  const [dailyUsed, setDailyUsed] = useState(0);
  const [editingGoal, setEditingGoal] = useState(false);
  const [goalInput, setGoalInput] = useState('');

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    loadSubscription();
    loadConversations();
  }, []);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, streamingContent]);

  // Khi chọn subject khác → select conversation đầu tiên của subject đó
  useEffect(() => {
    const filtered = conversations.filter(c => c.subject === selectedSubject);
    if (filtered.length > 0) {
      selectConversation(filtered[0]);
    } else {
      setActiveConv(null);
      setMessages([]);
    }
  }, [selectedSubject, conversations.length]);

  const loadSubscription = async () => {
    setIsLoadingSubscription(true);
    try {
      const data = await aiApi.getSubscriptionStatus();
      setSubscription(data);
    } catch {
      // Giữ null
    } finally {
      setIsLoadingSubscription(false);
    }
  };

  const loadConversations = async () => {
    try {
      const list = await aiApi.listConversations();
      setConversations(list);
    } catch {
      /* ignore */
    }
  };

  const selectConversation = useCallback(async (conv: AiConversation) => {
    setActiveConv(conv);
    setMessages([]);
    setIsLoadingMessages(true);
    try {
      const msgs = await aiApi.getMessages(conv.id);
      setMessages(msgs);
    } catch {
      /* ignore */
    } finally {
      setIsLoadingMessages(false);
    }
  }, []);

  const handleNewConversation = async () => {
    if (!canUse) return;
    try {
      const conv = await aiApi.createConversation({ subject: selectedSubject });
      setConversations(prev => [conv, ...prev]);
      setActiveConv(conv);
      setMessages([]);
    } catch {
      /* ignore */
    }
  };

  const handleDeleteConversation = async (convId: string, e: React.MouseEvent) => {
    e.stopPropagation();
    if (!confirm('Xóa cuộc trò chuyện này?')) return;
    try {
      await aiApi.deleteConversation(convId);
      const updated = conversations.filter(c => c.id !== convId);
      setConversations(updated);
      if (activeConv?.id === convId) {
        const filtered = updated.filter(c => c.subject === selectedSubject);
        setActiveConv(filtered[0] ?? null);
        setMessages([]);
      }
    } catch {
      /* ignore */
    }
  };

  const handleUpdateLearningGoal = async () => {
    if (!activeConv) return;
    const trimmed = goalInput.trim();
    try {
      const updated = await aiApi.updateConversation(activeConv.id, {
        learningGoal: trimmed || undefined,
      });
      setActiveConv(updated);
      setConversations(prev =>
        prev.map(c => c.id === updated.id ? updated : c)
      );
      setEditingGoal(false);
    } catch {
      /* ignore */
    }
  };

  const handleAddSubject = (subject: string) => {
    const updated = [...activeSubjects, subject];
    setActiveSubjects(updated);
    saveActiveSubjects(updated);
    setSelectedSubject(subject);
  };

  const handleSendMessage = async (imageBase64?: string, imageMimeType?: string, suggestionText?: string) => {
    if (!activeConv || isSending || !canUse) return;

    const textToSend = suggestionText ?? inputText.trim();
    if (!textToSend && !imageBase64) return;

    const userContent = textToSend || 'Hãy giải thích bài tập trong ảnh từng bước chi tiết.';
    setInputText('');
    setError(null);
    setIsSending(true);
    setStreamingContent('');
    setIsStreaming(true);

    // Optimistic user message
    const tempMsg: AiMessage = {
      id: `temp-${Date.now()}`,
      role: 'USER',
      content: userContent,
      imageUrl: imageBase64 ? `data:${imageMimeType};base64,${imageBase64}` : null,
      createdAt: new Date().toISOString(),
    };
    setMessages(prev => [...prev, tempMsg]);

    // SSE Streaming
    const abortController = aiApi.sendMessageStream(
      activeConv.id,
      { content: userContent, imageBase64, imageMimeType },
      {
        onChunk: (text) => {
          setStreamingContent(prev => prev + text);
        },
        onDone: async () => {
          setIsStreaming(false);
          setIsSending(false);
          setStreamingContent('');
          // Refresh messages from server to get persisted version
          try {
            const msgs = await aiApi.getMessages(activeConv.id);
            setMessages(msgs);
            setDailyUsed(prev => prev + 1);
            loadConversations();
            loadSubscription();
          } catch {
            /* ignore refresh errors */
          }
        },
        onError: (errorMsg) => {
          setIsStreaming(false);
          setIsSending(false);
          setStreamingContent('');
          if (errorMsg.includes('AI_DAILY_LIMIT_REACHED')) {
            setShowDailyLimitPopup(true);
          } else {
            setError(errorMsg || 'Có lỗi xảy ra, thử lại nhé.');
          }
          setMessages(prev => prev.filter(m => m.id !== tempMsg.id));
        },
      }
    );
    streamAbortRef.current = abortController;
  };

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

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  const handleTextareaChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setInputText(e.target.value);
    const ta = e.target;
    ta.style.height = 'auto';
    ta.style.height = Math.min(ta.scrollHeight, 160) + 'px';
  };

  const canUse = subscription?.canUseAi ?? false;
  const isExpired = !isLoadingSubscription && subscription !== null && !canUse;
  const filteredConversations = conversations.filter(c => c.subject === selectedSubject);

  return (
    <div className="ai-page">
      {/* ── Sidebar: subject tabs + conversations ── */}
      <aside className="ai-conv-sidebar">
        <div className="ai-conv-sidebar__header">
          <div className="ai-conv-sidebar__title">
            <Sparkles size={18} />
            <span>Gia sư AI</span>
          </div>
          <SubBadge subscription={subscription} loading={isLoadingSubscription} />
        </div>

        {/* Subject tabs */}
        <div className="ai-subject-tabs">
          {activeSubjects.map(subject => (
            <button
              key={subject}
              className={`ai-subject-tab ${selectedSubject === subject ? 'active' : ''}`}
              onClick={() => setSelectedSubject(subject)}
            >
              <span className="ai-subject-tab__icon">{SUBJECT_ICONS[subject]}</span>
              <span className="ai-subject-tab__name">{subject}</span>
            </button>
          ))}
          {activeSubjects.length < ALL_SUBJECTS.length && (
            <button
              className="ai-subject-tab ai-subject-tab--add"
              onClick={() => setShowSubjectPicker(true)}
            >
              <Plus size={14} />
              <span className="ai-subject-tab__name">Thêm</span>
            </button>
          )}
        </div>

        {/* New conversation button */}
        <button
          className="ai-conv-sidebar__new"
          onClick={handleNewConversation}
          disabled={!canUse}
        >
          <Plus size={16} /> Hội thoại {selectedSubject} mới
        </button>

        {/* Conversation list filtered by subject */}
        <div className="ai-conv-sidebar__list">
          {filteredConversations.length === 0 ? (
            <p className="ai-conv-sidebar__empty">
              Chưa có hội thoại nào cho môn {selectedSubject}.<br />
              Bấm nút ở trên để bắt đầu! 🚀
            </p>
          ) : (
            filteredConversations.map(conv => (
              <button
                key={conv.id}
                className={`ai-conv-item ${activeConv?.id === conv.id ? 'active' : ''}`}
                onClick={() => selectConversation(conv)}
              >
                <Bot size={14} className="ai-conv-item__icon" />
                <div className="ai-conv-item__info">
                  <span className="ai-conv-item__title">{conv.title || 'Cuộc trò chuyện'}</span>
                </div>
                <button
                  className="ai-conv-item__delete"
                  onClick={(e) => handleDeleteConversation(conv.id, e)}
                >
                  <Trash2 size={13} />
                </button>
              </button>
            ))
          )}
        </div>

        {/* Usage indicator (trial only) */}
        {subscription?.trial && (
          <div className="ai-conv-sidebar__footer">
            <UsageIndicator used={dailyUsed} limit={TRIAL_DAILY_LIMIT} />
          </div>
        )}
      </aside>

      {/* ── Main chat area ── */}
      <main className="ai-chat-main">
        {/* Trial warning */}
        {subscription?.trial && (
          <TrialBanner daysRemaining={subscription.trialDaysRemaining ?? 0} />
        )}

        {isExpired ? (
          <PaywallScreen />
        ) : (
          <>
            {/* Learning goal bar */}
            {activeConv && (
              <div className="ai-goal-bar">
                <Target size={14} className="ai-goal-bar__icon" />
                {editingGoal ? (
                  <div className="ai-goal-bar__edit">
                    <input
                      className="ai-goal-bar__input"
                      value={goalInput}
                      onChange={(e) => setGoalInput(e.target.value)}
                      placeholder="VD: Ôn thi giữa kỳ chương 3-4, Luyện đạo hàm..."
                      autoFocus
                      maxLength={500}
                      onKeyDown={(e) => {
                        if (e.key === 'Enter') handleUpdateLearningGoal();
                        if (e.key === 'Escape') setEditingGoal(false);
                      }}
                    />
                    <button className="ai-goal-bar__save" onClick={handleUpdateLearningGoal}>Lưu</button>
                    <button className="ai-goal-bar__cancel" onClick={() => setEditingGoal(false)}><X size={14} /></button>
                  </div>
                ) : (
                  <button
                    className="ai-goal-bar__btn"
                    onClick={() => {
                      setGoalInput(activeConv.learningGoal || '');
                      setEditingGoal(true);
                    }}
                  >
                    {activeConv.learningGoal
                      ? <><span className="ai-goal-bar__label">🎯</span> {activeConv.learningGoal}</>
                      : <span className="ai-goal-bar__placeholder">Đặt mục tiêu học tập...</span>
                    }
                  </button>
                )}
              </div>
            )}

            {/* Messages area */}
            <div className="ai-messages">
              {isLoadingMessages ? (
                <div className="ai-messages__loading">
                  <Loader2 size={24} className="spinning" />
                  <span>Đang tải hội thoại...</span>
                </div>
              ) : !activeConv ? (
                <EmptyChat
                  subject={selectedSubject}
                  onSuggestion={(text) => {
                    handleNewConversation().then(() => setInputText(text));
                  }}
                />
              ) : messages.length === 0 ? (
                <EmptyChat
                  subject={selectedSubject}
                  onSuggestion={(text) => {
                    setInputText(text);
                    textareaRef.current?.focus();
                  }}
                />
              ) : (
                messages.map(msg => <MessageBubble key={msg.id} message={msg} />)
              )}

              {/* AI streaming / typing indicator */}
              {isSending && (
                <div className="ai-msg ai-msg--assistant">
                  <div className="ai-msg__avatar"><Bot size={16} /></div>
                  <div className="ai-msg__bubble">
                    {isStreaming && streamingContent ? (
                      <div className="ai-msg__content">
                        <MarkdownRenderer content={streamingContent} />
                        <span className="ai-streaming-cursor">▌</span>
                      </div>
                    ) : (
                      <div className="ai-typing">
                        <span /><span /><span />
                      </div>
                    )}
                  </div>
                </div>
              )}
              <div ref={messagesEndRef} />
            </div>

            {/* Error toast */}
            {error && (
              <div className="ai-error">
                <AlertCircle size={15} />
                <span>{error}</span>
                <button onClick={() => setError(null)}><X size={14} /></button>
              </div>
            )}

            {/* Input area */}
            <div className="ai-input-area">
              <div className="ai-input-box">
                <button
                  className="ai-input-box__attach"
                  onClick={() => fileInputRef.current?.click()}
                  title="Chụp ảnh / Chọn ảnh bài tập"
                  disabled={isSending || !activeConv}
                >
                  <Camera size={19} />
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
                  placeholder={
                    activeConv
                      ? `Hỏi Gia sư AI môn ${selectedSubject} bất cứ điều gì... (Enter gửi)`
                      : `Nhấn "Hội thoại mới" để bắt đầu học ${selectedSubject}`
                  }
                  value={inputText}
                  onChange={handleTextareaChange}
                  onKeyDown={handleKeyDown}
                  disabled={isSending || !activeConv}
                  rows={1}
                />
                <button
                  className="ai-input-box__send"
                  onClick={() => handleSendMessage()}
                  disabled={isSending || !inputText.trim() || !activeConv}
                >
                  {isSending
                    ? <Loader2 size={19} className="spinning" />
                    : <Send size={19} />}
                </button>
              </div>
              <p className="ai-input-area__hint">
                AI có thể nhầm. Hãy kiểm tra lại đáp án quan trọng.
              </p>
            </div>
          </>
        )}
      </main>

      {/* ── Modals ── */}
      {showSubjectPicker && (
        <SubjectPickerModal
          activeSubjects={activeSubjects}
          onAdd={handleAddSubject}
          onClose={() => setShowSubjectPicker(false)}
        />
      )}

      {showDailyLimitPopup && (
        <DailyLimitPopup onClose={() => setShowDailyLimitPopup(false)} />
      )}
    </div>
  );
}
