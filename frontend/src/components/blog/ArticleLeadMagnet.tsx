import { useState } from 'react';
import { PhoneCall, CheckCircle } from 'lucide-react';
import { ConsultationModal } from './ConsultationModal';

export const ArticleLeadMagnet = () => {
  const [showModal, setShowModal] = useState(false);

  return (
    <>
      <div className="article-lead-magnet">
        <div className="alm-icon">
          <PhoneCall size={32} />
        </div>
        <h3>Ba mẹ đang gặp khó khăn trong định hướng cho con?</h3>
        <p>Nhận ngay tư vấn lộ trình học tập miễn phí từ chuyên gia giáo dục của Gia Sư Tinh Hoa.</p>
        <ul className="alm-benefits">
          <li><CheckCircle size={16} /> Phân tích năng lực của con miễn phí</li>
          <li><CheckCircle size={16} /> Định hướng lộ trình học cá nhân hóa</li>
          <li><CheckCircle size={16} /> Lên phương pháp chọn bộ gia sư chất lượng</li>
        </ul>
        <button onClick={() => setShowModal(true)} className="alm-btn" style={{ border: 'none', cursor: 'pointer', fontFamily: 'inherit' }}>
          Đăng Ký Nhận Tư Vấn Ngay
        </button>
      </div>
      <ConsultationModal isOpen={showModal} onClose={() => setShowModal(false)} />
    </>
  );
};
