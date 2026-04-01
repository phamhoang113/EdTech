import { Users, X } from 'lucide-react';
import { useState, useEffect } from 'react';
import { useEscapeKey } from '../../hooks/useEscapeKey';

import { parentApi } from '../../services/parentApi';
import type { ParentClass } from '../../services/parentApi';

export function ManageStudentsModal({ cls, onClose, onSuccess }: { cls: ParentClass; onClose: () => void; onSuccess: () => void; }) {
  const [children, setChildren] = useState<{ id: string; userId: string; fullName: string; }[]>([]);
  const [selectedIds, setSelectedIds] = useState<string[]>(cls.studentIds ?? []);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    parentApi.getMyChildren().then(res => setChildren(res.data ?? [])).catch(() => {}).finally(() => setLoading(false));
  }, []);
  useEscapeKey(onClose);

  const handleSave = async () => {
    if (selectedIds.length === 0) { alert('Vui lòng chọn ít nhất 1 học sinh'); return; }
    setSaving(true);
    try {
      await parentApi.updateClassStudents(cls.id, selectedIds);
      onSuccess();
    } catch { alert('Lỗi khi cập nhật học sinh'); }
    setSaving(false);
  };

  return (
    <div className="ap-overlay" onClick={onClose}>
      <div className="ap-modal" style={{ maxWidth: 420 }} onClick={e => e.stopPropagation()}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
          <h3 style={{ display: 'flex', alignItems: 'center', gap: 6 }}><Users size={18} color="#8b5cf6"/> Gán học sinh</h3>
          <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', color: 'var(--color-text-muted)' }}><X size={20}/></button>
        </div>
        <p style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)', marginBottom: 16 }}>Lớp: <b>{cls.title}</b></p>
        
        {loading ? <p>Đang tải...</p> : children.length === 0 ? <p>Bạn chưa thêm hồ sơ HS nào.</p> : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {children.map(c => (
              <label key={c.userId} style={{
                display: 'flex', alignItems: 'center', gap: 10, padding: '10px 14px', borderRadius: 12, cursor: 'pointer',
                border: '1px solid', background: selectedIds.includes(c.userId) ? '#eef2ff' : '#fff',
                borderColor: selectedIds.includes(c.userId) ? '#6366f1' : '#e5e7eb'
              }}>
                <input type="checkbox" checked={selectedIds.includes(c.userId)} onChange={e => {
                  setSelectedIds(e.target.checked ? [...selectedIds, c.userId] : selectedIds.filter(id => id !== c.userId));
                }} style={{ width: 16, height: 16, cursor: 'pointer' }} />
                <span style={{ fontSize: '0.9rem', fontWeight: 600, color: '#374151' }}>{c.fullName}</span>
              </label>
            ))}
          </div>
        )}
        <div className="ap-actions" style={{ marginTop: 24 }}>
          <button onClick={onClose} className="ap-cancel">Hủy</button>
          <button onClick={handleSave} className="ap-confirm" disabled={saving || loading}>{saving ? 'Đang lưu...' : 'Lưu học sinh'}</button>
        </div>
      </div>
    </div>
  );
}
