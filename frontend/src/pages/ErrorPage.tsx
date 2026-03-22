import { useRouteError, isRouteErrorResponse, useNavigate, Link } from 'react-router-dom';
import './ErrorPage.css';

/** Bắt tất cả loại lỗi từ React Router: 404, 403, 500, network error... */
export default function ErrorPage() {
  const error = useRouteError();
  const navigate = useNavigate();

  let status = 500;
  let title = 'Đã có lỗi xảy ra';
  let description = 'Có thể máy chủ đang gặp sự cố. Vui lòng thử lại sau.';

  if (isRouteErrorResponse(error)) {
    status = error.status;
    if (status === 404) {
      title = 'Không tìm thấy trang';
      description = 'Trang bạn truy cập không tồn tại hoặc đã bị xóa.';
    } else if (status === 403) {
      title = 'Không có quyền truy cập';
      description = 'Bạn không có quyền xem trang này.';
    } else if (status === 401) {
      title = 'Chưa đăng nhập';
      description = 'Vui lòng đăng nhập để tiếp tục.';
    }
  }

  const CONFIG: Record<number, { emoji: string; accent: string }> = {
    404: { emoji: '🔍', accent: '#6366f1' },
    403: { emoji: '🔒', accent: '#f59e0b' },
    401: { emoji: '🔑', accent: '#f59e0b' },
    500: { emoji: '⚡', accent: '#ef4444' },
  };

  const cfg = CONFIG[status] ?? CONFIG[500];

  return (
    <div className="error-page">
      {/* Background decoration */}
      <div className="error-page__bg-circle error-page__bg-circle--1" style={{ background: cfg.accent }} />
      <div className="error-page__bg-circle error-page__bg-circle--2" style={{ background: cfg.accent }} />

      <div className="error-page__card">
        {/* Emoji */}
        <div className="error-page__emoji" style={{ background: cfg.accent + '18' }}>
          {cfg.emoji}
        </div>

        {/* Status code */}
        <div className="error-page__code" style={{ color: cfg.accent }}>{status}</div>

        {/* Title & description */}
        <h1 className="error-page__title">{title}</h1>
        <p className="error-page__desc">{description}</p>

        {/* Actions */}
        <div className="error-page__actions">
          <button className="error-page__btn error-page__btn--primary" style={{ background: cfg.accent }} onClick={() => navigate(-1)}>
            ← Quay lại
          </button>
          <Link to="/" className="error-page__btn error-page__btn--secondary">
            🏠 Về trang chủ
          </Link>
          {status === 401 && (
            <Link to="/login" className="error-page__btn error-page__btn--primary" style={{ background: cfg.accent }}>
              🔑 Đăng nhập
            </Link>
          )}
        </div>

        {/* Dev detail */}
        {import.meta.env.DEV && error instanceof Error && (
          <details className="error-page__detail">
            <summary>Chi tiết lỗi (dev mode)</summary>
            <pre>{error.message}{'\n'}{error.stack}</pre>
          </details>
        )}
      </div>
    </div>
  );
}
