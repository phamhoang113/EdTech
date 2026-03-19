import { Button } from '../ui/Button';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import heroBg1 from '../../assets/photorealistic_hero.png';
import heroBg2 from '../../assets/photorealistic_hero_2.png';
import heroBg3 from '../../assets/photorealistic_hero_3.png';
import './HeroSection.css';

interface HeroSectionProps {
  onRegisterClick: () => void;
}

export const HeroSection = ({ onRegisterClick }: HeroSectionProps) => {
  const navigate = useNavigate();
  const { isAuthenticated, user } = useAuthStore();

  return (
    <section className="hero">
      <div className="hero-crossfade-bg">
        <img src={heroBg1} alt="Online Tutoring 1" className="crossfade-img" />
        <img src={heroBg2} alt="Online Tutoring 2" className="crossfade-img" />
        <img src={heroBg3} alt="Online Tutoring 3" className="crossfade-img" />
      </div>
      <div className="container hero-container">
        <div className="hero-content">
          <h1 className="hero-title">
            Tìm Gia Sư Giỏi, <br /> <span className="highlight">Kiến Tạo Tương Lai</span>
          </h1>
          <p className="hero-subtitle">
            Kết nối với hàng ngàn gia sư chất lượng cao trải dài trên toàn quốc. 
            <span className="mobile-hidden">Học trực tuyến hay tại nhà, tất cả đều trong tầm tay.</span>
          </p>
          <div className="hero-actions">
            {(!isAuthenticated || !user) && (
              <>
                <Button size="lg" onClick={() => navigate('/search')}>
                  Tìm Gia Sư Ngay
                </Button>
                <Button variant="ghost" size="lg" onClick={onRegisterClick}>
                  Trở Thành Gia Sư
                </Button>
              </>
            )}
          </div>
        </div>
        <div className="hero-visual">
          <div className="visual-circle"></div>
        </div>
      </div>
    </section>
  );
};
