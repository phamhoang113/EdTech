import { useState } from 'react';
import { Button } from '../ui/Button';
import { X, Users, BookOpen, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import './RoleSelectionModal.css';

interface RoleSelectionModalProps {
  onClose: () => void;
  onBack: () => void;
}

export const RoleSelectionModal = ({ onClose, onBack }: RoleSelectionModalProps) => {
  const [selectedRole, setSelectedRole] = useState<'PARENT' | 'TUTOR' | null>(null);

  const navigate = useNavigate();

  const handleContinue = () => {
    if (!selectedRole) return;
    
    // Push to the register page with the selected role
    onClose(); // Close the modal
    navigate(`/register?role=${selectedRole}`);
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content glass-effect role-modal" onClick={e => e.stopPropagation()}>
        <button className="modal-back" onClick={onBack} aria-label="Back to login">
          <ArrowLeft size={24} />
        </button>
        <button className="modal-close" onClick={onClose} aria-label="Close">
          <X size={24} />
        </button>

        <div className="modal-header">
          <h2 className="modal-title">Tham gia cùng chúng tôi</h2>
          <p className="modal-subtitle">Bạn muốn tạo tài khoản với vai trò nào?</p>
        </div>

        <div className="modal-body">
          <div className="role-cards-container">
            <div 
              className={`role-card parent-card ${selectedRole === 'PARENT' ? 'selected' : ''}`}
              onClick={() => setSelectedRole('PARENT')}
            >
              <div className="role-icon-wrapper">
                <Users className="role-icon" />
              </div>
              <h3 className="role-title">Tìm Gia Sư</h3>
              <p className="role-desc">
                Tôi muốn tìm gia sư chất lượng cho con tôi hoặc cho bản thân. Tôi muốn đăng ký học.
              </p>
              <div className="role-check">✓</div>
            </div>

            <div 
              className={`role-card tutor-card ${selectedRole === 'TUTOR' ? 'selected' : ''}`}
              onClick={() => setSelectedRole('TUTOR')}
            >
              <div className="role-icon-wrapper">
                <BookOpen className="role-icon" />
              </div>
              <h3 className="role-title">Trở Thành Gia Sư</h3>
              <p className="role-desc">
                Tôi muốn áp dụng chuyên môn để kiếm thêm thu nhập bằng cách dạy kèm.
              </p>
              <div className="role-check">✓</div>
            </div>
          </div>

          <Button 
            fullWidth 
            onClick={handleContinue} 
            disabled={!selectedRole}
            className="continue-btn"
          >
            Tiếp tục
          </Button>

          <div className="role-footer">
            <button className="text-btn" onClick={onBack}>
              Đã có tài khoản? Đăng nhập
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
