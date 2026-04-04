import { useState, useEffect } from 'react';
import { getAdminLeads, toggleLeadContactStatus } from '../../services/leadApi';
import type { Lead } from '../../services/leadApi';
import { Loader2 } from 'lucide-react';
import './AdminLeads.css';

export function AdminLeads() {
  const [leads, setLeads] = useState<Lead[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchLeads();
  }, []);

  const fetchLeads = async () => {
    try {
      setLoading(true);
      const data = await getAdminLeads();
      setLeads(data);
    } catch (err) {
      console.error('Lỗi khi tải danh sách leads', err);
      setError('Không thể lấy dữ liệu khách tiềm năng.');
    } finally {
      setLoading(false);
    }
  };

  const handleToggleContacted = async (id: string, currentStatus: boolean) => {
    // Optimistic update
    setLeads(prev => prev.map(l => l.id === id ? { ...l, isContacted: !l.isContacted } : l));
    try {
      await toggleLeadContactStatus(id);
    } catch (err) {
      console.error('Lỗi cập nhật trạng thái', err);
      // Revert if failed
      setLeads(prev => prev.map(l => l.id === id ? { ...l, isContacted: currentStatus } : l));
      alert('Có lỗi xảy ra khi cập nhật trạng thái.');
    }
  };

  return (
    <div className="admin-leads-page">
      <div className="admin-leads-header">
        <h2>Khách Hàng Tiềm Năng (Leads)</h2>
      </div>

      {error && <div className="admin-error-notice">{error}</div>}

      <div className="admin-leads-card">
        {loading ? (
          <div style={{ display: 'flex', justifyContent: 'center', padding: '3rem' }}>
            <Loader2 className="animate-spin" size={32} color="var(--color-primary)" />
          </div>
        ) : leads.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '3rem', color: 'var(--color-text-muted)' }}>
            Chưa có đăng ký tư vấn nào.
          </div>
        ) : (
          <table className="admin-leads-table">
            <thead>
              <tr>
                <th>Họ và tên</th>
                <th>Số điện thoại</th>
                <th>Thời gian đăng ký</th>
                <th>Đã liên hệ</th>
              </tr>
            </thead>
            <tbody>
              {leads.map(lead => (
                <tr key={lead.id}>
                  <td className="lead-name">{lead.name}</td>
                  <td>
                    <a href={`tel:${lead.phone}`} style={{ color: 'var(--color-primary)', fontWeight: 500, textDecoration: 'none' }}>
                      {lead.phone}
                    </a>
                  </td>
                  <td>{new Date(lead.createdAt).toLocaleString('vi-VN')}</td>
                  <td>
                    <label className="lead-contacted">
                      <input 
                        type="checkbox" 
                        className="contact-checkbox"
                        checked={lead.isContacted}
                        onChange={() => handleToggleContacted(lead.id, lead.isContacted)}
                      />
                      {lead.isContacted ? 'Đã gọi' : 'Chưa gọi'}
                    </label>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
