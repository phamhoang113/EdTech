import { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import { userProfileApi } from '../../services/userProfileApi';
import type { UpdateUserProfileRequest } from '../../services/userProfileApi';
import { ArrowLeft, Mail, MapPin, Phone, Save, Camera, Lock } from 'lucide-react';
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
      setTimeout(() => navigate('/dashboard'), 1500);
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
      <div className="up-loading">
        <div className="up-spinner" />
      </div>
    );
  }

  return (
    <div className="up-page">
      <div className="up-header-nav">
        <button className="up-back-btn" onClick={() => navigate(-1)}>
          <ArrowLeft size={18} /> Quay lại
        </button>
      </div>

      <div className="up-card">
        {/* Banner Cover */}
        <div className="up-cover">
          <div className="up-cover-overlay"></div>
        </div>

        {/* Profile Header (Avatar overlap) */}
        <div className="up-profile-head">
          <div className="up-avatar-wrap" onClick={() => fileInputRef.current?.click()} title="Đổi ảnh đại diện">
            {avatarBase64 ? (
              <img src={avatarBase64} alt="Avatar" className="up-avatar-img" />
            ) : (
              <div className="up-avatar-placeholder">{initial}</div>
            )}
          </div>
          
          <button className="up-avatar-upload-btn" onClick={() => fileInputRef.current?.click()}>
            <Camera size={14} /> Thay đổi ảnh
          </button>
          
          <input ref={fileInputRef} type="file" accept="image/*" style={{ display: 'none' }} onChange={handleAvatarChange} />
          
          <div className="up-head-info">
            <h1 className="up-name">{fullName}</h1>
            <p className="up-phone">
              <Phone size={14} /> {phone}
            </p>
          </div>
        </div>

        {/* Body Content */}
        <div className="up-body-content">
          <div className="up-readonly-alert">
            <Lock size={16} /> Thông tin gốc của bạn đã được xác thực, không thể tự ý sửa đổi.
          </div>

          <div className="up-form-group">
            <label className="up-label">Email liên lạc</label>
            <div className="up-input-wrap">
              <Mail className="up-input-icon" size={18} />
              <input type="email" className="up-input" value={email} onChange={e => setEmail(e.target.value)} placeholder="Nhập địa chỉ email của bạn" />
            </div>
          </div>

          <div className="up-form-group">
            <label className="up-label">Địa chỉ hiện tại</label>
            <div className="up-input-wrap up-input-wrap--textarea">
              <MapPin className="up-input-icon" size={18} />
              <textarea className="up-textarea" value={address} onChange={e => setAddress(e.target.value.slice(0, 500))} maxLength={500} rows={3} placeholder="VD: 123 Đường A, Quận B, TP HCM..." />
            </div>
            <div className="up-char-limit">{address.length}/500</div>
          </div>

          {error && <div className="up-msg error">{error}</div>}
          {success && <div className="up-msg success">{success}</div>}

          <div className="up-actions">
            <button className={`up-btn-save ${isDirty ? 'active' : ''}`} onClick={handleSave} disabled={saving || !isDirty}>
              {saving ? <div className="up-spinner-btn" /> : <Save size={18} />} 
              {saving ? 'Đang lưu...' : 'Lưu thay đổi'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
