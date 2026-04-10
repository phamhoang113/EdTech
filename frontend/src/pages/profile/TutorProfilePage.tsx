import { useState, useEffect, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { User } from 'lucide-react';
import { tutorApi, type UpdateTutorProfileRequest } from '../../services/tutorApi';
import { classApi } from '../../services/classApi';
import { useAuthStore } from '../../store/useAuthStore';
import { compressAvatar } from '../../utils/imageCompress';
import './TutorProfilePage.css';

const TEACHING_MODES = [
  { value: 'ONLINE', label: '🌐 Online' },
  { value: 'OFFLINE', label: '🏠 Tại nhà' },
  { value: 'BOTH', label: '✅ Cả hai' },
];

const MAX_SELECT = 5;



export default function TutorProfilePage() {
  const navigate = useNavigate();
  const routeLocation = useLocation();
  const isInsideTutorLayout = routeLocation.pathname.startsWith('/tutor/');
  const { updateUser } = useAuthStore();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  // Read-only display
  const [fullName, setFullName] = useState('');
  const [idCardNumber, setIdCardNumber] = useState('');

  // Editable fields
  const [avatarBase64, setAvatarBase64] = useState<string | null>(null);
  const [email, setEmail] = useState('');
  const [bio, setBio] = useState('');
  const [location, setLocation] = useState('');
  const [achievements, setAchievements] = useState('');
  const [experienceYears, setExperienceYears] = useState(0);
  const [teachingMode, setTeachingMode] = useState('BOTH');
  const [subjects, setSubjects] = useState<string[]>([]);
  const [teachingLevels, setTeachingLevels] = useState<string[]>([]);

  // Bank Info
  const [bankName, setBankName] = useState('');
  const [bankAccountNumber, setBankAccountNumber] = useState('');
  const [bankOwnerName, setBankOwnerName] = useState('');

  const [availableSubjects, setAvailableSubjects] = useState<string[]>([]);
  const [availableGradeLevels, setAvailableGradeLevels] = useState<string[]>([]);

  // Snapshot state khi load xong — dùng để detect thay đổi
  const initialRef = useRef({
    avatarBase64: null as string | null,
    email: '', bio: '', location: '', achievements: '',
    experienceYears: 0, teachingMode: 'BOTH',
    subjects: [] as string[], teachingLevels: [] as string[],
    bankName: '', bankAccountNumber: '', bankOwnerName: ''
  });

  useEffect(() => {
    // Load profile
    tutorApi.getMyProfile().then(p => {
      setFullName(p.fullName ?? '');
      setIdCardNumber(p.idCardNumber ?? '');
      setAvatarBase64(p.avatarBase64 ?? null);
      setEmail(p.email ?? '');
      setBio(p.bio ?? '');
      setLocation(p.location ?? '');
      setAchievements(p.achievements ?? '');
      setExperienceYears(p.experienceYears ?? 0);
      setTeachingMode(p.teachingMode ?? 'BOTH');
      setSubjects(p.subjects ?? []);
      setTeachingLevels(p.teachingLevels ?? []);
      setBankName(p.bankName ?? '');
      setBankAccountNumber(p.bankAccountNumber ?? '');
      setBankOwnerName(p.bankOwnerName ?? '');
      // Ghi snapshot ban đầu
      initialRef.current = {
        avatarBase64: p.avatarBase64 ?? null,
        email: p.email ?? '',
        bio: p.bio ?? '',
        location: p.location ?? '',
        achievements: p.achievements ?? '',
        experienceYears: p.experienceYears ?? 0,
        teachingMode: p.teachingMode ?? 'BOTH',
        subjects: p.subjects ?? [],
        teachingLevels: p.teachingLevels ?? [],
        bankName: p.bankName ?? '',
        bankAccountNumber: p.bankAccountNumber ?? '',
        bankOwnerName: p.bankOwnerName ?? ''
      };
    }).catch(() => setError('Không tải được hồ sơ. Vui lòng thử lại.')).finally(() => setLoading(false));

    // Load filter options
    classApi.getClassFilters().then(data => {
      if (data?.subjects) setAvailableSubjects(data.subjects.filter((s: string) => s !== 'Khác'));
      if (data?.levels) setAvailableGradeLevels(data.levels.filter((l: string) => l !== 'Khác'));
    }).catch(() => {
      setAvailableSubjects(['Toán', 'Vật Lý', 'Hóa Học', 'Sinh Học', 'Ngữ Văn', 'Tiếng Anh', 'Tin Học']);
      setAvailableGradeLevels(['Mầm non', 'Lớp 1', 'Lớp 2', 'Lớp 3', 'Lớp 4', 'Lớp 5',
        'Lớp 6', 'Lớp 7', 'Lớp 8', 'Lớp 9', 'Lớp 10', 'Lớp 11', 'Lớp 12', 'Đại học']);
    });
  }, []);

  const toggleTag = (item: string, list: string[], setList: (v: string[]) => void) => {
    if (list.includes(item)) setList(list.filter(v => v !== item));
    else if (list.length < MAX_SELECT) setList([...list, item]);
  };

  const handleAvatarClick = () => fileInputRef.current?.click();

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
    setError('');
    setSuccess('');
    setSaving(true);
    try {
      const req: UpdateTutorProfileRequest = {
        email: email.trim() || undefined,
        avatarBase64: avatarBase64 ?? undefined,
        bio: bio || undefined,
        location: location || undefined,
        achievements: achievements || undefined,
        experienceYears,
        teachingMode,
        subjects,
        teachingLevels,
        bankName: bankName.trim(),
        bankAccountNumber: bankAccountNumber.trim(),
        bankOwnerName: bankOwnerName.trim()
      };
      const updated = await tutorApi.updateMyProfile(req);
      // Sync avatar vào store để header cập nhật ngay
      if (updated.avatarBase64 !== undefined) {
        updateUser({ avatarBase64: updated.avatarBase64 ?? undefined });
      }
      setSuccess('✅ Lưu thành công!');
      setTimeout(() => navigate(isInsideTutorLayout ? '/tutor/dashboard' : '/dashboard'), 1500);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Lưu thất bại. Vui lòng thử lại.');
    } finally {
      setSaving(false);
    }
  };

  const initial = fullName.trim().split(' ').pop()?.charAt(0).toUpperCase() ?? '?';

  // True nếu bất kỳ field nào thay đổi so với snapshot
  const isDirty =
    avatarBase64 !== initialRef.current.avatarBase64 ||
    email !== initialRef.current.email ||
    bio !== initialRef.current.bio ||
    location !== initialRef.current.location ||
    achievements !== initialRef.current.achievements ||
    experienceYears !== initialRef.current.experienceYears ||
    teachingMode !== initialRef.current.teachingMode ||
    JSON.stringify([...subjects].sort()) !== JSON.stringify([...initialRef.current.subjects].sort()) ||
    JSON.stringify([...teachingLevels].sort()) !== JSON.stringify([...initialRef.current.teachingLevels].sort()) ||
    bankName !== initialRef.current.bankName ||
    bankAccountNumber !== initialRef.current.bankAccountNumber ||
    bankOwnerName !== initialRef.current.bankOwnerName;

  if (loading) {
    return (
      <div className="tp-loading">
        <div className="tp-spinner" />
        <p>Đang tải hồ sơ...</p>
      </div>
    );
  }

  return (
    <div className="tp-page">
      {/* Header */}
      <div className="tp-header">
        {!isInsideTutorLayout && (
          <button className="tp-back-btn" onClick={() => navigate(-1)}>← Quay lại</button>
        )}
        <div>
          <h1 className="tp-title" style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <User size={28} className="text-primary" /> Hồ sơ gia sư
          </h1>
          <p className="tp-subtitle">Cập nhật thông tin để phụ huynh dễ tìm thấy bạn</p>
        </div>
      </div>

      <div className="tp-body">
        {/* Left: Avatar + identity */}
        <div className="tp-sidebar">
          <div className="tp-avatar-wrap" onClick={handleAvatarClick} title="Nhấn để đổi ảnh">
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
            {idCardNumber && (
              <div className="tp-identity-item">
                <span className="tp-identity-label">Số CCCD / CMND</span>
                <span className="tp-identity-value" title="Không thể thay đổi">
                  {idCardNumber.replace(/(\d{4})(?=\d)/g, '$1 ')}
                </span>
              </div>
            )}
          </div>
          <p className="tp-readonly-note">🔒 Thông tin trên không thể thay đổi</p>
        </div>

        {/* Right: editable form */}
        <div className="tp-form">
          {/* Email */}
          <div className="tp-section">
            <div className="tp-section-title">📧 Email liên hệ</div>
            <input
              type="email"
              className="tp-input"
              value={email}
              onChange={e => setEmail(e.target.value)}
              placeholder="example@gmail.com"
            />
          </div>

          {/* Bank Info */}
          <div className="tp-section">
            <div className="tp-section-title">💸 Tài khoản ngân hàng (Nhận thù lao)</div>
            <div style={{ display: 'flex', gap: '12px', flexWrap: 'wrap' }}>
              <div style={{ flex: '1 1 200px' }}>
                <div style={{ fontSize: '0.85rem', color: '#64748b', marginBottom: '6px' }}>Ngân hàng</div>
                <input
                  type="text"
                  className="tp-input"
                  value={bankName}
                  onChange={e => setBankName(e.target.value)}
                  placeholder="VD: MB Bank, Vietcombank..."
                />
              </div>
              <div style={{ flex: '1 1 200px' }}>
                <div style={{ fontSize: '0.85rem', color: '#64748b', marginBottom: '6px' }}>Số tài khoản</div>
                <input
                  type="text"
                  className="tp-input"
                  value={bankAccountNumber}
                  onChange={e => setBankAccountNumber(e.target.value)}
                  placeholder="Nhập số tài khoản hợp lệ"
                />
              </div>
              <div style={{ flex: '1 1 200px' }}>
                <div style={{ fontSize: '0.85rem', color: '#64748b', marginBottom: '6px' }}>Tên người thụ hưởng</div>
                <input
                  type="text"
                  className="tp-input"
                  value={bankOwnerName}
                  onChange={e => setBankOwnerName(e.target.value.toUpperCase())}
                  placeholder="VIẾT HOA KHÔNG DẤU"
                />
              </div>
            </div>
            <p className="tp-readonly-note" style={{ marginTop: '8px', color: '#888' }}>
              💡 Vui lòng nhập thông tin chính xác. Kế toán sẽ chuyển khoản tự động vào tài khoản này.
            </p>
          </div>

          {/* Bio */}
          <div className="tp-section">
            <div className="tp-section-title">📝 Giới thiệu bản thân</div>
            <textarea
              className="tp-textarea"
              value={bio}
              onChange={e => setBio(e.target.value.slice(0, 500))}
              maxLength={500}
              rows={4}
              placeholder="Giới thiệu ngắn về bản thân, phong cách dạy học..."
            />
            <span className="tp-char-count">{bio.length}/500</span>
          </div>

          {/* Location */}
          <div className="tp-section">
            <div className="tp-section-title">📍 Khu vực dạy</div>
            <textarea
              className="tp-textarea tp-textarea--sm"
              value={location}
              onChange={e => setLocation(e.target.value.slice(0, 500))}
              maxLength={500}
              rows={2}
              placeholder="VD: Quận 1, Quận 3, TP.HCM / Cầu Giấy, Đống Đa, Hà Nội..."
            />
            <span className="tp-char-count">{location.length}/500</span>
          </div>

          {/* Subjects */}
          <div className="tp-section">
            <div className="tp-section-title">📚 Môn học <span className="tp-hint">tối đa {MAX_SELECT}</span></div>
            <div className="tp-tags">
              {availableSubjects.map(s => (
                <button
                  key={s}
                  type="button"
                  className={`tp-tag ${subjects.includes(s) ? 'tp-tag--active' : ''}`}
                  onClick={() => toggleTag(s, subjects, setSubjects)}
                >
                  {s}
                </button>
              ))}
            </div>
          </div>

          {/* Teaching levels */}
          <div className="tp-section">
            <div className="tp-section-title">🎓 Cấp độ giảng dạy <span className="tp-hint">tối đa {MAX_SELECT}</span></div>
            <div className="tp-tags">
              {availableGradeLevels.map(l => (
                <button
                  key={l}
                  type="button"
                  className={`tp-tag ${teachingLevels.includes(l) ? 'tp-tag--active' : ''}`}
                  onClick={() => toggleTag(l, teachingLevels, setTeachingLevels)}
                >
                  {l}
                </button>
              ))}
            </div>
          </div>

          {/* Teaching mode */}
          <div className="tp-section">
            <div className="tp-section-title">🏫 Hình thức dạy</div>
            <div className="tp-mode-group">
              {TEACHING_MODES.map(m => (
                <button
                  key={m.value}
                  type="button"
                  className={`tp-mode-btn ${teachingMode === m.value ? 'tp-mode-btn--active' : ''}`}
                  onClick={() => setTeachingMode(m.value)}
                >
                  {m.label}
                </button>
              ))}
            </div>
          </div>

          {/* Experience */}
          <div className="tp-section tp-row">
            <div style={{ flex: 1 }}>
              <div className="tp-section-title">⭐ Số năm kinh nghiệm</div>
              <input
                type="number"
                className="tp-input"
                value={experienceYears}
                onChange={e => setExperienceYears(Math.max(0, Number(e.target.value)))}
                min={0}
                max={50}
              />
            </div>
          </div>

          {/* Achievements */}
          <div className="tp-section">
            <div className="tp-section-title">🏆 Thành tích & Kinh nghiệm <span className="tp-hint">tối đa 500</span></div>
            <textarea
              className="tp-textarea"
              value={achievements}
              onChange={e => setAchievements(e.target.value.slice(0, 500))}
              maxLength={500}
              rows={4}
              placeholder="Giải thưởng, kinh nghiệm nổi bật, chứng chỉ..."
            />
            <span className="tp-char-count">{achievements.length}/500</span>
          </div>

          {error && <div className="tp-alert tp-alert--error">{error}</div>}
          {success && <div className="tp-alert tp-alert--success">{success}</div>}

          <button
            className="tp-save-btn"
            onClick={handleSave}
            disabled={saving || !isDirty}
            title={!isDirty ? 'Chưa có thay đổi nào' : undefined}
          >
            {saving ? 'Đang lưu...' : '💾 Lưu thay đổi'}
          </button>
        </div>
      </div>
    </div>
  );
}
