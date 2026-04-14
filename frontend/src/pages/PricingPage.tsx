import { Sparkles, Star, CheckCircle, ArrowRight, Users, Briefcase } from 'lucide-react';
import { useOutletContext, Link } from 'react-router-dom';
import { useScrollReveal } from '../hooks/useScrollReveal';
import type { PublicLayoutContext } from '../components/layout/PublicLayout';
import { SEO } from '../components/common/SEO';
import './PricingPage.css';

/* ─── Pricing Data ─── */

interface TutorTypePricing {
  label: string;
  description: string;
  icon: React.ReactNode;
  color: string;
  price: string;
  note?: string;
  highlights: string[];
}

const TUTOR_TYPES: TutorTypePricing[] = [
  {
    label: 'Sinh viên',
    description: 'Sinh viên giỏi từ các trường ĐH top đầu (Bách Khoa, Ngoại Thương, Sư Phạm...)',
    icon: <Users size={28} />,
    color: '#3b82f6', // blue
    price: '1.200.000đ',
    note: 'Lựa chọn tối ưu cho việc kèm bài hàng ngày',
    highlights: ['Nhiệt tình, gần gũi như anh/chị', 'Nắm bắt các phương pháp học mới', 'Học phí cực kỳ tối ưu'],
  },
  {
    label: 'Gia sư Tốt nghiệp',
    description: 'Cử nhân, Kỹ sư đã tốt nghiệp, có nhiều năm kinh nghiệm đi dạy kèm.',
    icon: <Briefcase size={28} />,
    color: '#10b981', // emerald
    price: '1.800.000đ',
    note: 'Kiến thức vững chắc, nghiêm túc',
    highlights: ['Kinh nghiệm sư phạm dày dặn', 'Tác phong chuyên nghiệp', 'Cam kết thời gian ổn định'],
  },
  {
    label: 'Giáo viên',
    description: 'Giáo viên đang giảng dạy tại trường phổ thông hoặc các trung tâm luyện thi uy tín.',
    icon: <Star size={28} />,
    color: '#f59e0b', // amber
    price: '2.500.000đ',
    note: 'Chuyên gia bài bản, bứt phá thành tích',
    highlights: ['Giáo án chuẩn mực bộ GD&ĐT', 'Dày dặn kinh nghiệm nắm bắt tâm lý', 'Chuyên gia luyện thi vượt cấp'],
  },
];

const INCLUDED_FEATURES = [
  'Gia sư đã xác minh hồ sơ bằng cấp',
  'Lịch học linh hoạt theo lịch cá nhân',
  'Trực tiếp chọn gia sư hoặc để trung tâm tìm giúp',
  'Học thử miễn phí để đánh giá độ phù hợp',
  'Đổi gia sư miễn phí nếu không ưng ý',
  'Bảo mật 100% khi thanh toán học phí',
];

export const PricingPage = () => {
  const { openRegister } = useOutletContext<PublicLayoutContext>();
  const { ref: tableRef, isRevealed: tableRevealed } = useScrollReveal();
  const { ref: ctaRef, isRevealed: ctaRevealed } = useScrollReveal();

  return (
    <div className="pricing-page bg-surface">
      <SEO
        title="Học Phí Gia Sư Theo Cấp Độ | Gia Sư Tinh Hoa"
        description="Bảng học phí tham khảo theo trình độ gia sư: Sinh viên từ 1.2tr, Tốt nghiệp từ 1.8tr, Giáo viên từ 2.5tr/tháng. Minh bạch, không phí ẩn."
        keywords="học phí gia sư, bảng giá gia sư, chi phí thuê gia sư, giá gia sư tại nhà"
      />
      <main className="pricing-main">
        {/* ─── HERO ─── */}
        <section className="pricing-hero">
          <div className="pricing-hero-glow pricing-hero-glow-1" />
          <div className="pricing-hero-glow pricing-hero-glow-2" />

          <div className="container pricing-hero-content">
            <div className="badge-pill animate-fade-up">
              <Sparkles size={16} className="badge-icon" />
              <span>Phân loại rõ ràng — Không chênh lệch phí ẩn</span>
            </div>
            <h1 className="pricing-hero-title animate-fade-up delay-100">
              Học phí theo <span className="text-gradient">Chất lượng Gia sư</span>
            </h1>
            <p className="pricing-hero-sub animate-fade-up delay-200">
              Mức học phí cơ sở (tham khảo) áp dụng cho tần suất 2 buổi/tuần &mdash; 90 phút/buổi. Tùy thuộc vào yêu cầu đặc biệt của phụ huynh hoặc độ khó của môn học mà giá có thể dao động nhẹ.
            </p>
          </div>
        </section>

        {/* ─── PRICING CARDS ─── */}
        <section className="pricing-cards-section" ref={tableRef}>
          <div className="container">
            {/* Cards grid */}
            <div className="pricing-grid-3">
              {TUTOR_TYPES.map((type, idx) => (
                <div
                  key={type.label}
                  className={`pricing-card reveal-base reveal-scale ${tableRevealed ? 'revealed' : ''}`}
                  style={{ transitionDelay: `${idx * 150}ms`, '--accent': type.color } as React.CSSProperties}
                >
                  <div className="pricing-card-header">
                    <div className="pricing-card-icon">{type.icon}</div>
                    <h3>{type.label}</h3>
                    <p className="pricing-card-desc">{type.description}</p>
                  </div>

                  <div className="pricing-card-body">
                    <div className="pricing-tier-main">
                      <span className="tier-prefix">Từ</span>
                      <span className="tier-price">{type.price}</span>
                      <span className="tier-unit">/tháng</span>
                    </div>

                    <p className="pricing-card-note">✨ {type.note}</p>

                    <div className="pricing-highlights">
                      {type.highlights.map((hlt, hIdx) => (
                         <div key={hIdx} className="highlight-item">
                           <CheckCircle size={14} className="highlight-check" />
                           <span>{hlt}</span>
                         </div>
                      ))}
                    </div>
                  </div>

                  <div className="pricing-card-footer">
                    <button className="btn-pricing-action" onClick={openRegister}>
                      Tìm {type.label} ngay <ArrowRight size={16} />
                    </button>
                  </div>
                </div>
              ))}
            </div>

            {/* Disclaimer */}
            <p className="pricing-disclaimer">
              * Đây là mức lương cơ sở ước tính do hệ thống đề xuất. Học sinh/Phụ huynh hoàn toàn có thể trao đổi, thống nhất mức phí cụ thể với gia sư thông qua hợp đồng thỏa thuận chung.
            </p>
          </div>
        </section>

        {/* ─── INCLUDED FEATURES ─── */}
        <section className="pricing-features-section">
          <div className="container">
            <h2 className="section-title">Đã bao gồm trong học phí</h2>
            <div className="pricing-features-grid">
              {INCLUDED_FEATURES.map((feature) => (
                <div key={feature} className="pricing-feature-item">
                  <CheckCircle size={20} className="feature-check" />
                  <span>{feature}</span>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* ─── CTA ─── */}
        <section className="pricing-cta" ref={ctaRef}>
          <div className="container">
            <div className={`pricing-cta-card reveal-base reveal-up ${ctaRevealed ? 'revealed' : ''}`}>
              <h2>Sẵn sàng bắt đầu?</h2>
              <p>
                Đăng ký miễn phí để tìm gia sư phù hợp hoặc xem 
                <Link to="/classes" className="pricing-cta-link"> các lớp hiện có</Link>.
              </p>
              <div className="pricing-cta-buttons">
                <button className="btn btn-primary btn-lg cta-btn-glow" onClick={openRegister}>
                  Mở lớp ngay
                </button>
                <Link to="/classes" className="btn btn-ghost btn-lg">
                  Xem lớp hiện có
                </Link>
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
};
