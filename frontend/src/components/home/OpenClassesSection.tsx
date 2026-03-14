import { OpenClassCard } from './OpenClassCard';
import { Button } from '../ui/Button';
import { useNavigate } from 'react-router-dom';
import './OpenClassesSection.css';

interface OpenClassesSectionProps {
  onAuthRequired: () => void;
}

const mockClasses = [
  {
    id: 'c1',
    title: 'Tìm Gia Sư Dạy Toán Lớp 10 Bồi Dưỡng Học Sinh Giỏi',
    subject: 'Toán',
    grade: 'Lớp 10',
    location: 'Quận Cầu Giấy, Hà Nội (Học online)',
    schedule: '2 buổi / tuần (Tối T3, T5)',
    fee: 2000000,
    timeFramte: 'Bắt đầu tuần tới'
  },
  {
    id: 'c2',
    title: 'Giao Tiếp Tiếng Anh Cơ Bản Luyện Speaking',
    subject: 'Tiếng Anh',
    grade: 'Sinh Viên',
    location: 'Quận 1, TP. HCM (Tại nhà)',
    schedule: '3 buổi / tuần (Linh hoạt)',
    fee: 3500000,
    timeFramte: 'Gấp'
  },
  {
    id: 'c3',
    title: 'Ôn Thi Đại Học Môn Vật Lý Khối A',
    subject: 'Vật Lý',
    grade: 'Lớp 12',
    location: 'Học Trực Tuyến',
    schedule: '2 buổi / tuần',
    fee: 2500000,
    timeFramte: 'Trong tháng này'
  }
];

export const OpenClassesSection = ({ onAuthRequired }: OpenClassesSectionProps) => {
  const navigate = useNavigate();

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
          <div className="class-list">
            {mockClasses.map((cl) => (
              <OpenClassCard key={cl.id} classInfo={cl} onAuthRequired={onAuthRequired} />
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};
