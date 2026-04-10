import { Phone } from 'lucide-react';
import { useLocation } from 'react-router-dom';
import './FloatingContact.css';

export const FloatingContact = () => {
  const location = useLocation();
  const isHomeOrAbout = location.pathname === '/' || location.pathname === '/about';
  const isArticlePage = location.pathname.startsWith('/bai-viet');
  
  return (
    <div className={`floating-contact ${!isHomeOrAbout ? 'hide-on-mobile' : ''} ${isArticlePage ? 'hide-on-desktop' : ''}`}>
      <a href="tel:0345851204" className="float-btn phone-btn" aria-label="Call us">
        <div className="btn-icon">
          <Phone fill="currentColor" size={20} />
        </div>
        <span className="btn-text">Gọi Hotline</span>
      </a>
      
      <a href="https://zalo.me/0345851204" target="_blank" rel="noreferrer" className="float-btn zalo-btn" aria-label="Chat via Zalo">
        <div className="btn-icon">
          Z
        </div>
        <span className="btn-text">Zalo Chat</span>
      </a>
    </div>
  );
};
