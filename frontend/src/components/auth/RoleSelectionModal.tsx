import { X, Users, BookOpen, GraduationCap, ArrowLeft, Check } from 'lucide-react';
import { useState } from 'react';
import { Button } from '../ui/Button';

import { useNavigate } from 'react-router-dom';
import { useEscapeKey } from '../../hooks/useEscapeKey';
import './RoleSelectionModal.css';

interface RoleSelectionModalProps {
  onClose: () => void;
  onBack: () => void;
}

type SelectableRole = 'PARENT' | 'STUDENT' | 'TUTOR';

const roles: {
  key: SelectableRole;
  emoji: string;
  title: string;
  subtitle: string;
  desc: string;
  accentClass: string;
}[] = [
    {
      key: 'PARENT',
      emoji: '👨‍👩‍👧',
      title: 'Phụ huynh',
      subtitle: 'Đặt gia sư cho con',
      desc: 'Tìm gia sư chất lượng, đặt lịch và theo dõi tiến độ học tập của con em.',
      accentClass: 'accent-violet',
    },
    {
      key: 'STUDENT',
      emoji: '📚',
      title: 'Học sinh',
      subtitle: 'Người học',
      desc: 'Tự tìm gia sư phù hợp, đặt lịch học và thanh toán học phí cho bản thân.',
      accentClass: 'accent-cyan',
    },
    {
      key: 'TUTOR',
      emoji: '👩‍🏫',
      title: 'Gia sư',
      subtitle: 'Dạy học, kiếm thêm thu nhập',
      desc: 'Chia sẻ kiến thức, nhận học sinh và tạo nguồn thu nhập ổn định từ việc dạy thêm.',
      accentClass: 'accent-indigo',
    },
  ];

export const RoleSelectionModal = ({ onClose, onBack }: RoleSelectionModalProps) => {
  const [selectedRole, setSelectedRole] = useState<SelectableRole | null>(null);
  const navigate = useNavigate();
  useEscapeKey(onClose);

  const handleContinue = () => {
    if (!selectedRole) return;
    onClose();
    navigate(`/register?role=${selectedRole}`);
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={e => e.stopPropagation()}>
        <button className="modal-back" onClick={onBack} aria-label="Back">
          <ArrowLeft size={20} />
        </button>
        <button className="modal-close" onClick={onClose} aria-label="Close">
          <X size={20} />
        </button>

        <div className="modal-header">
          <h2 className="modal-title">Tham gia cùng chúng tôi</h2>
          <p className="modal-subtitle">Bạn muốn đăng ký với vai trò nào?</p>
        </div>

        <div className="modal-body">
          {/* Vertical role list */}
          <div className="role-list">
            {roles.map(r => (
              <div
                key={r.key}
                className={`role-row ${r.accentClass} ${selectedRole === r.key ? 'selected' : ''}`}
                onClick={() => setSelectedRole(r.key)}
                role="button"
                tabIndex={0}
                onKeyDown={e => e.key === 'Enter' && setSelectedRole(r.key)}
              >
                {/* Left: emoji */}
                <div className="role-row-emoji">{r.emoji}</div>

                {/* Middle: text */}
                <div className="role-row-text">
                  <div className="role-row-title">
                    {r.key === 'PARENT' && <Users size={17} className="rr-icon" />}
                    {r.key === 'STUDENT' && <GraduationCap size={17} className="rr-icon" />}
                    {r.key === 'TUTOR' && <BookOpen size={17} className="rr-icon" />}
                    {r.title}
                    <span className="role-row-sub">{r.subtitle}</span>
                  </div>
                  <p className="role-row-desc">{r.desc}</p>
                </div>

                {/* Right: radio indicator */}
                <div className={`role-radio ${selectedRole === r.key ? 'checked' : ''}`}>
                  {selectedRole === r.key && <Check size={14} strokeWidth={3} />}
                </div>
              </div>
            ))}
          </div>

          <Button
            fullWidth
            onClick={handleContinue}
            disabled={!selectedRole}
            className="continue-btn"
          >
            {selectedRole
              ? `Tiếp tục với vai trò ${roles.find(r => r.key === selectedRole)?.title}`
              : 'Chọn vai trò để tiếp tục'}
          </Button>

          <p className="role-footer-text">
            <button className="text-btn" onClick={onBack}>
              Đã có tài khoản? Đăng nhập
            </button>
          </p>
        </div>
      </div>
    </div>
  );
};
