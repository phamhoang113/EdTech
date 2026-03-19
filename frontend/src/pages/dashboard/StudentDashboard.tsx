import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import {
  BookOpen, Award, Star, Calendar,
  ChevronRight, Clock, TrendingUp, MessageSquare,
  UserPlus, X, Heart, LogOut
} from 'lucide-react';
import { DashboardHeader } from '../../components/layout/DashboardHeader';
import './Dashboard.css';

/* ---- mock data ---- */
const upcomingClasses = [
  { subject: 'Toán lớp 10',      who: 'Nguyễn Minh Anh', time: 'Hôm nay, 19:00', avatar: '🧑‍🏫' },
  { subject: 'Tiếng Anh IELTS',  who: 'Trần Lan Phương',  time: 'Thứ 6, 08:00',   avatar: '👩‍🏫' },
  { subject: 'Lập trình Python', who: 'Lớp mở',            time: 'Thứ 7, 14:00',   avatar: '💻'   },
];

const activities = [
  { text: 'Buổi học Toán với GS Minh Anh hoàn thành',    time: '2 giờ trước',  type: 'act-lesson'  },
  { text: 'Thanh toán buổi học thành công — 200.000đ',   time: '1 ngày trước', type: 'act-payment' },
  { text: 'Đánh giá gia sư Lan Phương ★★★★★',            time: '2 ngày trước', type: 'act-review'  },
  { text: 'Đặt lịch học Tiếng Anh IELTS vào thứ 6',     time: '3 ngày trước', type: 'act-booking' },
];

// Mock danh sách phụ huynh đã liên kết — để [] để test trạng thái chưa liên kết
const initParents: { name: string; meta: string }[] = [];

export const StudentDashboard = () => {
  const { user, logout } = useAuthStore();
  const navigate = useNavigate();
  const [parents, setParents] = useState(initParents);
  const [showAddParent, setShowAddParent] = useState(false);
  const [newParentPhone, setNewParentPhone] = useState('');
  // TODO: lấy từ API — false = chưa có phụ huynh nào liên kết
  const hasLinkedParent = parents.length > 0;



  const handleLogout = () => { logout(); navigate('/'); };

  const handleAddParent = () => {
    if (!newParentPhone.trim()) return;
    setParents(p => [...p, { name: newParentPhone, meta: 'Phụ huynh mới liên kết' }]);
    setNewParentPhone('');
    setShowAddParent(false);
  };

  const name = user?.fullName ?? 'Học sinh';

  const h = new Date().getHours();
  const greeting = h < 12 ? 'Chào buổi sáng' : h < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';

  return (
    <div className="dash-page">
      {/* ===== SIDEBAR ===== */}
      <aside className="dash-sidebar">
        <Link to="/" className="dash-sidebar-logo">
          <span className="dash-sidebar-logo-icon">🎓</span>
          <span className="dash-sidebar-logo-name">EdTech</span>
        </Link>

        <div className="dash-sidebar-section">
          <span className="dash-sidebar-section-label">Học tập</span>
          <button className="dash-sidebar-item active"><BookOpen size={18} /> Tổng quan</button>
          <button className="dash-sidebar-item"><Calendar size={18} /> Lịch học</button>
          <button className="dash-sidebar-item"><MessageSquare size={18} /> Tin nhắn <span className="item-badge">2</span></button>
          <button className="dash-sidebar-item"><Star size={18} /> Thành tích</button>

          <span className="dash-sidebar-section-label">Tài khoản</span>
          <button className="dash-sidebar-item" onClick={() => setShowAddParent(true)}><UserPlus size={18} /> Phụ huynh của tôi</button>
          <button className="dash-sidebar-item"><TrendingUp size={18} /> Thanh toán</button>
        </div>

        <button className="dash-logout" onClick={handleLogout}><LogOut size={16} /> Đăng xuất</button>
      </aside>

      {/* ===== MAIN ===== */}
      <main className="dash-main">
        {/* Topbar */}
        <DashboardHeader />

        {/* Body */}
        <div className="dash-body">
          {/* Greeting */}
          <div className="dash-greeting">
            <div className="greeting-left">
              <p className="greeting-hi">{greeting} 👋</p>
              <h1 className="greeting-name">{name}</h1>
              <span className="greeting-tag">📚 Học sinh</span>
            </div>
            <div className="greeting-emoji">🎒</div>
          </div>

          {/* ===== ONBOARDING CTA BANNER ===== */}
          {!hasLinkedParent && (
            <div className="onboard-banners">
              <div
                className="onboard-card onboard-parent"
                onClick={() => setShowAddParent(true)}
              >
                <div className="onboard-card-glow" />
                <div className="onboard-icon-wrap">
                  <Heart size={26} />
                </div>
                <div className="onboard-content">
                  <p className="onboard-step">Gợi ý · An toàn hơn</p>
                  <h3 className="onboard-title">Liên kết phụ huynh</h3>
                  <p className="onboard-desc">
                    Cho phép bố/mẹ theo dõi lịch học, tiến độ và nhận thông báo quan trọng cùng bạn.
                  </p>
                </div>
                <div className="onboard-arrow">
                  <ChevronRight size={22} />
                </div>
              </div>
            </div>
          )}

          {/* Stats */}
          <section>
            <div className="dash-stats-grid">
              {[
                { val: '3',     lbl: 'Lớp đang học',    icon: <BookOpen size={20}/>,   cls: 'color-indigo'  },
                { val: '6',     lbl: 'Buổi học tuần',   icon: <Calendar size={20}/>,   cls: 'color-violet'  },
                { val: '24',    lbl: 'Bài hoàn thành',  icon: <Award size={20}/>,      cls: 'color-emerald' },
                { val: '1,240', lbl: 'Điểm tích lũy',  icon: <Star size={20}/>,       cls: 'color-amber'   },
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
            {/* Upcoming */}
            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">📅 Lịch học sắp tới</span>
                <button className="dash-see-all">Xem tất cả <ChevronRight size={14}/></button>
              </div>
              <div className="upcoming-list">
                {upcomingClasses.map((c,i) => (
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

            {/* Activities */}
            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">⚡ Hoạt động gần đây</span>
              </div>
              <div className="activity-list">
                {activities.map((a, i) => (
                  <div key={i} className={`activity-item ${a.type}`}>
                    <div className="activity-icon-box">
                      {a.type === 'act-lesson'  && <BookOpen size={14}/>}
                      {a.type === 'act-payment' && <TrendingUp size={14}/>}
                      {a.type === 'act-review'  && <Star size={14}/>}
                      {a.type === 'act-booking' && <Calendar size={14}/>}
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

          {/* Parents panel */}
          <div className="dash-panel">
            <div className="dash-section-head">
              <span className="dash-section-title">👨‍👩‍👧 Phụ huynh liên kết</span>
              <button className="dash-see-all" onClick={() => setShowAddParent(true)}>
                <UserPlus size={14}/> Thêm phụ huynh
              </button>
            </div>
            <div className="people-list">
              {parents.map((p, i) => (
                <div key={i} className="person-card">
                  <div className="person-avatar">{p.name.charAt(0)}</div>
                  <div className="person-info">
                    <p className="person-name">{p.name}</p>
                    <p className="person-meta">{p.meta}</p>
                  </div>
                  <span className="person-badge">Đã liên kết</span>
                </div>
              ))}
              <button className="add-person-btn" onClick={() => setShowAddParent(true)}>
                <UserPlus size={16}/> Thêm phụ huynh bằng số điện thoại
              </button>
            </div>
          </div>

          {/* Quick actions */}
          <section>
            <div className="dash-section-head">
              <span className="dash-section-title">⚡ Thao tác nhanh</span>
            </div>
            <div className="dash-qa-grid">
              {[
                { emoji: '🔍', label: 'Tìm gia sư',    onClick: () => navigate('/search')   },
                { emoji: '📅', label: 'Lịch học',      onClick: () => navigate('/schedule') },
                { emoji: '💬', label: 'Nhắn tin',      onClick: () => navigate('/messages') },
                { emoji: '💳', label: 'Thanh toán',    onClick: () => navigate('/payment')  },
              ].map((a,i) => (
                <button key={i} className="dash-qa-card" onClick={a.onClick}>
                  <span className="qa-emoji">{a.emoji}</span>
                  <span className="qa-label">{a.label}</span>
                  <ChevronRight size={15} className="qa-arr"/>
                </button>
              ))}
            </div>
          </section>
        </div>
      </main>

      {/* ===== MODAL: Add Parent ===== */}
      {showAddParent && (
        <div className="ap-overlay" onClick={() => setShowAddParent(false)}>
          <div className="ap-modal" onClick={e => e.stopPropagation()}>
            <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',marginBottom:'4px'}}>
              <h3>Thêm phụ huynh</h3>
              <button onClick={() => setShowAddParent(false)} style={{background:'none',border:'none',cursor:'pointer',color:'var(--color-text-muted)'}}>
                <X size={20}/>
              </button>
            </div>
            <p>Nhập số điện thoại của phụ huynh để gửi yêu cầu liên kết. Phụ huynh cần có tài khoản EdTech.</p>
            <input
              className="ap-input"
              type="tel"
              placeholder="Số điện thoại phụ huynh"
              value={newParentPhone}
              onChange={e => setNewParentPhone(e.target.value)}
              autoFocus
            />
            <div className="ap-actions">
              <button className="ap-cancel" onClick={() => setShowAddParent(false)}>Hủy</button>
              <button className="ap-confirm" onClick={handleAddParent}>Gửi yêu cầu</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
