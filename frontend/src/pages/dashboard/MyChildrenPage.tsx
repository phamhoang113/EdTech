import { Plus, ArrowLeft, Phone, GraduationCap, School, UserCircle, CheckCircle, AlertCircle, Pencil, Trash2, X, Search, Users } from 'lucide-react';
import { useState, useEffect, useRef } from 'react';
import { useEscapeKey } from '../../hooks/useEscapeKey';

import { RequestClassModal } from '../../components/parent/RequestClassModal';
import { parentApi } from '../../services/parentApi';
import type { Student, StudentRequest } from '../../services/parentApi';
import apiClient from '../../services/apiClient';
import './MyChildrenPage.css';
import '../dashboard/Dashboard.css';

/* ── Types ─────────────────────────────────────────────────────────────── */
type LookupStatus = 'idle' | 'searching' | 'found' | 'not_found' | 'error';
interface Filters { levels: string[] }

/* ══════════════════════════════════════════════════════════════════════════
   Phone Lookup Step — step 1 của flow thêm con em
══════════════════════════════════════════════════════════════════════════ */
function PhoneLookupStep({ levels, onDone, onCancel }: {
  levels: string[];
  onDone: () => void;
  onCancel: () => void;
}) {
  const [phone, setPhone] = useState('');
  const [hasPhone, setHasPhone] = useState(true);
  const [status, setStatus] = useState<LookupStatus>('idle');
  const [foundStudent, setFoundStudent] = useState<Student | null>(null);
  const [lookupError, setLookupError] = useState('');
  const [createdStudent, setCreatedStudent] = useState<Student | null>(null);
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Form tạo mới (hiện khi status = not_found hoặc !hasPhone)
  const [form, setForm] = useState<Omit<StudentRequest, 'phone'>>({ fullName: '', grade: '', school: '' });
  const [saving, setSaving] = useState(false);
  const [saveError, setSaveError] = useState('');

  // Popup gửi yêu cầu liên kết (khi status = found)
  const [showLinkPopup, setShowLinkPopup] = useState(false);
  const [linking, setLinking] = useState(false);
  useEscapeKey(() => setShowLinkPopup(false), showLinkPopup);

  const handlePhoneChange = (val: string) => {
    setPhone(val);
    setStatus('idle');
    setFoundStudent(null);
    setLookupError('');
    setShowLinkPopup(false);

    if (timerRef.current) clearTimeout(timerRef.current);

    if (/^0[0-9]{9,10}$/.test(val)) {
      setStatus('searching');
      timerRef.current = setTimeout(async () => {
        try {
          const res = await parentApi.lookupChildByPhone(val);
          if (res.message === 'FOUND' && res.data) {
            setStatus('found');
            setFoundStudent(res.data);
          } else {
            setStatus('not_found');
          }
        } catch (e: unknown) {
          const err = e as { response?: { data?: { message?: string } } };
          setStatus('error');
          setLookupError(err?.response?.data?.message ?? 'Không thể kiểm tra SĐT.');
        }
      }, 700);
    }
  };

  /* Gửi yêu cầu liên kết — HS phải chấp nhận */
  const [linkSent, setLinkSent] = useState(false);
  const handleLink = async () => {
    setLinking(true);
    try {
      await parentApi.addChild({ phone, fullName: foundStudent!.fullName });
      setShowLinkPopup(false);
      setLinkSent(true);
    } catch (e: unknown) {
      const err = e as { response?: { data?: { message?: string } } };
      setLookupError(err?.response?.data?.message ?? 'Liên kết thất bại.');
    } finally {
      setLinking(false);
    }
  };

  /* Tạo học sinh mới */
  const handleCreate = async () => {
    if (hasPhone && (!phone || !phone.trim())) { setSaveError('Vui lòng nhập SĐT'); return; }
    if (!form.fullName.trim()) { setSaveError('Vui lòng nhập tên học sinh.'); return; }
    setSaving(true); setSaveError('');
    try {
      const payload: any = { ...form };
      if (hasPhone) payload.phone = phone;
      const res = await parentApi.addChild(payload);
      if (!hasPhone && res.data.username) {
        setCreatedStudent(res.data);
      } else {
        onDone();
      }
    } catch (e: unknown) {
      const err = e as { response?: { data?: { message?: string } } };
      setSaveError(err?.response?.data?.message ?? 'Có lỗi xảy ra.');
    } finally {
      setSaving(false);
    }
  };

  if (createdStudent) {
    return (
      <div className="mcp-add-wrapper">
        <div className="mcp-add-card" style={{ padding: '40px 30px', textAlign: 'center' }}>
          <CheckCircle size={52} color="#10b981" style={{ margin: '0 auto 16px' }} />
          <h2 className="mcp-add-title" style={{ color: '#059669', marginBottom: 12 }}>Thêm thành công!</h2>
          <p style={{ color: '#4b5563', marginBottom: 20 }}>
            Hệ thống đã tự động tạo tài khoản cho học sinh <strong>{createdStudent.fullName}</strong>.
          </p>
          <div style={{ background: '#f3f4f6', padding: 20, borderRadius: 12, textAlign: 'left', marginBottom: 24, display: 'inline-block', width: '100%' }}>
            <p style={{ margin: '0 0 10px' }}><strong>Tên đăng nhập:</strong> <span style={{ fontFamily: 'monospace', color: '#4f46e5', fontSize: '1.1rem', fontWeight: 700, marginLeft: 8 }}>{createdStudent.username}</span></p>
            <p style={{ margin: 0 }}><strong>Mật khẩu:</strong> <span style={{ fontFamily: 'monospace', color: '#4f46e5', fontSize: '1.1rem', fontWeight: 700, marginLeft: 8 }}>{createdStudent.defaultPassword}</span></p>
          </div>
          <p style={{ fontSize: '0.85rem', color: '#6b7280', marginBottom: 24 }}>
            * Xin vui lòng lưu lại thông tin này để học sinh có thể đăng nhập.
          </p>
          <button className="mcp-create-btn" onClick={onDone} style={{ width: '100%', margin: 0 }}>Xác nhận & Đóng</button>
        </div>
      </div>
    );
  }

  if (linkSent) {
    return (
      <div className="mcp-add-wrapper">
        <div className="mcp-add-card" style={{ padding: '40px 30px', textAlign: 'center' }}>
          <CheckCircle size={52} color="#f59e0b" style={{ margin: '0 auto 16px' }} />
          <h2 className="mcp-add-title" style={{ color: '#d97706', marginBottom: 12 }}>Đã gửi yêu cầu liên kết!</h2>
          <p style={{ color: '#4b5563', marginBottom: 20 }}>
            Yêu cầu liên kết đã được gửi tới học sinh <strong>{foundStudent?.fullName}</strong>.
          </p>
          <div style={{ background: '#fffbeb', padding: 16, borderRadius: 12, textAlign: 'left', marginBottom: 24, border: '1px solid #fde68a' }}>
            <p style={{ margin: 0, color: '#92400e', fontSize: '0.9rem' }}>
              ⏳ Học sinh cần <strong>đăng nhập vào ứng dụng</strong> và chấp nhận yêu cầu liên kết.
              Khi được chấp nhận, con em sẽ tự động hiện trong danh sách của bạn.
            </p>
          </div>
          <button className="mcp-create-btn" onClick={onDone} style={{ width: '100%', margin: 0 }}>Xác nhận & Đóng</button>
        </div>
      </div>
    );
  }

  return (
    <div className="mcp-add-wrapper">
      <div className="mcp-add-card">
        <div className="mcp-add-header">
          <div className="mcp-add-icon">👶</div>
          <h2 className="mcp-add-title">Thêm con em</h2>
          <p className="mcp-add-sub">Nhập SĐT để tìm và gửi yêu cầu liên kết</p>
        </div>

        {/* ── Phone input ── */}
        <div className="mcp-field" style={{ paddingTop: 28 }}>
          {/* Nút chuyển đổi (Toggle SĐT) */}
          <div
            onClick={() => {
              const nextState = !hasPhone;
              setHasPhone(nextState);
              if (!nextState) setPhone(''); // khi bỏ SĐT thì clear phone
              setStatus('idle'); setLookupError('');
            }}
            style={{
              display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
              marginBottom: 16, padding: '12px', borderRadius: 12,
              background: hasPhone ? '#f8fafc' : '#eff6ff',
              border: `1.5px solid ${hasPhone ? '#e2e8f0' : '#bfdbfe'}`,
              cursor: 'pointer', transition: 'all 0.2s',
              color: hasPhone ? '#475569' : '#1d4ed8',
              fontWeight: 600, fontSize: '0.85rem'
            }}
          >
            {hasPhone ? (
              <>
                <UserCircle size={16} /> <span style={{ textDecoration: 'underline' }}>Học sinh chưa có số điện thoại? Nhấn vào đây</span>
              </>
            ) : (
              <>
                <Phone size={16} /> <span>Dùng Số điện thoại để tìm và liên kết</span>
              </>
            )}
          </div>

          {hasPhone ? (
            <>
              <label className="mcp-label">Số điện thoại học sinh <span className="mcp-required">*</span></label>
              <div className="mcp-input-wrap" style={{ marginTop: 8 }}>
                <Phone size={15} className="mcp-input-icon" />
                <input
                  className="mcp-input"
                  type="tel"
                  maxLength={11}
                  value={phone}
                  onChange={e => handlePhoneChange(e.target.value)}
                  placeholder="Vd: 0912 345 678"
                  autoFocus
                />
              </div>
            </>
          ) : (
            <div style={{ textAlign: 'center', padding: '10px 0 0' }}>
              <div style={{ display: 'inline-flex', alignItems: 'center', gap: 8, color: '#10b981', fontWeight: 600, background: '#ecfdf5', padding: '10px 16px', borderRadius: 20 }}>
                <CheckCircle size={18} />
                <span>Tạo tài khoản không cần SĐT</span>
              </div>
            </div>
          )}

          {/* Lookup status */}
          {hasPhone && status === 'searching' && (
            <div className="mcp-lookup searching"><Search size={13} /> Đang kiểm tra...</div>
          )}
          {hasPhone && status === 'found' && foundStudent && (
            <div className="mcp-lookup found">
              <CheckCircle size={14} />
              <span>Tìm thấy: <strong>{foundStudent.fullName}</strong></span>
              <button className="mcp-link-btn" onClick={() => setShowLinkPopup(true)}>Gửi yêu cầu liên kết</button>
            </div>
          )}
          {hasPhone && status === 'not_found' && (
            <div className="mcp-lookup not-found" style={{ background: '#fef2f2', borderColor: '#fecaca', color: '#991b1b' }}>
              <AlertCircle size={13} />
              <span>
                Không tìm thấy tài khoản học sinh với SĐT này.<br />
                <small style={{ fontWeight: 400 }}>Vui lòng yêu cầu học sinh tải ứng dụng và đăng ký tài khoản trước, sau đó quay lại liên kết.</small>
              </span>
            </div>
          )}
          {hasPhone && status === 'error' && (
            <div className="mcp-lookup error-s"><AlertCircle size={13} /> {lookupError}</div>
          )}
        </div>

        {/* ── Form tạo mới (CHỈ khi không có SĐT — tạo tài khoản do PH quản lý) ── */}
        {(!hasPhone) && (
          <div className="mcp-form-new">
            {saveError && (
              <div className="mcp-save-error"><AlertCircle size={13} /> {saveError}</div>
            )}
            <div className="mcp-field">
              <label className="mcp-label">Họ tên học sinh <span className="mcp-required">*</span></label>
              <input
                className="mcp-input"
                value={form.fullName}
                onChange={e => setForm(f => ({ ...f, fullName: e.target.value }))}
                placeholder="Vd: Nguyễn Bảo An"
              />
            </div>
            <div className="mcp-field">
              <label className="mcp-label">Khối / Lớp</label>
              <select
                className="mcp-input"
                value={form.grade}
                onChange={e => setForm(f => ({ ...f, grade: e.target.value }))}
              >
                <option value="">Chưa chọn</option>
                {levels.map(l => <option key={l} value={l}>{l}</option>)}
              </select>
            </div>
            <div className="mcp-field">
              <label className="mcp-label">Trường học</label>
              <input
                className="mcp-input"
                value={form.school}
                onChange={e => setForm(f => ({ ...f, school: e.target.value }))}
                placeholder="Vd: THCS Trần Đại Nghĩa"
              />
            </div>
            <button className="mcp-create-btn" onClick={handleCreate} disabled={saving}>
              {saving ? 'Đang tạo...' : '+ Tạo và thêm vào danh sách'}
            </button>
          </div>
        )}

        <button className="mcp-cancel-btn" onClick={onCancel}>Huỷ</button>
      </div>

      {/* ── Link Request Popup ── */}
      {showLinkPopup && foundStudent && (
        <div className="mcp-popup-overlay" onClick={() => setShowLinkPopup(false)}>
          <div className="mcp-popup" onClick={e => e.stopPropagation()}>
            <button className="mcp-popup-close" onClick={() => setShowLinkPopup(false)}><X size={16} /></button>
            <div className="mcp-popup-avatar">
              {foundStudent.avatarBase64
                ? <img src={`data:image/jpeg;base64,${foundStudent.avatarBase64}`} alt={foundStudent.fullName} />
                : <span>{foundStudent.fullName.split(' ').pop()?.charAt(0)}</span>
              }
            </div>
            <h3 className="mcp-popup-name">{foundStudent.fullName}</h3>
            <p className="mcp-popup-phone"><Phone size={12} /> {phone}</p>
            <p className="mcp-popup-desc">
              Học sinh này đã có tài khoản trên hệ thống.<br />
              Gửi yêu cầu liên kết? Học sinh sẽ cần <strong>chấp nhận</strong> trước khi hiện trong danh sách con em.
            </p>
            {lookupError && <p className="mcp-popup-error"><AlertCircle size={12} /> {lookupError}</p>}
            <div className="mcp-popup-actions">
              <button className="mcp-popup-cancel" onClick={() => setShowLinkPopup(false)}>Huỷ</button>
              <button className="mcp-popup-confirm" onClick={handleLink} disabled={linking}>
                {linking ? 'Đang gửi...' : '✉ Gửi yêu cầu liên kết'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

/* ── Child Card ─────────────────────────────────────────────────────────── */
function ChildCard({ child, onEdit, onDelete }: {
  child: Student; onEdit: () => void; onDelete: () => void;
}) {
  const initials = child.fullName.trim().split(' ').pop()?.charAt(0).toUpperCase() ?? '?';
  const isPhonelessChild = child.username && (!child.phone || child.phone === child.username);
  const [showCreds, setShowCreds] = useState(false);
  const [showResetForm, setShowResetForm] = useState(false);
  const [passwordInput, setPasswordInput] = useState('');
  const [resetting, setResetting] = useState(false);
  const [resetSuccess, setResetSuccess] = useState(false);
  const [resetError, setResetError] = useState('');

  const handleResetPassword = async () => {
    if (passwordInput.length < 6) {
      setResetError('Mật khẩu phải có ít nhất 6 ký tự.');
      return;
    }
    setResetting(true);
    setResetError('');
    try {
      await parentApi.resetChildPassword(child.id, passwordInput);
      setResetSuccess(true);
      setPasswordInput('');
      setTimeout(() => {
        setShowResetForm(false);
        setResetSuccess(false);
      }, 2500);
    } catch {
      setResetError('Không thể đặt lại mật khẩu.');
    } finally { setResetting(false); }
  };

  return (
    <div className="mcp-child-card">
      <div className="mcp-child-avatar">{initials}</div>
      <div className="mcp-child-info">
        <div className="mcp-child-name">{child.fullName}</div>
        <div className="mcp-child-meta">
          {child.phone && <span className="mcp-tag phone"><Phone size={10} /> {child.phone}</span>}
          {child.grade && <span className="mcp-tag grade"><GraduationCap size={10} /> {child.grade}</span>}
          {child.school && <span className="mcp-tag school"><School size={10} /> {child.school}</span>}
          {!child.phone && !child.grade && !child.school && (
            <span className="mcp-tag muted"><UserCircle size={10} /> Chưa cập nhật</span>
          )}
        </div>

        {/* Thông tin đăng nhập cho HS do PH quản lý */}
        {isPhonelessChild && (
          <div className="mcp-creds-section">
            <button className="mcp-creds-toggle" onClick={() => setShowCreds(!showCreds)}>
              🔑 {showCreds ? 'Ẩn' : 'Xem'} thông tin đăng nhập
            </button>
            {showCreds && (
              <div className="mcp-creds-box">
                <div className="mcp-creds-row">
                  <span className="mcp-creds-label">Tài khoản:</span>
                  <code className="mcp-creds-value">{child.username}</code>
                </div>

                {/* Form đặt lại mật khẩu */}
                {showResetForm ? (
                  <div className="mcp-reset-form">
                    {resetSuccess ? (
                      <div className="mcp-reset-success">✅ Đã đặt lại mật khẩu thành công!</div>
                    ) : (
                      <div className="mcp-reset-input-row">
                        <input
                          type="text"
                          className="mcp-reset-input"
                          placeholder="Nhập mật khẩu mới (≥ 6 ký tự)"
                          value={passwordInput}
                          onChange={e => setPasswordInput(e.target.value)}
                          autoFocus
                        />
                        <div className="mcp-reset-btn-group">
                          <button
                            className="mcp-reset-submit"
                            onClick={handleResetPassword}
                            disabled={resetting}
                          >
                            {resetting ? 'Đang lưu...' : 'Xác nhận'}
                          </button>
                          <button className="mcp-reset-cancel" onClick={() => { setShowResetForm(false); setResetError(''); }}>
                            Hủy
                          </button>
                        </div>
                        {resetError && <div className="mcp-reset-error">{resetError}</div>}
                      </div>
                    )}
                  </div>
                ) : (
                  <button className="mcp-reset-pwd-btn" onClick={() => setShowResetForm(true)}>
                    🔄 Đặt lại mật khẩu
                  </button>
                )}

                <div className="mcp-creds-hint">
                  Nếu con em quên mật khẩu, phụ huynh có thể đặt lại tại đây.
                </div>
              </div>
            )}
          </div>
        )}
      </div>
      <div className="mcp-child-actions">
        <button className="mcp-act edit" onClick={onEdit}><Pencil size={13} /></button>
        <button className="mcp-act delete" onClick={onDelete}><Trash2 size={13} /></button>
      </div>
    </div>
  );
}

/* ── Edit Modal ─────────────────────────────────────────────────────────── */
function EditModal({ child, levels, onClose, onSaved }: {
  child: Student; levels: string[]; onClose: () => void; onSaved: () => void;
}) {
  const [form, setForm] = useState<StudentRequest>({
    phone: child.phone ?? '',
    fullName: child.fullName,
    grade: child.grade ?? '',
    school: child.school ?? '',
  });
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const handleSave = async () => {
    if (!form.fullName.trim()) { setError('Vui lòng nhập tên.'); return; }
    setSaving(true); setError('');
    try { await parentApi.updateChild(child.id, form); onSaved(); }
    catch (e: unknown) {
      const err = e as { response?: { data?: { message?: string } } };
      setError(err?.response?.data?.message ?? 'Lỗi khi lưu.');
    } finally { setSaving(false); }
  };

  return (
    <div className="mcp-popup-overlay" onClick={onClose}>
      <div className="mcp-popup edit-mode" onClick={e => e.stopPropagation()}>
        <button className="mcp-popup-close" onClick={onClose}><X size={16} /></button>
        <h3 className="mcp-popup-name" style={{ marginTop: 8 }}>✏️ Sửa thông tin</h3>
        {error && <p className="mcp-popup-error"><AlertCircle size={12} /> {error}</p>}
        <div className="mcp-field" style={{ width: '100%', textAlign: 'left' }}>
          <label className="mcp-label">Họ tên <span className="mcp-required">*</span></label>
          <input className="mcp-input" value={form.fullName}
            onChange={e => setForm(f => ({ ...f, fullName: e.target.value }))} placeholder="Họ tên học sinh" />
        </div>
        <div className="mcp-field" style={{ width: '100%', textAlign: 'left' }}>
          <label className="mcp-label">Khối/Lớp</label>
          <select className="mcp-input" value={form.grade} onChange={e => setForm(f => ({ ...f, grade: e.target.value }))}>
            <option value="">Chưa chọn</option>
            {levels.map(l => <option key={l} value={l}>{l}</option>)}
          </select>
        </div>
        <div className="mcp-field" style={{ width: '100%', textAlign: 'left' }}>
          <label className="mcp-label">Trường học</label>
          <input className="mcp-input" value={form.school ?? ''}
            onChange={e => setForm(f => ({ ...f, school: e.target.value }))} placeholder="Trường học" />
        </div>
        <div className="mcp-popup-actions">
          <button className="mcp-popup-cancel" onClick={onClose}>Huỷ</button>
          <button className="mcp-popup-confirm" onClick={handleSave} disabled={saving}>
            {saving ? 'Đang lưu...' : '✓ Lưu thay đổi'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ── Delete Confirm ─────────────────────────────────────────────────────── */
function DeleteConfirm({ child, onClose, onDeleted }: {
  child: Student; onClose: () => void; onDeleted: () => void;
}) {
  const [loading, setLoading] = useState(false);
  const handleDelete = async () => {
    setLoading(true);
    try { await parentApi.deleteChild(child.id); onDeleted(); }
    finally { setLoading(false); }
  };
  return (
    <div className="mcp-popup-overlay" onClick={onClose}>
      <div className="mcp-popup" onClick={e => e.stopPropagation()} style={{ maxWidth: 380 }}>
        <button className="mcp-popup-close" onClick={onClose}><X size={16} /></button>
        <div className="mcp-popup-avatar" style={{ background: '#ef4444' }}>⚠️</div>
        <h3 className="mcp-popup-name">Xác nhận xoá</h3>
        <p className="mcp-popup-desc">
          Xoá liên kết với <strong>{child.fullName}</strong>?<br />
          <small>Tài khoản do bạn tạo sẽ bị xoá.</small>
        </p>
        <div className="mcp-popup-actions">
          <button className="mcp-popup-cancel" onClick={onClose}>Huỷ</button>
          <button className="mcp-popup-confirm danger" onClick={handleDelete} disabled={loading}>
            {loading ? 'Đang xoá...' : 'Xác nhận xoá'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   MyChildrenPage — trang chính
══════════════════════════════════════════════════════════════════════════ */
export function MyChildrenPage() {
  const [children, setChildren] = useState<Student[]>([]);
  const [levels, setLevels] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [showAdd, setShowAdd] = useState(false);
  const [editChild, setEditChild] = useState<Student | null>(null);
  const [delChild, setDelChild] = useState<Student | null>(null);
  const [showRequestClass, setShowRequestClass] = useState(false);

  const fetchChildren = async () => {
    try { setChildren((await parentApi.getMyChildren()).data ?? []); }
    finally { setLoading(false); }
  };

  useEffect(() => {
    fetchChildren();
    apiClient.get('/api/v1/classes/filters')
      .then(res => setLevels((res.data?.data as Filters)?.levels ?? []))
      .catch(() => { });
  }, []);

  if (showAdd) {
    return (
      <>
        <div className="dash-body">
          <div className="mcp-back-bar">
            <button className="mcp-back-btn" onClick={() => setShowAdd(false)}>
              <ArrowLeft size={16} /> Quay lại
            </button>
          </div>
          <PhoneLookupStep
            levels={levels}
            onDone={() => { setShowAdd(false); fetchChildren(); }}
            onCancel={() => setShowAdd(false)}
          />
        </div>
      </>
    );
  }

  return (
    <>
      <div className="mcp-page-body">
        {/* Page header */}
        <div className="mcp-page-header">
          <div className="mcp-page-header-left">
            <div className="mcp-page-icon">👨‍👩‍👧‍👦</div>
            <div>
              <h1 className="mcp-page-title">Con em của tôi</h1>
              <p className="mcp-page-sub">Quản lý danh sách học sinh trong gia đình</p>
            </div>
          </div>
          <button className="mcp-add-new-btn" onClick={() => setShowAdd(true)}>
            <Plus size={15} /> Thêm con em
          </button>
        </div>

        {/* Body */}
        {loading ? (
          <div className="mcp-empty"><div className="mcp-spinner" /></div>
        ) : children.length === 0 ? (
          <div className="mcp-empty">
            <div className="mcp-empty-illus"><Users size={48} strokeWidth={1.2} /></div>
            <p className="mcp-empty-title">Chưa có con em nào</p>
            <p className="mcp-empty-hint">Nhập SĐT học sinh để liên kết tài khoản hoặc tạo mới</p>
            <button className="mcp-add-new-btn" style={{ marginTop: 20 }} onClick={() => setShowAdd(true)}>
              <Plus size={15} /> Thêm con em đầu tiên
            </button>
          </div>
        ) : (
          <div className="mcp-list">
            {children.map(child => (
              <ChildCard
                key={child.id} child={child}
                onEdit={() => setEditChild(child)}
                onDelete={() => setDelChild(child)}
              />
            ))}
            {/* Add card */}
            <button className="mcp-add-card" onClick={() => setShowAdd(true)}>
              <Plus size={20} /><span>Thêm con em</span>
            </button>
          </div>
        )}
      </div>

      {editChild && (
        <EditModal
          child={editChild} levels={levels}
          onClose={() => setEditChild(null)}
          onSaved={() => { setEditChild(null); fetchChildren(); }}
        />
      )}
      {delChild && (
        <DeleteConfirm
          child={delChild}
          onClose={() => setDelChild(null)}
          onDeleted={() => { setDelChild(null); fetchChildren(); }}
        />
      )}
      {showRequestClass && (
        <RequestClassModal
          onClose={() => setShowRequestClass(false)}
          onSuccess={() => { setShowRequestClass(false); }}
        />
      )}
    </>
  );
}
