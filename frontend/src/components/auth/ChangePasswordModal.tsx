import { X, Eye, EyeOff, AlertCircle, CheckCircle, ShieldAlert } from 'lucide-react';
import { useState } from 'react';
import { Button } from '../ui/Button';

import { changePasswordApi } from '../../services/authApi';
import { useEscapeKey } from '../../hooks/useEscapeKey';
import { useAuthStore } from '../../store/useAuthStore';

import './LoginModal.css';
import './ChangePasswordModal.css';

interface ChangePasswordModalProps {
  onClose: () => void;
  isMandatory?: boolean;
}

export const ChangePasswordModal = ({ onClose, isMandatory = false }: ChangePasswordModalProps) => {
  const [oldPassword, setOldPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  const [showOld, setShowOld] = useState(false);
  const [showNew, setShowNew] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);

  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const updateUser = useAuthStore(state => state.updateUser);

  // Still allow escape to close even if mandatory so they can 'skip' per user requirement
  useEscapeKey(onClose);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (newPassword.length < 6) {
      setError('Mật khẩu mới phải có ít nhất 6 ký tự.');
      return;
    }

    if (newPassword !== confirmPassword) {
      setError('Xác nhận mật khẩu không khớp.');
      return;
    }

    setIsLoading(true);
    try {
      await changePasswordApi({ oldPassword, newPassword });
      setSuccess(true);
      updateUser({ mustChangePassword: false });
      
      // Auto close after 2s
      setTimeout(() => {
        onClose();
      }, 2000);
      
    } catch (err: any) {
      setError(err.response?.data?.message || 'Đổi mật khẩu thất bại. Mật khẩu hiện tại không đúng.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content change-password-modal" onClick={e => e.stopPropagation()}>
        <button className="modal-close" onClick={onClose} aria-label="Close">
          <X size={24} />
        </button>

        <div className="modal-header">
          <h2 className="modal-title">Đổi Mật Khẩu</h2>
        </div>

        <div className="modal-body">
          {success ? (
            <div className="fp-success-box" style={{ margin: '20px 0' }}>
              <h3 className="fp-success-title"><CheckCircle size={20} /> Đổi mật khẩu thành công</h3>
              <p>Hệ thống tự động đóng cử sổ sau giây lát...</p>
            </div>
          ) : (
            <form onSubmit={handleSubmit}>
              {isMandatory && (
                <div className="cp-mandatory-alert">
                  <ShieldAlert size={18} />
                  <span>Vì lý do bảo mật, bạn nên thay đổi mật khẩu mặc định thành mật khẩu cá nhân mới.</span>
                </div>
              )}

              {error && (
                <div className="form-error">
                  <AlertCircle size={16} />
                  <span>{error}</span>
                </div>
              )}

              <div className="form-group">
                <label htmlFor="cp-old">Mật khẩu hiện tại</label>
                <div className="password-input-wrapper">
                  <input
                    id="cp-old"
                    type={showOld ? 'text' : 'password'}
                    className="form-input"
                    placeholder="Mật khẩu hiện tại"
                    value={oldPassword}
                    onChange={e => setOldPassword(e.target.value)}
                    required
                    autoFocus
                  />
                  <button type="button" className="password-toggle" onClick={() => setShowOld(!showOld)}>
                    {showOld ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="cp-new">Mật khẩu mới</label>
                <div className="password-input-wrapper">
                  <input
                    id="cp-new"
                    type={showNew ? 'text' : 'password'}
                    className="form-input"
                    placeholder="Tối thiểu 6 ký tự"
                    value={newPassword}
                    onChange={e => setNewPassword(e.target.value)}
                    required
                  />
                  <button type="button" className="password-toggle" onClick={() => setShowNew(!showNew)}>
                    {showNew ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
              </div>

              <div className="form-group">
                <label htmlFor="cp-confirm">Xác nhận mật khẩu mới</label>
                <div className="password-input-wrapper">
                  <input
                    id="cp-confirm"
                    type={showConfirm ? 'text' : 'password'}
                    className="form-input"
                    placeholder="Nhập lại mật khẩu mới"
                    value={confirmPassword}
                    onChange={e => setConfirmPassword(e.target.value)}
                    required
                  />
                  <button 
                    type="button" 
                    className="password-toggle" 
                    onClick={() => setShowConfirm(!showConfirm)}
                    style={{ right: confirmPassword ? '40px' : '12px' }}
                  >
                    {showConfirm ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                  {confirmPassword && (
                    <span className="password-match-icon">
                      {newPassword === confirmPassword
                        ? <CheckCircle size={18} className="match" />
                        : <AlertCircle size={18} className="no-match" />}
                    </span>
                  )}
                </div>
              </div>

              <Button type="submit" fullWidth isLoading={isLoading}>
                Cập nhật Mật khẩu
              </Button>
            </form>
          )}
        </div>
      </div>
    </div>
  );
};
