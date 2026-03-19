import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import {
  BookOpen, Award, TrendingUp, Calendar,
  ChevronRight, Clock, MessageSquare,
  UserPlus, Users, X, Sparkles, Link2,
  Search, LogOut
} from 'lucide-react';
import { DashboardHeader } from '../../components/layout/DashboardHeader';
import './Dashboard.css';

const upcomingClasses = [
  { subject: 'Toán lớp 10',      who: 'GS Nguyễn Minh Anh', time: 'Hôm nay, 19:00', avatar: '🧑‍🏫' },
  { subject: 'Tiếng Anh IELTS',  who: 'GS Trần Lan Phương',  time: 'Thứ 6, 08:00',   avatar: '👩‍🏫' },
];

const activities = [
  { text: 'Con Bảo Nguyên vừa hoàn thành bài kiểm tra Toán',   time: '1 giờ trước',  type: 'act-lesson'  },
  { text: 'Thanh toán học phí tháng 3 — 2.400.000đ',            time: '1 ngày trước', type: 'act-payment' },
  { text: 'Đặt lịch học Anh văn cho con vào thứ 6',             time: '2 ngày trước', type: 'act-booking' },
  { text: 'Con Bảo Nguyên đánh giá gia sư Lan Phương ★★★★★',    time: '3 ngày trước', type: 'act-review'  },
];

// Mock học sinh đã liên kết — để [] để test trạng thái chưa liên kết
const initStudents: { name: string; meta: string }[] = [];

export const ParentDashboard = () => {
  const { user, logout } = useAuthStore();
  const navigate = useNavigate();
  const [students, setStudents] = useState(initStudents);
  const [showAddStudent, setShowAddStudent] = useState(false);
  const [newStudentPhone, setNewStudentPhone] = useState('');
  // TODO: lấy từ API — false = chưa có gia sư nào đang hoạt động
  const hasTutor = false;
  const hasLinkedStudent = students.length > 0;



  const handleLogout = () => { logout(); navigate('/'); };

  const handleAddStudent = () => {
    if (!newStudentPhone.trim()) return;
    setStudents(p => [...p, { name: newStudentPhone, meta: 'Học sinh mới liên kết' }]);
    setNewStudentPhone('');
    setShowAddStudent(false);
  };

  const name = user?.fullName ?? 'Phụ huynh';
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
          <span className="dash-sidebar-section-label">Quản lý</span>
          <button className="dash-sidebar-item active"><TrendingUp size={18}/> Tổng quan</button>
          <button className="dash-sidebar-item" onClick={() => setShowAddStudent(true)}><Users size={18}/> Con em của tôi</button>
          <button className="dash-sidebar-item"><Search size={18}/> Tìm gia sư</button>
          <button className="dash-sidebar-item"><Calendar size={18}/> Lịch học</button>
          <button className="dash-sidebar-item"><MessageSquare size={18}/> Tin nhắn <span className="item-badge">1</span></button>

          <span className="dash-sidebar-section-label">Tài chính</span>
          <button className="dash-sidebar-item"><TrendingUp size={18}/> Thanh toán</button>
          <button className="dash-sidebar-item"><Award size={18}/> Báo cáo học tập</button>
        </div>

        <button className="dash-logout" onClick={handleLogout}><LogOut size={16}/> Đăng xuất</button>
      </aside>

      {/* ===== MAIN ===== */}
      <main className="dash-main">
        <DashboardHeader />

        <div className="dash-body">
          {/* Greeting */}
          <div className="dash-greeting">
            <div className="greeting-left">
              <p className="greeting-hi">{greeting} 👋</p>
              <h1 className="greeting-name">{name}</h1>
              <span className="greeting-tag">👨‍👩‍👧 Phụ huynh</span>
            </div>
            <div className="greeting-emoji">🏠</div>
          </div>

          {/* ===== ONBOARDING CTA BANNERS ===== */}
          {(!hasLinkedStudent || !hasTutor) && (
            <div className="onboard-banners">
              {!hasLinkedStudent && (
                <div className="onboard-card onboard-student" onClick={() => setShowAddStudent(true)}>
                  <div className="onboard-card-glow" />
                  <div className="onboard-icon-wrap">
                    <Link2 size={26} />
                  </div>
                  <div className="onboard-content">
                    <p className="onboard-step">Bước 1 · Bắt đầu ngay</p>
                    <h3 className="onboard-title">Liên kết học sinh</h3>
                    <p className="onboard-desc">Thêm con em để theo dõi lịch học, tiến độ và thanh toán tập trung.</p>
                  </div>
                  <div className="onboard-arrow">
                    <ChevronRight size={22} />
                  </div>
                </div>
              )}
              {!hasTutor && (
                <div className="onboard-card onboard-tutor" onClick={() => navigate('/search')}>
                  <div className="onboard-card-glow" />
                  <div className="onboard-icon-wrap">
                    <Sparkles size={26} />
                  </div>
                  <div className="onboard-content">
                    <p className="onboard-step">{hasLinkedStudent ? 'Bước 2 · Tiếp theo' : 'Bước 2'} · Quan trọng</p>
                    <h3 className="onboard-title">Tìm gia sư phù hợp</h3>
                    <p className="onboard-desc">Khám phá hàng trăm gia sư chất lượng cao, lọc theo môn học, mức giá và đánh giá.</p>
                  </div>
                  <div className="onboard-arrow">
                    <ChevronRight size={22} />
                  </div>
                </div>
              )}
            </div>
          )}

          {/* Stats */}
          <section>
            <div className="dash-stats-grid">
              {[
                { val: `${students.length}`, lbl: 'Con em đang học', icon: <Users size={20}/>,     cls: 'color-indigo'  },
                { val: '6',                   lbl: 'Buổi học tuần',   icon: <Calendar size={20}/>,  cls: 'color-violet'  },
                { val: '2.4M',                lbl: 'Chi phí tháng',   icon: <TrendingUp size={20}/>,cls: 'color-amber'   },
                { val: '88%',                 lbl: 'Tiến độ trung bình', icon: <Award size={20}/>, cls: 'color-emerald' },
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
                <span className="dash-section-title">📅 Lịch học sắp tới</span>
                <button className="dash-see-all">Xem tất cả <ChevronRight size={14}/></button>
              </div>
              <div className="upcoming-list">
                {upcomingClasses.map((c, i) => (
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
                      {a.type === 'act-review'  && <Award size={14}/>}
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

          {/* Students panel */}
          <div className="dash-panel">
            <div className="dash-section-head">
              <span className="dash-section-title">👦👧 Con em đã liên kết</span>
              <button className="dash-see-all" onClick={() => setShowAddStudent(true)}>
                <UserPlus size={14}/> Thêm học sinh
              </button>
            </div>
            <div className="people-list">
              {students.map((s, i) => (
                <div key={i} className="person-card">
                  <div className="person-avatar">{s.name.charAt(0)}</div>
                  <div className="person-info">
                    <p className="person-name">{s.name}</p>
                    <p className="person-meta">{s.meta}</p>
                  </div>
                  <span className="person-badge">Đang học</span>
                </div>
              ))}
              <button className="add-person-btn" onClick={() => setShowAddStudent(true)}>
                <UserPlus size={16}/> Thêm học sinh bằng số điện thoại
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
                { emoji: '👶', label: 'Quản lý con',   onClick: () => setShowAddStudent(true) },
                { emoji: '📅', label: 'Lịch học',      onClick: () => navigate('/schedule') },
                { emoji: '💳', label: 'Thanh toán',    onClick: () => navigate('/payment')  },
              ].map((a, i) => (
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

      {/* Modal: Add Student */}
      {showAddStudent && (
        <div className="ap-overlay" onClick={() => setShowAddStudent(false)}>
          <div className="ap-modal" onClick={e => e.stopPropagation()}>
            <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',marginBottom:'4px'}}>
              <h3>Thêm học sinh</h3>
              <button onClick={() => setShowAddStudent(false)} style={{background:'none',border:'none',cursor:'pointer',color:'var(--color-text-muted)'}}>
                <X size={20}/>
              </button>
            </div>
            <p>Nhập số điện thoại của học sinh để gửi yêu cầu liên kết. Học sinh cần có tài khoản EdTech.</p>
            <input
              className="ap-input"
              type="tel"
              placeholder="Số điện thoại học sinh"
              value={newStudentPhone}
              onChange={e => setNewStudentPhone(e.target.value)}
              autoFocus
            />
            <div className="ap-actions">
              <button className="ap-cancel" onClick={() => setShowAddStudent(false)}>Hủy</button>
              <button className="ap-confirm" onClick={handleAddStudent}>Gửi yêu cầu</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
