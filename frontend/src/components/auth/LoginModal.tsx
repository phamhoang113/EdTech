import { X, Eye, EyeOff, AlertCircle } from 'lucide-react';
import { useState } from 'react';
import { Button } from '../ui/Button';

import { useAuthStore } from '../../store/useAuthStore';
import { useNavigate } from 'react-router-dom';
import { RoleSelectionModal } from './RoleSelectionModal';
import { ForgotPasswordModal } from './ForgotPasswordModal';
import { SocialLoginButtons } from './SocialLoginButtons';
import { loginApi } from '../../services/authApi';
import type { TokenResponse } from '../../services/authApi';
import { useEscapeKey } from '../../hooks/useEscapeKey';
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
  const [error, setError] = useState<string | null>(null);
  const [showRoleSelection, setShowRoleSelection] = useState(initialMode === 'register');
  const [showForgotPassword, setShowForgotPassword] = useState(false);

  const { login, redirectUrl, setRedirectUrl } = useAuthStore();
  const navigate = useNavigate();
  useEscapeKey(onClose);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);

    try {
      const data = await loginApi({ phone, password });
      login(
        { phone, role: data.role, fullName: data.fullName, avatarBase64: data.avatarBase64 ?? undefined },
        data.accessToken,
        data.refreshToken
      );
      onClose();
      if (redirectUrl) {
        navigate(redirectUrl);
        setRedirectUrl(null);
      } else if (data.role === 'ADMIN') {
        navigate('/admin/dashboard');
      } else {
        navigate('/dashboard');
      }
    } catch (err: unknown) {
      const msg =
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
        'Đăng nhập thất bại, vui lòng thử lại.';
      setError(msg);
    } finally {
      setIsLoading(false);
    }
  };

  if (showRoleSelection) {
    return (
      <RoleSelectionModal
        onClose={onClose}
        onBack={() => setShowRoleSelection(false)}
      />
    );
  }

  if (showForgotPassword) {
    return (
      <ForgotPasswordModal
        onClose={onClose}
        onBackToLogin={() => setShowForgotPassword(false)}
      />
    );
  }

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={e => e.stopPropagation()}>
        <button className="modal-close" onClick={onClose} aria-label="Close">
          <X size={24} />
        </button>

        <div className="modal-header">
          <h2 className="modal-title">Xin chào!</h2>
          <p className="modal-subtitle">Vui lòng đăng nhập để tiếp tục.</p>
        </div>

        <form className="modal-body" onSubmit={handleLogin}>
          {error && (
            <div className="form-error">
              <AlertCircle size={16} />
              <span>{error}</span>
            </div>
          )}

          <div className="form-group">
            <label htmlFor="phone">Tài khoản</label>
            <input
              id="phone"
              type="text"
              className="form-input"
              placeholder="Nhập SĐT hoặc tên đăng nhập"
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
                type={showPassword ? 'text' : 'password'}
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
              <button type="button" className="text-btn" onClick={() => setShowForgotPassword(true)}>Quên mật khẩu?</button>
            </div>
          </div>

          <Button type="submit" fullWidth isLoading={isLoading} className="login-btn">
            Đăng Nhập
          </Button>

          <div className="modal-divider">
            <span>Hoặc</span>
          </div>

          <SocialLoginButtons
            mode="login"
            onSuccess={(data: TokenResponse) => {
              login(
                { phone: data.email || '', role: data.role, fullName: data.fullName, avatarBase64: data.avatarBase64 ?? undefined },
                data.accessToken,
                data.refreshToken
              );
              onClose();
              if (data.role === 'ADMIN') {
                navigate('/admin/dashboard');
              } else {
                navigate('/dashboard');
              }
            }}
            onError={(msg: string) => setError(msg)}
          />

          <div style={{ marginTop: 'var(--spacing-4)' }}>
            <Button
              type="button"
              variant="ghost"
              fullWidth
              onClick={() => setShowRoleSelection(true)}
            >
              Chưa có tài khoản? Đăng ký ngay
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
};
