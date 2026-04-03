import { Lock, Clock, CheckCircle, AlertTriangle, TrendingUp, BarChart } from 'lucide-react';
import { useEffect, useState } from 'react';
import { tutorApi, type TutorPayoutDTO, type TutorProfileResponse } from '../../services/tutorApi';
import { useNavigate } from 'react-router-dom';

import '../dashboard/Dashboard.css';
import './TutorRevenuePage.css';

export default function TutorRevenuePage() {
  const navigate = useNavigate();
  const [payouts, setPayouts] = useState<TutorPayoutDTO[]>([]);
  const [profile, setProfile] = useState<TutorProfileResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const loadData = async () => {
      try {
        const [payoutData, profileData] = await Promise.all([
          tutorApi.getPayouts(),
          tutorApi.getMyProfile()
        ]);
        setPayouts(payoutData);
        setProfile(profileData);
      } catch (err: any) {
        setError('Không thể tải dữ liệu báo cáo doanh thu.');
      } finally {
        setLoading(false);
      }
    };
    loadData();
  }, []);

  if (loading) {
    return (
      <div className="tr-loading">
        <div className="tr-spinner" />
        <p>Đang tải dữ liệu doanh thu...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="tr-error">
        <p>❌ {error}</p>
        <button onClick={() => window.location.reload()} className="tr-retry-btn">Thử lại</button>
      </div>
    );
  }

  const missingBankInfo = !profile?.bankName || !profile?.bankAccountNumber;

  // Calculate summaries
  const lockedAmount = payouts.filter(p => p.status === 'LOCKED').reduce((sum, p) => sum + p.amount, 0);
  const pendingAmount = payouts.filter(p => p.status === 'PENDING').reduce((sum, p) => sum + p.amount, 0);
  const paidAmount = payouts.filter(p => p.status === 'PAID_OUT').reduce((sum, p) => sum + p.amount, 0);

  // Group by month
  const groupedPayouts = payouts.reduce((acc, p) => {
    const key = `Tháng ${p.month}/${p.year}`;
    if (!acc[key]) acc[key] = [];
    acc[key].push(p);
    return acc;
  }, {} as Record<string, TutorPayoutDTO[]>);

  const getStatusConfig = (status: string) => {
    switch (status) {
      case 'LOCKED': return { label: 'Chờ thanh toán', class: 'tr-status-locked', icon: <Lock size={16} /> };
      case 'PENDING': return { label: 'Khả dụng', class: 'tr-status-pending', icon: <Clock size={16} /> };
      case 'PAID_OUT': return { label: 'Đã nhận', class: 'tr-status-paid', icon: <CheckCircle size={16} /> };
      default: return { label: 'Không rõ', class: 'tr-status-unknown', icon: <AlertTriangle size={16} /> };
    }
  };

  return (
    <div className="tr-container">
          <div className="tr-header">
            <div className="tr-title-group">
              <div className="tr-icon-wrap">
                <BarChart size={24} color="#6366f1" />
              </div>
              <div>
                <h1 className="tr-title">Doanh thu & Báo cáo</h1>
                <p className="tr-subtitle">Quản lý và thống kê thu nhập từ giảng dạy</p>
              </div>
            </div>
          </div>

          {missingBankInfo && (
            <div className="tr-alert-card">
              <div className="tr-alert-icon">
                <AlertTriangle size={24} color="#f59e0b" />
              </div>
              <div className="tr-alert-content">
                <h3>Thiếu thông tin nhận lương</h3>
                <p>Bạn cần cung cấp Số tài khoản Ngân hàng. Kế toán sẽ tự động dải ngân thù lao vào mùng 5 hàng tháng mà bạn không cần phải rút tiền thủ công.</p>
                <button className="tr-alert-btn" onClick={() => navigate('/profile')}>Cập nhật ngay</button>
              </div>
            </div>
          )}

      {/* Analytics Cards */}
      <div className="tr-stats-grid">
        <div className="tr-stat-card tr-card-locked">
          <div className="tr-stat-header">
            <div className="tr-stat-icon-box"><Lock size={20} /></div>
            <span className="tr-stat-label">Chờ phụ huynh đóng</span>
          </div>
          <h3 className="tr-stat-value">{lockedAmount.toLocaleString('vi-VN')} ₫</h3>
          <p className="tr-stat-desc">Tiền thù lao đang bị khóa, chờ thanh toán từ phụ huynh.</p>
        </div>

        <div className="tr-stat-card tr-card-pending">
          <div className="tr-stat-header">
            <div className="tr-stat-icon-box"><Clock size={20} /></div>
            <span className="tr-stat-label">Số dư khả dụng</span>
          </div>
          <h3 className="tr-stat-value">{pendingAmount.toLocaleString('vi-VN')} ₫</h3>
          <p className="tr-stat-desc">Giao dịch thành công. Chờ vòng lặp giải ngân tự động đến tài khoản ngân hàng của bạn.</p>
        </div>

        <div className="tr-stat-card tr-card-paid">
          <div className="tr-stat-header">
            <div className="tr-stat-icon-box"><TrendingUp size={20} /></div>
            <span className="tr-stat-label">Đã nhận lũy kế</span>
          </div>
          <h3 className="tr-stat-value">{paidAmount.toLocaleString('vi-VN')} ₫</h3>
          <p className="tr-stat-desc">Tổng thu nhập đã thực nhận kể từ khi bạn giảng dạy đến nay.</p>
        </div>
      </div>

      {/* History List */}
      <div className="tr-history-section">
        <h2 className="tr-section-title">Lịch sử thu nhập</h2>
        
        {Object.keys(groupedPayouts).length === 0 ? (
          <div className="tr-empty-state">
            <div className="tr-empty-icon">📊</div>
            <p>Bạn chưa có dữ liệu doanh thu nào.</p>
          </div>
        ) : (
          Object.keys(groupedPayouts).map(monthKey => (
            <div key={monthKey} className="tr-month-group">
              <h3 className="tr-month-title">{monthKey}</h3>
              <div className="tr-payout-list">
                {groupedPayouts[monthKey].map(payout => {
                  const statusConf = getStatusConfig(payout.status);
                  const showConfirmBtn = payout.status === 'PAID_OUT' && !payout.confirmedByTutorAt;
                  return (
                    <div key={payout.id} className="tr-payout-item">
                      <div className="tr-payout-main">
                        <div className={`tr-payout-icon-box ${statusConf.class}`}>
                          {statusConf.icon}
                        </div>
                        <div className="tr-payout-details">
                          <h4 className="tr-payout-title">Kỳ thanh toán {monthKey.toLowerCase()}</h4>
                          <span className="tr-payout-trans">
                            Mã GD: {payout.transactionCode || 'Chưa đối soát'}
                          </span>
                          {payout.adminNote && (
                            <span className="tr-payout-note">💬 {payout.adminNote}</span>
                          )}
                        </div>
                      </div>
                      <div className="tr-payout-amounts">
                        <span className="tr-payout-money">+{payout.amount.toLocaleString('vi-VN')} ₫</span>
                        {showConfirmBtn ? (
                          <button className="tr-confirm-btn" onClick={async () => {
                            try {
                              await tutorApi.confirmPayoutReceived(payout.id);
                              setPayouts(prev => prev.map(p => p.id === payout.id ? { ...p, confirmedByTutorAt: new Date().toISOString() } : p));
                            } catch { alert('Xác nhận thất bại'); }
                          }}>
                            <CheckCircle size={14}/> Xác nhận đã nhận
                          </button>
                        ) : payout.confirmedByTutorAt ? (
                          <span className="tr-payout-status tr-status-confirmed">✓ Đã xác nhận</span>
                        ) : (
                          <span className={`tr-payout-status ${statusConf.class}`}>
                            {statusConf.label}
                          </span>
                        )}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}
