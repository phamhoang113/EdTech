import { X, ArrowLeft, AlertCircle, CheckCircle } from 'lucide-react';
import { useState, useEffect } from 'react';
import { Button } from '../ui/Button';

import { useEscapeKey } from '../../hooks/useEscapeKey';
import { initForgotPasswordApi, resetPasswordApi } from '../../services/authApi';
import { auth } from '../../firebase';
import { RecaptchaVerifier, signInWithPhoneNumber, type ConfirmationResult } from 'firebase/auth';

import './LoginModal.css';
import './ForgotPasswordModal.css';

interface ForgotPasswordModalProps {
  onClose: () => void;
  onBackToLogin: () => void;
}

export const ForgotPasswordModal = ({ onClose, onBackToLogin }: ForgotPasswordModalProps) => {
  const [step, setStep] = useState<'INIT' | 'OTP' | 'SUCCESS'>('INIT');
  const [identifier, setIdentifier] = useState('');
  const [maskedPhone, setMaskedPhone] = useState('');
  const [otpCode, setOtpCode] = useState('');
  const [newPassword, setNewPassword] = useState('');

  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [cooldown, setCooldown] = useState(0);

  const [confirmationResult, setConfirmationResult] = useState<ConfirmationResult | null>(null);

  useEscapeKey(onClose);

  useEffect(() => {
    let timer: any;
    if (cooldown > 0) {
      timer = setInterval(() => setCooldown((c) => c - 1), 1000);
    }
    return () => clearInterval(timer);
  }, [cooldown]);

  useEffect(() => {
    return () => {
      if ((window as any).recaptchaVerifier) {
        (window as any).recaptchaVerifier.clear();
        (window as any).recaptchaVerifier = null;
      }
    };
  }, []);

  const initRecaptcha = () => {
    if (!(window as any).recaptchaVerifier) {
      (window as any).recaptchaVerifier = new RecaptchaVerifier(auth, 'fp-recaptcha-container', {
        size: 'invisible',
      });
    }
  };

  const handleInit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!identifier.trim()) {
      setError('Vui lòng nhập Tên đăng nhập hoặc SĐT');
      return;
    }

    setIsLoading(true);
    setError(null);

    try {
      // 1. Call Backend to check if user exists and has a phone number
      const data = await initForgotPasswordApi(identifier);
      setMaskedPhone(data.maskedPhone);

      // 2. Call Firebase
      let formattedPhone = data.fullPhone.trim();
      if (formattedPhone.startsWith('0')) {
        formattedPhone = '+84' + formattedPhone.slice(1);
      } else if (!formattedPhone.startsWith('+')) {
        formattedPhone = '+' + formattedPhone;
      }

      if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
        // Mock Firebase
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
      } else {
        initRecaptcha();
        const appVerifier = (window as any).recaptchaVerifier;
        const confirmResult = await signInWithPhoneNumber(auth, formattedPhone, appVerifier);
        setConfirmationResult(confirmResult);
      }

      setCooldown(60); // Anti-spam cooldown
      setStep('OTP');
    } catch (err: any) {
      console.error(err);
      const msg = err.response?.data?.message || err.message || 'Thao tác thất bại';
      // Specific error handling
      if (msg.includes('NO_PHONE_ASSOCIATED')) {
        setError('Tài khoản không có số điện thoại liên kết. Vui lòng liên hệ Admin để cấp lại mật khẩu.');
      } else {
        setError(msg);
      }
    } finally {
      setIsLoading(false);
    }
  };

  const handleVerifyOtp = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    if (!otpCode || otpCode.length < 6) {
      setError('Vui lòng nhập mã OTP gồm 6 chữ số');
      return;
    }

    setIsLoading(true);
    try {
      const result = await confirmationResult!.confirm(otpCode);
      const idToken = await result.user.getIdToken();

      // 3. Reset password via backend
      const resData = await resetPasswordApi({
        identifier: identifier,
        idToken: idToken
      });

      setNewPassword(resData.newPassword);
      setStep('SUCCESS');
    } catch (err: any) {
      console.error(err);
      setError('Xác thực thất bại: ' + (err.response?.data?.message || err.message || 'Mã OTP không hợp lệ'));
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content forgot-password-modal" onClick={(e) => e.stopPropagation()}>
        <button className="modal-back" onClick={step === 'OTP' ? () => setStep('INIT') : onBackToLogin} aria-label="Back">
          <ArrowLeft size={20} />
        </button>
        <button className="modal-close" onClick={onClose} aria-label="Close">
          <X size={20} />
        </button>

        <div className="modal-header">
          <h2 className="modal-title">
            {step === 'INIT' && 'Quên Mật Khẩu'}
            {step === 'OTP' && 'Xác thực SMS'}
            {step === 'SUCCESS' && 'Thành Công'}
          </h2>
        </div>

        <div className="modal-body">
          {error && (
            <div className="form-error">
              <AlertCircle size={16} />
              <span>{error}</span>
            </div>
          )}

          {step === 'INIT' && (
            <form onSubmit={handleInit}>
              <p className="forgot-password-desc">
                Nhập số điện thoại hoặc tên đăng nhập của bạn. Chúng tôi sẽ gửi mã OTP qua SMS để xác nhận (chỉ áp dụng cho tài khoản có SĐT liên kết).
              </p>
              
              <div className="form-group">
                <label htmlFor="identifier">Số điện thoại hoặc Tên đăng nhập</label>
                <input
                  id="identifier"
                  type="text"
                  className="form-input"
                  placeholder="Nhập SĐT hoặc tên đăng nhập..."
                  value={identifier}
                  onChange={(e) => setIdentifier(e.target.value)}
                  required
                  disabled={cooldown > 0}
                  autoFocus
                />
              </div>

              {cooldown > 0 && <p className="fp-cooldown-text">Vui lòng chờ {cooldown}s để gửi lại</p>}

              <div id="fp-recaptcha-container"></div>

              <Button type="submit" fullWidth isLoading={isLoading} disabled={cooldown > 0}>
                Tiếp tục
              </Button>
            </form>
          )}

          {step === 'OTP' && (
            <form onSubmit={handleVerifyOtp}>
              <p className="forgot-password-desc">
                Mã OTP đã được gửi đến số điện thoại <strong>{maskedPhone}</strong>. Vui lòng kiểm tra tin nhắn.
              </p>

              <div className="form-group">
                <label htmlFor="fp-otp">Mã Xác Thực (6 số)</label>
                <input
                  id="fp-otp"
                  type="text"
                  className="form-input fp-otp-input"
                  placeholder="123456"
                  value={otpCode}
                  onChange={(e) => setOtpCode(e.target.value.replace(/\D/g, '').slice(0, 6))}
                  required
                  autoFocus
                  maxLength={6}
                />
              </div>

              <Button type="submit" fullWidth isLoading={isLoading} disabled={otpCode.length !== 6}>
                Xác Nhận
              </Button>
            </form>
          )}

          {step === 'SUCCESS' && (
            <div className="fp-success-container">
              <div className="fp-success-box">
                <h3 className="fp-success-title"><CheckCircle size={20} /> Cấp Lại Mật Khẩu Thành Công</h3>
                <p>Hệ thống đã tạo một mật khẩu ngẫu nhiên cho bạn. Vui lòng sao chép mật khẩu này để đăng nhập ngay!</p>
                <div className="fp-random-password" onClick={() => { navigator.clipboard.writeText(newPassword); alert('Đã sao chép mật khẩu!'); }}>
                  {newPassword}
                </div>
                <span className="fp-copy-hint">(Click vào mật khẩu để sao chép)</span>
              </div>

              <Button type="button" fullWidth onClick={onBackToLogin}>
                Quay Lại Đăng Nhập
              </Button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
