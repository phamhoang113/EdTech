import { Button } from '../ui/Button';
import { MapPin, Calendar, Clock, GraduationCap } from 'lucide-react';
import { useAuthStore } from '../../store/useAuthStore';
import './OpenClassCard.css';

interface OpenClass {
  id: string;
  title: string;
  subject: string;
  grade: string;
  location: string;
  schedule: string;
  fee: number;
  timeFramte: string;
}

interface OpenClassCardProps {
  classInfo: OpenClass;
  onAuthRequired: () => void;
}

export const OpenClassCard = ({ classInfo, onAuthRequired }: OpenClassCardProps) => {
  const { isAuthenticated, setRedirectUrl } = useAuthStore();

  const handleApplyClick = () => {
    if (!isAuthenticated) {
      setRedirectUrl(`/class/${classInfo.id}`);
      onAuthRequired();
      return;
    }
    // Proceed to class application
    console.log(`Navigate to /class/${classInfo.id}`);
  };

  const formattedFee = new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND'
  }).format(classInfo.fee);

  return (
    <div className="class-card">
      <div className="class-header">
        <h3 className="class-title">{classInfo.title}</h3>
        <span className="class-fee">{formattedFee} <span className="fee-unit">/ tháng</span></span>
      </div>
      
      <div className="class-body">
        <div className="class-info-item">
          <GraduationCap size={16} className="class-icon" />
          <span>{classInfo.subject} - {classInfo.grade}</span>
        </div>
        <div className="class-info-item">
          <MapPin size={16} className="class-icon" />
          <span>{classInfo.location}</span>
        </div>
        <div className="class-info-item">
          <Calendar size={16} className="class-icon" />
          <span>{classInfo.schedule}</span>
        </div>
        <div className="class-info-item">
          <Clock size={16} className="class-icon" />
          <span>{classInfo.timeFramte}</span>
        </div>
      </div>

      <div className="class-footer">
        <Button fullWidth onClick={handleApplyClick} variant="secondary">
          Nhận Lớp Ngay
        </Button>
      </div>
    </div>
  );
};
