import { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import { userProfileApi } from '../../services/userProfileApi';
import type { UpdateUserProfileRequest } from '../../services/userProfileApi';
import './UserProfilePage.css';

function toBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result as string);
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
}

export function ParentProfileForm() {
  const navigate = useNavigate();
  const { updateUser } = useAuthStore();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const [fullName, setFullName] = useState('');
  const [phone, setPhone] = useState('');
  const [avatarBase64, setAvatarBase64] = useState<string | null>(null);
  const [email, setEmail] = useState('');
  const [address, setAddress] = useState('');

  const initialRef = useRef({ avatarBase64: null as string | null, email: '', address: '' });

  useEffect(() => {
    userProfileApi.getMyProfile().then(p => {
      setFullName(p.fullName ?? '');
      setPhone(p.phone ?? '');
      setAvatarBase64(p.avatarBase64 ?? null);
      setEmail(p.email ?? '');
      setAddress(p.address ?? '');
      initialRef.current = {
        avatarBase64: p.avatarBase64 ?? null,
        email: p.email ?? '',
        address: p.address ?? '',
      };
    }).catch(() => setError('Không tải được hồ sơ.'))
      .finally(() => setLoading(false));
  }, []);

  const handleAvatarChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) { setError('Ảnh tối đa 2MB.'); return; }
    const b64 = await toBase64(file);
    setAvatarBase64(b64);
    setError('');
  };

  const handleSave = async () => {
    setError(''); setSuccess(''); setSaving(true);
    try {
      const req: UpdateUserProfileRequest = {
        email: email.trim() || undefined,
        avatarBase64: avatarBase64 ?? undefined,
        address: address.trim() || undefined,
      };
      const updated = await userProfileApi.updateMyProfile(req);
      if (updated.avatarBase64 !== undefined) {
        updateUser({ avatarBase64: updated.avatarBase64 ?? undefined });
      }
      setSuccess('✅ Lưu thành công!');
      setTimeout(() => navigate('/dashboard'), 1200);
    } catch (err: unknown) {
      const message = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      setError(message || 'Lưu thất bại.');
    } finally { setSaving(false); }
  };

  const isDirty =
    avatarBase64 !== initialRef.current.avatarBase64 ||
    email !== initialRef.current.email ||
    address !== initialRef.current.address;

  const initial = fullName.trim().split(' ').pop()?.charAt(0).toUpperCase() ?? '?';

  if (loading) {
    return (
      <div className="up-loading">
        <div className="up-spinner" />
        <p>Đang tải hồ sơ...</p>
      </div>
    );
  }

  return (
    <div className="up-page">
      <div className="up-header">
        <button className="up-back-btn" onClick={() => navigate(-1)}>← Quay lại</button>
        <div>
          <h1 className="up-title">Hồ sơ cá nhân</h1>
          <p className="up-subtitle">Cập nhật thông tin của bạn</p>
        </div>
      </div>

      <div className="up-body">
        {/* Left: Avatar + identity */}
        <div className="up-sidebar">
          <div className="up-avatar-wrap" onClick={() => fileInputRef.current?.click()} title="Nhấn để đổi ảnh">
            {avatarBase64 ? (
              <img src={avatarBase64} alt="Avatar" className="up-avatar-img" />
            ) : (
              <div className="up-avatar-placeholder">{initial}</div>
            )}
            <div className="up-avatar-overlay">📷 Đổi ảnh</div>
          </div>
          <input ref={fileInputRef} type="file" accept="image/*" style={{ display: 'none' }} onChange={handleAvatarChange} />
          <p className="up-avatar-hint">JPG, PNG · tối đa 2MB</p>

          <div className="up-identity-card">
            <div className="up-identity-item">
              <span className="up-identity-label">Họ và tên</span>
              <span className="up-identity-value">{fullName}</span>
            </div>
            <div className="up-identity-item">
              <span className="up-identity-label">Số điện thoại</span>
              <span className="up-identity-value">{phone}</span>
            </div>
          </div>
          <p className="up-readonly-note">🔒 Thông tin trên không thể thay đổi</p>
        </div>

        {/* Right: form */}
        <div className="up-form">
          <div className="up-section">
            <div className="up-section-title">📧 Email liên hệ</div>
            <input type="email" className="up-input" value={email}
              onChange={e => setEmail(e.target.value)} placeholder="example@gmail.com" />
          </div>

          <div className="up-section">
            <div className="up-section-title">📍 Địa chỉ</div>
            <textarea className="up-textarea" value={address}
              onChange={e => setAddress(e.target.value.slice(0, 500))} maxLength={500} rows={3}
              placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố..." />
            <span className="up-char-count">{address.length}/500</span>
          </div>

          {error && <div className="up-alert up-alert--error">{error}</div>}
          {success && <div className="up-alert up-alert--success">{success}</div>}

          <button className="up-save-btn" onClick={handleSave} disabled={saving || !isDirty}
            title={!isDirty ? 'Chưa có thay đổi nào' : undefined}>
            {saving ? 'Đang lưu...' : '💾 Lưu thay đổi'}
          </button>
        </div>
      </div>
    </div>
  );
}
