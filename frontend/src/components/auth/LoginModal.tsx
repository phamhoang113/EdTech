import { X, Eye, EyeOff, AlertCircle, Users, BookOpen, GraduationCap, Check } from 'lucide-react';
import { useState } from 'react';
import { Button } from '../ui/Button';

import { useAuthStore } from '../../store/useAuthStore';
import { useNavigate } from 'react-router-dom';
import { ForgotPasswordModal } from './ForgotPasswordModal';
import { SocialLoginButtons } from './SocialLoginButtons';
import { loginApi, firebaseAuthApi } from '../../services/authApi';
import type { TokenResponse } from '../../services/authApi';
import { useEscapeKey } from '../../hooks/useEscapeKey';
import './LoginModal.css';
import './RoleSelectionModal.css';

type SelectableRole = 'PARENT' | 'STUDENT' | 'TUTOR';

interface LoginModalProps {
  onClose: () => void;
  initialMode?: 'login' | 'register';
}

/** Danh sách role cho social login */
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

export const LoginModal = ({ onClose, initialMode = 'login' }: LoginModalProps) => {
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showForgotPassword, setShowForgotPassword] = useState(false);

  // Social login — chọn role cho user mới
  const [pendingSocialIdToken, setPendingSocialIdToken] = useState<string | null>(null);
  const [pendingProvider, setPendingProvider] = useState<'google' | 'facebook' | null>(null);
  const [selectedRole, setSelectedRole] = useState<SelectableRole | null>(null);
  const [isRegisteringWithSocial, setIsRegisteringWithSocial] = useState(initialMode === 'register');
  const [showConfirm, setShowConfirm] = useState(false);

  const { login, redirectUrl, setRedirectUrl } = useAuthStore();
  const navigate = useNavigate();
  useEscapeKey(onClose);

  const handleLoginSuccess = (data: TokenResponse) => {
    login(
      { phone: data.email || phone, role: data.role, fullName: data.fullName, avatarBase64: data.avatarBase64 ?? undefined, hasCompletedOnboarding: data.hasCompletedOnboarding ?? true },
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
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);
    try {
      const data = await loginApi({ phone, password });
      handleLoginSuccess(data);
    } catch (err: unknown) {
      const msg =
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
        'Đăng nhập thất bại, vui lòng thử lại.';
      setError(msg);
    } finally {
      setIsLoading(false);
    }
  };

  /** Khi social login gặp user mới — lưu idToken + mở màn chọn role */
  const handleNeedRole = (idToken: string, provider: 'google' | 'facebook') => {
    setPendingSocialIdToken(idToken);
    setPendingProvider(provider);
    setSelectedRole(null);
    setError(null);
  };

  /** Sau khi chọn role → gọi API đăng ký với role đã chọn */
  const handleSocialRegisterWithRole = async () => {
    if (!pendingSocialIdToken || !selectedRole) return;
    setIsLoading(true);
    setError(null);
    try {
      const data = await firebaseAuthApi({
        idToken: pendingSocialIdToken,
        fullName: '',
        role: selectedRole,
      });
      handleLoginSuccess(data);
    } catch (err: unknown) {
      const msg =
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
        'Đăng ký thất bại, vui lòng thử lại.';
      setError(msg);
    } finally {
      setIsLoading(false);
    }
  };

  if (showForgotPassword) {
    return (
      <ForgotPasswordModal
        onClose={onClose}
        onBackToLogin={() => setShowForgotPassword(false)}
      />
    );
  }

  // Màn chọn role cho user mới đăng nhập bằng social
  if (pendingSocialIdToken !== null) {
    const providerName = pendingProvider === 'facebook' ? 'Facebook' : 'Google';
    const selectedInfo = selectedRole ? roles.find(r => r.key === selectedRole) : null;

    return (
      <div className="modal-overlay" onClick={onClose}>
        <div className="modal-content" onClick={e => e.stopPropagation()}>
          <button className="modal-close" onClick={onClose} aria-label="Close">
            <X size={24} />
          </button>

          {!showConfirm ? (
            <>
              <div className="modal-header">
                <h2 className="modal-title">Tham gia cùng chúng tôi</h2>
                <p className="modal-subtitle">
                  Tài khoản {providerName} của bạn chưa được đăng ký.<br />
                  Vui lòng chọn vai trò để hoàn tất đăng ký.
                </p>
              </div>

              <div className="modal-body">
                {error && (
                  <div className="form-error">
                    <AlertCircle size={16} />
                    <span>{error}</span>
                  </div>
                )}

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
                      <div className="role-row-emoji">{r.emoji}</div>
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
                      <div className={`role-radio ${selectedRole === r.key ? 'checked' : ''}`}>
                        {selectedRole === r.key && <Check size={14} strokeWidth={3} />}
                      </div>
                    </div>
                  ))}
                </div>

                <Button
                  fullWidth
                  onClick={() => { if (selectedRole) setShowConfirm(true); }}
                  disabled={!selectedRole}
                  className="continue-btn"
                >
                  {selectedRole
                    ? `Tiếp tục với vai trò ${roles.find(r => r.key === selectedRole)?.title}`
                    : 'Chọn vai trò để tiếp tục'}
                </Button>

                <p className="role-footer-text">
                  <button className="text-btn" onClick={() => { setPendingSocialIdToken(null); setPendingProvider(null); }}>
                    ← Quay lại đăng nhập
                  </button>
                </p>
              </div>
            </>
          ) : (
            <>
              <div className="modal-header">
                <h2 className="modal-title">Xác nhận vai trò</h2>
                <p className="modal-subtitle">Vui lòng xác nhận lựa chọn của bạn</p>
              </div>

              <div className="modal-body">
                {error && (
                  <div className="form-error">
                    <AlertCircle size={16} />
                    <span>{error}</span>
                  </div>
                )}

                {selectedInfo && (
                  <div className="role-confirm-card">
                    <div className="role-confirm-emoji">{selectedInfo.emoji}</div>
                    <div className="role-confirm-title">{selectedInfo.title}</div>
                    <div className="role-confirm-desc">{selectedInfo.desc}</div>
                    <div className="role-confirm-hint">
                      {selectedInfo.key === 'PARENT' && '👉 Chọn vai trò này nếu bạn là ba mẹ / phụ huynh muốn tìm gia sư cho con em.'}
                      {selectedInfo.key === 'STUDENT' && '👉 Chọn vai trò này nếu bạn là người học và muốn tự tìm gia sư cho bản thân.'}
                      {selectedInfo.key === 'TUTOR' && '👉 Chọn vai trò này nếu bạn muốn dạy học và kiếm thu nhập từ gia sư.'}
                    </div>
                  </div>
                )}

                <Button
                  fullWidth
                  onClick={handleSocialRegisterWithRole}
                  isLoading={isLoading}
                  className="continue-btn"
                >
                  ✅ Đúng rồi, đăng ký ngay
                </Button>

                <p className="role-footer-text">
                  <button className="text-btn" onClick={() => setShowConfirm(false)}>
                    ← Chọn lại vai trò khác
                  </button>
                </p>
              </div>
            </>
          )}
        </div>
      </div>
    );
  }

  // Màn đăng ký — chọn role rồi navigate sang /register
  if (isRegisteringWithSocial) {
    const selectedInfo = selectedRole ? roles.find(r => r.key === selectedRole) : null;

    return (
      <div className="modal-overlay" onClick={onClose}>
        <div className="modal-content" onClick={e => e.stopPropagation()}>
          <button className="modal-close" onClick={onClose} aria-label="Close">
            <X size={24} />
          </button>

          {!showConfirm ? (
            <>
              <div className="modal-header">
                <h2 className="modal-title">Tham gia cùng chúng tôi</h2>
                <p className="modal-subtitle">Bạn muốn đăng ký với vai trò nào?</p>
              </div>

              <div className="modal-body">
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
                      <div className="role-row-emoji">{r.emoji}</div>
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
                      <div className={`role-radio ${selectedRole === r.key ? 'checked' : ''}`}>
                        {selectedRole === r.key && <Check size={14} strokeWidth={3} />}
                      </div>
                    </div>
                  ))}
                </div>

                <Button
                  fullWidth
                  onClick={() => { if (selectedRole) setShowConfirm(true); }}
                  disabled={!selectedRole}
                  className="continue-btn"
                >
                  {selectedRole
                    ? `Tiếp tục với vai trò ${roles.find(r => r.key === selectedRole)?.title}`
                    : 'Chọn vai trò để tiếp tục'}
                </Button>

                <p className="role-footer-text">
                  <button className="text-btn" onClick={() => setIsRegisteringWithSocial(false)}>
                    Đã có tài khoản? Đăng nhập
                  </button>
                </p>
              </div>
            </>
          ) : (
            <>
              <div className="modal-header">
                <h2 className="modal-title">Xác nhận vai trò</h2>
                <p className="modal-subtitle">Vui lòng xác nhận lựa chọn của bạn</p>
              </div>

              <div className="modal-body">
                {selectedInfo && (
                  <div className="role-confirm-card">
                    <div className="role-confirm-emoji">{selectedInfo.emoji}</div>
                    <div className="role-confirm-title">{selectedInfo.title}</div>
                    <div className="role-confirm-desc">{selectedInfo.desc}</div>
                    <div className="role-confirm-hint">
                      {selectedInfo.key === 'PARENT' && '👉 Chọn vai trò này nếu bạn là ba mẹ / phụ huynh muốn tìm gia sư cho con em.'}
                      {selectedInfo.key === 'STUDENT' && '👉 Chọn vai trò này nếu bạn là người học và muốn tự tìm gia sư cho bản thân.'}
                      {selectedInfo.key === 'TUTOR' && '👉 Chọn vai trò này nếu bạn muốn dạy học và kiếm thu nhập từ gia sư.'}
                    </div>
                  </div>
                )}

                <Button
                  fullWidth
                  onClick={() => { if (selectedRole) { onClose(); navigate(`/register?role=${selectedRole}`); } }}
                  className="continue-btn"
                >
                  ✅ Đúng rồi, tiếp tục đăng ký
                </Button>

                <p className="role-footer-text">
                  <button className="text-btn" onClick={() => setShowConfirm(false)}>
                    ← Chọn lại vai trò khác
                  </button>
                </p>
              </div>
            </>
          )}
        </div>
      </div>
    );
  }

  // Màn đăng nhập chính
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
            onSuccess={handleLoginSuccess}
            onError={(msg: string) => setError(msg)}
            onNeedRole={handleNeedRole}
          />

          <div style={{ marginTop: 'var(--spacing-4)' }}>
            <Button
              type="button"
              variant="ghost"
              fullWidth
              onClick={() => setIsRegisteringWithSocial(true)}
            >
              Chưa có tài khoản? Đăng ký ngay
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
};
