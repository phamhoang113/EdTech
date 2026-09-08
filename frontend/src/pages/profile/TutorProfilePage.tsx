import { useState, useEffect, useRef } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { User, GraduationCap, Trash2, Plus, Upload, X } from 'lucide-react';
import { tutorApi, type UpdateTutorProfileRequest } from '../../services/tutorApi';
import { classApi } from '../../services/classApi';
import { useAuthStore } from '../../store/useAuthStore';
import { compressAvatar } from '../../utils/imageCompress';
import { AccountLinkingSettings } from '../../components/settings/AccountLinkingSettings';
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

  // Certificate images
  const [certImages, setCertImages] = useState<string[]>([]);
  const [certUploading, setCertUploading] = useState(false);
  const [certMsg, setCertMsg] = useState<{ type: 'success' | 'error'; text: string } | null>(null);
  const certInputRef = useRef<HTMLInputElement>(null);
  const [zoomImg, setZoomImg] = useState<string | null>(null);

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
      setCertImages((p.certBase64s ?? []).filter((img: string) => img && img.trim().length > 50));
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

          {/* Account Linking — moved up */}
          <div style={{ marginTop: 16 }}>
            <AccountLinkingSettings />
          </div>
        </div>

        {/* Right: editable form */}
        <div className="tp-form">
          {/* Row: Email + Bank */}
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
                <input type="text" className="tp-input" value={bankName} onChange={e => setBankName(e.target.value)} placeholder="VD: MB Bank, Vietcombank..." />
              </div>
              <div style={{ flex: '1 1 200px' }}>
                <div style={{ fontSize: '0.85rem', color: '#64748b', marginBottom: '6px' }}>Số tài khoản</div>
                <input type="text" className="tp-input" value={bankAccountNumber} onChange={e => setBankAccountNumber(e.target.value)} placeholder="Nhập số tài khoản hợp lệ" />
              </div>
              <div style={{ flex: '1 1 200px' }}>
                <div style={{ fontSize: '0.85rem', color: '#64748b', marginBottom: '6px' }}>Tên người thụ hưởng</div>
                <input type="text" className="tp-input" value={bankOwnerName} onChange={e => setBankOwnerName(e.target.value.toUpperCase())} placeholder="VIẾT HOA KHÔNG DẤU" />
              </div>
            </div>
            <p className="tp-readonly-note" style={{ marginTop: '8px', color: '#888' }}>
              💡 Vui lòng nhập thông tin chính xác. Kế toán sẽ chuyển khoản tự động vào tài khoản này.
            </p>
          </div>

          {/* Row: Bio + Location side by side on desktop */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
            <div className="tp-section">
              <div className="tp-section-title">📝 Giới thiệu bản thân</div>
              <textarea className="tp-textarea" value={bio} onChange={e => setBio(e.target.value.slice(0, 500))} maxLength={500} rows={3} placeholder="Giới thiệu ngắn về bản thân, phong cách dạy học..." />
              <span className="tp-char-count">{bio.length}/500</span>
            </div>
            <div className="tp-section">
              <div className="tp-section-title">📍 Khu vực dạy</div>
              <textarea className="tp-textarea" value={location} onChange={e => setLocation(e.target.value.slice(0, 500))} maxLength={500} rows={3} placeholder="VD: Quận 1, Quận 3, TP.HCM / Cầu Giấy, Đống Đa, Hà Nội..." />
              <span className="tp-char-count">{location.length}/500</span>
            </div>
          </div>

          {/* Subjects */}
          <div className="tp-section">
            <div className="tp-section-title">📚 Môn học <span className="tp-hint">tối đa {MAX_SELECT}</span></div>
            <div className="tp-tags">
              {availableSubjects.map(s => (
                <button key={s} type="button" className={`tp-tag ${subjects.includes(s) ? 'tp-tag--active' : ''}`} onClick={() => toggleTag(s, subjects, setSubjects)}>{s}</button>
              ))}
            </div>
          </div>

          {/* Teaching levels */}
          <div className="tp-section">
            <div className="tp-section-title">🎓 Cấp độ giảng dạy <span className="tp-hint">tối đa {MAX_SELECT}</span></div>
            <div className="tp-tags">
              {availableGradeLevels.map(l => (
                <button key={l} type="button" className={`tp-tag ${teachingLevels.includes(l) ? 'tp-tag--active' : ''}`} onClick={() => toggleTag(l, teachingLevels, setTeachingLevels)}>{l}</button>
              ))}
            </div>
          </div>

          {/* Row: Teaching mode + Experience + Achievements side by side */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
              <div className="tp-section" style={{ margin: 0 }}>
                <div className="tp-section-title">🏫 Hình thức dạy</div>
                <div className="tp-mode-group">
                  {TEACHING_MODES.map(m => (
                    <button key={m.value} type="button" className={`tp-mode-btn ${teachingMode === m.value ? 'tp-mode-btn--active' : ''}`} onClick={() => setTeachingMode(m.value)}>{m.label}</button>
                  ))}
                </div>
              </div>
              <div className="tp-section" style={{ margin: 0 }}>
                <div className="tp-section-title">⭐ Số năm kinh nghiệm</div>
                <input type="number" className="tp-input" value={experienceYears} onChange={e => setExperienceYears(Math.max(0, Number(e.target.value)))} min={0} max={50} />
              </div>
            </div>
            <div className="tp-section" style={{ margin: 0 }}>
              <div className="tp-section-title">🏆 Thành tích & Kinh nghiệm <span className="tp-hint">tối đa 500</span></div>
              <textarea className="tp-textarea" value={achievements} onChange={e => setAchievements(e.target.value.slice(0, 500))} maxLength={500} rows={5} placeholder="Giải thưởng, kinh nghiệm nổi bật, chứng chỉ..." />
              <span className="tp-char-count">{achievements.length}/500</span>
            </div>
          </div>

          {/* === Bằng cấp / Chứng chỉ === */}
          <div className="tp-section" style={{ marginTop: 16, padding: 16, background: 'var(--color-surface-raised, #f9fafb)', borderRadius: 12, border: '1px solid var(--color-border, #e5e7eb)' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 10 }}>
              <div className="tp-section-title" style={{ margin: 0 }}>
                <GraduationCap size={16} style={{ verticalAlign: 'middle', marginRight: 6 }} />
                Ảnh bằng cấp / Chứng chỉ ({certImages.length})
              </div>
              <button
                onClick={() => certInputRef.current?.click()}
                disabled={certUploading}
                style={{
                  display: 'flex', alignItems: 'center', gap: 4, padding: '5px 12px',
                  borderRadius: 8, border: '1.5px solid rgba(99,102,241,0.3)',
                  background: 'rgba(99,102,241,0.06)', color: '#6366f1',
                  fontSize: '0.78rem', fontWeight: 700, cursor: 'pointer', fontFamily: 'inherit',
                }}
              >
                <Plus size={13}/> Thêm ảnh
              </button>
              <input
                ref={certInputRef} type="file" accept="image/*" multiple style={{ display: 'none' }}
                onChange={async (e) => {
                  if (!e.target.files?.length) return;
                  setCertUploading(true); setCertMsg(null);
                  try {
                    const existingFiles: File[] = [];
                    for (let i = 0; i < certImages.length; i++) {
                      const src = certImages[i].startsWith('data:') ? certImages[i] : `data:image/png;base64,${certImages[i]}`;
                      const res = await fetch(src); const blob = await res.blob();
                      existingFiles.push(new File([blob], `cert_${i}.jpg`, { type: blob.type }));
                    }
                    const allFiles = [...existingFiles, ...Array.from(e.target.files)];
                    const result = await tutorApi.updateMyCertificates(allFiles);
                    setCertImages((result.certBase64s ?? []).filter(img => img && img.trim().length > 50));
                    setCertMsg({ type: 'success', text: 'Cập nhật thành công!' });
                    setTimeout(() => setCertMsg(null), 3000);
                  } catch { setCertMsg({ type: 'error', text: 'Upload thất bại.' }); }
                  finally { setCertUploading(false); e.target.value = ''; }
                }}
              />
            </div>

            {certUploading && <div style={{ textAlign: 'center', padding: 8, color: '#6366f1', fontSize: '0.85rem', fontWeight: 600 }}>⏳ Đang xử lý...</div>}
            {certMsg && <div style={{ padding: '6px 10px', borderRadius: 8, marginBottom: 8, fontSize: '0.8rem', fontWeight: 600, background: certMsg.type === 'success' ? '#ecfdf5' : '#fef2f2', color: certMsg.type === 'success' ? '#059669' : '#dc2626' }}>{certMsg.text}</div>}

            {certImages.length > 0 ? (
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(120px, 1fr))', gap: 10 }}>
                {certImages.map((img, idx) => {
                  const src = img.startsWith('data:') || img.startsWith('http') ? img : `data:image/png;base64,${img}`;
                  return (
                    <div key={idx} style={{ position: 'relative', borderRadius: 8, overflow: 'hidden', border: '1px solid var(--color-border, #e5e7eb)', background: '#fff' }}>
                      <img src={src} alt={`Bằng cấp ${idx + 1}`}
                        style={{ width: '100%', aspectRatio: '4/3', objectFit: 'cover', display: 'block', cursor: 'zoom-in' }}
                        onClick={() => setZoomImg(src)} />
                      <button
                        onClick={async () => {
                          if (!confirm('Xóa ảnh bằng cấp này?')) return;
                          setCertUploading(true);
                          try {
                            const remaining = certImages.filter((_, i) => i !== idx);
                            const files: File[] = [];
                            for (let i = 0; i < remaining.length; i++) {
                              const s = remaining[i].startsWith('data:') ? remaining[i] : `data:image/png;base64,${remaining[i]}`;
                              const res = await fetch(s); const blob = await res.blob();
                              files.push(new File([blob], `cert_${i}.jpg`, { type: blob.type }));
                            }
                            const result = await tutorApi.updateMyCertificates(files);
                            setCertImages((result.certBase64s ?? []).filter(im => im && im.trim().length > 50));
                            setCertMsg({ type: 'success', text: 'Đã xóa!' }); setTimeout(() => setCertMsg(null), 3000);
                          } catch { setCertMsg({ type: 'error', text: 'Xóa thất bại.' }); }
                          finally { setCertUploading(false); }
                        }}
                        disabled={certUploading}
                        style={{ position: 'absolute', top: 4, right: 4, width: 24, height: 24, borderRadius: '50%', border: 'none', background: 'rgba(239,68,68,0.9)', color: '#fff', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', boxShadow: '0 2px 6px rgba(0,0,0,0.3)' }}
                        title="Xóa ảnh này"
                      ><X size={12}/></button>
                    </div>
                  );
                })}
              </div>
            ) : (
              <div style={{ textAlign: 'center', padding: 16, color: 'var(--color-text-muted, #9ca3af)' }}>
                <Upload size={24} style={{ opacity: 0.3, marginBottom: 6 }}/>
                <p style={{ fontSize: '0.8rem', margin: 0 }}>Chưa có ảnh bằng cấp. Nhấn "Thêm ảnh" để upload.</p>
              </div>
            )}
          </div>

          {/* Alerts + Save button — at the very bottom */}
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

      {/* Lightbox */}
      {zoomImg && (
        <div onClick={() => setZoomImg(null)} style={{
          position: 'fixed', inset: 0, zIndex: 10001,
          background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(6px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'zoom-out', padding: 24,
        }}>
          <button onClick={() => setZoomImg(null)} style={{
            position: 'absolute', top: 16, right: 16, width: 40, height: 40, borderRadius: '50%',
            border: 'none', background: 'rgba(255,255,255,0.9)', color: '#111', cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '1.2rem',
            boxShadow: '0 2px 10px rgba(0,0,0,0.3)',
          }}>✕</button>
          <img src={zoomImg} alt="Phóng to" onClick={e => e.stopPropagation()} style={{
            maxWidth: '90vw', maxHeight: '85vh', objectFit: 'contain',
            borderRadius: 12, boxShadow: '0 8px 40px rgba(0,0,0,0.5)', cursor: 'default',
          }}/>
        </div>
      )}
    </div>
  );
}
