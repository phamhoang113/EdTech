import { Eye, EyeOff, AlertCircle, CheckCircle, ArrowLeft } from 'lucide-react';
import { useState, useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { firebaseAuthApi, checkPhoneApi } from '../services/authApi';
import type { TokenResponse } from '../services/authApi';
import { RecaptchaVerifier, signInWithPhoneNumber, type ConfirmationResult } from 'firebase/auth';
import { auth } from '../firebase';
import { useAuthStore } from '../store/useAuthStore';
import { SocialLoginButtons } from '../components/auth/SocialLoginButtons';

import { SEO } from '../components/common/SEO';
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
  const login = useAuthStore(state => state.login);

  const [step, setStep]                     = useState<'FORM' | 'OTP'>('FORM');
  const [phone, setPhone]                   = useState('');
  const [fullName, setFullName]             = useState('');
  const [password, setPassword]             = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [otpCode, setOtpCode]               = useState('');
  const [showPassword, setShowPassword]     = useState(false);
  const [showConfirm, setShowConfirm]       = useState(false);
  const [isLoading, setIsLoading]           = useState(false);
  const [error, setError]                   = useState<string | null>(null);

  const [confirmationResult, setConfirmationResult] = useState<ConfirmationResult | null>(null);

  useEffect(() => {
    // Clear recaptcha container if unmounted to prevent duplicates
    return () => {
      if ((window as any).recaptchaVerifier) {
        (window as any).recaptchaVerifier.clear();
        (window as any).recaptchaVerifier = null;
      }
    };
  }, []);

  const initRecaptcha = () => {
    if (!(window as any).recaptchaVerifier) {
      (window as any).recaptchaVerifier = new RecaptchaVerifier(auth, 'recaptcha-container', {
        size: 'invisible',
        callback: () => {
          // reCAPTCHA solved, allow signInWithPhoneNumber.
        }
      });
    }
  };

  const handleSendSms = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);

    let formattedPhone = phone.trim();
    if (!formattedPhone) {
      setError('Vui lòng nhập số điện thoại');
      return;
    }

    const phoneRegex = /^(\+84|84|0)(3|5|7|8|9)([0-9]{8})$/;
    if (!phoneRegex.test(formattedPhone)) {
      setError('Số điện thoại không hợp lệ định dạng Việt Nam.');
      return;
    }
    
    // Normalize to +84 format for Firebase
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '+84' + formattedPhone.slice(1);
    } else if (!formattedPhone.startsWith('+')) {
      formattedPhone = '+' + formattedPhone;
    }

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
      // Check trùng SĐT TRƯỚC khi gen OTP → tiết kiệm chi phí SMS
      const phoneExists = await checkPhoneApi(formattedPhone);
      if (phoneExists) {
        setError('Số điện thoại này đã được đăng ký. Vui lòng đăng nhập hoặc sử dụng số khác.');
        setIsLoading(false);
        return;
      }

      if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
        // BYPASS: Môi trường Local/SIT bỏ qua gọi Firebase thật để tránh block IP
        setConfirmationResult({
          confirm: async (code: string) => {
            if (code === '123456') {
              return {
                user: {
                  getIdToken: async () => 'MOCK_TOKEN_' + formattedPhone
                }
              };
            }
            throw new Error('Mã OTP sai. Môi trường test vui lòng nhập: 123456');
          }
        } as any);
        setStep('OTP');
      } else {
        initRecaptcha();
        const appVerifier = (window as any).recaptchaVerifier;
        const confirmResult = await signInWithPhoneNumber(auth, formattedPhone, appVerifier);
        setConfirmationResult(confirmResult);
        setStep('OTP');
      }
    } catch (err: any) {
      console.error(err);
      setError('Lỗi gửi SMS từ Firebase: ' + (err.message || 'Thử lại sau.'));
    } finally {
      setIsLoading(false);
    }
  };

  const handleVerifyOtp = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    if (!otpCode || otpCode.length < 6) {
      setError('Vui lòng nhập mã có 6 chữ số');
      return;
    }

    setIsLoading(true);
    try {
      const result = await confirmationResult!.confirm(otpCode);
      const idToken = await result.user.getIdToken();
      
      // Call Backend API to register user
      const tokenRes = await firebaseAuthApi({
        idToken,
        fullName,
        password,
        role
      });
      
      let formattedPhone = phone.trim();
      if (formattedPhone.startsWith('0')) {
        formattedPhone = '+84' + formattedPhone.slice(1);
      } else if (!formattedPhone.startsWith('+')) {
        formattedPhone = '+' + formattedPhone;
      }

      login({
        phone: formattedPhone,
        role: tokenRes.role,
        fullName: tokenRes.fullName,
        avatarBase64: tokenRes.avatarBase64 || undefined
      }, tokenRes.accessToken, tokenRes.refreshToken);
      
      navigate('/dashboard', { replace: true });

    } catch (err: any) {
      console.error(err);
      setError('Xác thực thất bại: ' + (err.response?.data?.message || err.message || 'Mã OTP không hợp lệ'));
    } finally {
      setIsLoading(false);
    }
  };

  const cfg = roleConfig[role];

  return (
    <div className="register-page">
      <SEO
        title="Đăng Ký Tài Khoản | Gia Sư Tinh Hoa"
        description="Đăng ký tài khoản Phụ huynh, Học sinh hoặc Gia sư trên nền tảng Gia Sư Tinh Hoa. Bắt đầu hành trình học tập ngay hôm nay."
      />
      <div className="register-card">
        {/* Back button */}
        <button className="register-back" onClick={() => step === 'OTP' ? setStep('FORM') : navigate(-1)}>
          <ArrowLeft size={15} />
          Quay lại
        </button>

        {/* Header */}
        <div className="register-header">
          <div className="register-logo">
            <div className="register-logo-icon">🎓</div>
            <span className="register-logo-name">Gia Sư Tinh Hoa</span>
          </div>
          <h1>{step === 'FORM' ? 'Tạo tài khoản' : 'Xác thực số điện thoại'}</h1>
          <p className="register-role-badge">
            <span>{cfg.emoji}</span>
            {cfg.label}
          </p>
          <p className="register-role-desc">
            {step === 'FORM' ? cfg.desc : `Mã OTP đã được gửi đến SĐT: ${phone}`}
          </p>
        </div>

        {/* Form Container */}
        {error && (
          <div className="form-error">
            <AlertCircle size={16} />
            <span>{error}</span>
          </div>
        )}

        {step === 'FORM' ? (
          <form className="register-form" onSubmit={handleSendSms}>
            
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
                placeholder="Ví dụ: 0345851204"
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

            <div id="recaptcha-container"></div>

            <button
              type="submit"
              id="register-submit"
              className={`register-submit-btn${isLoading ? ' loading' : ''}`}
              disabled={isLoading}
            >
              {isLoading ? 'Đang gửi mã OTP...' : 'Đăng ký'}
            </button>

            <p className="register-terms">
              Bằng cách đăng ký, bạn đồng ý với{' '}
              <a href="#terms">Điều khoản sử dụng</a> của chúng tôi.
            </p>

            <div className="modal-divider" style={{ margin: '20px 0' }}>
              <span>Hoặc đăng ký bằng</span>
            </div>

            <SocialLoginButtons
              mode="register"
              role={role}
              onSuccess={(data: TokenResponse) => {
                login({
                  phone: data.email || '',
                  role: data.role,
                  fullName: data.fullName,
                  avatarBase64: data.avatarBase64 || undefined
                }, data.accessToken, data.refreshToken);
                navigate('/dashboard', { replace: true });
              }}
              onError={(msg: string) => setError(msg)}
            />
          </form>
        ) : (
          <form className="register-form" onSubmit={handleVerifyOtp}>
            <div className="form-group">
              <label htmlFor="reg-otp">Mã Xác Thực (OTP 6 số từ SMS)</label>
              <input
                id="reg-otp"
                type="text"
                className="form-input otp-input"
                placeholder="Ví dụ: 123456"
                value={otpCode}
                onChange={e => setOtpCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
                required
                autoFocus
                maxLength={6}
                style={{ letterSpacing: '8px', textAlign: 'center', fontSize: '1.25rem' }}
              />
            </div>

            <button
              type="submit"
              className={`register-submit-btn${isLoading ? ' loading' : ''}`}
              disabled={isLoading || otpCode.length !== 6}
            >
              {isLoading ? 'Đang kiểm tra...' : 'Xác thực & Tạo tài khoản'}
            </button>
          </form>
        )}
      </div>
    </div>
  );
};
