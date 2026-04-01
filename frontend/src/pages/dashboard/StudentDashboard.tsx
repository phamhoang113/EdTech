import { BookOpen, Award, Calendar, ChevronRight, Clock, UserPlus, Heart, X, Users } from 'lucide-react';
import { useState, useEffect } from 'react';
import { getDisplayStatus } from '../../utils/sessionStatus';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';

import { DashboardHeader } from '../../components/layout/DashboardHeader';
import { StudentSidebar } from '../../components/student/StudentSidebar';
import { studentApi } from '../../services/studentApi';
import type { ParentLinkResponse } from '../../services/studentApi';
import type { SessionDTO } from '../../services/sessionApi';
import './Dashboard.css';

/* ── Helpers ──────────────────────────────────────────── */
function formatSessionTime(s: SessionDTO): string {
  const d = new Date(s.sessionDate);
  const today = new Date();
  const tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);

  const timeStr = s.startTime?.substring(0, 5) ?? '--:--';

  if (d.toDateString() === today.toDateString()) return `Hôm nay, ${timeStr}`;
  if (d.toDateString() === tomorrow.toDateString()) return `Ngày mai, ${timeStr}`;

  const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
  return `${dayNames[d.getDay()]}, ${d.getDate()}/${d.getMonth() + 1} ${timeStr}`;
}

const PARENT_LINK_DISMISSED_KEY = 'edtech_parent_link_dismissed';

export const StudentDashboard = () => {
  const { user } = useAuthStore();
  const navigate = useNavigate();
  const [links, setLinks] = useState<ParentLinkResponse[]>([]);
  const [showAddParent, setShowAddParent] = useState(false);
  const [showParentInfo, setShowParentInfo] = useState(false);
  const [newParentPhone, setNewParentPhone] = useState('');
  const [sessions, setSessions] = useState<SessionDTO[]>([]);
  const [parentLinkDismissed, setParentLinkDismissed] = useState(
    () => localStorage.getItem(PARENT_LINK_DISMISSED_KEY) === 'true'
  );

  useEffect(() => {
    fetchLinks();
    fetchSessions();
  }, []);

  const fetchLinks = async () => {
    try {
      const res = await studentApi.getParentLinks();
      setLinks(res.data);
    } catch (e) {
      console.error(e);
    }
  };

  const fetchSessions = async () => {
    try {
      const res = await studentApi.getSessions();
      const data = Array.isArray(res.data) ? res.data : (res.data as unknown as { data: SessionDTO[] })?.data ?? [];
      setSessions(data);
    } catch (e) {
      console.error('Failed to load sessions:', e);
    }
  };

  const handleAddParent = async () => {
    if (!newParentPhone.trim()) return;
    try {
      await studentApi.requestParentLink(newParentPhone.trim());
      alert('Đã liên kết thành công với phụ huynh!');
      setNewParentPhone('');
      setShowAddParent(false);
      fetchLinks();
    } catch (e: any) {
      alert(e.response?.data?.message || 'Có lỗi xảy ra, vui lòng thử lại.');
    }
  };

  const handleAccept = async (linkId: string) => {
    try {
      await studentApi.acceptParentLink(linkId);
      fetchLinks();
    } catch (e) {
      console.error(e);
      alert('Có lỗi xảy ra khi xác nhận.');
    }
  };

  const handleReject = async (linkId: string) => {
    if (!window.confirm('Từ chối yêu cầu liên kết này?')) return;
    try {
      await studentApi.rejectParentLink(linkId);
      fetchLinks();
    } catch (e) {
      console.error(e);
    }
  };

  const name = user?.fullName ?? 'Học sinh';
  const h = new Date().getHours();
  const greeting = h < 12 ? 'Chào buổi sáng' : h < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';

  // Compute stats from real sessions
  const now = new Date();
  const upcomingSessions = sessions
    .filter(s => getDisplayStatus(s.status, s.sessionDate, s.endTime) === 'SCHEDULED' && new Date(s.sessionDate) >= new Date(now.toDateString()))
    .sort((a, b) => new Date(a.sessionDate).getTime() - new Date(b.sessionDate).getTime());
  const completedSessions = sessions.filter(s => {
    const ds = getDisplayStatus(s.status, s.sessionDate, s.endTime);
    return ds === 'COMPLETED' || s.status === 'COMPLETED_PENDING';
  });
  const uniqueClassIds = new Set(sessions.filter(s => s.status !== 'CANCELLED').map(s => s.classId));

  // Has parent link? Used for payment visibility logic
  const hasParentLink = links.some(l => l.linkStatus === 'ACCEPTED');

  return (
    <div className="dash-page">
      <StudentSidebar 
        active="overview" 
        onAddParent={() => {
          if (hasParentLink) setShowParentInfo(true);
          else setShowAddParent(true);
        }} 
        hasParent={hasParentLink} 
      />

      <main className="dash-main">
        <DashboardHeader />

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

          {/* Pending parent link requests */}
          {links.filter(l => l.linkStatus === 'PENDING').map(link => (
            <div key={link.id} className="onboard-banners" style={{ marginBottom: 15 }}>
              <div className="onboard-card" style={{ background: '#fffbeb', border: '1px solid #fde68a' }}>
                <div style={{ marginRight: 15, padding: 12, background: '#fef3c7', borderRadius: '50%', color: '#d97706' }}>
                  <UserPlus size={24} />
                </div>
                <div className="onboard-content" style={{ flex: 1 }}>
                  <h3 className="onboard-title" style={{ color: '#d97706', marginBottom: 4 }}>Yêu cầu liên kết mới</h3>
                  <p className="onboard-desc" style={{ color: '#92400e', margin: 0 }}>
                    Phụ huynh <strong>{link.parentName}</strong> ({link.parentPhone}) muốn liên kết với tài khoản của bạn.
                  </p>
                </div>
                <div style={{ display: 'flex', gap: 10 }}>
                  <button onClick={() => handleReject(link.id)} style={{ padding: '8px 16px', border: '1px solid #fca5a5', background: '#fee2e2', color: '#b91c1c', borderRadius: 6, cursor: 'pointer', fontWeight: 500 }}>
                    Từ chối
                  </button>
                  <button onClick={() => handleAccept(link.id)} style={{ padding: '8px 16px', border: 'none', background: '#d97706', color: '#fff', borderRadius: 6, cursor: 'pointer', fontWeight: 500 }}>
                    Đồng ý
                  </button>
                </div>
              </div>
            </div>
          ))}

          {/* No parent banner — hiển thị khi chưa có liên kết VÀ chưa bấm bỏ qua */}
          {links.length === 0 && !parentLinkDismissed && (
            <div className="onboard-banners">
              <div className="onboard-card onboard-parent">
                <div className="onboard-card-glow" />
                <div className="onboard-icon-wrap"><Heart size={26} /></div>
                <div className="onboard-content">
                  <p className="onboard-step">Gợi ý · An toàn hơn</p>
                  <h3 className="onboard-title">Liên kết phụ huynh</h3>
                  <p className="onboard-desc">
                    Cho phép bố/mẹ theo dõi lịch học, tiến độ và nhận thông báo quan trọng cùng bạn.
                  </p>
                  <div className="onboard-actions">
                    <button className="onboard-action-primary" onClick={() => setShowAddParent(true)}>
                      Liên kết ngay
                    </button>
                    <button
                      className="onboard-action-secondary"
                      onClick={(e) => {
                        e.stopPropagation();
                        localStorage.setItem(PARENT_LINK_DISMISSED_KEY, 'true');
                        setParentLinkDismissed(true);
                      }}
                    >
                      Bỏ qua
                    </button>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Stats from real data */}
          <section>
            <div className="dash-stats-grid">
              {[
                { val: `${uniqueClassIds.size}`, lbl: 'Lớp đang học', icon: <BookOpen size={20}/>, cls: 'color-indigo' },
                { val: `${upcomingSessions.length}`, lbl: 'Buổi sắp tới', icon: <Calendar size={20}/>, cls: 'color-violet' },
                { val: `${completedSessions.length}`, lbl: 'Buổi hoàn thành', icon: <Award size={20}/>, cls: 'color-emerald' },
                { val: `${sessions.length}`, lbl: 'Tổng buổi học', icon: <Clock size={20}/>, cls: 'color-amber' },
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
            {/* Upcoming classes from API */}
            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">📅 Lịch học sắp tới</span>
                <button className="dash-see-all" onClick={() => navigate('/student/schedule')}>
                  Xem tất cả <ChevronRight size={14}/>
                </button>
              </div>
              <div className="upcoming-list">
                {upcomingSessions.length === 0 ? (
                  <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Không có buổi học nào sắp tới.</p>
                ) : (
                  upcomingSessions.slice(0, 4).map(s => (
                    <div key={s.id} className="upcoming-item">
                      <span className="upcoming-avatar">📚</span>
                      <div className="upcoming-info">
                        <p className="upcoming-subj">{s.classTitle}</p>
                        <p className="upcoming-who">{s.tutorName} · {s.subject}</p>
                      </div>
                      <div className="upcoming-time"><Clock size={12}/><span>{formatSessionTime(s)}</span></div>
                    </div>
                  ))
                )}
              </div>
            </div>

            {/* Completed sessions (activities) */}
            <div className="dash-panel">
              <div className="dash-section-head">
                <span className="dash-section-title">✅ Buổi học đã hoàn thành</span>
              </div>
              <div className="upcoming-list">
                {completedSessions.length === 0 ? (
                  <p style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Chưa hoàn thành buổi học nào.</p>
                ) : (
                  completedSessions.slice(0, 4).map(s => (
                    <div key={s.id} className="upcoming-item">
                      <span className="upcoming-avatar" style={{
                        width: 36, height: 36, borderRadius: 10,
                        background: 'linear-gradient(135deg,#10b981,#059669)',
                        color: '#fff', display: 'flex',
                        alignItems: 'center', justifyContent: 'center',
                        fontSize: '0.8rem',
                      }}>✓</span>
                      <div className="upcoming-info">
                        <p className="upcoming-subj">{s.classTitle}</p>
                        <p className="upcoming-who">{s.tutorName} · {s.subject}</p>
                      </div>
                      <div className="upcoming-time"><Calendar size={12}/><span>{new Date(s.sessionDate).toLocaleDateString('vi-VN')}</span></div>
                    </div>
                  ))
                )}
              </div>
            </div>
          </div>

          {/* Parents panel */}
          <div className="dash-panel">
            <div className="dash-section-head">
              <span className="dash-section-title">👨‍👩‍👧 Phụ huynh liên kết</span>
            </div>
            <div className="people-list">
              {links.filter(l => l.linkStatus === 'ACCEPTED').map((p) => (
                <div key={p.id} className="person-card">
                  <div className="person-avatar">{p.parentName.charAt(0)}</div>
                  <div className="person-info">
                    <p className="person-name">{p.parentName}</p>
                    <p className="person-meta">{p.parentPhone}</p>
                  </div>
                  <span className="person-badge">Đã liên kết</span>
                </div>
              ))}
              {links.filter(l => l.linkStatus === 'ACCEPTED').length === 0 && (
                <p style={{ color: '#6b7280', fontSize: '0.9rem', padding: '10px 0' }}>Chưa có phụ huynh nào liên kết.</p>
              )}
            </div>
          </div>

          {/* Quick actions */}
          <section>
            <div className="dash-section-head">
              <span className="dash-section-title">⚡ Thao tác nhanh</span>
            </div>
            <div className="dash-qa-grid">
              {[
                { emoji: '📅', label: 'Lịch học', onClick: () => navigate('/student/schedule') },
                { emoji: '💬', label: 'Nhắn tin', onClick: () => navigate('/messages') },
                { emoji: '👤', label: 'Hồ sơ', onClick: () => navigate('/profile') },
                ...(!hasParentLink ? [{ emoji: '💳', label: 'Thanh toán', onClick: () => navigate('/payment') }] : []),
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

      {/* Modal: Add Parent */}
      {showAddParent && (
        <div className="ap-overlay" onClick={() => setShowAddParent(false)}>
          <div className="ap-modal" onClick={e => e.stopPropagation()}>
            <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',marginBottom:'4px'}}>
              <h3>Thêm phụ huynh</h3>
              <button onClick={() => setShowAddParent(false)} style={{background:'none',border:'none',cursor:'pointer',color:'var(--color-text-muted)'}}>
                <X size={20}/>
              </button>
            </div>
            <p>Nhập số điện thoại của phụ huynh để liên kết. Phụ huynh cần có tài khoản Gia Sư Tinh Hoa.</p>
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
              <button className="ap-confirm" onClick={handleAddParent}>Liên kết</button>
            </div>
          </div>
        </div>
      )}

      {/* Modal: Parent Info */}
      {showParentInfo && (
        <div className="ap-overlay" onClick={() => setShowParentInfo(false)}>
          <div className="ap-modal" onClick={e => e.stopPropagation()}>
            <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',marginBottom:'12px'}}>
              <h3 style={{display: 'flex', alignItems: 'center', gap: '8px'}}><Users size={20} className="text-primary"/> Phụ huynh của tôi</h3>
              <button onClick={() => setShowParentInfo(false)} style={{background:'none',border:'none',cursor:'pointer',color:'var(--color-text-muted)'}}>
                <X size={20}/>
              </button>
            </div>
            <p style={{fontSize: '0.85rem', color: 'var(--color-text-muted)', marginBottom: '20px'}}>
              Đây là phụ huynh đã liên kết và đang quản lý lộ trình học cũng như thanh toán học phí của bạn.
            </p>
            
            <div className="people-list">
              {links.filter(l => l.linkStatus === 'ACCEPTED').map((p) => (
                <div key={p.id} className="person-card" style={{ marginBottom: 12, padding: '16px', border: '1px solid rgba(139, 92, 246, 0.2)', backgroundColor: 'var(--color-surface)', borderRadius: '12px' }}>
                  <div className="person-avatar" style={{ width: 48, height: 48, fontSize: '1.2rem', background: 'linear-gradient(135deg, #6366f1 0%, #a855f7 100%)', color: 'white' }}>
                    {p.parentName.charAt(0).toUpperCase()}
                  </div>
                  <div className="person-info">
                    <p className="person-name" style={{ fontSize: '1rem', fontWeight: 600 }}>{p.parentName}</p>
                    <p className="person-meta" style={{ fontSize: '0.85rem', marginTop: 4 }}>📞 {p.parentPhone}</p>
                  </div>
                  <span className="person-badge" style={{ background: '#dcfce7', color: '#15803d', padding: '4px 8px', borderRadius: '20px', fontSize: '0.75rem', fontWeight: 600 }}>
                    Đã liên kết
                  </span>
                </div>
              ))}
            </div>

            <div className="ap-actions" style={{ marginTop: 24, justifyContent: 'flex-end' }}>
              <button className="btn-primary" onClick={() => setShowParentInfo(false)} style={{ padding: '8px 24px', borderRadius: '8px', border: 'none', background: 'var(--color-primary)', color: '#fff', cursor: 'pointer', fontWeight: 600 }}>
                Đóng
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
