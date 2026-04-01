

import { Users, BookOpen, Star } from 'lucide-react';
import { useScrollReveal } from '../../hooks/useScrollReveal';
import './StatsSection.css';

export const StatsSection = () => {
  const { ref, isRevealed } = useScrollReveal({ threshold: 0.2 });

  return (
    <section className="stats-section" ref={ref}>
      <div className="container stats-container">
        <div className={`stat-item reveal-base reveal-up ${isRevealed ? 'revealed' : ''}`}>
          <div className="stat-icon-wrapper">
            <Users className="stat-icon" />
          </div>
          <div className="stat-info">
            <h3 className="stat-number">10,000+</h3>
            <p className="stat-text">Học sinh</p>
          </div>
        </div>
        
        <div className={`stat-item reveal-base reveal-up delay-100 ${isRevealed ? 'revealed' : ''}`}>
          <div className="stat-icon-wrapper">
            <BookOpen className="stat-icon" />
          </div>
          <div className="stat-info">
            <h3 className="stat-number">3,000+</h3>
            <p className="stat-text">Gia sư</p>
          </div>
        </div>
        
        <div className={`stat-item reveal-base reveal-up delay-200 ${isRevealed ? 'revealed' : ''}`}>
          <div className="stat-icon-wrapper">
            <Star className="stat-icon star-icon" />
          </div>
          <div className="stat-info">
            <h3 className="stat-number">4.8/5</h3>
            <p className="stat-text">Đánh giá trung bình</p>
          </div>
        </div>
      </div>
    </section>
  );
};
