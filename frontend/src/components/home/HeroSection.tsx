import { useEffect, useState } from 'react';
import { Users, BookOpen, Star } from 'lucide-react';
import { Button } from '../ui/Button';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/useAuthStore';
import heroBg1 from '../../assets/photorealistic_hero.png';
import heroBg2 from '../../assets/photorealistic_hero_2.png';
import heroBg3 from '../../assets/photorealistic_hero_3.png';
import heroMobile from '../../assets/hero_mobile.webp';
import './HeroSection.css';

interface HeroSectionProps {
}

export const HeroSection = ({}: HeroSectionProps) => {
  const navigate = useNavigate();
  const { isAuthenticated, user } = useAuthStore();
  const [scrollY, setScrollY] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      setScrollY(window.scrollY);
    };
    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <section className="hero">
      <div className="hero-crossfade-bg" style={{ transform: `translateY(${scrollY * 0.4}px)` }}>
        <img src={heroBg1} alt="Online Tutoring 1" className="crossfade-img" fetchPriority="high" />
        <img src={heroBg2} alt="Online Tutoring 2" className="crossfade-img" loading="lazy" />
        <img src={heroBg3} alt="Online Tutoring 3" className="crossfade-img" loading="lazy" />
      </div>
      <div className="container hero-container">
        <div className="hero-content">
          <h1 className="hero-title animate-fade-up">
            Tìm Gia Sư Giỏi, <br /> <span className="highlight">Kiến Tạo Tương Lai</span>
          </h1>
          <p className="hero-subtitle animate-fade-up delay-100">
            Kết nối với hàng ngàn gia sư chất lượng cao trải dài trên toàn quốc. 
            <span className="mobile-hidden">Học trực tuyến hay tại nhà, tất cả đều trong tầm tay.</span>
          </p>
          <div className="hero-mobile-illustration animate-fade-up delay-200">
            <img src={heroMobile} alt="Gia sư dạy học trực tuyến" width={612} height={612} fetchPriority="high" />
          </div>
          <div className="hero-trust-badge animate-fade-up delay-300">
            <span className="trust-item">
              <Users size={16} /> 10,000+ Học sinh
            </span>
            <span className="trust-item">
              <BookOpen size={16} /> 3,000+ Gia sư
            </span>
            <span className="trust-item">
              <Star size={16} /> 4.8/5 Đánh giá
            </span>
          </div>
          <div className="hero-actions animate-fade-up delay-200">
            {(!isAuthenticated || !user) && (
              <>
                <Button size="lg" onClick={() => navigate('/classes')} style={{ padding: '0 28px', fontSize: '1rem', fontWeight: 700, boxShadow: '0 10px 25px rgba(99,102,241,0.35)' }}>
                  Xem Lớp Hiện Có
                </Button>
                <a href="https://zalo.me/0336652085" target="_blank" rel="noreferrer" style={{ 
                  display: 'inline-flex', alignItems: 'center', gap: 10, 
                  background: 'linear-gradient(135deg, #007bff, #0056b3)', color: '#fff', 
                  padding: '0 24px', height: '100%', minHeight: 48, borderRadius: 12, 
                  textDecoration: 'none', fontWeight: 700, fontSize: '0.98rem',
                  boxShadow: '0 10px 25px rgba(0, 123, 255, 0.3)', transition: 'transform 0.2s'
                }} onMouseOver={e => e.currentTarget.style.transform = 'translateY(-2px)'} onMouseOut={e => e.currentTarget.style.transform = 'translateY(0)'}>
                  <div style={{ width: 26, height: 26, background: '#fff', color: '#007bff', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '0.9rem', fontWeight: 900 }}>Z</div>
                  Mở lớp nhanh qua Zalo
                </a>
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
