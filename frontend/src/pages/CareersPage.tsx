import { Briefcase, MapPin, Clock, ArrowRight } from 'lucide-react';

import { SEO } from '../components/common/SEO';
import './CareersPage.css';

const JOB_OPENINGS: any[] = [];

export const CareersPage = () => {
  return (
    <div className="careers-page">
      <SEO
        title="Tuyển Dụng | Gia Sư Tinh Hoa"
        description="Gia nhập đội ngũ Gia Sư Tinh Hoa — Cùng kiến tạo tương lai giáo dục Việt Nam bằng công nghệ. Xem các vị trí đang tuyển dụng."
      />
      <main className="careers-main">
        {/* HERO SECTION */}
        <section className="careers-hero">
          <div className="container">
            <h1 className="careers-title">Cùng Gia Sư Tinh Hoa<br/>Kiến tạo tương lai</h1>
            <p className="careers-subtitle">
              Chúng tôi luôn tìm kiếm những nhân tài khao khát ứng dụng công nghệ để xóa bỏ rào cản giáo dục và mang đến cơ hội học tập bình đẳng cho hàng triệu học sinh Việt Nam.
            </p>
          </div>
        </section>

        {/* OPENINGS SECTION */}
        <section className="careers-openings">
          <div className="container">
            <div className="careers-section-header">
              <h2>Vị trí đang tuyển dụng</h2>
              <p>Khám phá cơ hội nghề nghiệp và gia nhập đội ngũ của chúng tôi ngay hôm nay.</p>
            </div>

            {JOB_OPENINGS.length > 0 ? (
              <div className="jobs-grid">
                {JOB_OPENINGS.map(job => (
                  <div key={job.id} className="job-card">
                    <div className="job-department">{job.department}</div>
                    <h3 className="job-title">{job.title}</h3>
                    <div className="job-meta">
                      <span className="meta-item"><MapPin size={16}/> {job.location}</span>
                      <span className="meta-item"><Clock size={16}/> {job.type}</span>
                      <span className="meta-item"><Briefcase size={16}/> {job.salary}</span>
                    </div>
                    <p className="job-desc">{job.description}</p>
                    
                    <a href="/contact" className="btn-apply text-primary">
                      Ứng tuyển ngay <ArrowRight size={18} />
                    </a>
                  </div>
                ))}
              </div>
            ) : (
              <div className="empty-jobs-state" style={{ textAlign: 'center', padding: '60px 40px', background: 'var(--color-surface)', borderRadius: '16px', border: '1px dashed var(--color-border)', marginBottom: '40px' }}>
                <Briefcase size={48} style={{ color: 'var(--color-text-muted)', marginBottom: '20px', opacity: 0.5 }} />
                <h3 style={{ fontSize: '1.4rem', color: 'var(--color-heading)', marginBottom: '12px' }}>Hiện tại chúng tôi chưa mở đợt tuyển dụng mới</h3>
                <p style={{ color: 'var(--color-text-secondary)', fontSize: '1.05rem', maxWidth: '600px', margin: '0 auto' }}>Đội ngũ Gia Sư Tinh Hoa hiện đã ổn định nhân sự cho các vị trí cốt lõi. Hãy thường xuyên quay lại trang này để cập nhật các cơ hội gia nhập mới nhất nhé!</p>
              </div>
            )}
            
            <div className="general-application">
              <h3>Không tìm thấy vị trí phù hợp?</h3>
              <p>Hãy để lại tên và ghi chú vị trí mong muốn qua <a href="/contact" style={{color: 'var(--color-primary)', fontWeight: 'bold'}}>biểu mẫu tải trang Liên hệ</a>, chúng tôi sẽ chủ động lưu trữ dữ liệu và gọi lại cho bạn ngay khi có vị trí tương ứng rộng mở.</p>
            </div>
          </div>
        </section>
      </main>

      </div>
  );
};
