import { useState, useEffect } from 'react';
import { studentApi } from '../../services/studentApi';
import { Users, UserPlus, Phone, CheckCircle } from 'lucide-react';

export function StudentParentsPage() {
  const [links, setLinks] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [newParentPhone, setNewParentPhone] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [toast, setToast] = useState<{type: 'success'|'error', msg: string} | null>(null);

  const fetchLinks = async () => {
    try {
      setLoading(true);
      const res = await studentApi.getParentLinks();
      setLinks(res.data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchLinks();
  }, []);

  const showToast = (type: 'success'|'error', msg: string) => {
    setToast({type, msg});
    setTimeout(() => setToast(null), 3000);
  };

  const handleAddParent = async () => {
    if (!newParentPhone) {
      showToast('error', 'Vui lòng nhập số điện thoại phụ huynh');
      return;
    }
    try {
      setSubmitting(true);
      await studentApi.requestParentLink(newParentPhone);
      setNewParentPhone('');
      showToast('success', 'Đã gửi yêu cầu liên kết đến phụ huynh. Chờ phụ huynh xác nhận.');
      fetchLinks();
    } catch (e: any) {
      showToast('error', e?.response?.data?.message || 'Không thể liên kết phụ huynh. Vui lòng kiểm tra lại số điện thoại.');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <>
      <div className="dash-section-head" style={{ marginBottom: 20 }}>
        <div>
          <h2 className="dash-section-title" style={{ fontSize: '1.4rem', display: 'flex', alignItems: 'center', gap: 8 }}>
            <Users size={24} className="text-primary" /> Phụ huynh của tôi
          </h2>
          <p style={{ color: 'var(--color-text-muted)', fontSize: '0.9rem', marginTop: 4 }}>
            Quản lý phụ huynh liên kết để cùng theo dõi lộ trình học tập và thanh toán.
          </p>
        </div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 24 }}>
        {/* Cột 1: Danh sách phụ huynh */}
        <div style={{ background: 'var(--color-surface)', padding: 24, borderRadius: 16, border: '1px solid var(--color-border)' }}>
          <h3 style={{ fontSize: '1.1rem', marginBottom: 16 }}>Phụ huynh đã liên kết</h3>
          
          {loading ? (
            <div style={{ padding: 20, textAlign: 'center', color: 'var(--color-text-muted)' }}>Đang tải...</div>
          ) : links.filter(l => l.linkStatus === 'ACCEPTED').length > 0 ? (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
              {links.filter(l => l.linkStatus === 'ACCEPTED').map((p) => (
                <div key={p.id} style={{ display: 'flex', padding: '16px', border: '1px solid rgba(139, 92, 246, 0.2)', backgroundColor: 'var(--color-surface)', borderRadius: '12px', alignItems: 'center', justifyContent: 'space-between' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
                    <div style={{ width: 48, height: 48, fontSize: '1.2rem', display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'linear-gradient(135deg, #6366f1 0%, #a855f7 100%)', color: 'white', borderRadius: '50%' }}>
                      {p.parentName.charAt(0).toUpperCase()}
                    </div>
                    <div>
                      <p style={{ fontSize: '1rem', fontWeight: 600, margin: 0 }}>{p.parentName}</p>
                      <p style={{ fontSize: '0.85rem', marginTop: 4, color: 'var(--color-text-muted)', margin: 0, display: 'flex', alignItems: 'center', gap: 4 }}>
                        <Phone size={12} /> {p.parentPhone}
                      </p>
                    </div>
                  </div>
                  <span style={{ display: 'flex', alignItems: 'center', gap: 4, background: '#dcfce7', color: '#15803d', padding: '6px 10px', borderRadius: '20px', fontSize: '0.75rem', fontWeight: 600 }}>
                    <CheckCircle size={14} /> Đã liên kết
                  </span>
                </div>
              ))}
            </div>
          ) : (
            <div style={{ padding: 30, textAlign: 'center', background: 'var(--color-surface-2)', borderRadius: 12, border: '1px dashed var(--color-border)' }}>
              <Users size={32} style={{ opacity: 0.3, marginBottom: 12 }} />
              <p style={{ color: 'var(--color-text-muted)' }}>Chưa có phụ huynh nào liên kết với bạn.</p>
            </div>
          )}

          {/* Pending Links */}
          {links.filter(l => l.linkStatus === 'PENDING').length > 0 && (
            <div style={{ marginTop: 24 }}>
              <h4 style={{ fontSize: '0.9rem', color: 'var(--color-text-muted)', marginBottom: 12, textTransform: 'uppercase', letterSpacing: '0.05em' }}>Đang chờ xác nhận</h4>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                {links.filter(l => l.linkStatus === 'PENDING').map((p) => (
                  <div key={p.id} style={{ display: 'flex', padding: '12px 16px', border: '1px solid var(--color-border)', backgroundColor: 'var(--color-surface-2)', borderRadius: '12px', alignItems: 'center', justifyContent: 'space-between' }}>
                    <div>
                      <p style={{ fontSize: '0.95rem', fontWeight: 600, margin: 0 }}>Số điện thoại: {p.parentPhone}</p>
                      <p style={{ fontSize: '0.8rem', color: '#d97706', margin: 0, marginTop: 4 }}>⏳ Chờ phụ huynh xác nhận...</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Cột 2: Thêm phụ huynh */}
        <div style={{ background: 'var(--color-surface)', padding: 24, borderRadius: 16, border: '1px solid var(--color-border)', height: 'fit-content' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 16 }}>
            <div style={{ width: 40, height: 40, borderRadius: '50%', background: '#eef2ff', color: '#4f46e5', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <UserPlus size={20} />
            </div>
            <h3 style={{ fontSize: '1.1rem', margin: 0 }}>Thêm phụ huynh</h3>
          </div>
          
          <p style={{ color: 'var(--color-text-muted)', fontSize: '0.9rem', marginBottom: 20 }}>
            Nhập số điện thoại của phụ huynh. Phụ huynh cần có/tạo tài khoản Gia Sư Tinh Hoa để chấp nhận yêu cầu của bạn.
          </p>

          <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            <div>
              <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 600, marginBottom: 6, color: 'var(--color-text-secondary)' }}>Số điện thoại phụ huynh</label>
              <input
                type="tel"
                placeholder="VD: 0345851204"
                value={newParentPhone}
                onChange={e => setNewParentPhone(e.target.value)}
                style={{ width: '100%', padding: '12px 16px', border: '1.5px solid var(--color-border)', borderRadius: 10, fontSize: '0.95rem', outline: 'none' }}
              />
            </div>
            
            <button 
              onClick={handleAddParent} 
              disabled={submitting || !newParentPhone}
              style={{ padding: '12px', background: 'var(--color-primary)', color: 'white', border: 'none', borderRadius: 10, fontWeight: 700, cursor: (submitting || !newParentPhone) ? 'not-allowed' : 'pointer', opacity: (submitting || !newParentPhone) ? 0.6 : 1, transition: 'all 0.2s' }}
            >
              {submitting ? 'Đang xử lý...' : 'Gửi yêu cầu liên kết'}
            </button>
          </div>
        </div>
      </div>

      {/* Toast */}
      {toast && (
        <div style={{ position: 'fixed', bottom: 24, right: 24, zIndex: 9999, padding: '12px 20px', borderRadius: 12, fontWeight: 600, fontSize: '0.9rem', background: toast.type === 'success' ? '#ecfdf5' : '#fef2f2', color: toast.type === 'success' ? '#065f46' : '#b91c1c', border: `1px solid ${toast.type === 'success' ? '#10b981' : '#ef4444'}`, boxShadow: '0 10px 25px rgba(0,0,0,0.1)' }}>
          {toast.msg}
        </div>
      )}
    </>
  );
}
