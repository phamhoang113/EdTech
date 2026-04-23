import { useState } from 'react';
import { signInWithPopup } from 'firebase/auth';
import { auth, googleProvider, facebookProvider } from '../../firebase';
import { firebaseAuthApi } from '../../services/authApi';
import type { TokenResponse } from '../../services/authApi';
import './SocialLoginButtons.css';

type Role = 'PARENT' | 'TUTOR' | 'STUDENT';

interface SocialLoginButtonsProps {
  mode: 'login' | 'register';
  role?: Role;
  onSuccess: (data: TokenResponse) => void;
  onError: (msg: string) => void;
}

export const SocialLoginButtons = ({ mode, role, onSuccess, onError }: SocialLoginButtonsProps) => {
  const [loadingProvider, setLoadingProvider] = useState<'google' | 'facebook' | null>(null);

  const isLocalDev = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';

  const handleSocialLogin = async (provider: 'google' | 'facebook') => {
    setLoadingProvider(provider);
    try {
      let idToken: string;

      if (isLocalDev) {
        // Bypass Firebase popup cho môi trường local/dev
        const mockEmail = provider === 'google' ? 'testuser@gmail.com' : 'testuser@facebook.com';
        const email = window.prompt(
          `[Dev Mode] Nhập email ${provider === 'google' ? 'Google' : 'Facebook'} để test:`,
          mockEmail
        );
        if (!email) {
          setLoadingProvider(null);
          return;
        }
        const prefix = provider === 'google' ? 'GOOGLE' : 'FACEBOOK';
        idToken = `MOCK_TOKEN_${prefix}_${email}`;
      } else {
        const firebaseProvider = provider === 'google' ? googleProvider : facebookProvider;
        const result = await signInWithPopup(auth, firebaseProvider);
        idToken = await result.user.getIdToken();
      }

      const tokenRes = await firebaseAuthApi({
        idToken,
        fullName: '',
        role: mode === 'register' ? (role ?? 'STUDENT') : undefined as unknown as Role,
      });

      onSuccess(tokenRes);
    } catch (err: unknown) {
      const msg =
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
        (err as { message?: string })?.message ||
        `Đăng nhập ${provider === 'google' ? 'Google' : 'Facebook'} thất bại.`;
      onError(msg);
    } finally {
      setLoadingProvider(null);
    }
  };

  return (
    <div className="social-login-buttons">
      <button
        type="button"
        className="social-btn social-btn-google"
        onClick={() => handleSocialLogin('google')}
        disabled={loadingProvider !== null}
      >
        {loadingProvider === 'google' ? (
          <span className="social-btn-spinner" />
        ) : (
          <svg className="social-btn-icon" viewBox="0 0 24 24" width="20" height="20">
            <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"/>
            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
            <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18A10.96 10.96 0 0 0 1 12c0 1.77.42 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
          </svg>
        )}
        <span>{mode === 'register' ? 'Đăng ký với Google' : 'Đăng nhập với Google'}</span>
      </button>

      <button
        type="button"
        className="social-btn social-btn-facebook"
        onClick={() => handleSocialLogin('facebook')}
        disabled={loadingProvider !== null}
      >
        {loadingProvider === 'facebook' ? (
          <span className="social-btn-spinner" />
        ) : (
          <svg className="social-btn-icon" viewBox="0 0 24 24" width="20" height="20">
            <path fill="#1877F2" d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
          </svg>
        )}
        <span>{mode === 'register' ? 'Đăng ký với Facebook' : 'Đăng nhập với Facebook'}</span>
      </button>
    </div>
  );
};
