import { Button } from '../ui/Button';
import { Star, BookOpen } from 'lucide-react';
import { useAuthStore } from '../../store/useAuthStore';
import './TutorCard.css';

interface Tutor {
  id: string;
  name: string;
  subjects: string[];
  rating: number;
  reviews: number;
  hourlyRate: number;
  isOnline: boolean;
  avatarBase64?: string;
}

interface TutorCardProps {
  tutor: Tutor;
  onAuthRequired: () => void;
}

export const TutorCard = ({ tutor, onAuthRequired }: TutorCardProps) => {
  const { isAuthenticated, setRedirectUrl } = useAuthStore();

  const handleBookClick = () => {
    if (!isAuthenticated) {
      setRedirectUrl(`/booking/${tutor.id}`);
      onAuthRequired();
      return;
    }
    // Proceed to booking
    console.log(`Navigate to /booking/${tutor.id}`);
  };

  const formattedRate = new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND'
  }).format(tutor.hourlyRate);

  return (
    <div className="tutor-card">
      <div className="tutor-header">
        <div className="avatar-wrapper">
          <div className="avatar">
            {tutor.avatarBase64 ? (
              <img src={tutor.avatarBase64} alt={tutor.name} />
            ) : (
              <span className="avatar-placeholder">{tutor.name.charAt(0)}</span>
            )}
          </div>
          <div className={`online-badge ${tutor.isOnline ? 'online' : 'offline'}`}></div>
        </div>
        <div className="tutor-info">
          <h3 className="tutor-name">{tutor.name}</h3>
          <div className="tutor-rating">
            <Star size={16} fill="var(--color-warning)" color="var(--color-warning)" />
            <span className="rating-score">{tutor.rating.toFixed(1)}</span>
            <span className="rating-count">({tutor.reviews} đánh giá)</span>
          </div>
        </div>
      </div>
      
      <div className="tutor-body">
        <div className="info-row">
          <BookOpen size={16} className="info-icon" />
          <span>{tutor.subjects.join(', ')}</span>
        </div>
        <div className="info-row highlight-rate">
          <span className="rate-value">{formattedRate}</span>
          <span className="rate-unit">/ h</span>
        </div>
      </div>

      <div className="tutor-footer">
        <Button fullWidth onClick={handleBookClick}>
          Đặt lịch học
        </Button>
      </div>
    </div>
  );
};
