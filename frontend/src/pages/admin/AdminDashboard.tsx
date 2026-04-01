import { Users, GraduationCap, BookOpen, DollarSign, Clock, AlertTriangle } from 'lucide-react';
import { useState, useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';

import { adminApi } from '../../services/adminApi';
import type { AdminTutorVerificationResponse, DashboardStats } from '../../services/adminApi';
import './AdminDashboard.css';

/* ── Helpers ── */
const stringToColor = (str: string) => {
  if (!str) return '#ccc';
  let hash = 0;
  for (let i = 0; i < str.length; i++) hash = str.charCodeAt(i) + ((hash << 5) - hash);
  const c = (hash & 0x00ffffff).toString(16).toUpperCase();
  return '#' + '00000'.substring(0, 6 - c.length) + c;
};

function fmtVnd(n: number) {
  if (n >= 1_000_000_000) return (n / 1_000_000_000).toFixed(1).replace('.0', '') + 'B';
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1).replace('.0', '') + 'M';
  if (n >= 1_000) return (n / 1_000).toFixed(0) + 'K';
  return n.toLocaleString('vi-VN');
}

export function AdminDashboard() {
  const navigate = useNavigate();

  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [statsLoading, setStatsLoading] = useState(true);

  const [pendingVerifications, setPendingVerifications] = useState<AdminTutorVerificationResponse[]>([]);
  const [verificationsLoading, setVerificationsLoading] = useState(true);

  /* ── Fetch dashboard stats ── */
  useEffect(() => {
    adminApi.getDashboardStats()
      .then(res => setStats(res.data))
      .catch(e => console.error('Dashboard stats error:', e))
      .finally(() => setStatsLoading(false));
  }, []);

  /* ── Fetch pending verifications (top 5) ── */
  const fetchVerifications = async () => {
    try {
      setVerificationsLoading(true);
      const res = await adminApi.getTutorVerifications();
      setPendingVerifications(res.data.filter(v => v.status === 'PENDING').slice(0, 5));
    } catch (e) {
      console.error('Verifications error:', e);
    } finally {
      setVerificationsLoading(false);
    }
  };

  useEffect(() => { fetchVerifications(); }, []);

  const handleApprove = (id: string) => navigate(`/admin/verification?highlight=${id}`);
  const handleReject = async (id: string, name: string) => {
    if (!window.confirm(`Từ chối gia sư ${name}?`)) return;
    try {
      await adminApi.rejectTutor(id);
      window.dispatchEvent(new Event('refetchBadgeCounts'));
      fetchVerifications();
    } catch { alert('Từ chối thất bại!'); }
  };

  /* ── Stat cards (từ BE) ── */
  const statCards = useMemo(() => {
    if (!stats) return [];
    return [
      { icon: <Users size={22}/>, value: stats.totalUsers.toLocaleString(), label: 'Tổng người dùng', color: 'blue' },
      { icon: <GraduationCap size={22}/>, value: stats.activeTutors.toLocaleString(), label: 'Gia sư đã duyệt', color: 'green' },
      { icon: <BookOpen size={22}/>, value: (stats.openClasses + stats.activeClasses).toLocaleString(), label: 'Lớp đang hoạt động', color: 'violet' },
      { icon: <DollarSign size={22}/>, value: fmtVnd(stats.estimatedMonthlyRevenue), label: 'Doanh thu ước tính (VNĐ)', color: 'amber' },
    ];
  }, [stats]);

  /* ── Bar chart (user mới theo tháng) ── */
  const chartData = stats?.newUsersPerMonth ?? [];
  const maxChart = Math.max(...chartData.map(d => d.count), 1);

  /* ── Donut chart (phân bổ role) ── */
  const donutSegments = useMemo(() => {
    if (!stats) return [];
    const total = stats.tutorCount + stats.parentCount + stats.studentCount + stats.adminCount || 1;
    return [
      { label: 'Gia sư', count: stats.tutorCount, pct: Math.round(stats.tutorCount / total * 100), color: '#6366f1' },
      { label: 'Phụ huynh', count: stats.parentCount, pct: Math.round(stats.parentCount / total * 100), color: '#10b981' },
      { label: 'Học sinh', count: stats.studentCount, pct: Math.round(stats.studentCount / total * 100), color: '#06b6d4' },
      { label: 'Admin', count: stats.adminCount, pct: Math.round(stats.adminCount / total * 100), color: '#ef4444' },
    ];
  }, [stats]);

  const conicGradient = useMemo(() => {
    let acc = 0;
    const stops = donutSegments.map(s => {
      const start = acc; acc += s.pct;
      return `${s.color} ${start}% ${acc}%`;
    });
    return stops.length ? `conic-gradient(${stops.join(', ')})` : 'conic-gradient(#e5e7eb 0% 100%)';
  }, [donutSegments]);

  return (
    <div className="admin-dashboard">
      {/* Header */}
      <div className="admin-dashboard__header">
        <h1 className="admin-dashboard__title">Tổng quan</h1>
        <p className="admin-dashboard__subtitle">Xin chào, Admin! Đây là tổng quan hoạt động hôm nay.</p>
      </div>

      {/* Stat Cards */}
      <div className="admin-dashboard__stats">
        {statsLoading
          ? Array.from({ length: 4 }).map((_, i) => (
              <div key={i} className="admin-stat-card" style={{ opacity: 0.5 }}>
                <div className="admin-stat-card__icon admin-stat-card__icon--blue"><Clock size={22}/></div>
                <div className="admin-stat-card__info">
                  <div className="admin-stat-card__value">—</div>
                  <div className="admin-stat-card__label">Đang tải...</div>
                </div>
              </div>
            ))
          : statCards.map(s => (
              <div className="admin-stat-card" key={s.label}>
                <div className={`admin-stat-card__icon admin-stat-card__icon--${s.color}`}>{s.icon}</div>
                <div className="admin-stat-card__info">
                  <div className="admin-stat-card__value">{s.value}</div>
                  <div className="admin-stat-card__label">{s.label}</div>
                </div>
              </div>
            ))
        }
      </div>

      {/* Alert: hồ sơ chờ duyệt */}
      {!statsLoading && stats && stats.pendingVerifications > 0 && (
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          padding: '10px 16px', borderRadius: 10, marginBottom: 16,
          background: 'rgba(245,158,11,0.1)', border: '1px solid rgba(245,158,11,0.35)',
          color: '#d97706', fontSize: '0.88rem', fontWeight: 600,
        }}>
          <AlertTriangle size={16}/>
          Có <strong style={{ margin: '0 4px' }}>{stats.pendingVerifications}</strong> hồ sơ gia sư chờ duyệt.
          <button
            onClick={() => navigate('/admin/verification')}
            style={{ marginLeft: 'auto', background: 'none', border: 'none', color: '#d97706', cursor: 'pointer', fontWeight: 700, textDecoration: 'underline' }}
          >Xem ngay →</button>
        </div>
      )}

      {/* Charts Row */}
      <div className="admin-dashboard__charts">
        {/* Bar Chart: User mới */}
        <div className="admin-chart-card">
          <div className="admin-chart-card__header">
            <div className="admin-chart-card__title">Người dùng mới (6 tháng)</div>
          </div>
          {statsLoading ? (
            <div style={{ padding: 20, textAlign: 'center', color: 'var(--color-text-muted)' }}>Đang tải...</div>
          ) : (
            <div className="admin-bar-chart">
              {chartData.map(d => (
                <div className="admin-bar-chart__col" key={d.label}>
                  <div
                    className="admin-bar-chart__bar"
                    style={{ height: `${(d.count / maxChart) * 160}px` }}
                    title={`${d.label}: ${d.count} người`}
                  />
                  <span className="admin-bar-chart__label">{d.label}</span>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Donut Chart: Phân bổ role */}
        <div className="admin-chart-card">
          <div className="admin-chart-card__header">
            <div className="admin-chart-card__title">Phân bổ vai trò</div>
          </div>
          {statsLoading ? (
            <div style={{ padding: 20, textAlign: 'center', color: 'var(--color-text-muted)' }}>Đang tải...</div>
          ) : (
            <div className="admin-donut">
              <div className="admin-donut__chart" style={{ background: conicGradient }}>
                <div className="admin-donut__center">
                  <span className="admin-donut__center-value">{stats?.totalUsers.toLocaleString()}</span>
                  <span className="admin-donut__center-label">Tổng</span>
                </div>
              </div>
              <div className="admin-donut__legend">
                {donutSegments.map(s => (
                  <div className="admin-donut__legend-item" key={s.label}>
                    <span className="admin-donut__legend-dot" style={{ background: s.color }} />
                    {s.label} ({s.pct}% — {s.count.toLocaleString()})
                  </div>
                ))}
              </div>
            </div>
          )}
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

        {verificationsLoading ? (
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
              {pendingVerifications.map(v => (
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
                      <button className="admin-table__action-btn admin-table__action-btn--approve" onClick={() => handleApprove(v.id)}>
                        Duyệt
                      </button>
                      <button className="admin-table__action-btn admin-table__action-btn--reject" onClick={() => handleReject(v.id, v.name)}>
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
