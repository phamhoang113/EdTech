import { useState, useRef, useEffect, type KeyboardEvent } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { verifyOtpApi } from '../services/authApi';
import { useAuthStore } from '../store/useAuthStore';
import { AlertCircle, ArrowLeft, ShieldCheck } from 'lucide-react';
import './OtpVerifyPage.css';

export const OtpVerifyPage = () => {
  const [searchParams] = useSearchParams();
  const otpToken = searchParams.get('otpToken') || '';
  const phone    = searchParams.get('phone') || '';
  const navigate = useNavigate();
  const { login } = useAuthStore();

  const [otp, setOtp]         = useState<string[]>(Array(6).fill(''));
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError]     = useState<string | null>(null);
  const [timer, setTimer]     = useState(300); // 5 min countdown
  const inputs = useRef<(HTMLInputElement | null)[]>([]);

  // Countdown timer
  useEffect(() => {
    if (timer <= 0) return;
    const t = setInterval(() => setTimer(p => p - 1), 1000);
    return () => clearInterval(t);
  }, [timer]);

  const formatTime = (s: number) => {
    const m = Math.floor(s / 60);
    const sec = s % 60;
    return `${m}:${sec.toString().padStart(2, '0')}`;
  };

  const handleChange = (index: number, value: string) => {
    if (!/^\d?$/.test(value)) return;
    const next = [...otp];
    next[index] = value;
    setOtp(next);
    if (value && index < 5) inputs.current[index + 1]?.focus();
  };

  const handleKeyDown = (index: number, e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Backspace' && !otp[index] && index > 0) {
      inputs.current[index - 1]?.focus();
    }
  };

  const handlePaste = (e: React.ClipboardEvent) => {
    const text = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, 6);
    if (text.length === 6) {
      setOtp(text.split(''));
      setTimeout(() => inputs.current[5]?.focus(), 0);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const code = otp.join('');
    if (code.length < 6) {
      setError('Vui lòng nhập đủ 6 chữ số OTP.');
      return;
    }
    setIsLoading(true);
    setError(null);
    try {
      const data = await verifyOtpApi({ otpToken, code });
      login(
        { phone, role: data.role, fullName: data.fullName, avatarBase64: data.avatarBase64 ?? undefined },
        data.accessToken,
        data.refreshToken
      );
      navigate('/dashboard');
    } catch (err: unknown) {
      const msg =
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
        'OTP không hợp lệ hoặc đã hết hạn.';
      setError(msg);
      setOtp(Array(6).fill(''));
      inputs.current[0]?.focus();
    } finally {
      setIsLoading(false);
    }
  };

  const filledCount = otp.filter(Boolean).length;

  return (
    <div className="otp-page">
      <div className="otp-card">
        <button className="otp-back" onClick={() => navigate(-1)}>
          <ArrowLeft size={15} />
          Quay lại
        </button>

        {/* Header */}
        <div className="otp-header">
          <div className="otp-phone-icon">
            <ShieldCheck size={32} color="#fff" />
          </div>
          <h1>Xác thực OTP</h1>
          <p>
            Chúng tôi đã gửi mã 6 chữ số đến<br />
            <strong>{phone}</strong>
          </p>
        </div>

        <form className="otp-form" onSubmit={handleSubmit}>
          {error && (
            <div className="form-error">
              <AlertCircle size={15} />
              <span>{error}</span>
            </div>
          )}

          {/* Progress bar */}
          <div className="otp-progress-bar">
            <div
              className="otp-progress-fill"
              style={{ width: `${(filledCount / 6) * 100}%` }}
            />
          </div>

          {/* 6 digit inputs with separator */}
          <div className="otp-inputs" onPaste={handlePaste}>
            {otp.slice(0, 3).map((digit, i) => (
              <input
                key={i}
                ref={el => { inputs.current[i] = el; }}
                type="text"
                inputMode="numeric"
                maxLength={1}
                value={digit}
                className={`otp-input${digit ? ' filled' : ''}`}
                onChange={e => handleChange(i, e.target.value)}
                onKeyDown={e => handleKeyDown(i, e)}
                autoFocus={i === 0}
              />
            ))}
            <span className="otp-sep" />
            {otp.slice(3).map((digit, j) => {
              const i = j + 3;
              return (
                <input
                  key={i}
                  ref={el => { inputs.current[i] = el; }}
                  type="text"
                  inputMode="numeric"
                  maxLength={1}
                  value={digit}
                  className={`otp-input${digit ? ' filled' : ''}`}
                  onChange={e => handleChange(i, e.target.value)}
                  onKeyDown={e => handleKeyDown(i, e)}
                />
              );
            })}
          </div>

          <button
            type="submit"
            className={`otp-submit-btn${isLoading ? ' loading' : ''}`}
            disabled={isLoading || filledCount < 6}
          >
            {isLoading ? 'Đang xác thực...' : 'Xác nhận'}
          </button>

          <p className="otp-resend">
            {timer > 0 ? (
              <>Mã hết hạn sau <span className="otp-timer">{formatTime(timer)}</span></>
            ) : (
              'Mã đã hết hạn.'
            )}
            {' · '}
            <button
              type="button"
              className="resend-btn"
              disabled={timer > 0}
              onClick={() => { setTimer(300); navigate(-1); }}
            >
              Gửi lại
            </button>
          </p>
        </form>
      </div>
    </div>
  );
};
