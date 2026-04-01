import { MapPin, Calendar, Clock, GraduationCap } from 'lucide-react';
import { Button } from '../ui/Button';

import { useAuthStore } from '../../store/useAuthStore';
import './OpenClassCard.css';

export interface OpenClass {
  id: string;
  title: string;
  subject: string;
  grade: string;
  location: string;
  schedule: string;
  minTutorFee: number;
  maxTutorFee: number;
  feePercentage?: number;
  classCode?: string;
  timeFrame: string;
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

  const isRange = classInfo.minTutorFee !== classInfo.maxTutorFee;
  
  const formattedFee = isRange 
    ? `${classInfo.minTutorFee?.toLocaleString('vi-VN')}đ - ${classInfo.maxTutorFee?.toLocaleString('vi-VN')}đ`
    : `${classInfo.minTutorFee?.toLocaleString('vi-VN')}đ`;

  const formatSchedule = (scheduleRaw: string) => {
    try {
      if (!scheduleRaw || scheduleRaw === '[]') return 'Chưa xếp lịch';
      const slots = JSON.parse(scheduleRaw);
      if (Array.isArray(slots) && slots.length > 0) {
        return slots.map(s => {
          const day = s.dayOfWeek.charAt(0).toUpperCase() + s.dayOfWeek.slice(1).toLowerCase();
          const start = s.startTime.substring(0, 5);
          const end = s.endTime.substring(0, 5);
          return `${day} ${start}-${end}`;
        }).join(', ');
      }
      return scheduleRaw;
    } catch {
      return scheduleRaw;
    }
  };

  return (
    <div className="class-card">
      <div className="class-header">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' }}>
          <span style={{ fontSize: '0.85rem', color: '#6b7280', fontWeight: 500 }}>
            #{classInfo.classCode || classInfo.id.substring(0,6).toUpperCase()}
          </span>
          <span style={{ fontSize: '0.75rem', backgroundColor: '#f26a21', color: '#fff', padding: '2px 8px', borderRadius: '12px', fontWeight: 600 }}>
            PHÍ NHẬN LỚP: {classInfo.feePercentage || 30}%
          </span>
        </div>
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
          <span>{formatSchedule(classInfo.schedule)}</span>
        </div>
        <div className="class-info-item">
          <Clock size={16} className="class-icon" />
          <span>{classInfo.timeFrame}</span>
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
