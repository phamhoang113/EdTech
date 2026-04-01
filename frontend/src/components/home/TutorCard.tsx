

import { Star, BookOpen } from 'lucide-react';
import './TutorCard.css';

interface Tutor {
  id: string;
  name: string;
  subjects: string[];
  rating: number;
  reviews: number;
  hourlyRate?: number;
  isOnline: boolean;
  avatarBase64?: string;
  bio?: string;
}

interface TutorCardProps {
  tutor: Tutor;
  onAuthRequired?: () => void;
}

export const TutorCard = ({ tutor }: TutorCardProps) => {
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
        {tutor.bio && (
          <div className="info-row tutor-bio">
            <span className="bio-text">{tutor.bio.length > 80 ? tutor.bio.substring(0, 80) + '...' : tutor.bio}</span>
          </div>
        )}
      </div>
    </div>
  );
};
