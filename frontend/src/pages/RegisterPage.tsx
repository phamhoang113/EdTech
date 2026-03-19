import { useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { registerApi } from '../services/authApi';
import { Eye, EyeOff, AlertCircle, CheckCircle, ArrowLeft } from 'lucide-react';
import './RegisterPage.css';

type Role = 'PARENT' | 'TUTOR' | 'STUDENT';

const roleConfig: Record<Role, { label: string; emoji: string; desc: string }> = {
  PARENT:  { label: 'Phụ huynh',  emoji: '👨‍👩‍👧', desc: 'Đặt gia sư & quản lý học tập cho con'        },
  STUDENT: { label: 'Học sinh',   emoji: '📚',     desc: 'Tự học, tự đặt gia sư & tự thanh toán'      },
  TUTOR:   { label: 'Gia sư',     emoji: '👩‍🏫',   desc: 'Dạy học, chia sẻ kiến thức, kiếm thu nhập'  },
};

export const RegisterPage = () => {
  const [searchParams] = useSearchParams();
  const role = (searchParams.get('role') as Role) || 'PARENT';
  const navigate = useNavigate();

  const [phone, setPhone]                   = useState('');
  const [fullName, setFullName]             = useState('');
  const [password, setPassword]             = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword]     = useState(false);
  const [showConfirm, setShowConfirm]       = useState(false);
  const [isLoading, setIsLoading]           = useState(false);
  const [error, setError]                   = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    if (password !== confirmPassword) {
      setError('Xác nhận mật khẩu không khớp.');
      return;
    }
    if (password.length < 6) {
      setError('Mật khẩu phải có ít nhất 6 ký tự.');
      return;
    }

    setIsLoading(true);
    try {
      const { otpToken } = await registerApi({ phone, password, fullName, role });
      navigate(`/verify-otp?otpToken=${encodeURIComponent(otpToken)}&phone=${encodeURIComponent(phone)}`);
    } catch (err: unknown) {
      const msg =
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
        'Đăng ký thất bại, vui lòng thử lại.';
      setError(msg);
    } finally {
      setIsLoading(false);
    }
  };

  const cfg = roleConfig[role];

  return (
    <div className="register-page">
      <div className="register-card">
        {/* Back button */}
        <button className="register-back" onClick={() => navigate(-1)}>
          <ArrowLeft size={15} />
          Quay lại
        </button>

        {/* Header */}
        <div className="register-header">
          <div className="register-logo">
            <div className="register-logo-icon">🎓</div>
            <span className="register-logo-name">EdTech</span>
          </div>
          <h1>Tạo tài khoản</h1>
          <p className="register-role-badge">
            <span>{cfg.emoji}</span>
            {cfg.label}
          </p>
          <p className="register-role-desc">{cfg.desc}</p>
        </div>

        {/* Form */}
        <form className="register-form" onSubmit={handleSubmit}>
          {error && (
            <div className="form-error">
              <AlertCircle size={16} />
              <span>{error}</span>
            </div>
          )}

          <div className="form-group">
            <label htmlFor="reg-name">Họ và tên</label>
            <input
              id="reg-name"
              type="text"
              className="form-input"
              placeholder="Nhập họ và tên đầy đủ"
              value={fullName}
              onChange={e => setFullName(e.target.value)}
              required
              autoFocus
            />
          </div>

          <div className="form-group">
            <label htmlFor="reg-phone">Số điện thoại</label>
            <input
              id="reg-phone"
              type="tel"
              className="form-input"
              placeholder="Ví dụ: 0901234567"
              value={phone}
              onChange={e => setPhone(e.target.value)}
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="reg-password">Mật khẩu</label>
            <div className="password-input-wrapper">
              <input
                id="reg-password"
                type={showPassword ? 'text' : 'password'}
                className="form-input"
                placeholder="Ít nhất 6 ký tự"
                value={password}
                onChange={e => setPassword(e.target.value)}
                required
              />
              <button
                type="button"
                className="password-toggle"
                onClick={() => setShowPassword(!showPassword)}
              >
                {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
          </div>

          <div className="form-group">
            <label htmlFor="reg-confirm">Xác nhận mật khẩu</label>
            <div className="password-input-wrapper">
              <input
                id="reg-confirm"
                type={showConfirm ? 'text' : 'password'}
                className="form-input"
                placeholder="Nhập lại mật khẩu"
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
                  {password === confirmPassword
                    ? <CheckCircle size={18} className="match" />
                    : <AlertCircle size={18} className="no-match" />}
                </span>
              )}
            </div>
          </div>

          <button
            type="submit"
            id="register-submit"
            className={`register-submit-btn${isLoading ? ' loading' : ''}`}
            disabled={isLoading}
          >
            {isLoading ? 'Đang xử lý...' : 'Đăng ký'}
          </button>

          <p className="register-terms">
            Bằng cách đăng ký, bạn đồng ý với{' '}
            <a href="#terms">Điều khoản sử dụng</a> của chúng tôi.
          </p>
        </form>
      </div>
    </div>
  );
};
