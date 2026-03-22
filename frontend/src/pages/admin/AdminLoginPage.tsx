import { useState, type FormEvent } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { Sun, Moon, User, Lock, Eye, EyeOff, ShieldCheck } from 'lucide-react';
import { loginApi } from '../../services/authApi';
import { useAuthStore } from '../../store/useAuthStore';
import './AdminLoginPage.css';

export function AdminLoginPage() {
  const navigate = useNavigate();
  const { login } = useAuthStore();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [remember, setRemember] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const [theme, setTheme] = useState<'light' | 'dark'>(
    () => (document.documentElement.getAttribute('data-theme') as 'light' | 'dark') ?? 'light'
  );

  const toggleTheme = () => {
    const next = theme === 'light' ? 'dark' : 'light';
    setTheme(next);
    document.documentElement.setAttribute('data-theme', next);
    localStorage.setItem('theme', next);
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError('');

    if (!username.trim() || !password.trim()) {
      setError('Vui lòng nhập đầy đủ thông tin đăng nhập.');
      return;
    }

    setLoading(true);

    try {
      const data = await loginApi({ phone: username, password });
      
      if (data.role !== 'ADMIN') {
        setError('Tài khoản này không có quyền truy cập Admin.');
        setLoading(false);
        return;
      }
      
      login(
        { phone: username, role: data.role, fullName: data.fullName, avatarBase64: data.avatarBase64 ?? undefined },
        data.accessToken,
        data.refreshToken
      );
      
      navigate('/admin/dashboard');
    } catch (err: unknown) {
      const msg = (err as any).response?.data?.message || 'Đăng nhập thất bại, vui lòng kiểm tra lại thông tin.';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="admin-login">
      {/* ── Left Hero ── */}
      <div className="admin-login__hero">
        <div className="admin-login__hero-content">
          <Link to="/" className="admin-login__hero-logo" style={{ textDecoration: 'none', color: 'inherit', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <span>🎓</span> EdTech Admin
          </Link>
          <p className="admin-login__hero-tagline">
            Quản lý nền tảng giáo dục thông minh.<br />
            Theo dõi, kiểm duyệt và vận hành mọi thứ từ một nơi.
          </p>

          <div className="admin-login__hero-stats">
            <div className="admin-login__hero-stat">
              <div className="admin-login__hero-stat-icon">👨‍🏫</div>
              <div className="admin-login__hero-stat-value">1,200+</div>
              <div className="admin-login__hero-stat-label">Gia sư</div>
            </div>
            <div className="admin-login__hero-stat">
              <div className="admin-login__hero-stat-icon">👩‍🎓</div>
              <div className="admin-login__hero-stat-value">5,000+</div>
              <div className="admin-login__hero-stat-label">Học sinh</div>
            </div>
            <div className="admin-login__hero-stat">
              <div className="admin-login__hero-stat-icon">📚</div>
              <div className="admin-login__hero-stat-value">100+</div>
              <div className="admin-login__hero-stat-label">Môn học</div>
            </div>
          </div>

          <div className="admin-login__hero-illustration">
            <div className="admin-login__deco-card">✓ Gia sư đã xác thực</div>
            <div className="admin-login__deco-card">📊 Phân tích realtime</div>
            <div className="admin-login__deco-card">🔒 Bảo mật cao</div>
            <div className="admin-login__deco-card">💰 Quản lý thanh toán</div>
          </div>
        </div>
      </div>

      {/* ── Right Form ── */}
      <div className="admin-login__form-section">
        <button
          className="admin-login__theme-toggle"
          onClick={toggleTheme}
          title={theme === 'light' ? 'Chuyển sang giao diện tối' : 'Chuyển sang giao diện sáng'}
        >
          {theme === 'light' ? <Moon size={18} /> : <Sun size={18} />}
        </button>

        <div className="admin-login__form-container">
          <h1 className="admin-login__form-title">Đăng nhập Admin</h1>
          <p className="admin-login__form-subtitle">Truy cập bảng điều khiển quản trị</p>

          {error && (
            <div className="admin-login__error">
              ⚠️ {error}
            </div>
          )}

          <form onSubmit={handleSubmit}>
            <div className="admin-login__field">
              <label className="admin-login__label">Tên đăng nhập</label>
              <div className="admin-login__input-wrapper">
                <User size={18} className="admin-login__input-icon" />
                <input
                  id="admin-username"
                  type="text"
                  className="admin-login__input"
                  placeholder="Nhập tên đăng nhập..."
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  autoComplete="username"
                />
              </div>
            </div>

            <div className="admin-login__field">
              <label className="admin-login__label">Mật khẩu</label>
              <div className="admin-login__input-wrapper">
                <Lock size={18} className="admin-login__input-icon" />
                <input
                  id="admin-password"
                  type={showPassword ? 'text' : 'password'}
                  className="admin-login__input"
                  placeholder="Nhập mật khẩu..."
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  autoComplete="current-password"
                />
                <button
                  type="button"
                  className="admin-login__password-toggle"
                  onClick={() => setShowPassword(!showPassword)}
                  tabIndex={-1}
                >
                  {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                </button>
              </div>
            </div>

            <div className="admin-login__extras">
              <label className="admin-login__remember">
                <input
                  type="checkbox"
                  checked={remember}
                  onChange={(e) => setRemember(e.target.checked)}
                />
                Ghi nhớ đăng nhập
              </label>
              <button type="button" className="admin-login__forgot">
                Quên mật khẩu?
              </button>
            </div>

            <button
              type="submit"
              className="admin-login__submit"
              disabled={loading}
            >
              {loading ? 'Đang đăng nhập...' : 'Đăng Nhập'}
            </button>
          </form>

          <div className="admin-login__security">
            <ShieldCheck size={16} />
            Kết nối bảo mật SSL
          </div>
        </div>
      </div>
    </div>
  );
}
