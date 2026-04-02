import { useState, useEffect } from 'react';
import { OpenClassCard, type OpenClass } from './OpenClassCard';
import { Button } from '../ui/Button';
import { useNavigate } from 'react-router-dom';
import { classApi } from '../../services/classApi';
import { useScrollReveal } from '../../hooks/useScrollReveal';
import './OpenClassesSection.css';

interface OpenClassesSectionProps {
  onAuthRequired: () => void;
}

export const OpenClassesSection = ({ onAuthRequired }: OpenClassesSectionProps) => {
  const navigate = useNavigate();
  const [classes, setClasses] = useState<OpenClass[]>([]);
  const [loading, setLoading] = useState(true);
  const { ref, isRevealed } = useScrollReveal({ threshold: 0.1 });

  useEffect(() => {
    const fetchClasses = async () => {
      try {
        const data = await classApi.getOpenClasses();
        setClasses(data);
      } catch (error) {
        console.error("Failed to fetch open classes", error);
      } finally {
        setLoading(false);
      }
    };
    fetchClasses();
  }, []);

  return (
    <section className="open-classes-section" ref={ref}>
      <div className="container">
        <div className={`section-header reveal-base reveal-up ${isRevealed ? 'revealed' : ''}`}>
          <div>
            <h2 className="section-title">Lớp Học <span className="highlight-green">Mới Nhất</span></h2>
            <p className="section-subtitle">Các lớp học đang tìm kiếm gia sư phù hợp ngay hôm nay.</p>
          </div>
        </div>

        <div className="class-list-wrapper">
          {loading ? (
             <div style={{ textAlign: 'center', padding: '2rem' }}>Đang tải lớp học...</div>
          ) : (
            <div className="class-list">
              {classes.slice(0, 6).map((cl, index) => (
                <div key={cl.id} className={`reveal-base reveal-up delay-${Math.min(index * 100, 500)} ${isRevealed ? 'revealed' : ''}`}>
                  <OpenClassCard classInfo={cl} onAuthRequired={onAuthRequired} />
                </div>
              ))}
            </div>
          )}
        </div>
        
        {!loading && classes.length > 0 && (
          <div className={`section-footer reveal-base reveal-up delay-300 ${isRevealed ? 'revealed' : ''}`}>
            <Button variant="secondary" onClick={() => navigate('/classes')} className="view-all-btn mobile-full-width">
              Xem Tất Cả Lớp
            </Button>
          </div>
        )}
      </div>
    </section>
  );
};
