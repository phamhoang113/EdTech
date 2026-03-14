import { Link } from 'react-router-dom';
import './Footer.css';

export const Footer = () => {
  return (
    <footer className="footer">
      <div className="container footer-container">
        <div className="footer-brand">
          <Link to="/" className="logo">
            <span className="logo-icon">🎓</span>
            <span className="logo-text">EdTech</span>
          </Link>
          <p className="footer-description">
            Nền tảng kết nối Gia sư và Học sinh hàng đầu Việt Nam. Học mọi lúc, mọi nơi.
          </p>
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
        <div className="container">
          <p>&copy; {new Date().getFullYear()} EdTech Platform. All rights reserved.</p>
        </div>
      </div>
    </footer>
  );
};
