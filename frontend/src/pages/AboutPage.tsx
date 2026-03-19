import { Header } from '../components/layout/Header';
import { Footer } from '../components/layout/Footer';
import { useState } from 'react';
import { LoginModal } from '../components/auth/LoginModal';
import { Target, Users, Shield, Sparkles, BookOpen, TrendingUp } from 'lucide-react';
import './AboutPage.css';

export const AboutPage = () => {
  const [authModalState, setAuthModalState] = useState<{ isOpen: boolean; mode: 'login' | 'register' }>({
    isOpen: false,
    mode: 'login',
  });

  const openLogin = () => setAuthModalState({ isOpen: true, mode: 'login' });
  const openRegister = () => setAuthModalState({ isOpen: true, mode: 'register' });
  const closeAuth = () => setAuthModalState((prev) => ({ ...prev, isOpen: false }));

  return (
    <div className="about-page">
      <Header onLoginClick={openLogin} onRegisterClick={openRegister} />
      
      <main className="about-main">
        {/* PREMIUM HERO */}
        <section className="about-hero-premium">
          <div className="hero-glow hero-glow-1"></div>
          <div className="hero-glow hero-glow-2"></div>
          
          <div className="container hero-content-premium">
            <div className="badge-pill">
              <Sparkles size={16} className="badge-icon" />
              <span>Định hình tương lai giáo dục</span>
            </div>
            <h1 className="hero-title-premium">
              Học tập không giới hạn cùng <span className="text-gradient">EdTech</span>
            </h1>
            <p className="hero-subtitle-premium">
              Nền tảng kết nối gia sư tinh hoa và học sinh tiên phong. 
              Chúng tôi ứng dụng công nghệ để cá nhân hóa lộ trình học tập, mở ra tiềm năng trọn vẹn của mỗi cá nhân.
            </p>
          </div>
        </section>

        {/* STATS STRIP */}
        <section className="about-stats-strip">
          <div className="container stats-grid">
            <div className="stat-box">
              <h2 className="stat-number">10,000+</h2>
              <p className="stat-label">Gia sư được kiểm duyệt</p>
            </div>
            <div className="stat-box">
              <h2 className="stat-number">50,000+</h2>
              <p className="stat-label">Học sinh toàn quốc</p>
            </div>
            <div className="stat-box">
              <h2 className="stat-number">4.9/5</h2>
              <p className="stat-label">Đánh giá trung bình</p>
            </div>
            <div className="stat-box">
              <h2 className="stat-number">98%</h2>
              <p className="stat-label">Cải thiện điểm số</p>
            </div>
          </div>
        </section>

        {/* BENTO GRID VALUES */}
        <section className="about-bento-section">
          <div className="container">
            <div className="section-header">
              <h2>Giá trị cốt lõi</h2>
              <p>Những nguyên tắc định hướng mọi hành động và sản phẩm tại EdTech.</p>
            </div>

            <div className="bento-grid">
              <div className="bento-card bento-large bg-gradient-indigo">
                <Target className="bento-icon" size={40} />
                <h3>Sứ mệnh</h3>
                <p>Nâng tầm tri thức Việt Nam bằng cách phá vỡ rào cản địa lý và chi phí, mang đến trải nghiệm học tập chất lượng cao cho tất cả học sinh ở mọi vùng miền.</p>
              </div>

              <div className="bento-card bg-surface-glass">
                <Shield className="bento-icon text-accent" size={32} />
                <h3>Chất lượng tuyệt đối</h3>
                <p>Quy trình xác thực chuyên môn nghiêm ngặt đảm bảo 100% gia sư đạt chuẩn đầu vào xuất sắc.</p>
              </div>

              <div className="bento-card bg-surface-glass">
                <Users className="bento-icon text-primary" size={32} />
                <h3>Cộng đồng</h3>
                <p>Xây dựng hệ sinh thái hỗ trợ chặt chẽ giữa Gia sư, Học sinh và Phụ huynh.</p>
              </div>

              <div className="bento-card bg-pattern">
                <TrendingUp className="bento-icon text-white" size={32} />
                <h3>Công nghệ AI Tiên phong</h3>
                <p>Sử dụng thuật toán AI để gợi ý lộ trình học tập phù hợp nhất dựa trên điểm mạnh và điểm yếu của từng học viên.</p>
              </div>

              <div className="bento-card bg-surface-glass">
                <BookOpen className="bento-icon text-success" size={32} />
                <h3>Học đi đôi với hành</h3>
                <p>Phương pháp giảng dạy tập trung vào giải quyết vấn đề thực tế.</p>
              </div>
            </div>
          </div>
        </section>

        {/* CTA PREMIUM */}
        <section className="about-cta-premium">
          <div className="container">
            <div className="cta-glass-card">
              <div className="cta-content">
                <h2>Hãy trở thành một phần của EdTech</h2>
                <p>Cho dù bạn là học sinh muốn bứt phá hay gia sư muốn truyền cảm hứng. Hành trình của bạn bắt đầu từ đây.</p>
                <div className="cta-buttons">
                  <button className="btn btn-primary btn-lg cta-btn-glow" onClick={openRegister}>
                    Bắt đầu ngay hôm nay
                  </button>
                  <button className="btn btn-ghost btn-lg text-white" onClick={openLogin}>
                    Tìm hiểu thêm
                  </button>
                </div>
              </div>
            </div>
          </div>
        </section>
      </main>

      <Footer />

      {authModalState.isOpen && <LoginModal onClose={closeAuth} initialMode={authModalState.mode} />}
    </div>
  );
};
