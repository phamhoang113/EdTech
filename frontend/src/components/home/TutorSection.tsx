import { TutorCard } from './TutorCard';
import { Button } from '../ui/Button';
import { useNavigate } from 'react-router-dom';
import './TutorSection.css';

interface TutorSectionProps {
  onAuthRequired: () => void;
}

const mockTutors = [
  {
    id: '1',
    name: 'Nguyễn Văn A',
    subjects: ['Toán', 'Lý (THPT)'],
    rating: 5.0,
    reviews: 120,
    hourlyRate: 150000,
    isOnline: true,
  },
  {
    id: '2',
    name: 'Trần Thị B',
    subjects: ['Tiếng Anh (IELTS)'],
    rating: 4.9,
    reviews: 85,
    hourlyRate: 200000,
    isOnline: false,
  },
  {
    id: '3',
    name: 'Lê Hoàng C',
    subjects: ['Hóa Học (12)'],
    rating: 4.8,
    reviews: 56,
    hourlyRate: 120000,
    isOnline: true,
  },
  {
    id: '4',
    name: 'Phạm Thị D',
    subjects: ['Ngữ Văn (THCS)'],
    rating: 4.9,
    reviews: 94,
    hourlyRate: 100000,
    isOnline: true,
  }
];

export const TutorSection = ({ onAuthRequired }: TutorSectionProps) => {
  const navigate = useNavigate();

  return (
    <section className="tutor-section">
      <div className="container">
        <div className="section-header">
          <div>
            <h2 className="section-title">Gia Sư <span className="highlight">Nổi Bật</span></h2>
            <p className="section-subtitle">Danh sách các gia sư được đánh giá cao nhất trong tuần qua.</p>
          </div>
          <Button variant="secondary" onClick={() => navigate('/search')} className="view-all-btn">
            Xem Tất Cả
          </Button>
        </div>

        <div className="tutor-list-wrapper">
          <div className="tutor-list">
            {mockTutors.map((tutor) => (
              <TutorCard key={tutor.id} tutor={tutor} onAuthRequired={onAuthRequired} />
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};
