import { useState, useEffect, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import { userProfileApi } from '../../services/userProfileApi';
import type { UpdateUserProfileRequest } from '../../services/userProfileApi';
import { ArrowLeft, Mail, MapPin, Phone, Save, Camera, Lock, User } from 'lucide-react';
import './TutorProfilePage.css';

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
  const location = useLocation();
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

  const initialRef = useRef({
    avatarBase64: null as string | null, email: '', address: '',
  });

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
    }).catch(() => setError('Không thể tải thông tin cá nhân. Vui lòng thử lại.'))
      .finally(() => setLoading(false));
  }, []);

  const handleAvatarChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) { setError('Ảnh không được vượt quá 2MB.'); return; }
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
      setSuccess('✅ Cập nhật hồ sơ thành công!');
      setTimeout(() => navigate('/parent/dashboard'), 1500);
    } catch (err: unknown) {
      const message = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      setError(message || 'Lỗi hệ thống. Vui lòng thử lại.');
    } finally { setSaving(false); }
  };

  const isDirty =
    avatarBase64 !== initialRef.current.avatarBase64 ||
    email !== initialRef.current.email ||
    address !== initialRef.current.address;

  const initial = fullName.trim().split(' ').pop()?.charAt(0).toUpperCase() ?? '?';

  if (loading) {
    return (
      <div className="tp-loading">
        <div className="tp-spinner" />
        <p>Đang tải thông tin...</p>
      </div>
    );
  }

  const isInsideLayout = location.pathname.startsWith('/parent');

  return (
    <div className="tp-page parent-profile-page">
      {/* Header */}
      <div className="tp-header">
        {!isInsideLayout && (
          <button className="tp-back-btn" onClick={() => navigate(-1)}>← Quay lại</button>
        )}
        <div>
          <h1 className="tp-title" style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <User size={28} className="text-primary" /> Hồ sơ phụ huynh
          </h1>
          <p className="tp-subtitle">Cập nhật thông tin tài khoản của bạn</p>
        </div>
      </div>

      <div className="tp-body" style={{ display: 'flex', gap: '32px', flexWrap: 'wrap' }}>
        {/* Left: Avatar + identity */}
        <div className="tp-sidebar" style={{ flex: '1 1 300px', maxWidth: '350px' }}>
          <div className="tp-avatar-wrap" onClick={() => fileInputRef.current?.click()} title="Nhấn để đổi ảnh">
            {avatarBase64 ? (
              <img src={avatarBase64} alt="Avatar" className="tp-avatar-img" />
            ) : (
              <div className="tp-avatar-placeholder">{initial}</div>
            )}
            <div className="tp-avatar-overlay">📷 Đổi ảnh</div>
          </div>
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            style={{ display: 'none' }}
            onChange={handleAvatarChange}
          />
          <p className="tp-avatar-hint">JPG, PNG · tối đa 2MB</p>

          {/* Readonly identity */}
          <div className="tp-identity-card">
            <div className="tp-identity-item">
              <span className="tp-identity-label">Họ và tên</span>
              <span className="tp-identity-value" title="Không thể thay đổi">{fullName}</span>
            </div>
            <div className="tp-identity-item">
              <span className="tp-identity-label">Số điện thoại</span>
              <span className="tp-identity-value" title="Không thể tự do đổi">{phone}</span>
            </div>
          </div>
          <p className="tp-readonly-note">
            <Lock size={12} style={{ display: 'inline', verticalAlign: 'middle', marginRight: '4px' }} />
            Thông tin trên đã xác thực, không thể thay đổi
          </p>
        </div>

        {/* Right: editable form */}
        <div className="tp-form" style={{ flex: '2 1 500px', display: 'flex', flexDirection: 'column', gap: '24px' }}>
          
          {/* Email */}
          <div className="tp-section">
            <div className="tp-section-title">
              <Mail size={16} style={{ display: 'inline', verticalAlign: 'middle', marginRight: '6px' }} /> 
              Email liên hệ
            </div>
            <input
              type="email"
              className="tp-input"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Nhập địa chỉ email của bạn"
            />
          </div>

          {/* Địa chỉ */}
          <div className="tp-section">
            <div className="tp-section-title">
              <MapPin size={16} style={{ display: 'inline', verticalAlign: 'middle', marginRight: '6px' }} /> 
              Địa chỉ hiện tại
            </div>
            <textarea
              className="tp-input"
              style={{ minHeight: '100px', resize: 'vertical' }}
              value={address}
              onChange={(e) => setAddress(e.target.value.slice(0, 500))}
              placeholder="VD: số 123 đường ABC, phường X, quận Y..."
              rows={4}
            />
            <div style={{ textAlign: 'right', fontSize: '0.75rem', color: 'var(--color-text-muted)', marginTop: '4px' }}>
              {address.length}/500
            </div>
          </div>

          {/* Messages */}
          {error && (
            <div style={{ padding: '12px 16px', background: 'rgba(239, 68, 68, 0.1)', color: '#ef4444', borderRadius: '8px', fontSize: '0.85rem' }}>
              {error}
            </div>
          )}
          {success && (
            <div style={{ padding: '12px 16px', background: 'rgba(16, 185, 129, 0.1)', color: '#10b981', borderRadius: '8px', fontSize: '0.85rem' }}>
              {success}
            </div>
          )}

          {/* Actions */}
          <div className="tp-form-actions" style={{ marginTop: 'auto', display: 'flex', justifyContent: 'flex-end', paddingTop: '24px', borderTop: '1px solid var(--color-border)' }}>
            <button
              className="tp-save-btn"
              onClick={handleSave}
              disabled={saving || !isDirty}
              style={{ padding: '10px 24px', borderRadius: '10px', display: 'flex', alignItems: 'center', gap: '8px', background: (!saving && isDirty) ? 'var(--color-primary)' : 'var(--color-surface-hover)', outline: 'none', color: (!saving && isDirty) ? '#fff' : 'var(--color-text-muted)', fontWeight: 600, cursor: (!saving && isDirty) ? 'pointer' : 'not-allowed', border: (!saving && isDirty) ? 'none' : '1px solid var(--color-border)' }}
            >
              {saving ? <div className="tp-spinner-btn" /> : <Save size={18} />}
              {saving ? 'Đang lưu...' : 'Lưu thay đổi'}
            </button>
          </div>

        </div>
      </div>
    </div>
  );
}
