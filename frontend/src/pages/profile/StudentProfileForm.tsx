import { useState, useEffect, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import { userProfileApi } from '../../services/userProfileApi';
import type { UpdateUserProfileRequest } from '../../services/userProfileApi';
import { compressAvatar } from '../../utils/imageCompress';
import { Mail, School, Save, Lock, User, GraduationCap } from 'lucide-react';
import { AccountLinkingSettings } from '../../components/settings/AccountLinkingSettings';
import './TutorProfilePage.css';



export function StudentProfileForm() {
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
  const [school, setSchool] = useState('');
  const [grade, setGrade] = useState('');

  const initialRef = useRef({
    avatarBase64: null as string | null, email: '', school: '', grade: '', phone: '',
  });

  const isPhoneEditable = !initialRef.current.phone;

  useEffect(() => {
    userProfileApi.getMyProfile().then(p => {
      setFullName(p.fullName ?? '');
      setPhone(p.phone ?? '');
      setAvatarBase64(p.avatarBase64 ?? null);
      setEmail(p.email ?? '');
      setSchool(p.school ?? '');
      setGrade(p.grade ?? '');
      initialRef.current = {
        avatarBase64: p.avatarBase64 ?? null,
        email: p.email ?? '',
        school: p.school ?? '',
        grade: p.grade ?? '',
        phone: p.phone ?? '',
      };
    }).catch(() => setError('Không tải được hồ sơ.'))
      .finally(() => setLoading(false));
  }, []);

  const handleAvatarChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 5 * 1024 * 1024) { setError('Ảnh tối đa 5MB.'); return; }
    try {
      const compressed = await compressAvatar(file);
      setAvatarBase64(compressed);
      setError('');
    } catch {
      setError('Không thể xử lý ảnh.');
    }
  };

  const handleSave = async () => {
    setError(''); setSuccess(''); setSaving(true);
    try {
      const req: UpdateUserProfileRequest = {
        phone: isPhoneEditable && phone.trim() ? phone.trim() : undefined,
        email: email.trim() || undefined,
        avatarBase64: avatarBase64 ?? undefined,
        school: school.trim() || undefined,
        grade: grade.trim() || undefined,
      };
      const updated = await userProfileApi.updateMyProfile(req);
      if (updated.avatarBase64 !== undefined) {
        updateUser({ avatarBase64: updated.avatarBase64 ?? undefined });
      }
      setSuccess('✅ Cập nhật hồ sơ thành công!');
      setTimeout(() => navigate('/student/dashboard'), 1500);
    } catch (err: unknown) {
      const message = (err as { response?: { data?: { message?: string } } })?.response?.data?.message;
      setError(message || 'Không thể lưu thay đổi.');
    } finally { setSaving(false); }
  };

  const isDirty =
    avatarBase64 !== initialRef.current.avatarBase64 ||
    email !== initialRef.current.email ||
    school !== initialRef.current.school ||
    grade !== initialRef.current.grade ||
    (isPhoneEditable && phone !== initialRef.current.phone);

  const initial = fullName.trim().split(' ').pop()?.charAt(0).toUpperCase() ?? '?';

  const GRADE_OPTIONS = [
    'Mầm non', 'Lớp 1', 'Lớp 2', 'Lớp 3', 'Lớp 4', 'Lớp 5',
    'Lớp 6', 'Lớp 7', 'Lớp 8', 'Lớp 9', 'Lớp 10', 'Lớp 11', 'Lớp 12',
    'Đại học', 'Khác',
  ];

  if (loading) {
    return (
      <div className="tp-loading">
        <div className="tp-spinner" />
        <p>Đang tải thông tin...</p>
      </div>
    );
  }

  const isInsideLayout = location.pathname.startsWith('/student');

  return (
    <div className="tp-page student-profile-page">
      {/* Header */}
      <div className="tp-header">
        {!isInsideLayout && (
          <button className="tp-back-btn" onClick={() => navigate(-1)}>← Quay lại</button>
        )}
        <div>
          <h1 className="tp-title" style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <User size={28} className="text-primary" /> Hồ sơ học viên
          </h1>
          <p className="tp-subtitle">Cập nhật thông tin học tập của bạn</p>
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
              {isPhoneEditable ? (
                <input
                  type="tel"
                  className="tp-input"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  placeholder="Nhập số điện thoại (VD: 0345851204)"
                  maxLength={10}
                  style={{ marginTop: '4px', fontSize: '14px' }}
                />
              ) : (
                <span className="tp-identity-value" title="Không thể tự do đổi">{phone}</span>
              )}
            </div>
          </div>
          <p className="tp-readonly-note">
            <Lock size={12} style={{ display: 'inline', verticalAlign: 'middle', marginRight: '4px' }} />
            {isPhoneEditable
              ? 'Họ tên đã xác thực. Bạn có thể bổ sung số điện thoại.'
              : 'Thông tin trên đã xác thực, không thể thay đổi'}
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

          {/* Trường học */}
          <div className="tp-section">
            <div className="tp-section-title">
              <School size={16} style={{ display: 'inline', verticalAlign: 'middle', marginRight: '6px' }} />
              Trường học hiện tại
            </div>
            <input
              type="text"
              className="tp-input"
              value={school}
              onChange={(e) => setSchool(e.target.value)}
              placeholder="VD: THPT Nguyễn Huệ"
            />
          </div>

          {/* Khối lớp */}
          <div className="tp-section">
            <div className="tp-section-title" style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
              <GraduationCap size={16} /> Lớp / Cấp học
            </div>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '8px', marginTop: '10px' }}>
              {GRADE_OPTIONS.map(g => (
                <button
                  key={g}
                  type="button"
                  onClick={() => setGrade(g)}
                  style={{
                    padding: '8px 16px',
                    borderRadius: '20px',
                    border: grade === g ? '2px solid var(--color-primary)' : '1px solid var(--color-border)',
                    background: grade === g ? 'var(--color-primary-light, #e0e7ff)' : 'var(--color-surface)',
                    color: grade === g ? 'var(--color-primary)' : 'var(--color-text)',
                    fontWeight: grade === g ? 600 : 400,
                    cursor: 'pointer',
                    transition: 'all 0.2s',
                    fontSize: '14px'
                  }}
                >
                  {g}
                </button>
              ))}
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

        {/* Bottom: Account Linking Settings */}
        <div style={{ flexBasis: '100%', marginTop: '24px' }}>
          <AccountLinkingSettings />
        </div>
      </div>
    </div>
  );
}
