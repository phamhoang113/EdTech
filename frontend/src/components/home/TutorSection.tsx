import { useState, useEffect } from 'react';
import { TutorCard } from './TutorCard';
import { Button } from '../ui/Button';
import { useNavigate } from 'react-router-dom';
import { tutorPublicApi } from '../../services/tutorPublicApi';
import type { TutorPublicResponse } from '../../services/tutorPublicApi';
import { useScrollReveal } from '../../hooks/useScrollReveal';
import './TutorSection.css';

interface TutorSectionProps {
  onAuthRequired: () => void;
}

export const TutorSection = ({ onAuthRequired }: TutorSectionProps) => {
  const navigate = useNavigate();
  const [tutors, setTutors] = useState<TutorPublicResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const { ref, isRevealed } = useScrollReveal({ threshold: 0.1 });

  useEffect(() => {
    let mounted = true;
    const fetchTutors = async () => {
      try {
        const res = await tutorPublicApi.getPublicTutors({ size: 4, sort: 'rating,desc' });
        if (mounted && res.data) {
          setTutors(res.data.content);
        }
      } catch (error) {
        console.error('Lỗi khi tải danh sách gia sư:', error);
      } finally {
        if (mounted) setLoading(false);
      }
    };
    fetchTutors();
    return () => { mounted = false; };
  }, []);

  return (
    <section className="tutor-section" id="tutor-section" ref={ref}>
      <div className="container">
        <div className={`section-header reveal-base reveal-up ${isRevealed ? 'revealed' : ''}`}>
          <div>
            <h2 className="section-title">Gia Sư <span className="highlight">Nổi Bật</span></h2>
            <p className="section-subtitle">Danh sách các gia sư được đánh giá cao nhất trong hệ thống.</p>
          </div>
          <Button variant="secondary" onClick={() => navigate('/tutors')} className="view-all-btn">
            Xem Tất Cả
          </Button>
        </div>

        <div className="tutor-list-wrapper">
          {loading ? (
            <div className="loading-state">Đang tải danh sách gia sư...</div>
          ) : tutors.length === 0 ? (
            <div className="empty-state">Hiện tại chưa có dữ liệu gia sư.</div>
          ) : (
            <div className="tutor-list">
              {tutors.map((tutor, index) => (
                <div key={tutor.userId} className={`reveal-base reveal-up delay-${Math.min((index % 4) * 100, 400)} ${isRevealed ? 'revealed' : ''}`}>
                  <TutorCard 
                    tutor={{
                      id: tutor.userId,
                      name: tutor.fullName,
                      subjects: tutor.subjects || [],
                      rating: tutor.rating || 0,
                      reviews: tutor.ratingCount || 0,
                      hourlyRate: tutor.hourlyRate || 0,
                      isOnline: false,
                      avatarBase64: tutor.avatarBase64,
                      bio: tutor.bio
                    }} 
                    onAuthRequired={onAuthRequired} 
                  />
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </section>
  );
};
