import { Link } from 'react-router-dom';
import { Button } from '../ui/Button';
import { Sun, Moon } from 'lucide-react';
import { useState, useEffect } from 'react';
import './Header.css';

interface HeaderProps {
  onLoginClick: () => void;
  onRegisterClick: () => void;
}

export const Header = ({ onLoginClick, onRegisterClick }: HeaderProps) => {
  const [isDark, setIsDark] = useState(false);

  useEffect(() => {
    // Check initial theme
    const theme = document.documentElement.getAttribute('data-theme');
    setIsDark(theme === 'dark');
  }, []);

  const toggleTheme = () => {
    const newTheme = isDark ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);
    setIsDark(!isDark);
  };

  return (
    <header className="header">
      <div className="container header-container">
        <Link to="/" className="logo">
          <span className="logo-icon">🎓</span>
          <span className="logo-text">EdTech</span>
        </Link>
        
        <nav className="nav-links">
          <Link to="/" className="nav-link">Trang Chủ</Link>
          <Link to="/search" className="nav-link">Tìm Gia Sư</Link>
          <Link to="/about" className="nav-link">Về Chúng Tôi</Link>
        </nav>
        
        <div className="header-actions">
          <button className="theme-toggle" onClick={toggleTheme} aria-label="Toggle theme">
            {isDark ? <Sun size={20} /> : <Moon size={20} />}
          </button>
          
          <Button variant="ghost" onClick={onLoginClick}>
            Đăng Nhập
          </Button>
          <Button variant="primary" onClick={onRegisterClick}>
            Đăng Ký
          </Button>
        </div>
      </div>
    </header>
  );
};
