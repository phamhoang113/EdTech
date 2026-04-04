import { useState, useEffect } from 'react';
import { X } from 'lucide-react';
import { useOutletContext } from 'react-router-dom';

export const ArticleStickyBanner = () => {
  const [isVisible, setIsVisible] = useState(false);
  const [isDismissed, setIsDismissed] = useState(false);
  const { openRegister } = useOutletContext<{ openRegister: () => void }>();

  useEffect(() => {
    const handleScroll = () => {
      if (window.scrollY > 400 && !isDismissed) {
        setIsVisible(true);
      } else {
        setIsVisible(false);
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, [isDismissed]);

  if (!isVisible) return null;

  return (
    <>
      {isVisible && (
        <div className="article-sticky-banner">
          <button className="asb-close" onClick={() => { setIsVisible(false); setIsDismissed(true); }} aria-label="Đóng banner">
            <X size={16} />
          </button>
          <div className="asb-content">
            <div className="asb-text">
              Đừng để con tụt hậu! <strong>Hàng ngàn</strong> phụ huynh đã chọn Gia Sư Tinh Hoa giúp con tiến bộ.
            </div>
            <div className="asb-actions">
              <button onClick={openRegister} className="asb-btn" style={{ border: 'none', cursor: 'pointer', fontFamily: 'inherit' }}>
                Đăng Ký Ngay
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};
