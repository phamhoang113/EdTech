import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Users, GraduationCap, BookOpen, DollarSign, TrendingUp, TrendingDown } from 'lucide-react';
import { adminApi } from '../../services/adminApi';
import type { AdminTutorVerificationResponse } from '../../services/adminApi';
import './AdminDashboard.css';

/* ── Mock data ── */
const STATS = [
  { icon: <Users size={22} />, value: '5,234', label: 'Tổng người dùng', trend: '+12%', trendDir: 'up' as const, color: 'blue' },
  { icon: <GraduationCap size={22} />, value: '1,247', label: 'Gia sư hoạt động', trend: '+8%', trendDir: 'up' as const, color: 'green' },
  { icon: <BookOpen size={22} />, value: '892', label: 'Lớp đang diễn ra', trend: '+5%', trendDir: 'up' as const, color: 'violet' },
  { icon: <DollarSign size={22} />, value: '125.4M', label: 'Doanh thu tháng (VNĐ)', trend: '-2%', trendDir: 'down' as const, color: 'amber' },
];

const CHART_DATA = [
  { label: 'T10', value: 65 },
  { label: 'T11', value: 80 },
  { label: 'T12', value: 72 },
  { label: 'T1', value: 90 },
  { label: 'T2', value: 85 },
  { label: 'T3', value: 95 },
];

const DONUT_SEGMENTS = [
  { label: 'Gia sư', pct: 24, color: '#6366f1' },
  { label: 'Phụ huynh', pct: 35, color: '#10b981' },
  { label: 'Học sinh', pct: 38, color: '#f59e0b' },
  { label: 'Admin', pct: 3, color: '#ef4444' },
];

function buildConicGradient() {
  let acc = 0;
  const stops = DONUT_SEGMENTS.map((s) => {
    const start = acc;
    acc += s.pct;
    return `${s.color} ${start}% ${acc}%`;
  });
  return `conic-gradient(${stops.join(', ')})`;
}

// Hàm lấy màu avatar 
const stringToColor = (str: string) => {
  if (!str) return '#ccc';
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  const c = (hash & 0x00ffffff).toString(16).toUpperCase();
  return '#' + '00000'.substring(0, 6 - c.length) + c;
};

export function AdminDashboard() {
  const navigate = useNavigate();
  const maxChart = Math.max(...CHART_DATA.map((d) => d.value));

  const [pendingVerifications, setPendingVerifications] = useState<AdminTutorVerificationResponse[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchVerifications = async () => {
    try {
      setLoading(true);
      const res = await adminApi.getTutorVerifications();
      // Only keep PENDING and slice top 5
      const pending = res.data.filter((v) => v.status === 'PENDING').slice(0, 5);
      setPendingVerifications(pending);
    } catch (error) {
      console.error('Lỗi khi tải danh sách gia sư chờ duyệt:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchVerifications();
  }, []);

  const handleApprove = async (id: string, name: string) => {
    if (!window.confirm(`Bạn có chắc chắn muốn phê duyệt gia sư ${name}?`)) return;
    try {
      await adminApi.approveTutor(id);
      alert('Đã phê duyệt thành công!');
      fetchVerifications();
    } catch (error) {
      console.error('Lỗi duyệt:', error);
      alert('Phê duyệt thất bại!');
    }
  };

  const handleReject = async (id: string, name: string) => {
    if (!window.confirm(`Bạn có chắc chắn muốn từ chối gia sư ${name}?`)) return;
    try {
      await adminApi.rejectTutor(id);
      alert('Đã từ chối hồ sơ!');
      fetchVerifications();
    } catch (error) {
      console.error('Lỗi từ chối:', error);
      alert('Từ chối thất bại!');
    }
  };

  return (
    <div className="admin-dashboard">
      {/* Header */}
      <div className="admin-dashboard__header">
        <h1 className="admin-dashboard__title">Tổng quan</h1>
        <p className="admin-dashboard__subtitle">Xin chào, Admin! Đây là tổng quan hoạt động hôm nay.</p>
      </div>

      {/* Stat Cards */}
      <div className="admin-dashboard__stats">
        {STATS.map((stat) => (
          <div className="admin-stat-card" key={stat.label}>
            <div className={`admin-stat-card__icon admin-stat-card__icon--${stat.color}`}>
              {stat.icon}
            </div>
            <div className="admin-stat-card__info">
              <div className="admin-stat-card__value">{stat.value}</div>
              <div className="admin-stat-card__label">{stat.label}</div>
              <div className={`admin-stat-card__trend admin-stat-card__trend--${stat.trendDir}`}>
                {stat.trendDir === 'up' ? <TrendingUp size={12} /> : <TrendingDown size={12} />}
                {' '}{stat.trend} so với tháng trước
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Charts Row */}
      <div className="admin-dashboard__charts">
        {/* Bar Chart */}
        <div className="admin-chart-card">
          <div className="admin-chart-card__header">
            <div className="admin-chart-card__title">Người dùng mới</div>
          </div>
          <div className="admin-bar-chart">
            {CHART_DATA.map((d) => (
              <div className="admin-bar-chart__col" key={d.label}>
                <div
                  className="admin-bar-chart__bar"
                  style={{ height: `${(d.value / maxChart) * 160}px` }}
                />
                <span className="admin-bar-chart__label">{d.label}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Donut Chart */}
        <div className="admin-chart-card">
          <div className="admin-chart-card__header">
            <div className="admin-chart-card__title">Phân bổ vai trò</div>
          </div>
          <div className="admin-donut">
            <div
              className="admin-donut__chart"
              style={{ background: buildConicGradient() }}
            >
              <div className="admin-donut__center">
                <span className="admin-donut__center-value">5,234</span>
                <span className="admin-donut__center-label">Tổng</span>
              </div>
            </div>
            <div className="admin-donut__legend">
              {DONUT_SEGMENTS.map((s) => (
                <div className="admin-donut__legend-item" key={s.label}>
                  <span className="admin-donut__legend-dot" style={{ background: s.color }} />
                  {s.label} ({s.pct}%)
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Pending Verifications Table */}
      <div className="admin-table-card">
        <div className="admin-table-card__header">
          <h2 className="admin-table-card__title">Xác minh gia sư chờ duyệt</h2>
          <button className="admin-table-card__action" onClick={() => navigate('/admin/verification')}>
            Xem tất cả →
          </button>
        </div>
        
        {loading ? (
          <div style={{ padding: '20px', textAlign: 'center' }}>Đang tải dữ liệu...</div>
        ) : pendingVerifications.length === 0 ? (
          <div style={{ padding: '20px', textAlign: 'center', color: 'var(--color-text-muted)' }}>
            Không có hồ sơ nào đang chờ duyệt.
          </div>
        ) : (
          <table className="admin-table">
            <thead>
              <tr>
                <th>Gia sư</th>
                <th>Môn dạy / Kinh nghiệm</th>
                <th>Căn cước / Bằng cấp</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
              </tr>
            </thead>
            <tbody>
              {pendingVerifications.map((v) => (
                <tr key={v.id}>
                  <td>
                    <div className="admin-table__user">
                      <div className="admin-table__avatar" style={{ background: stringToColor(v.name) }}>
                        {v.name ? v.name.charAt(v.name.lastIndexOf(' ') + 1) : '?'}
                      </div>
                      {v.name}
                    </div>
                  </td>
                  <td>
                    <div style={{ fontSize: '13px' }}>
                      <strong>{v.subjects?.length ? `${v.subjects.length} môn` : 'Chưa cập nhật'}</strong>
                    </div>
                    <div style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>
                      {v.experience ? `${v.experience} năm KN` : ''} 
                    </div>
                  </td>
                  <td>
                    <div style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>
                      ID: {v.docs?.find(d => d.name === 'CCCD') ? 'Đã tải lên' : 'Chưa có'}
                    </div>
                    <div style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>
                      CV: {v.docs?.find(d => d.name === 'Sơ yếu lý lịch') ? 'Đã tải lên' : 'Chưa có'}
                    </div>
                  </td>
                  <td><span className="admin-badge admin-badge--pending">Chờ duyệt</span></td>
                  <td>
                    <div className="admin-table__actions">
                      <button 
                        className="admin-table__action-btn admin-table__action-btn--approve"
                        onClick={() => handleApprove(v.id, v.name)}
                      >
                        Duyệt
                      </button>
                      <button 
                        className="admin-table__action-btn admin-table__action-btn--reject"
                        onClick={() => handleReject(v.id, v.name)}
                      >
                        Từ chối
                      </button>
                    </div>
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
