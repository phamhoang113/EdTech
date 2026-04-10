// @ts-nocheck
import { useState } from 'react';
import { Mail, Phone, MapPin, Send, CheckCircle, Loader2 } from 'lucide-react';
import { SEO } from '../components/common/SEO';
import { submitContactMessage } from '../services/contactApi';
import './ContactPage.css';

const SUBJECT_OPTIONS = [
  'Hỗ trợ tìm gia sư',
  'Trở thành gia sư',
  'Góp ý hệ thống',
  'Vấn đề thanh toán',
  'Khác',
];

export const ContactPage = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    subject: SUBJECT_OPTIONS[0],
    message: '',
  });
  const [loading, setLoading] = useState(false);
  const [success, setSuccess] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    setFormData(prev => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);

    try {
      await submitContactMessage(formData);
      setSuccess(true);
      setFormData({ name: '', email: '', subject: SUBJECT_OPTIONS[0], message: '' });
    } catch (err: any) {
      setError(err?.response?.data?.message || 'Có lỗi xảy ra, vui lòng thử lại.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="contact-page">
      <SEO 
        title="Liên Hệ | Gia Sư Tinh Hoa" 
        description="Liên hệ với đội ngũ Gia Sư Tinh Hoa để được hỗ trợ tư vấn tìm gia sư, đăng ký làm gia sư và giải đáp mọi thắc mắc."
      />
      <main className="contact-main">
        <div className="contact-header">
          <div className="container">
            <h1 className="contact-title">Liên hệ với chúng tôi</h1>
            <p className="contact-subtitle">Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn trong suốt quá trình sử dụng nền tảng Gia Sư Tinh Hoa.</p>
          </div>
        </div>

        <div className="container contact-content-wrapper">
          <div className="contact-info-section">
            <div className="contact-info-card">
              <Mail className="contact-icon text-primary" size={32} />
              <h3>Email Kỹ thuật & Hỗ trợ</h3>
              <p><a href="mailto:giasutinhhoa2026@gmail.com" style={{ color: 'var(--color-primary)', textDecoration: 'none', fontWeight: 600 }}>giasutinhhoa2026@gmail.com</a></p>
              <span className="contact-subtext">Hoặc gửi qua Form bên cạnh — phản hồi trong 24h</span>
            </div>
            
            <div className="contact-info-card">
              <Phone className="contact-icon text-success" size={32} />
              <h3>Hotline CSKH</h3>
              <p>Hỗ trợ qua Zalo</p>
              <span className="contact-subtext">Tư vấn miễn phí mỗi khi bạn cần</span>
            </div>
            
            <div className="contact-info-card">
              <MapPin className="contact-icon text-danger" size={32} />
              <h3>Phạm vi văn phòng</h3>
              <p>Hỗ trợ trực tuyến</p>
              <span className="contact-subtext">Hoạt động kết nối trên toàn quốc</span>
            </div>
          </div>

          <div className="contact-form-section">
            <div className="glass-form-card">
              <h2>Gửi tin nhắn trực tiếp</h2>

              {success ? (
                <div className="contact-success-msg">
                  <CheckCircle size={48} color="var(--color-success)" />
                  <h3>Tin nhắn đã được gửi!</h3>
                  <p>Cảm ơn bạn đã liên hệ. Chúng tôi sẽ phản hồi sớm nhất có thể.</p>
                  <button className="btn btn-primary" onClick={() => setSuccess(false)}>Gửi tin nhắn khác</button>
                </div>
              ) : (
                <form className="contact-form" onSubmit={handleSubmit}>
                  <div className="form-group">
                    <label>Họ và tên</label>
                    <input type="text" name="name" className="contact-input" placeholder="Nguyễn Văn A" value={formData.name} onChange={handleChange} required />
                  </div>
                  
                  <div className="form-group">
                    <label>SĐT hoặc Email liên hệ</label>
                    <input type="text" name="email" className="contact-input" placeholder="0345851204 hoặc email@example.com" value={formData.email} onChange={handleChange} required />
                  </div>
                  
                  <div className="form-group">
                    <label>Chủ đề</label>
                    <select name="subject" className="contact-input" value={formData.subject} onChange={handleChange}>
                      {SUBJECT_OPTIONS.map(opt => (
                        <option key={opt}>{opt}</option>
                      ))}
                    </select>
                  </div>
                  
                  <div className="form-group">
                    <label>Nội dung</label>
                    <textarea name="message" className="contact-textarea" rows={5} placeholder="Nhập nội dung tin nhắn của bạn..." value={formData.message} onChange={handleChange} required></textarea>
                  </div>

                  {error && <div className="contact-error-msg">{error}</div>}

                  <button type="submit" className="btn btn-primary btn-block contact-submit" disabled={loading}>
                    {loading ? <Loader2 size={18} className="animate-spin" /> : <Send size={18} />}
                    {loading ? 'Đang gửi...' : 'Gửi tin nhắn'}
                  </button>
                </form>
              )}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};
