import { Search, Link as LinkIcon, Video } from 'lucide-react';
import './HowItWorksSection.css';

export const HowItWorksSection = () => {
  return (
    <section className="how-it-works">
      <div className="container">
        <div className="section-header center">
          <h2 className="section-title">Cách Thức Hoạt Động</h2>
          <p className="section-subtitle">Chỉ với 3 bước đơn giản để bắt đầu học tập cùng gia sư phù hợp nhất.</p>
        </div>

        <div className="steps-container">
          <div className="step-card">
            <div className="step-icon-wrapper">
              <Search className="step-icon" />
              <div className="step-number">1</div>
            </div>
            <h3 className="step-title">1. Tìm kiếm</h3>
            <p className="step-description">
              Tìm và lọc gia sư theo môn học, khu vực, xếp hạng hoặc giá tiền phù hợp với nhu cầu.
            </p>
          </div>

          <div className="step-connector"></div>

          <div className="step-card">
            <div className="step-icon-wrapper">
              <LinkIcon className="step-icon" />
              <div className="step-number">2</div>
            </div>
            <h3 className="step-title">2. Kết nối</h3>
            <p className="step-description">
              Gửi yêu cầu học, trao đổi trực tiếp với gia sư về mục tiêu và lên lịch học chi tiết.
            </p>
          </div>

          <div className="step-connector"></div>

          <div className="step-card">
            <div className="step-icon-wrapper">
              <Video className="step-icon" />
              <div className="step-number">3</div>
            </div>
            <h3 className="step-title">3. Học tập</h3>
            <p className="step-description">
              Bắt đầu quá trình dạy và học thông qua các lớp học trực tuyến qua Google Meet hoặc offline.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};
