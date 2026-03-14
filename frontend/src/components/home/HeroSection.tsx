import { Button } from '../ui/Button';
import { useNavigate } from 'react-router-dom';
import './HeroSection.css';

interface HeroSectionProps {
  onRegisterClick: () => void;
}

export const HeroSection = ({ onRegisterClick }: HeroSectionProps) => {
  const navigate = useNavigate();

  return (
    <section className="hero">
      <div className="container hero-container">
        <div className="hero-content">
          <h1 className="hero-title">
            Tìm Gia Sư Giỏi <br /> <span className="highlight">Nâng Tương Lai Sáng</span>
          </h1>
          <p className="hero-subtitle">
            Kết nối với hàng ngàn gia sư chất lượng cao trải dài trên toàn quốc. 
            Học trực tuyến hay tại nhà, tất cả đều trong tầm tay.
          </p>
          <div className="hero-actions">
            <Button size="lg" onClick={() => navigate('/search')}>
              Tìm Gia Sư Ngay
            </Button>
            <Button variant="ghost" size="lg" onClick={onRegisterClick}>
              Trở Thành Gia Sư
            </Button>
          </div>
        </div>
        <div className="hero-visual">
          <div className="visual-circle"></div>
          <div className="glass-card stat-card">
            <div className="stat-value">100+</div>
            <div className="stat-label">Môn học</div>
          </div>
          <div className="glass-card trust-card">
            <div className="trust-icon">✓</div>
            <div className="trust-label">Gia sư đã xác thực</div>
          </div>
        </div>
      </div>
    </section>
  );
};
