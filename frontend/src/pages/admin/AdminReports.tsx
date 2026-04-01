import { BarChart3, TrendingUp, Users, BookOpen, DollarSign, Download } from 'lucide-react';
import { useState, useEffect } from 'react';

import { adminApi } from '../../services/adminApi';
import type { DashboardStats } from '../../services/adminApi';
import './AdminReports.css';

function fmtVnd(n: number) {
  if (n >= 1_000_000_000) return (n / 1_000_000_000).toFixed(1) + ' tỷ';
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + ' triệu';
  if (n >= 1_000) return (n / 1_000).toFixed(0) + ' nghìn';
  return n.toLocaleString('vi-VN');
}

export function AdminReports() {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    adminApi.getDashboardStats()
      .then(res => setStats(res.data))
      .catch(e => console.error('Report stats error:', e))
      .finally(() => setLoading(false));
  }, []);

  const chartData = stats?.newUsersPerMonth ?? [];
  const maxBar = Math.max(...chartData.map(d => d.count), 1);

  const summaryCards = stats ? [
    { icon: <Users size={20}/>, label: 'Tổng người dùng', value: stats.totalUsers.toLocaleString(), color: '#6366f1', sub: `${stats.tutorCount} GS · ${stats.parentCount} PH` },
    { icon: <BookOpen size={20}/>, label: 'Lớp đang dạy', value: stats.activeClasses.toLocaleString(), color: '#10b981', sub: `${stats.openClasses} lớp đang mở` },
    { icon: <TrendingUp size={20}/>, label: 'Gia sư đã duyệt', value: stats.activeTutors.toLocaleString(), color: '#8b5cf6', sub: `${stats.pendingVerifications} chờ duyệt` },
    { icon: <DollarSign size={20}/>, label: 'Doanh thu ước tính', value: fmtVnd(stats.estimatedMonthlyRevenue) + ' ₫', color: '#f59e0b', sub: 'Tổng phí nền tảng lớp ACTIVE' },
  ] : [];

  return (
    <div className="admin-reports">
      {/* Header */}
      <div className="ar-header">
        <div>
          <h1 className="ar-title">Báo cáo & Thống kê</h1>
          <p className="ar-subtitle">Tổng quan hoạt động hệ thống theo thời gian thực</p>
        </div>
        <button className="ar-export-btn" onClick={() => alert('Chức năng xuất Excel sẽ sớm được cập nhật!')}>
          <Download size={16}/> Xuất báo cáo
        </button>
      </div>

      {/* Summary cards */}
      {loading ? (
        <div className="ar-loading">Đang tải dữ liệu...</div>
      ) : (
        <>
          <div className="ar-cards">
            {summaryCards.map(c => (
              <div className="ar-card" key={c.label}>
                <div className="ar-card__icon" style={{ background: c.color + '1a', color: c.color }}>{c.icon}</div>
                <div className="ar-card__body">
                  <div className="ar-card__value">{c.value}</div>
                  <div className="ar-card__label">{c.label}</div>
                  <div className="ar-card__sub">{c.sub}</div>
                </div>
              </div>
            ))}
          </div>

          {/* Charts row */}
          <div className="ar-charts">
            {/* Bar chart: User mới theo tháng */}
            <div className="ar-chart-card">
              <div className="ar-chart-card__head">
                <BarChart3 size={18} style={{ color: '#6366f1' }}/>
                <span>Người dùng đăng ký mới (6 tháng gần nhất)</span>
              </div>
              <div className="ar-bar-chart">
                {chartData.map(d => (
                  <div className="ar-bar-col" key={d.label}>
                    <div className="ar-bar-val">{d.count > 0 ? d.count : ''}</div>
                    <div
                      className="ar-bar"
                      style={{ height: `${(d.count / maxBar) * 160}px` }}
                      title={`${d.label}: ${d.count} người`}
                    />
                    <div className="ar-bar-label">{d.label}</div>
                  </div>
                ))}
              </div>
            </div>

            {/* Role distribution */}
            {stats && (
              <div className="ar-chart-card">
                <div className="ar-chart-card__head">
                  <Users size={18} style={{ color: '#10b981' }}/>
                  <span>Phân bổ người dùng theo vai trò</span>
                </div>
                <div className="ar-role-list">
                  {[
                    { label: 'Gia sư', count: stats.tutorCount, color: '#6366f1', total: stats.totalUsers },
                    { label: 'Phụ huynh', count: stats.parentCount, color: '#10b981', total: stats.totalUsers },
                    { label: 'Admin', count: stats.adminCount, color: '#ef4444', total: stats.totalUsers },
                  ].map(r => {
                    const pct = stats.totalUsers > 0 ? Math.round(r.count / stats.totalUsers * 100) : 0;
                    return (
                      <div className="ar-role-row" key={r.label}>
                        <div className="ar-role-row__header">
                          <span style={{ fontWeight: 600, fontSize: '0.88rem' }}>{r.label}</span>
                          <span style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)' }}>{r.count.toLocaleString()} ({pct}%)</span>
                        </div>
                        <div className="ar-role-bar-bg">
                          <div className="ar-role-bar-fill" style={{ width: `${pct}%`, background: r.color }}/>
                        </div>
                      </div>
                    );
                  })}
                </div>

                {/* Class status breakdown */}
                <div className="ar-chart-card__head" style={{ marginTop: 24 }}>
                  <BookOpen size={18} style={{ color: '#8b5cf6' }}/>
                  <span>Trạng thái lớp học</span>
                </div>
                <div className="ar-role-list">
                  {[
                    { label: 'Lớp đang dạy (ACTIVE)', count: stats.activeClasses, color: '#10b981' },
                    { label: 'Lớp đang mở (OPEN)', count: stats.openClasses, color: '#6366f1' },
                  ].map(r => {
                    const total = stats.activeClasses + stats.openClasses || 1;
                    const pct = Math.round(r.count / total * 100);
                    return (
                      <div className="ar-role-row" key={r.label}>
                        <div className="ar-role-row__header">
                          <span style={{ fontWeight: 600, fontSize: '0.88rem' }}>{r.label}</span>
                          <span style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)' }}>{r.count} lớp</span>
                        </div>
                        <div className="ar-role-bar-bg">
                          <div className="ar-role-bar-fill" style={{ width: `${pct}%`, background: r.color }}/>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            )}
          </div>
        </>
      )}
    </div>
  );
}
