import { useState } from 'react';
import { Button } from '../ui/Button';
import { X, Eye, EyeOff } from 'lucide-react';
import { useAuthStore } from '../../store/useAuthStore';
import { useNavigate } from 'react-router-dom';
import { RoleSelectionModal } from './RoleSelectionModal';
import './LoginModal.css';

interface LoginModalProps {
  onClose: () => void;
  initialMode?: 'login' | 'register';
}

export const LoginModal = ({ onClose, initialMode = 'login' }: LoginModalProps) => {
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [showRoleSelection, setShowRoleSelection] = useState(initialMode === 'register');

  const { login, redirectUrl, setRedirectUrl } = useAuthStore();
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    // Mock API Call
    setTimeout(() => {
      login({ id: 'u123', phone, role: 'PARENT', name: 'Phụ Huynh Demo' });
      setIsLoading(false);
      onClose();

      if (redirectUrl) {
        navigate(redirectUrl);
        setRedirectUrl(null);
      }
    }, 1000);
  };

  if (showRoleSelection) {
    return (
      <RoleSelectionModal 
        onClose={onClose} 
        onBack={() => setShowRoleSelection(false)} 
      />
    );
  }

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content glass-effect" onClick={e => e.stopPropagation()}>
        <button className="modal-close" onClick={onClose} aria-label="Close">
          <X size={24} />
        </button>

        <div className="modal-header">
          <h2 className="modal-title">Xin chào!</h2>
          <p className="modal-subtitle">Vui lòng đăng nhập để tiếp tục.</p>
        </div>

        <form className="modal-body" onSubmit={handleLogin}>
          <div className="form-group">
            <label htmlFor="phone">Số điện thoại</label>
            <input 
              id="phone"
              type="tel" 
              className="form-input" 
              placeholder="Nhập số điện thoại" 
              value={phone}
              onChange={e => setPhone(e.target.value)}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="password">Mật khẩu</label>
            <div className="password-input-wrapper">
              <input 
                id="password"
                type={showPassword ? "text" : "password"} 
                className="form-input" 
                placeholder="Nhập mật khẩu" 
                value={password}
                onChange={e => setPassword(e.target.value)}
                required
              />
              <button 
                type="button" 
                className="password-toggle"
                onClick={() => setShowPassword(!showPassword)}
                aria-label="Toggle password visibility"
              >
                {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
              </button>
            </div>
            <div className="forgot-password">
              <a href="#forgot">Quên mật khẩu?</a>
            </div>
          </div>

          <Button type="submit" fullWidth isLoading={isLoading} className="login-btn">
            Đăng Nhập
          </Button>

          <div className="modal-divider">
            <span>Hoặc</span>
          </div>

          <Button 
            type="button" 
            variant="ghost" 
            fullWidth 
            onClick={() => setShowRoleSelection(true)}
          >
            Chưa có tài khoản? Đăng ký ngay
          </Button>
        </form>
      </div>
    </div>
  );
};
