import { Link } from 'react-router-dom';
import { Facebook, Youtube, Phone } from 'lucide-react';
import './Footer.css';

export const Footer = () => {
  return (
    <footer className="footer">
      <div className="container footer-container">
        <div className="footer-brand">
          <div className="footer-logo">
            <Link to="/" style={{ display: 'flex', alignItems: 'center', gap: '8px', textDecoration: 'none', color: 'inherit' }}>
              <img src="/logo.png" alt="Gia Sư Tinh Hoa" style={{ height: '48px', width: 'auto', objectFit: 'contain' }} className="footer-logo-img" />
            </Link>
          </div>
          <p className="footer-description" style={{ marginTop: '12px' }}>
            Nền tảng kết nối gia sư chất lượng cao hàng đầu Việt Nam. Học mọi lúc, mọi nơi.
          </p>
          <div className="footer-social">
            <a href="https://facebook.com" target="_blank" rel="noreferrer" className="footer-social-icon" aria-label="Facebook">
              <Facebook size={18} />
            </a>
            <a href="https://zalo.me/0336652085" target="_blank" rel="noreferrer" className="footer-social-icon" aria-label="Zalo">
              Z
            </a>
            <a href="https://youtube.com" target="_blank" rel="noreferrer" className="footer-social-icon" aria-label="YouTube">
              <Youtube size={18} />
            </a>
          </div>
        </div>
        
        <div className="footer-links-group">
          <h4 className="footer-title">Về Chúng Tôi</h4>
          <ul className="footer-links">
            <li><Link to="/about">Giới thiệu</Link></li>
            <li><Link to="/contact">Liên hệ</Link></li>
            <li><Link to="/careers">Tuyển dụng</Link></li>
          </ul>
        </div>

        <div className="footer-links-group">
          <h4 className="footer-title">Hỗ Trợ</h4>
          <ul className="footer-links">
            <li><Link to="/faq">Câu hỏi thường gặp</Link></li>
            <li><Link to="/terms">Điều khoản sử dụng</Link></li>
            <li><Link to="/privacy">Chính sách bảo mật</Link></li>
          </ul>
        </div>
      </div>
      
      <div className="footer-bottom">
        <div className="container footer-bottom-content">
          <p>&copy; {new Date().getFullYear()} Gia Sư Tinh Hoa Platform. All rights reserved.</p>
          <p className="footer-hotline">
            <Phone size={14} style={{ verticalAlign: 'middle', marginRight: '4px' }} />
            Hotline: 0336 652 085
          </p>
        </div>
      </div>
    </footer>
  );
};
