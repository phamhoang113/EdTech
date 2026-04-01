import { Mail, Phone, MapPin, Send } from 'lucide-react';
import { Header } from '../components/layout/Header';
import { Footer } from '../components/layout/Footer';
import { useState } from 'react';
import { LoginModal } from '../components/auth/LoginModal';

import './ContactPage.css';

export const ContactPage = () => {
  const [authModalState, setAuthModalState] = useState<{ isOpen: boolean; mode: 'login' | 'register' }>({
    isOpen: false,
    mode: 'login',
  });

  const openLogin = () => setAuthModalState({ isOpen: true, mode: 'login' });
  const openRegister = () => setAuthModalState({ isOpen: true, mode: 'register' });
  const closeAuth = () => setAuthModalState((prev) => ({ ...prev, isOpen: false }));

  return (
    <div className="contact-page">
      <Header onLoginClick={openLogin} onRegisterClick={openRegister} />
      
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
              <p>Mời gửi qua Form</p>
              <span className="contact-subtext">Chúng tôi sẽ liên lạc lại trong 24h</span>
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
              <form className="contact-form" onSubmit={(e) => { e.preventDefault(); alert("Tin nhắn đã được gửi!"); }}>
                <div className="form-group">
                  <label>Họ và tên</label>
                  <input type="text" className="contact-input" placeholder="Nguyễn Văn A" required />
                </div>
                
                <div className="form-group">
                  <label>Email liên hệ</label>
                  <input type="email" className="contact-input" placeholder="email@example.com" required />
                </div>
                
                <div className="form-group">
                  <label>Chủ đề</label>
                  <select className="contact-input">
                    <option>Hỗ trợ tìm gia sư</option>
                    <option>Trở thành gia sư</option>
                    <option>Góp ý hệ thống</option>
                    <option>Vấn đề thanh toán</option>
                    <option>Khác</option>
                  </select>
                </div>
                
                <div className="form-group">
                  <label>Nội dung</label>
                  <textarea className="contact-textarea" rows={5} placeholder="Nhập nội dung tin nhắn của bạn..." required></textarea>
                </div>

                <button type="submit" className="btn btn-primary btn-block contact-submit">
                  <Send size={18} /> Gửi tin nhắn
                </button>
              </form>
            </div>
          </div>
        </div>
      </main>

      <Footer />

      {authModalState.isOpen && <LoginModal onClose={closeAuth} initialMode={authModalState.mode} />}
    </div>
  );
};
