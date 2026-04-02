// @ts-nocheck
import { Target, Users, Shield, Sparkles, BookOpen, TrendingUp } from 'lucide-react';


import { useScrollReveal } from '../hooks/useScrollReveal';
import './AboutPage.css';

export const AboutPage = () => {
  const { openLogin, openRegister } = useOutletContext<PublicLayoutContext>();

  return (
    <div className="about-page">
      <main className="about-main">
        {/* PREMIUM HERO */}
        <section className="about-hero-premium">
          <div className="hero-glow hero-glow-1"></div>
          <div className="hero-glow hero-glow-2"></div>
          
          <div className="container hero-content-premium">
            <div className="badge-pill animate-fade-up">
              <Sparkles size={16} className="badge-icon" />
              <span>Định hình tương lai giáo dục</span>
            </div>
            <h1 className="hero-title-premium animate-fade-up delay-100">
              Học tập không giới hạn cùng <span className="text-gradient">Gia Sư Tinh Hoa</span>
            </h1>
            <p className="hero-subtitle-premium animate-fade-up delay-200">
              Nền tảng kết nối gia sư tinh hoa và học sinh tiên phong. 
              Chúng tôi ứng dụng công nghệ để cá nhân hóa lộ trình học tập, mở ra tiềm năng trọn vẹn của mỗi cá nhân.
            </p>
          </div>
        </section>

        {/* STATS STRIP */}
        <section className="about-stats-strip" ref={statsRef}>
          <div className="container stats-grid">
            <div className={`stat-box reveal-base reveal-up ${statsRevealed ? 'revealed' : ''}`}>
              <h2 className="stat-number">10,000+</h2>
              <p className="stat-label">Gia sư được kiểm duyệt</p>
            </div>
            <div className={`stat-box reveal-base reveal-up delay-100 ${statsRevealed ? 'revealed' : ''}`}>
              <h2 className="stat-number">50,000+</h2>
              <p className="stat-label">Học sinh toàn quốc</p>
            </div>
            <div className={`stat-box reveal-base reveal-up delay-200 ${statsRevealed ? 'revealed' : ''}`}>
              <h2 className="stat-number">4.9/5</h2>
              <p className="stat-label">Đánh giá trung bình</p>
            </div>
            <div className={`stat-box reveal-base reveal-up delay-300 ${statsRevealed ? 'revealed' : ''}`}>
              <h2 className="stat-number">98%</h2>
              <p className="stat-label">Cải thiện điểm số</p>
            </div>
          </div>
        </section>

        {/* BENTO GRID VALUES */}
        <section className="about-bento-section" ref={bentoRef}>
          <div className="container">
            <div className={`section-header reveal-base reveal-up ${bentoRevealed ? 'revealed' : ''}`}>
              <h2>Giá trị cốt lõi</h2>
              <p>Những nguyên tắc định hướng mọi hành động và sản phẩm tại Gia Sư Tinh Hoa.</p>
            </div>

            <div className="bento-grid">
              <div className={`bento-card bento-large bg-gradient-indigo reveal-base reveal-scale ${bentoRevealed ? 'revealed' : ''}`}>
                <Target className="bento-icon" size={40} />
                <h3>Sứ mệnh</h3>
                <p>Nâng tầm tri thức Việt Nam bằng cách phá vỡ rào cản địa lý và chi phí, mang đến trải nghiệm học tập chất lượng cao cho tất cả học sinh ở mọi vùng miền.</p>
              </div>

              <div className={`bento-card bg-surface-glass reveal-base reveal-scale delay-100 ${bentoRevealed ? 'revealed' : ''}`}>
                <Shield className="bento-icon text-accent" size={32} />
                <h3>Chất lượng tuyệt đối</h3>
                <p>Quy trình xác thực chuyên môn nghiêm ngặt đảm bảo 100% gia sư đạt chuẩn đầu vào xuất sắc.</p>
              </div>

              <div className={`bento-card bg-surface-glass reveal-base reveal-scale delay-200 ${bentoRevealed ? 'revealed' : ''}`}>
                <Users className="bento-icon text-primary" size={32} />
                <h3>Cộng đồng</h3>
                <p>Xây dựng hệ sinh thái hỗ trợ chặt chẽ giữa Gia sư, Học sinh và Phụ huynh.</p>
              </div>

              <div className={`bento-card bg-pattern reveal-base reveal-scale delay-100 ${bentoRevealed ? 'revealed' : ''}`}>
                <TrendingUp className="bento-icon text-white" size={32} />
                <h3>Công nghệ tiên phong</h3>
                <p>Sử dụng thuật toán AI để gợi ý lộ trình học tập phù hợp nhất dựa trên điểm mạnh và điểm yếu của từng học viên.</p>
              </div>

              <div className={`bento-card bg-surface-glass reveal-base reveal-scale delay-200 ${bentoRevealed ? 'revealed' : ''}`}>
                <BookOpen className="bento-icon text-success" size={32} />
                <h3>Học đi đôi với hành</h3>
                <p>Phương pháp giảng dạy tập trung vào giải quyết vấn đề và tư duy sáng tạo.</p>
              </div>
            </div>
          </div>
        </section>

        {/* CTA PREMIUM */}
        <section className="about-cta-premium" ref={ctaRef}>
          <div className="container">
            <div className={`cta-glass-card reveal-base reveal-up ${ctaRevealed ? 'revealed' : ''}`}>
              <div className="cta-content">
                <h2>Hãy trở thành một phần của Gia Sư Tinh Hoa</h2>
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

      </div>
  );
};
