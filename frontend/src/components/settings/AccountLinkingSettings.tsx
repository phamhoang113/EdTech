import { useState, useEffect } from 'react';
import { getLinkedProvidersApi, linkProviderApi, unlinkProviderApi, type LinkedProvider, setPasswordApi } from '../../services/authApi';
import { useAuthStore } from '../../store/useAuthStore';
import { Button } from '../ui/Button';
import { signInWithPopup } from 'firebase/auth';
import { auth, googleProvider, facebookProvider } from '../../firebase';
import './AccountLinkingSettings.css';

export const AccountLinkingSettings = () => {
  const { user } = useAuthStore();
  const [providers, setProviders] = useState<LinkedProvider[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const [showPasswordForm, setShowPasswordForm] = useState(false);
  const [newPassword, setNewPassword] = useState('');

  const isLocalDev = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';

  const fetchProviders = async () => {
    try {
      const data = await getLinkedProvidersApi();
      setProviders(data);
    } catch (err: any) {
      console.error(err);
      setError('Không thể tải danh sách tài khoản liên kết.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProviders();
  }, []);

  const handleLink = async (providerId: 'google' | 'facebook') => {
    setError('');
    setSuccess('');
    try {
      let idToken: string;
      if (isLocalDev) {
        const mockEmail = providerId === 'google' ? 'testuser@gmail.com' : 'testuser@facebook.com';
        const email = window.prompt(`[Dev Mode] Nhập email ${providerId}:`, mockEmail);
        if (!email) return;
        const prefix = providerId === 'google' ? 'GOOGLE' : 'FACEBOOK';
        idToken = `MOCK_TOKEN_${prefix}_${email}`;
      } else {
        const provider = providerId === 'google' ? googleProvider : facebookProvider;
        const result = await signInWithPopup(auth, provider);
        idToken = await result.user.getIdToken();
      }

      await linkProviderApi(idToken);
      setSuccess(`Liên kết tài khoản ${providerId === 'google' ? 'Google' : 'Facebook'} thành công.`);
      await fetchProviders();
    } catch (err: any) {
      const msg = err.response?.data?.message || err.message || 'Liên kết thất bại.';
      setError(msg);
    }
  };

  const handleUnlink = async (providerId: string) => {
    setError('');
    setSuccess('');
    if (!window.confirm('Bạn có chắc chắn muốn hủy liên kết tài khoản này?')) return;
    
    try {
      await unlinkProviderApi(providerId);
      setSuccess(`Đã bỏ liên kết tài khoản ${providerId}.`);
      await fetchProviders();
    } catch (err: any) {
      const msg = err.response?.data?.message || err.message || 'Hủy liên kết thất bại.';
      setError(msg);
    }
  };

  const handleSetPassword = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSuccess('');
    try {
      await setPasswordApi(user?.phone || '', newPassword);
      setSuccess('Đã thiết lập mật khẩu thành công. Lần sau bạn có thể đăng nhập bằng Số điện thoại + Mật khẩu này.');
      setShowPasswordForm(false);
      setNewPassword('');
    } catch (err: any) {
      const msg = err.response?.data?.message || 'Thiết lập mật khẩu thất bại.';
      setError(msg);
    }
  };

  const hasGoogle = providers.some(p => p.provider === 'google');
  const hasFacebook = providers.some(p => p.provider === 'facebook');

  if (loading) return <div>Đang tải...</div>;

  return (
    <div className="account-linking-settings">
      <h3>Tài khoản liên kết</h3>
      <p className="settings-desc">Liên kết các mạng xã hội để đăng nhập nhanh hơn.</p>

      {error && <div className="settings-error">{error}</div>}
      {success && <div className="settings-success">{success}</div>}

      <div className="linking-list">
        <div className="linking-item">
          <div className="linking-item-info">
            <svg viewBox="0 0 24 24" width="24" height="24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18A10.96 10.96 0 0 0 1 12c0 1.77.42 3.45 1.18 4.93l2.85-2.22.81-.62z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/></svg>
            <div>
              <strong>Google</strong>
              {hasGoogle && <div className="linked-email">{providers.find(p => p.provider === 'google')?.providerEmail}</div>}
            </div>
          </div>
          {hasGoogle ? (
            <Button variant="secondary" size="sm" onClick={() => handleUnlink('google')}>Hủy liên kết</Button>
          ) : (
            <Button variant="primary" size="sm" onClick={() => handleLink('google')}>Liên kết</Button>
          )}
        </div>

        <div className="linking-item">
          <div className="linking-item-info">
            <svg viewBox="0 0 24 24" width="24" height="24"><path fill="#1877F2" d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/></svg>
            <div>
              <strong>Facebook</strong>
              {hasFacebook && <div className="linked-email">{providers.find(p => p.provider === 'facebook')?.providerEmail}</div>}
            </div>
          </div>
          {hasFacebook ? (
            <Button variant="secondary" size="sm" onClick={() => handleUnlink('facebook')}>Hủy liên kết</Button>
          ) : (
            <Button variant="primary" size="sm" onClick={() => handleLink('facebook')}>Liên kết</Button>
          )}
        </div>
      </div>

      <div className="password-section">
        <div className="password-header">
          <div>
            <strong>Mật khẩu đăng nhập</strong>
            <p className="settings-desc">Thiết lập mật khẩu quản lý tài khoản độc lập với mạng xã hội.</p>
          </div>
          {!showPasswordForm && (
            <Button variant="secondary" size="sm" onClick={() => setShowPasswordForm(true)}>Thiết lập mật khẩu</Button>
          )}
        </div>

        {showPasswordForm && (
          <form className="password-form" onSubmit={handleSetPassword}>
            <div className="form-group">
              <label>Mật khẩu mới</label>
              <input 
                type="password" 
                className="form-input" 
                value={newPassword} 
                onChange={e => setNewPassword(e.target.value)}
                required
                minLength={6}
              />
            </div>
            <div className="form-actions">
              <Button type="button" variant="ghost" onClick={() => setShowPasswordForm(false)}>Hủy</Button>
              <Button type="submit" variant="primary">Lưu mật khẩu</Button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
};
