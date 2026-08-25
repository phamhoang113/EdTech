import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Sparkles, ChevronRight, X } from 'lucide-react';
import { completeOnboardingApi } from '../../services/authApi';
import { useAuthStore } from '../../store/useAuthStore';
import type { UserRole } from '../../store/useAuthStore';
import './OnboardingModal.css';

interface OnboardingStep {
  emoji: string;
  title: string;
  description: string;
  highlights?: string[];
  action?: { label: string; path: string };
}

const ONBOARDING_STEPS: Record<Exclude<UserRole, 'ADMIN'>, OnboardingStep[]> = {
  PARENT: [
    {
      emoji: '📋',
      title: 'Quản lý lớp học & con em',
      description: 'Trên nền tảng, bạn có thể dễ dàng:',
      highlights: [
        '📚 Tạo yêu cầu mở lớp để tìm gia sư phù hợp',
        '👧 Thêm và quản lý hồ sơ con em',
        '📊 Theo dõi tiến độ học tập và lịch học',
        '💬 Nhắn tin trực tiếp với gia sư',
      ],
    },
    {
      emoji: '🎯',
      title: 'Yêu cầu mở lớp ngay!',
      description: 'Bắt đầu hành trình học tập cho con bằng cách tạo yêu cầu mở lớp. Chúng tôi sẽ tìm gia sư phù hợp nhất cho bạn.',
      action: { label: 'Mở lớp ngay', path: '/parent/dashboard?openCreateClass=true' },
    },
  ],
  STUDENT: [
    {
      emoji: '📅',
      title: 'Quản lý học tập & liên kết',
      description: 'Là học sinh, bạn có thể:',
      highlights: [
        '📅 Xem lịch học và thời khóa biểu',
        '📝 Theo dõi bài tập và tiến trình',
        '🔗 Liên kết với phụ huynh để họ theo dõi',
        '💬 Nhắn tin với gia sư và phụ huynh',
      ],
    },
  ],
  TUTOR: [
    {
      emoji: '🗓️',
      title: 'Quản lý lịch dạy & thời gian biểu',
      description: 'Là gia sư trên nền tảng, bạn có thể:',
      highlights: [
        '📅 Quản lý lịch dạy và thời gian biểu',
        '📊 Theo dõi thu nhập và các lớp đang dạy',
        '🙋 Xin vắng mặt khi có việc bận',
        '💬 Nhắn tin với phụ huynh và học sinh',
      ],
    },
  ],
};

const ROLE_CONFIG: Record<Exclude<UserRole, 'ADMIN'>, { emoji: string; title: string; gradient: string; color: string }> = {
  PARENT: {
    emoji: '👨‍👩‍👧',
    title: 'Phụ huynh',
    gradient: 'linear-gradient(135deg, #8b5cf6 0%, #a78bfa 100%)',
    color: '#8b5cf6',
  },
  STUDENT: {
    emoji: '📚',
    title: 'Học sinh',
    gradient: 'linear-gradient(135deg, #06b6d4 0%, #22d3ee 100%)',
    color: '#06b6d4',
  },
  TUTOR: {
    emoji: '👩‍🏫',
    title: 'Gia sư',
    gradient: 'linear-gradient(135deg, #6366f1 0%, #818cf8 100%)',
    color: '#6366f1',
  },
};

interface OnboardingModalProps {
  role: Exclude<UserRole, 'ADMIN'>;
  fullName: string;
}

export const OnboardingModal = ({ role, fullName }: OnboardingModalProps) => {
  const [currentStep, setCurrentStep] = useState(0);
  const updateUser = useAuthStore(state => state.updateUser);
  const navigate = useNavigate();

  const steps = ONBOARDING_STEPS[role];
  const config = ROLE_CONFIG[role];
  const totalSteps = steps.length;
  const isOnLastStep = currentStep === totalSteps - 1;

  const handleComplete = async () => {
    try {
      await completeOnboardingApi();
    } catch {
      // Fail silently
    }
    updateUser({ hasCompletedOnboarding: true });
  };

  const handleActionClick = (path: string) => {
    completeOnboardingApi().catch(() => {});
    updateUser({ hasCompletedOnboarding: true });
    navigate(path);
  };

  const handleFinish = () => {
    handleComplete();
  };

  const step = steps[currentStep];

  return (
    <div className="onboarding-overlay">
      <div className="onboarding-modal">
        {/* Close */}
        <button className="onboarding-close" onClick={handleComplete} aria-label="Đóng">
          <X size={20} />
        </button>

        {/* Welcome header — luôn hiện */}
        <div className="onboarding-header" style={{ background: config.gradient }}>
          <div className="onboarding-header-sparkle">
            <Sparkles size={28} />
          </div>
          <span className="onboarding-header-emoji">{config.emoji}</span>
          <h2 className="onboarding-header-title">
            {currentStep === 0
              ? `Chào mừng ${firstName(fullName)}! 🎉`
              : step.title}
          </h2>
          <p className="onboarding-header-sub">
            {currentStep === 0
              ? <>Tài khoản <strong>{config.title}</strong> đã sẵn sàng!</>
              : step.description.slice(0, 60)}
          </p>
        </div>

        {/* Progress dots */}
        {totalSteps > 1 && (
          <div className="onboarding-progress">
            {steps.map((_, i) => (
              <div
                key={i}
                className={`onboarding-dot ${i === currentStep ? 'active' : ''} ${i < currentStep ? 'completed' : ''}`}
                style={{ '--accent': config.color } as React.CSSProperties}
              />
            ))}
          </div>
        )}

        {/* Step content */}
        <div className="onboarding-body" key={currentStep}>
          <div className="onboarding-step-emoji">{step.emoji}</div>

          {currentStep === 0 && (
            <h3 className="onboarding-step-title">{step.title}</h3>
          )}

          <p className="onboarding-step-desc">{step.description}</p>

          {/* Highlight list */}
          {step.highlights && (
            <ul className="onboarding-highlights">
              {step.highlights.map((item, i) => (
                <li key={i} className="onboarding-highlight-item">
                  {item}
                </li>
              ))}
            </ul>
          )}

          {/* Action CTA */}
          {step.action && (
            <button
              className="onboarding-cta"
              style={{ background: config.gradient }}
              onClick={() => handleActionClick(step.action!.path)}
            >
              {step.action.label}
              <ChevronRight size={18} />
            </button>
          )}
        </div>

        {/* Footer nav */}
        <div className="onboarding-footer">
          {currentStep > 0 && (
            <button
              className="onboarding-footer-btn onboarding-footer-prev"
              onClick={() => setCurrentStep(s => s - 1)}
            >
              ← Quay lại
            </button>
          )}

          {isOnLastStep ? (
            <button
              className="onboarding-footer-btn onboarding-footer-next"
              style={{ background: config.gradient }}
              onClick={step.action ? handleFinish : handleFinish}
            >
              {step.action ? 'Bỏ qua, vào Dashboard' : 'Vào Dashboard 🚀'}
            </button>
          ) : (
            <button
              className="onboarding-footer-btn onboarding-footer-next"
              style={{ background: config.gradient }}
              onClick={() => setCurrentStep(s => s + 1)}
            >
              Tiếp theo <ChevronRight size={16} />
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

/** Lấy tên gọi ngắn (tên cuối) */
function firstName(fullName: string): string {
  const parts = fullName.trim().split(' ');
  return parts[parts.length - 1] || fullName;
}
