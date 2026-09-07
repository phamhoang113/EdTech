import { X, UserPlus, Search, Loader2, AlertCircle } from 'lucide-react';
import React, { useState, useEffect } from 'react';

import { adminApi } from '../../services/adminApi';
import type { AdminUserListItem } from '../../services/adminApi';
import apiClient from '../../services/apiClient';
import '../../components/parent/RequestClassModal.css';
import {
  MapAddressInput,
  SessionPicker,
  LevelFeesEditor,
  toHHMM
} from '../../components/parent/RequestClassModal';
import type { CaSchedule, LevelFeeRow } from '../../components/parent/RequestClassModal';
import { useEscapeKey } from '../../hooks/useEscapeKey';

interface AdminCreateClassModalProps {
  onClose: () => void;
  onSuccess: () => void;
  showToast: (type: 'success' | 'error', msg: string) => void;
}

interface Filters {
  subjects: string[];
  levels: string[];
  tutorLevels: string[];
  genders: string[];
}

export function AdminCreateClassModal({ onClose, onSuccess, showToast }: AdminCreateClassModalProps) {
  useEscapeKey(onClose);
  // Tabs: search | keyword | create
  const [parentMode, setParentMode] = useState<'search' | 'keyword' | 'create'>('search');

  // Role filter: search across PARENT, STUDENT, or both
  const [searchRole, setSearchRole] = useState<'ALL' | 'PARENT' | 'STUDENT'>('ALL');

  // Search by phone
  const [phoneSearch, setPhoneSearch] = useState('');
  const [searchLoading, setSearchLoading] = useState(false);
  const [searchResults, setSearchResults] = useState<AdminUserListItem[]>([]);

  // Search by keyword (name/email)
  const [keywordSearch, setKeywordSearch] = useState('');
  const [keywordLoading, setKeywordLoading] = useState(false);
  const [keywordResults, setKeywordResults] = useState<AdminUserListItem[]>([]);
  const [selectedParent, setSelectedParent] = useState<AdminUserListItem | null>(null);

  // Quick Create Parent
  const [newParentForm, setNewParentForm] = useState({ fullName: '', phone: '', password: '' });
  const [creatingParent, setCreatingParent] = useState(false);

  // Filters State
  const [filters, setFilters] = useState<Filters>({ subjects: [], levels: [], tutorLevels: [], genders: [] });

  // Class Form State
  const [form, setForm] = useState({
    subject: '',
    customSubject: '',
    grade: '',
    mode: 'OFFLINE' as 'ONLINE' | 'IN_PERSON',
    address: '',
    sessionsPerWeek: 2,
    sessionDurationMin: 90,
    genderRequirement: 'Không yêu cầu',
    description: '',
    feePercentage: 30, // % nền tảng
  });
  
  const [caSchedules, setCaSchedules] = useState<CaSchedule[]>([]);
  const [levelFees, setLevelFees] = useState<LevelFeeRow[]>([]);
  const [submittingClass, setSubmittingClass] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    apiClient.get('/api/v1/classes/filters')
      .then(res => {
        const data = res.data?.data as Filters;
        setFilters(data);
        if (data.subjects.length > 0) setForm(f => ({ ...f, subject: data.subjects[0] }));
        if (data.levels.length > 0)   setForm(f => ({ ...f, grade: data.levels[0] }));
        setLevelFees([]);
      })
      .catch(() => {});
  }, []);

  const set = <K extends keyof typeof form>(k: K, v: typeof form[K]) =>
    setForm(f => ({ ...f, [k]: v }));

  // Fetch users by role filter (PARENT, STUDENT, or both)
  const fetchUsersByRole = async (): Promise<AdminUserListItem[]> => {
    if (searchRole === 'ALL') {
      const [parentRes, studentRes] = await Promise.all([
        adminApi.getUsers('PARENT'),
        adminApi.getUsers('STUDENT'),
      ]);
      return [...parentRes.data, ...studentRes.data];
    }
    const res = await adminApi.getUsers(searchRole);
    return res.data;
  };

  const getRoleName = (role: string) => {
    if (role === 'PARENT') return 'Phụ huynh';
    if (role === 'STUDENT') return 'Học sinh';
    return role;
  };

  // Search by phone
  const handleSearchParent = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (!phoneSearch.trim()) return;
    setSearchLoading(true);
    try {
      const allUsers = await fetchUsersByRole();
      const keyword = phoneSearch.trim().toLowerCase();
      const matches = allUsers.filter(u =>
        u.phone?.includes(keyword) ||
        u.fullName.toLowerCase().includes(keyword) ||
        (u.email && u.email.toLowerCase().includes(keyword))
      );
      setSearchResults(matches);
      if (matches.length === 0) showToast('error', 'Không tìm thấy user nào phù hợp');
    } catch {
      showToast('error', 'Lỗi khi tìm kiếm');
    } finally {
      setSearchLoading(false);
    }
  };

  // Search by keyword (name/email)
  const handleSearchByKeyword = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    const keyword = keywordSearch.trim().toLowerCase();
    if (!keyword) return;
    setKeywordLoading(true);
    try {
      const allUsers = await fetchUsersByRole();
      const matches = allUsers.filter(u =>
        u.fullName.toLowerCase().includes(keyword) ||
        (u.email && u.email.toLowerCase().includes(keyword))
      );
      setKeywordResults(matches);
      if (matches.length === 0) showToast('error', 'Không tìm thấy user nào phù hợp');
    } catch {
      showToast('error', 'Lỗi khi tìm kiếm');
    } finally {
      setKeywordLoading(false);
    }
  };

  // Create Parent Handler
  const handleCreateParent = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newParentForm.fullName || !newParentForm.phone || !newParentForm.password) {
      return showToast('error', 'Vui lòng điền đủ thông tin Phụ huynh');
    }
    setCreatingParent(true);
    try {
      const res = await adminApi.quickCreateUser({
        ...newParentForm,
        role: 'PARENT'
      });
      showToast('success', 'Đã tạo thành công tài khoản Phụ huynh');
      setSelectedParent(res.data as unknown as AdminUserListItem);
      setParentMode('search');
    } catch (err: any) {
      showToast('error', err.response?.data?.message || 'Lỗi khi tạo user');
    } finally {
      setCreatingParent(false);
    }
  };

  const effectiveSubject = form.subject === 'Khác' ? form.customSubject : form.subject;
  const buildTitle = () => (!effectiveSubject || !form.grade) ? '' : `Lớp ${effectiveSubject} ${form.grade}`;

  // Submit Class Handler
  const handleSubmitClass = async () => {
    if (!effectiveSubject) { setError('Vui lòng chọn môn học.'); return; }
    if (!form.grade)       { setError('Vui lòng chọn khối/lớp.'); return; }
    if (form.mode === 'IN_PERSON' && !form.address.trim()) { setError('Vui lòng chọn địa chỉ học.'); return; }
    
    // Parent fee derived from min level fees (or 0 if none)
    const computedParentFee = levelFees.length > 0
      ? Math.min(...levelFees.map(r => r.fee))
      : 0;

    let timeFrame = '';
    const scheduleEntries: { dayOfWeek: string; ca: string; startTime: string; endTime: string }[] = [];
    for (const cs of caSchedules) {
      if (cs.days.length === 0 && cs.slots.length === 0) continue;
      const slotStrs = cs.slots.map(s => `${toHHMM(s.start)}-${toHHMM(s.end)}`).join(', ');
      if (slotStrs && !timeFrame) timeFrame = `${cs.ca}: ${slotStrs}`;
      for (const day of cs.days) {
        for (const slot of cs.slots) {
          scheduleEntries.push({ dayOfWeek: day, ca: cs.ca, startTime: toHHMM(slot.start), endTime: toHHMM(slot.end) });
        }
        if (cs.slots.length === 0) scheduleEntries.push({ dayOfWeek: day, ca: cs.ca, startTime: '', endTime: '' });
      }
    }
    const scheduleJson  = scheduleEntries.length > 0 ? JSON.stringify(scheduleEntries) : undefined;
    const levelFeesJson = levelFees.length > 0 ? JSON.stringify(levelFees) : undefined;

    const finalTimeFrame = (timeFrame + (form.description ? ` | Ghi chú: ${form.description}` : '')).trim() || undefined;

    setSubmittingClass(true); setError('');
    try {
      await adminApi.createClass({
        parentId: selectedParent?.id,
        title: buildTitle() || `Lớp ${effectiveSubject}`,
        subject: effectiveSubject,
        grade: form.grade,
        mode: form.mode as 'ONLINE' | 'OFFLINE' | 'IN_PERSON',
        address: form.mode === 'IN_PERSON' ? form.address : undefined,
        schedule: scheduleJson,
        sessionsPerWeek: form.sessionsPerWeek,
        sessionDurationMin: form.sessionDurationMin,
        timeFrame: finalTimeFrame,
        parentFee: computedParentFee,
        feePercentage: form.feePercentage,
        genderRequirement: form.genderRequirement !== 'Không yêu cầu' ? form.genderRequirement : undefined,
        levelFees: levelFeesJson,
      });
      showToast('success', 'Tạo lớp học hộ thành công!');
      onSuccess();
    } catch (err: any) {
      setError(err.response?.data?.message || 'Lỗi khi tạo lớp');
    } finally {
      setSubmittingClass(false);
    }
  };

  return (
    <div className="rcm-overlay" onClick={onClose} style={{ zIndex: 1000, background: 'rgba(0,0,0,0.5)' }}>
      <div className="rcm-modal" onClick={e => e.stopPropagation()}>
        
        {/* Header */}
        <div className="rcm-header" style={{ padding: '20px 24px' }}>
          <div className="rcm-header-row">
            <div>
              <div className="rcm-header-icon" style={{ background: 'rgba(16, 185, 129, 0.1)', color: '#10b981' }}>📝</div>
              <h2 className="rcm-title">Mở lớp học hộ Phụ Huynh</h2>
              <p className="rcm-subtitle">PH không bắt buộc — có thể tạo lớp trước rồi gán PH sau. Trạng thái bắt đầu ở PENDING_APPROVAL.</p>
            </div>
            <button className="rcm-close" onClick={onClose} aria-label="Đóng"><X size={18}/></button>
          </div>
        </div>

        {/* Body */}
        <div className="rcm-body" style={{ padding: '20px 24px', overflowY: 'auto' }}>
          {error && <div className="rcm-error" style={{ marginBottom: 16 }}><AlertCircle size={15}/> {error}</div>}

          {/* Section 0: PARENT */}
          <div className="rcm-section">
            <div className="rcm-section-label" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
              <span><span className="rcm-sl-dot"/> 👤 Chọn Phụ huynh / Học sinh (không bắt buộc)</span>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                {!selectedParent && (
                  <select
                    value={searchRole}
                    onChange={e => setSearchRole(e.target.value as 'ALL' | 'PARENT' | 'STUDENT')}
                    style={{ fontSize: '0.8rem', padding: '4px 8px', borderRadius: 6, border: '1px solid #cbd5e1', background: '#fff', color: '#475569', cursor: 'pointer' }}
                  >
                    <option value="ALL">Tất cả role</option>
                    <option value="PARENT">Phụ huynh</option>
                    <option value="STUDENT">Học sinh</option>
                  </select>
                )}
                {selectedParent && (
                  <button onClick={() => setSelectedParent(null)} style={{ fontSize: '0.8rem', background: 'none', border: 'none', color: '#ef4444', cursor: 'pointer', fontWeight: 600 }}>
                    Hủy chọn
                  </button>
                )}
              </div>
            </div>

            {selectedParent ? (
              <div style={{ display: 'flex', alignItems: 'center', gap: 12, background: '#fff', padding: 16, borderRadius: 8, border: '1px solid #cbd5e1' }}>
                <div style={{ width: 40, height: 40, background: 'rgba(99,102,241,0.1)', color: '#6366f1', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 'bold' }}>
                  {selectedParent.fullName.charAt(0).toUpperCase()}
                </div>
                <div>
                  <div style={{ fontWeight: 600, color: '#1e293b' }}>{selectedParent.fullName} <span style={{ fontSize: '0.7rem', padding: '2px 6px', background: selectedParent.role === 'PARENT' ? 'rgba(99,102,241,0.1)' : 'rgba(16,185,129,0.1)', color: selectedParent.role === 'PARENT' ? '#6366f1' : '#10b981', borderRadius: 8, fontWeight: 600 }}>{getRoleName(selectedParent.role)}</span></div>
                  <div style={{ fontSize: '0.85rem', color: '#64748b' }}>{selectedParent.phone ? `SĐT: ${selectedParent.phone}` : (selectedParent.email || 'Chưa có SĐT')} | Khóa: {selectedParent.isActive?'Không':'Có'}</div>
                </div>
              </div>
            ) : (
              <div style={{ background: '#f8fafc', padding: 16, borderRadius: 8, border: '1px solid #e2e8f0' }}>
                <div style={{ display: 'flex', gap: 0, marginBottom: 16, borderBottom: '1px solid #e2e8f0' }}>
                  <button onClick={() => setParentMode('search')} style={{ flex: 1, padding: '10px 0', border: 'none', background: 'none', fontWeight: 600, cursor: 'pointer', fontSize: '0.85rem', color: parentMode === 'search' ? '#6366f1' : '#64748b', borderBottom: parentMode === 'search' ? '2px solid #6366f1' : '2px solid transparent' }}>
                    🔍 Tìm bằng SĐT/Tên
                  </button>
                  <button onClick={() => setParentMode('keyword')} style={{ flex: 1, padding: '10px 0', border: 'none', background: 'none', fontWeight: 600, cursor: 'pointer', fontSize: '0.85rem', color: parentMode === 'keyword' ? '#6366f1' : '#64748b', borderBottom: parentMode === 'keyword' ? '2px solid #6366f1' : '2px solid transparent' }}>
                    📧 Tìm theo tên/email
                  </button>
                  <button onClick={() => setParentMode('create')} style={{ flex: 1, padding: '10px 0', border: 'none', background: 'none', fontWeight: 600, cursor: 'pointer', fontSize: '0.85rem', color: parentMode === 'create' ? '#6366f1' : '#64748b', borderBottom: parentMode === 'create' ? '2px solid #6366f1' : '2px solid transparent' }}>
                    <UserPlus size={14} style={{display:'inline', verticalAlign:'text-bottom', marginRight: 4}}/>Tạo mới PH
                  </button>
                </div>

                {parentMode === 'search' ? (
                  <div>
                    <form onSubmit={handleSearchParent} style={{ display: 'flex', gap: 10 }}>
                      <div style={{ flex: 1, position: 'relative' }}>
                        <Search size={16} color="#94a3b8" style={{ position: 'absolute', top: 12, left: 12 }}/>
                        <input autoFocus placeholder="Nhập SĐT, tên hoặc email..." value={phoneSearch} onChange={e => setPhoneSearch(e.target.value)} style={{ width: '100%', padding: '10px 10px 10px 36px', borderRadius: 8, border: '1px solid #cbd5e1' }}/>
                      </div>
                      <button type="submit" disabled={searchLoading} style={{ padding: '0 20px', background: '#6366f1', color: '#fff', borderRadius: 8, border: 'none', fontWeight: 600, cursor: 'pointer' }}>
                        {searchLoading ? <Loader2 size={18} className="spin" /> : 'Tìm'}
                      </button>
                    </form>
                    {searchResults.length > 0 && (
                      <div style={{ marginTop: 12, display: 'flex', flexDirection: 'column', gap: 8, maxHeight: 180, overflowY: 'auto' }}>
                        {searchResults.map(u => (
                          <div key={u.id} onClick={() => setSelectedParent(u)} style={{ padding: 12, background: '#fff', border: '1px solid #e2e8f0', borderRadius: 8, cursor: 'pointer', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                            <div>
                              <div style={{ fontWeight: 600 }}>{u.fullName} {u.isActive?'':'(Bị khóa)'} <span style={{ fontSize: '0.7rem', padding: '1px 6px', background: u.role === 'PARENT' ? 'rgba(99,102,241,0.1)' : 'rgba(16,185,129,0.1)', color: u.role === 'PARENT' ? '#6366f1' : '#10b981', borderRadius: 8, fontWeight: 600 }}>{getRoleName(u.role)}</span></div>
                              <div style={{ fontSize: '0.8rem', color: '#64748b', marginTop: 2 }}>{u.phone || u.email || 'Chưa có thông tin'}</div>
                            </div>
                            <span style={{ fontSize: '0.75rem', padding: '2px 8px', background: 'rgba(99,102,241,0.1)', color: '#6366f1', borderRadius: 12, fontWeight: 600 }}>Chọn</span>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                ) : parentMode === 'keyword' ? (
                  <div>
                    <form onSubmit={handleSearchByKeyword} style={{ display: 'flex', gap: 10 }}>
                      <div style={{ flex: 1, position: 'relative' }}>
                        <Search size={16} color="#94a3b8" style={{ position: 'absolute', top: 12, left: 12 }}/>
                        <input autoFocus placeholder="Nhập tên hoặc email..." value={keywordSearch} onChange={e => setKeywordSearch(e.target.value)} style={{ width: '100%', padding: '10px 10px 10px 36px', borderRadius: 8, border: '1px solid #cbd5e1' }}/>
                      </div>
                      <button type="submit" disabled={keywordLoading} style={{ padding: '0 20px', background: '#6366f1', color: '#fff', borderRadius: 8, border: 'none', fontWeight: 600, cursor: 'pointer' }}>
                        {keywordLoading ? <Loader2 size={18} className="spin" /> : 'Tìm'}
                      </button>
                    </form>
                    {keywordResults.length > 0 && (
                      <div style={{ marginTop: 12, display: 'flex', flexDirection: 'column', gap: 8, maxHeight: 150, overflowY: 'auto' }}>
                        {keywordResults.map(u => (
                          <div key={u.id} onClick={() => setSelectedParent(u)} style={{ padding: 12, background: '#fff', border: '1px solid #e2e8f0', borderRadius: 8, cursor: 'pointer', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                            <div>
                              <div style={{ fontWeight: 600 }}>{u.fullName} {u.isActive?'':'(Bị khóa)'} <span style={{ fontSize: '0.7rem', padding: '1px 6px', background: u.role === 'PARENT' ? 'rgba(99,102,241,0.1)' : 'rgba(16,185,129,0.1)', color: u.role === 'PARENT' ? '#6366f1' : '#10b981', borderRadius: 8, fontWeight: 600 }}>{getRoleName(u.role)}</span></div>
                              <div style={{ fontSize: '0.8rem', color: '#64748b' }}>{u.email || 'Chưa có email'} {u.phone ? `| ${u.phone}` : ''}</div>
                            </div>
                            <span style={{ fontSize: '0.75rem', padding: '2px 8px', background: 'rgba(99,102,241,0.1)', color: '#6366f1', borderRadius: 12, fontWeight: 600 }}>Chọn</span>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                ) : (
                  <form onSubmit={handleCreateParent} style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                    <div style={{ gridColumn: '1 / -1' }}>
                      <label className="rcm-label">Số điện thoại</label>
                      <input required className="rcm-input" value={newParentForm.phone} onChange={e => setNewParentForm({...newParentForm, phone: e.target.value})}/>
                    </div>
                    <div>
                      <label className="rcm-label">Họ & Tên</label>
                      <input required className="rcm-input" value={newParentForm.fullName} onChange={e => setNewParentForm({...newParentForm, fullName: e.target.value})}/>
                    </div>
                    <div>
                      <label className="rcm-label">Mật khẩu mặc định</label>
                      <input required className="rcm-input" value={newParentForm.password} onChange={e => setNewParentForm({...newParentForm, password: e.target.value})}/>
                    </div>
                    <div style={{ gridColumn: '1 / -1', marginTop: 8 }}>
                      <button type="submit" disabled={creatingParent} style={{ width: '100%', padding: '10px', background: '#3b82f6', color: '#fff', borderRadius: 8, border: 'none', fontWeight: 600, cursor: 'pointer' }}>
                        {creatingParent ? 'Đang tạo...' : 'Tạo nhanh Phụ huynh'}
                      </button>
                    </div>
                  </form>
                )}
              </div>
            )}
          </div>

          <div style={{ opacity: 1 }}>
            {/* Section 1 — Thông tin lớp */}
            <div className="rcm-section">
              <div className="rcm-section-label">
                <span className="rcm-sl-dot"/> 📚 Thông tin lớp học
              </div>
              <div className="rcm-grid">
                <div className="rcm-field">
                  <label className="rcm-label">Môn học <span className="rcm-label-req">*</span></label>
                  <select className="rcm-input rcm-select" value={form.subject} onChange={e => set('subject', e.target.value)}>
                    {filters.subjects.map(s => <option key={s}>{s}</option>)}
                    <option value="Khác">Khác...</option>
                  </select>
                  {form.subject === 'Khác' && (
                    <input className="rcm-input" style={{ marginTop: 6 }}
                      value={form.customSubject} onChange={e => set('customSubject', e.target.value)}
                      placeholder="Nhập tên môn học" autoFocus/>
                  )}
                </div>

                <div className="rcm-field">
                  <label className="rcm-label">Khối/Lớp <span className="rcm-label-req">*</span></label>
                  <select className="rcm-input rcm-select" value={form.grade} onChange={e => set('grade', e.target.value)}>
                    {filters.levels.map(g => <option key={g}>{g}</option>)}
                  </select>
                </div>

                <div className="rcm-field">
                  <label className="rcm-label">Hình thức học <span className="rcm-label-req">*</span></label>
                  <div className="rcm-mode-toggle">
                    <button type="button" className={`rcm-mode-btn${form.mode === 'ONLINE' ? ' active' : ''}`} onClick={() => set('mode', 'ONLINE')}>
                      💻 Online
                    </button>
                    <button type="button" className={`rcm-mode-btn${form.mode === 'IN_PERSON' ? ' active' : ''}`} onClick={() => set('mode', 'IN_PERSON')}>
                      🏡 Tại nhà
                    </button>
                  </div>
                </div>

                {form.mode === 'IN_PERSON' && (
                  <div className="rcm-field rcm-grid-full">
                    <label className="rcm-label">Địa chỉ học <span className="rcm-label-req">*</span></label>
                    <MapAddressInput value={form.address} onChange={a => set('address', a)} />
                  </div>
                )}
              </div>
            </div>

            {/* Section 2 — Lịch học */}
            <div className="rcm-section">
              <div className="rcm-section-label">
                <span className="rcm-sl-dot"/> ⏱️ Lịch học mong muốn
              </div>
              <div className="rcm-grid">
                <div className="rcm-field">
                  <label className="rcm-label">Số buổi / tuần</label>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <input className="rcm-input" type="number" min={1} max={7} value={form.sessionsPerWeek} onChange={e => set('sessionsPerWeek', Number(e.target.value))} style={{ width: 80, textAlign: 'center' }}/>
                    <span style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)' }}>buổi</span>
                  </div>
                </div>
                <div className="rcm-field">
                  <label className="rcm-label">Thời lượng / buổi</label>
                  <select className="rcm-input rcm-select" value={form.sessionDurationMin} onChange={e => set('sessionDurationMin', Number(e.target.value))}>
                    <option value={60}>60 phút (1 tiếng)</option>
                    <option value={90}>90 phút (1.5 tiếng)</option>
                    <option value={120}>120 phút (2 tiếng)</option>
                    <option value={150}>150 phút</option>
                  </select>
                </div>

                <div className="rcm-field rcm-grid-full" style={{ marginTop: 10 }}>
                  <label className="rcm-label" style={{ marginBottom: 12 }}>Chọn khung giờ rảnh (Không bắt buộc)</label>
                  <SessionPicker caSchedules={caSchedules} onChange={setCaSchedules} sessionDurationMin={form.sessionDurationMin} />
                </div>
              </div>
            </div>

            {/* Section 3 — Yêu cầu & Học phí */}
            <div className="rcm-section" style={{ borderBottom: 'none' }}>
              <div className="rcm-section-label">
                <span className="rcm-sl-dot"/> 💡 Yêu cầu gia sư & Học phí Phụ Huynh cần đóng
              </div>

              <div className="rcm-grid">
                <div className="rcm-field rcm-grid-full">
                  <label className="rcm-label">Mức học phí theo từng loại Gia sư <span className="rcm-label-req">*</span></label>
                  {filters.tutorLevels.length > 0 && (
                    <LevelFeesEditor rows={levelFees} onChange={setLevelFees} tutorLevels={filters.tutorLevels} />
                  )}
                  {levelFees.length === 0 && (
                    <p style={{ fontSize: '0.8rem', color: '#ef4444', marginTop: 4 }}>Vui lòng thiết lập ít nhất 1 mức học phí</p>
                  )}
                </div>

                <div className="rcm-field" style={{ background: 'rgba(99, 102, 241, 0.05)', padding: 12, borderRadius: 8, border: '1px solid rgba(99, 102, 241, 0.2)' }}>
                  <label className="rcm-label" style={{ color: '#6366f1' }}>% Thù lao nhận lớp</label>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                    <input className="rcm-input" type="number" min={0} max={100} value={form.feePercentage} onChange={e => set('feePercentage', Number(e.target.value))} style={{ width: 70, textAlign: 'center' }}/>
                    <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>% Phí nhận lớp của GSE</span>
                  </div>
                </div>

                <div className="rcm-field">
                  <label className="rcm-label">Yêu cầu giới tính</label>
                  <div className="rcm-mode-toggle" style={{ height: 42 }}>
                    <button type="button" className={`rcm-mode-btn${form.genderRequirement === 'Không yêu cầu' ? ' active' : ''}`} onClick={() => set('genderRequirement', 'Không yêu cầu')}>
                      Bất kỳ
                    </button>
                    <button type="button" className={`rcm-mode-btn${form.genderRequirement === 'Nam' ? ' active' : ''}`} onClick={() => set('genderRequirement', 'Nam')}>
                      Nam
                    </button>
                    <button type="button" className={`rcm-mode-btn${form.genderRequirement === 'Nữ' ? ' active' : ''}`} onClick={() => set('genderRequirement', 'Nữ')}>
                      Nữ
                    </button>
                  </div>
                </div>

                <div className="rcm-field rcm-grid-full">
                  <label className="rcm-label">Yêu cầu thêm (Mô tả tình trạng học viên, tính cách...)</label>
                  <textarea className="rcm-input" rows={3} value={form.description} onChange={e => set('description', e.target.value)} placeholder="VD: Bé hơi nhút nhát, cần gia sư kiên nhẫn..." />
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="rcm-footer" style={{ padding: '16px 24px', background: '#f8fafc', borderTop: '1px solid #e5e7eb' }}>
          <button type="button" className="rcm-btn-cancel" onClick={onClose}>Huỷ bỏ</button>
          <button 
            type="button" 
            className="rcm-btn-submit" 
            onClick={handleSubmitClass}
            disabled={submittingClass || levelFees.length === 0}
            style={{ opacity: (submittingClass || levelFees.length === 0) ? 0.6 : 1, cursor: (submittingClass || levelFees.length === 0) ? 'not-allowed' : 'pointer', background: '#10b981' }}
          >
            {submittingClass ? <span className="rcm-spinner"/> : 'Xác nhận tạo lớp'}
          </button>
        </div>
        
      </div>
    </div>
  );
}

