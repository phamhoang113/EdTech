import { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import {
  BookOpen, Star, TrendingUp, Users,
  ChevronRight, Clock, MessageSquare, Calendar,
  Award, AlertCircle, LogOut
} from 'lucide-react';
import { TutorVerificationModal } from './TutorVerificationModal';
import { DashboardHeader } from '../../components/layout/DashboardHeader';
import apiClient from '../../services/apiClient';
import './Dashboard.css';

const upcomingLessons = [
  { subject: 'Toán lớp 10',     who: 'Lê Bảo Nguyên',   time: 'Hôm nay, 19:00', avatar: '👦' },
  { subject: 'Tiếng Anh IELTS', who: 'Trần Hồng Nhung',  time: 'Thứ 5, 15:00',   avatar: '👧' },
  { subject: 'Lập trình Python', who: 'Lớp mở (12 HS)',  time: 'Thứ 7, 14:00',   avatar: '💻' },
];

const activities = [
  { text: 'Bảo Nguyên hoàn thành bài tập Toán — đúng hạn',   time: '30 phút trước', type: 'act-lesson'  },
  { text: 'Nhận học phí buổi học Tiếng Anh — 200.000đ',      time: '1 ngày trước',  type: 'act-payment' },
  { text: 'Hồng Nhung đánh giá ★★★★★ — "Thầy giải thích rất dễ hiểu"', time: '2 ngày trước', type: 'act-review'  },
  { text: 'Lớp học Python tháng 4 đã có 8/12 học sinh đăng ký', time: '3 ngày trước', type: 'act-booking' },
];

export const TutorDashboard = () => {
  const { user, logout } = useAuthStore();
  const navigate = useNavigate();
  // Verification states
  const [verificationStatus, setVerificationStatus] = useState<string | null>(null);
  const [isLoadingProfile, setIsLoadingProfile] = useState(true);

  useEffect(() => {
    fetchProfileStatus();
  }, []);

  const fetchProfileStatus = async () => {
    try {
      const res = await apiClient.get('/api/v1/tutors/profile/me');
      setVerificationStatus(res.data?.data?.verificationStatus ?? 'UNVERIFIED');
    } catch (err: any) {
      // 404 = chưa có profile → UNVERIFIED
      if (err.response?.status === 404) {
        setVerificationStatus('UNVERIFIED');
      } else {
        // Lỗi khác (mạng, server) → ẩn modal, không bắt user submit
        setVerificationStatus(null);
      }
    } finally {
      setIsLoadingProfile(false);
    }
  };



  const name    = user?.fullName ?? 'Gia sư';
  const h       = new Date().getHours();
  const greeting = h < 12 ? 'Chào buổi sáng' : h < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';

  return (
    <div className="dash-page">
      {/* SIDEBAR */}
      <aside className="dash-sidebar">
        <Link to="/" className="dash-sidebar-logo">
          <span className="dash-sidebar-logo-icon">🎓</span>
          <span className="dash-sidebar-logo-name">EdTech</span>
        </Link>

        <div className="dash-sidebar-section">
          <span className="dash-sidebar-section-label">Dạy học</span>
          <button className="dash-sidebar-item active"><TrendingUp size={18}/> Tổng quan</button>
          <button className="dash-sidebar-item"><Users size={18}/> Học sinh của tôi</button>
          <button className="dash-sidebar-item"><BookOpen size={18}/> Lớp học</button>
          <button className="dash-sidebar-item"><Calendar size={18}/> Lịch dạy</button>
          <button className="dash-sidebar-item"><MessageSquare size={18}/> Tin nhắn <span className="item-badge">4</span></button>

          <span className="dash-sidebar-section-label">Hồ sơ & Tài chính</span>
          <button className="dash-sidebar-item"><Star size={18}/> Hồ sơ gia sư</button>
          <button className="dash-sidebar-item"><Award size={18}/> Doanh thu & Báo cáo</button>
        </div>

        <button className="dash-logout" onClick={() => { logout(); navigate('/'); }}>
          <LogOut size={16}/> Đăng xuất
        </button>
      </aside>

      {/* MAIN */}
      <main className="dash-main">
        <DashboardHeader />

        <div className="dash-body">
          {/* Greeting */}
          <div className="dash-greeting">
            <div className="greeting-left">
              <p className="greeting-hi">{greeting} 👋</p>
              <h1 className="greeting-name">{name}</h1>
              <span className="greeting-tag">👩‍🏫 Gia sư</span>
            </div>
            <div className="greeting-emoji">📖</div>
          </div>

          {/* Verification Warning (if PENDING) */}
          {verificationStatus === 'PENDING' && (
            <div className="verification-warning" style={{ 
              background: 'rgba(234, 179, 8, 0.1)', 
              color: '#ca8a04', 
              padding: '12px 16px', 
              borderRadius: '8px', 
              marginBottom: '24px',
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              fontSize: '0.95rem'
            }}>
              <AlertCircle size={20} />
              <div>
                <strong>Hồ sơ đang chờ duyệt!</strong> Bạn đã gửi thông tin xác thực, vui lòng chờ Quản trị viên phê duyệt để bắt đầu nhận lớp.
              </div>
            </div>
          )}

          {/* Verification Modal */}
          {(!isLoadingProfile && verificationStatus === 'UNVERIFIED') && (
            <TutorVerificationModal onSuccess={fetchProfileStatus} />
          )}

          {/* Stats */}
          <section>
            <div className="dash-stats-grid">
              {[
                { val: '12',    lbl: 'Học sinh',       icon: <Users size={20}/>,     cls: 'color-indigo'  },
                { val: '4',     lbl: 'Lớp đang dạy',  icon: <BookOpen size={20}/>,  cls: 'color-violet'  },
                { val: '4.9 ★', lbl: 'Đánh giá',       icon: <Star size={20}/>,      cls: 'color-amber'   },
                { val: '8.4M',  lbl: 'Doanh thu T3',  icon: <TrendingUp size={20}/>, cls: 'color-emerald' },
              ].map((s, i) => (
                <div key={i} className={`dash-stat-card ${s.cls}`}>
                  <div className="stat-icon-box">{s.icon}</div>
                  <div className="stat-info">
                    <span className="stat-val">{s.val}</span>
                    <span className="stat-lbl">{s.lbl}</span>
                  </div>
                </div>
              ))}
            </div>
          </section>

          {/* Two cols */}
          <div className="dash-cols">
            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">📅 Lịch dạy sắp tới</span>
                <button className="dash-see-all">Xem tất cả <ChevronRight size={14}/></button>
              </div>
              <div className="upcoming-list">
                {upcomingLessons.map((c, i) => (
                  <div key={i} className="upcoming-item">
                    <span className="upcoming-avatar">{c.avatar}</span>
                    <div className="upcoming-info">
                      <p className="upcoming-subj">{c.subject}</p>
                      <p className="upcoming-who">{c.who}</p>
                    </div>
                    <div className="upcoming-time"><Clock size={12}/><span>{c.time}</span></div>
                  </div>
                ))}
              </div>
            </div>

            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">⚡ Hoạt động</span>
              </div>
              <div className="activity-list">
                {activities.map((a, i) => (
                  <div key={i} className={`activity-item ${a.type}`}>
                    <div className="activity-icon-box">
                      {a.type === 'act-lesson'  && <BookOpen size={14}/>}
                      {a.type === 'act-payment' && <TrendingUp size={14}/>}
                      {a.type === 'act-review'  && <Star size={14}/>}
                      {a.type === 'act-booking' && <Users size={14}/>}
                    </div>
                    <div className="activity-body">
                      <p className="activity-text">{a.text}</p>
                      <span className="activity-time">{a.time}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* Quick actions */}
          <section>
            <div className="dash-section-head">
              <span className="dash-section-title">⚡ Thao tác nhanh</span>
            </div>
            <div className="dash-qa-grid">
              {[
                { emoji: '📅', label: 'Lịch dạy',      onClick: () => navigate('/schedule')  },
                { emoji: '💬', label: 'Tin nhắn',       onClick: () => navigate('/messages')  },
                { emoji: '👤', label: 'Hồ sơ gia sư',  onClick: () => navigate('/profile')   },
                { emoji: '📊', label: 'Báo cáo',        onClick: () => navigate('/reports')   },
              ].map((a, i) => {
                const isDisabled = (a.label === 'Lịch dạy') && verificationStatus !== 'APPROVED';
                return (
                  <button 
                    key={i} 
                    className="dash-qa-card" 
                    onClick={a.onClick}
                    disabled={isDisabled}
                    style={{ opacity: isDisabled ? 0.5 : 1, cursor: isDisabled ? 'not-allowed' : 'pointer' }}
                  >
                    <span className="qa-emoji">{a.emoji}</span>
                    <span className="qa-label">{a.label}</span>
                    <ChevronRight size={15} className="qa-arr"/>
                  </button>
                );
              })}
            </div>
          </section>
        </div>
      </main>
    </div>
  );
};
