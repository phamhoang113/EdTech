import { useState, useEffect } from 'react';
import { OpenClassCard, type OpenClass } from './OpenClassCard';
import { Button } from '../ui/Button';
import { useNavigate } from 'react-router-dom';
import { classApi } from '../../services/classApi';
import './OpenClassesSection.css';

interface OpenClassesSectionProps {
  onAuthRequired: () => void;
}

export const OpenClassesSection = ({ onAuthRequired }: OpenClassesSectionProps) => {
  const navigate = useNavigate();
  const [classes, setClasses] = useState<OpenClass[]>([]);
  const [loading, setLoading] = useState(true);

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
    <section className="open-classes-section">
      <div className="container">
        <div className="section-header">
          <div>
            <h2 className="section-title">Lớp Học <span className="highlight-green">Mới Nhất</span></h2>
            <p className="section-subtitle">Các lớp học đang tìm kiếm gia sư phù hợp ngay hôm nay.</p>
          </div>
          <Button variant="secondary" onClick={() => navigate('/classes')} className="view-all-btn">
            Xem Tất Cả Lớp
          </Button>
        </div>

        <div className="class-list-wrapper">
          {loading ? (
             <div style={{ textAlign: 'center', padding: '2rem' }}>Đang tải lớp học...</div>
          ) : (
            <div className="class-list">
              {classes.slice(0, 6).map((cl) => (
                <OpenClassCard key={cl.id} classInfo={cl} onAuthRequired={onAuthRequired} />
              ))}
            </div>
          )}
        </div>
      </div>
    </section>
  );
};
