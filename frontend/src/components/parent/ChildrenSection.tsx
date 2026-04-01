import { Plus, Pencil, Trash2, X, GraduationCap, School, UserCircle, AlertCircle, Phone, CheckCircle, Search } from 'lucide-react';
import { useState, useEffect, useRef } from 'react';

import { parentApi } from '../../services/parentApi';
import type { Student, StudentRequest } from '../../services/parentApi';
import apiClient from '../../services/apiClient';
import './ChildrenSection.css';

/* ── Types ─────────────────────────────────────────────────────────────── */
interface Filters { levels: string[] }
type LookupStatus = 'idle' | 'searching' | 'found' | 'not_found' | 'error';

/* ── Child Card ─────────────────────────────────────────────────────────── */
function ChildCard({ child, onEdit, onDelete }: {
  child: Student;
  onEdit: () => void;
  onDelete: () => void;
}) {
  const initials = child.fullName.trim().split(' ').pop()?.charAt(0).toUpperCase() ?? '?';

  return (
    <div className="child-card">
      <div className="child-avatar">
        {child.avatarBase64
          ? <img src={`data:image/jpeg;base64,${child.avatarBase64}`} alt={child.fullName}/>
          : <span className="child-avatar-initials">{initials}</span>
        }
      </div>
      <div className="child-info">
        <div className="child-name">{child.fullName}</div>
        <div className="child-meta">
          {child.phone && (
            <span className="child-tag phone"><Phone size={10}/> {child.phone}</span>
          )}
          {child.grade && (
            <span className="child-tag"><GraduationCap size={11}/> {child.grade}</span>
          )}
          {child.school && (
            <span className="child-tag school"><School size={11}/> {child.school}</span>
          )}
          {!child.grade && !child.school && !child.phone && (
            <span className="child-tag muted"><UserCircle size={11}/> Chưa cập nhật</span>
          )}
          {child.linkStatus === 'PENDING' && (
            <span className="child-tag" style={{ background: '#fef3c7', color: '#d97706', border: '1px solid #fde68a' }}>
              <AlertCircle size={11}/> Chờ học sinh duyệt
            </span>
          )}
        </div>
      </div>
      <div className="child-actions">
        {child.linkStatus === 'PENDING' ? (
           <button className="child-action-btn delete" onClick={onDelete} title="Huỷ yêu cầu"><X size={13}/></button>
        ) : (
          <>
            <button className="child-action-btn edit" onClick={onEdit} title="Sửa"><Pencil size={13}/></button>
            <button className="child-action-btn delete" onClick={onDelete} title="Xoá"><Trash2 size={13}/></button>
          </>
        )}
      </div>
    </div>
  );
}

/* ── Modal thêm / sửa ───────────────────────────────────────────────────── */
function ChildFormModal({ child, levels, onClose, onSaved }: {
  child: Student | null;
  levels: string[];
  onClose: () => void;
  onSaved: () => void;
}) {
  const isEdit = child !== null;

  const [form, setForm] = useState<StudentRequest>({
    phone: child?.phone ?? '',
    fullName: child?.fullName ?? '',
    grade: child?.grade ?? '',
    school: child?.school ?? '',
  });

  const [hasPhone, setHasPhone] = useState(true);
  const [createdStudent, setCreatedStudent] = useState<Student | null>(null);

  // Lookup state
  const [lookupStatus, setLookupStatus] = useState<LookupStatus>('idle');
  const [lookupName, setLookupName] = useState<string>('');
  const [lookupError, setLookupError] = useState('');
  const lookupTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const setField = <K extends keyof StudentRequest>(k: K, v: StudentRequest[K]) =>
    setForm(f => ({ ...f, [k]: v }));

  /* Auto-lookup khi PH nhập SĐT (chỉ ở mode thêm mới) */
  const handlePhoneChange = (phone: string) => {
    setField('phone', phone);
    if (isEdit) return;

    setLookupStatus('idle');
    setLookupName('');
    setLookupError('');

    if (lookupTimer.current) clearTimeout(lookupTimer.current);

    // Khi SĐT đủ định dạng mới lookup
    if (/^0[0-9]{9,10}$/.test(phone)) {
      setLookupStatus('searching');
      lookupTimer.current = setTimeout(async () => {
        try {
          const res = await parentApi.lookupChildByPhone(phone);
          if (res.message === 'FOUND' && res.data) {
            setLookupStatus('found');
            setLookupName(res.data.fullName);
            // Auto-fill tên từ tài khoản
            setForm(f => ({ ...f, fullName: res.data!.fullName }));
          } else if (res.message === 'NOT_FOUND') {
            setLookupStatus('not_found');
          }
        } catch (e: unknown) {
          const err = e as { response?: { data?: { message?: string } } };
          setLookupStatus('error');
          setLookupError(err?.response?.data?.message ?? 'Không thể kiểm tra SĐT');
        }
      }, 600);
    }
  };

  const handleSave = async () => {
    if (!isEdit && hasPhone && (!form.phone || !form.phone.trim())) { setError('Vui lòng nhập số điện thoại học sinh.'); return; }
    if (!form.fullName.trim())          { setError('Vui lòng nhập tên học sinh.'); return; }
    setSaving(true); setError('');
    try {
      const payload = { ...form };
      if (!isEdit && !hasPhone) {
        delete payload.phone; // Không gửi phone
      }

      if (isEdit) { 
        await parentApi.updateChild(child.id, payload); 
        onSaved();
      } else { 
        const res = await parentApi.addChild(payload); 
        // Phụ huynh tạo hộ không SĐT => Backend trả về username & defaultPassword
        if (!hasPhone && res.data.username) {
          setCreatedStudent(res.data);
        } else {
          onSaved();
        }
      }
    } catch (e: unknown) {
      const err = e as { response?: { data?: { message?: string } } };
      setError(err?.response?.data?.message ?? 'Có lỗi xảy ra. Vui lòng thử lại.');
    } finally {
      setSaving(false);
    }
  };

  if (createdStudent) {
    return (
      <div className="child-modal-overlay" onClick={onSaved}>
        <div className="child-modal" onClick={e => e.stopPropagation()} style={{ textAlign: 'center' }}>
          <div className="child-modal-header" style={{ borderBottom: 'none', paddingBottom: 0 }}>
            <h3 className="child-modal-title" style={{ width: '100%', color: '#10b981', fontSize: '1.25rem' }}>
              <CheckCircle size={40} style={{ margin: '0 auto 10px', display: 'block' }}/>
              Thêm con em thành công!
            </h3>
          </div>
          <div className="child-modal-body">
            <p style={{ marginBottom: 15, color: '#4b5563' }}>
              Hệ thống đã tạo tài khoản tự động cho học sinh <strong>{createdStudent.fullName}</strong>.
            </p>
            <div style={{ background: '#f3f4f6', padding: 15, borderRadius: 8, textAlign: 'left', marginBottom: 20 }}>
              <p style={{ margin: '0 0 8px' }}><strong>Tên đăng nhập:</strong> <span style={{ fontFamily: 'monospace', color: '#4f46e5', fontWeight: 600 }}>{createdStudent.username}</span></p>
              <p style={{ margin: 0 }}><strong>Mật khẩu:</strong> <span style={{ fontFamily: 'monospace', color: '#4f46e5', fontWeight: 600 }}>{createdStudent.defaultPassword}</span></p>
            </div>
            <p style={{ fontSize: '0.85rem', color: '#6b7280' }}>
              * Xin vui lòng lưu lại thông tin này để học sinh có thể đăng nhập.
            </p>
          </div>
          <div className="child-modal-footer" style={{ justifyContent: 'center' }}>
            <button className="child-btn-save" onClick={onSaved}>Xác nhận & Đóng</button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="child-modal-overlay" onClick={onClose}>
      <div className="child-modal" onClick={e => e.stopPropagation()}>

        <div className="child-modal-header">
          <div>
            <div className="child-modal-icon">{isEdit ? '✏️' : '👶'}</div>
            <h3 className="child-modal-title">{isEdit ? 'Sửa thông tin' : 'Thêm con em'}</h3>
            <p className="child-modal-subtitle">{isEdit ? 'Cập nhật thông tin học sinh' : 'Nhập SĐT để liên kết tài khoản'}</p>
          </div>
          <button className="child-modal-close" onClick={onClose}><X size={18}/></button>
        </div>

        <div className="child-modal-body">
          {error && (
            <div className="child-modal-error"><AlertCircle size={14}/> {error}</div>
          )}

          {/* SĐT — chỉ hiện khi thêm mới */}
          {!isEdit && (
            <div className="child-field" style={{ marginBottom: 15 }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 }}>
                <label className="child-label" style={{ margin: 0 }}>
                  Số điện thoại học sinh {hasPhone && <span style={{ color: '#ef4444' }}>*</span>}
                </label>
                <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: '0.85rem', cursor: 'pointer', color: '#4b5563' }}>
                  <input type="checkbox" checked={!hasPhone} onChange={(e) => {
                    setHasPhone(!e.target.checked);
                    if (e.target.checked) setField('phone', '');
                    setLookupStatus('idle'); setLookupError('');
                  }} />
                  Chưa có SĐT
                </label>
              </div>

              {hasPhone && (
                <div style={{ position: 'relative' }}>
                  <Phone size={14} style={{
                    position: 'absolute', left: 12, top: '50%', transform: 'translateY(-50%)',
                    color: 'var(--color-text-muted, #9ca3af)',
                  }}/>
                  <input
                    className="child-input"
                    style={{ paddingLeft: 34 }}
                    value={form.phone ?? ''}
                    onChange={e => handlePhoneChange(e.target.value)}
                    placeholder="Vd: 0912345678"
                    autoFocus
                    maxLength={11}
                  />
                </div>
              )}

              {/* Lookup status badge */}
              {lookupStatus === 'searching' && (
                <div className="child-lookup-badge searching">
                  <Search size={12}/> Đang kiểm tra...
                </div>
              )}
              {lookupStatus === 'found' && (
                <div className="child-lookup-badge found">
                  <CheckCircle size={13}/> Tìm thấy tài khoản: <strong>{lookupName}</strong> — sẽ liên kết
                </div>
              )}
              {lookupStatus === 'not_found' && (
                <div className="child-lookup-badge not-found">
                  <Plus size={12}/> Chưa có tài khoản — sẽ tạo mới
                </div>
              )}
              {lookupStatus === 'error' && (
                <div className="child-lookup-badge error-badge">
                  <AlertCircle size={12}/> {lookupError}
                </div>
              )}
            </div>
          )}

          {/* Họ tên */}
          <div className="child-field">
            <label className="child-label">Họ tên học sinh <span style={{ color: '#ef4444' }}>*</span></label>
            <input
              className="child-input"
              value={form.fullName}
              onChange={e => setField('fullName', e.target.value)}
              placeholder="Vd: Nguyễn Bảo An"
              disabled={!isEdit && hasPhone && lookupStatus === 'found'}
              style={{ opacity: (!isEdit && hasPhone && lookupStatus === 'found') ? 0.7 : 1 }}
            />
            {!isEdit && hasPhone && lookupStatus === 'found' && (
              <span style={{ fontSize: '0.72rem', color: '#6366f1' }}>
                Tên lấy từ tài khoản học sinh
              </span>
            )}
          </div>

          {/* Lớp */}
          <div className="child-field">
            <label className="child-label">Khối/Lớp</label>
            <select className="child-input" value={form.grade ?? ''} onChange={e => setField('grade', e.target.value)}>
              <option value="">Chưa chọn</option>
              {levels.map(l => <option key={l} value={l}>{l}</option>)}
            </select>
          </div>

          {/* Trường */}
          <div className="child-field">
            <label className="child-label">Trường học</label>
            <input
              className="child-input"
              value={form.school ?? ''}
              onChange={e => setField('school', e.target.value)}
              placeholder="Vd: THCS Trần Đại Nghĩa"
            />
          </div>
        </div>

        <div className="child-modal-footer">
          <button className="child-btn-cancel" onClick={onClose}>Huỷ</button>
          <button
            className="child-btn-save"
            onClick={handleSave}
            disabled={saving || lookupStatus === 'searching' || lookupStatus === 'error'}
          >
            {saving ? 'Đang lưu...' : isEdit ? '✓ Lưu thay đổi' : '+ Liên kết / Thêm mới'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ── Delete Confirm ─────────────────────────────────────────────────────── */
function DeleteConfirmModal({ child, onClose, onDeleted }: {
  child: Student; onClose: () => void; onDeleted: () => void;
}) {
  const [loading, setLoading] = useState(false);
  const handleDelete = async () => {
    setLoading(true);
    try { await parentApi.deleteChild(child.id); onDeleted(); }
    finally { setLoading(false); }
  };
  return (
    <div className="child-modal-overlay" onClick={onClose}>
      <div className="child-modal" style={{ maxWidth: 400 }} onClick={e => e.stopPropagation()}>
        <div className="child-modal-header" style={{ background: 'linear-gradient(135deg,#ef4444,#dc2626)' }}>
          <div>
            <div className="child-modal-icon">⚠️</div>
            <h3 className="child-modal-title">Xác nhận xoá</h3>
          </div>
          <button className="child-modal-close" onClick={onClose}><X size={18}/></button>
        </div>
        <div className="child-modal-body">
          <p style={{ textAlign: 'center', marginTop: 8 }}>
            Bạn có chắc muốn xoá liên kết với <strong>{child.fullName}</strong>?<br/>
            <span style={{ fontSize: '0.78rem', color: 'var(--color-text-muted)' }}>
              Nếu đây là tài khoản do bạn tạo, tài khoản sẽ bị xoá.
            </span>
          </p>
        </div>
        <div className="child-modal-footer">
          <button className="child-btn-cancel" onClick={onClose}>Huỷ</button>
          <button
            className="child-btn-save"
            style={{ background: 'linear-gradient(135deg,#ef4444,#dc2626)' }}
            onClick={handleDelete} disabled={loading}
          >
            {loading ? 'Đang xoá...' : 'Xác nhận xoá'}
          </button>
        </div>
      </div>
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════════════
   Main ChildrenSection
══════════════════════════════════════════════════════════════════════════ */
export function ChildrenSection() {
  const [children, setChildren] = useState<Student[]>([]);
  const [levels, setLevels] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editChild, setEditChild] = useState<Student | null>(null);
  const [deleteChild, setDeleteChild] = useState<Student | null>(null);

  const fetchChildren = async () => {
    try { setChildren((await parentApi.getMyChildren()).data); }
    finally { setLoading(false); }
  };

  useEffect(() => {
    fetchChildren();
    apiClient.get('/api/v1/classes/filters')
      .then(res => setLevels((res.data?.data as Filters)?.levels ?? []))
      .catch(() => {});
  }, []);

  const handleFormSaved = () => { setShowForm(false); setEditChild(null); fetchChildren(); };
  const handleDeleted   = () => { setDeleteChild(null); fetchChildren(); };

  return (
    <div className="children-section">
      <div className="children-header">
        <div className="children-header-left">
          <span className="children-header-icon">👨‍👩‍👧‍👦</span>
          <div>
            <h3 className="children-header-title">Con em của tôi</h3>
            <p className="children-header-sub">Liên kết qua SĐT — quản lý thông tin học sinh</p>
          </div>
        </div>
        <button className="children-add-btn" onClick={() => { setEditChild(null); setShowForm(true); }}>
          <Plus size={14}/> Thêm con em
        </button>
      </div>

      {loading ? (
        <div className="children-empty">
          <div className="children-loading-spinner"/>
          Đang tải...
        </div>
      ) : children.length === 0 ? (
        <div className="children-empty">
          <div className="children-empty-icon">👶</div>
          <p className="children-empty-text">Chưa có thông tin con em</p>
          <p className="children-empty-hint">Nhập SĐT học sinh để liên kết tài khoản</p>
          <button className="children-add-btn" style={{ marginTop: 12 }}
            onClick={() => { setEditChild(null); setShowForm(true); }}>
            <Plus size={14}/> Thêm ngay
          </button>
        </div>
      ) : (
        <div className="children-grid">
          {children.map(child => (
            <ChildCard
              key={child.id} child={child}
              onEdit={() => { setEditChild(child); setShowForm(true); }}
              onDelete={() => setDeleteChild(child)}
            />
          ))}
          <button className="child-add-card" onClick={() => { setEditChild(null); setShowForm(true); }}>
            <Plus size={22} style={{ color: '#6366f1' }}/>
            <span>Liên kết con em</span>
          </button>
        </div>
      )}

      {showForm && (
        <ChildFormModal
          child={editChild} levels={levels}
          onClose={() => { setShowForm(false); setEditChild(null); }}
          onSaved={handleFormSaved}
        />
      )}

      {deleteChild && (
        <DeleteConfirmModal
          child={deleteChild}
          onClose={() => setDeleteChild(null)}
          onDeleted={handleDeleted}
        />
      )}
    </div>
  );
}
