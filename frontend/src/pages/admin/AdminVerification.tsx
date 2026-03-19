import { useState, useEffect } from 'react';
import './AdminVerification.css';
import { adminApi } from '../../services/adminApi';
import type { AdminTutorVerificationResponse, VStatus } from '../../services/adminApi';

const STATUS_LABELS: Record<VStatus | 'all', string> = {
  all: 'Tất cả',
  UNVERIFIED: 'Chưa xác thực',
  PENDING: 'Chờ duyệt',
  APPROVED: 'Đã duyệt',
  REJECTED: 'Từ chối',
};

// Hàm helper tạo màu ngẫu nhiên cho avatar nếu bg không có
const stringToColor = (str: string) => {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  const c = (hash & 0x00ffffff).toString(16).toUpperCase();
  return '#' + '00000'.substring(0, 6 - c.length) + c;
};

export function AdminVerification() {
  const [filter, setFilter] = useState<'all' | VStatus>('all');
  const [tutors, setTutors] = useState<AdminTutorVerificationResponse[]>([]);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [lightboxSrc, setLightboxSrc] = useState<string | null>(null);
  const [rateInput, setRateInput] = useState<number>(140000);

  const fetchTutors = async () => {
    try {
      setLoading(true);
      const res = await adminApi.getTutorVerifications();
      if (res.data) {
        setTutors(res.data);
        if (res.data.length > 0 && !selectedId) {
          setSelectedId(res.data[0].id);
        }
      }
    } catch (error) {
      console.error('Lỗi khi tải danh sách gia sư:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTutors();
  }, []);

  const handleApprove = async (id: string) => {
    if (!window.confirm(`Phê duyệt với giá dạy ${rateInput.toLocaleString('vi-VN')} VNĐ/h?`)) return;
    try {
      await adminApi.approveTutor(id, rateInput);
      alert('Đã phê duyệt thành công!');
      fetchTutors();
    } catch (error) {
      console.error('Lỗi duyệt:', error);
      alert('Phê duyệt thất bại!');
    }
  };

  const handleReject = async (id: string) => {
    if (!window.confirm('Bạn có chắc chắn muốn từ chối hồ sơ này?')) return;
    try {
      await adminApi.rejectTutor(id);
      alert('Đã từ chối hồ sơ!');
      fetchTutors();
    } catch (error) {
      console.error('Lỗi từ chối:', error);
      alert('Từ chối thất bại!');
    }
  };

  const filtered = tutors.filter((t) => filter === 'all' || t.status === filter);
  const selected = tutors.find((t) => t.id === selectedId) || null;

  // Update rate default when tutor changes
  useEffect(() => {
    if (!selected) return;
    const defaults: Record<string, number> = {
      'Sinh viên': 140000,
      'Gia sư Tốt nghiệp': 180000,
      'Giáo viên': 230000,
    };
    const newDefault = defaults[selected.degree] ?? (selected.hourlyRate ? Number(selected.hourlyRate) : 140000);
    setRateInput(newDefault);
  }, [selectedId]);

  return (
    <div className="admin-verification">
      {/* List Panel */}
      <div className="admin-verification__list">
        <div className="admin-verification__list-header">
          <div className="admin-verification__list-title">Yêu cầu xác minh</div>
          <div className="admin-verification__list-filters">
            {(['all', 'PENDING', 'APPROVED', 'REJECTED'] as const).map((f) => (
              <button
                key={f}
                className={`admin-verification__filter-btn ${filter === f ? 'active' : ''}`}
                onClick={() => setFilter(f)}
              >
                {STATUS_LABELS[f]}
              </button>
            ))}
          </div>
        </div>

        <div className="admin-verification__list-items">
          {loading ? (
            <div style={{ padding: '20px', textAlign: 'center' }}>Đang tải...</div>
          ) : filtered.length === 0 ? (
            <div style={{ padding: '20px', textAlign: 'center', color: '#666' }}>Không có hồ sơ nào</div>
          ) : (
            filtered.map((tutor) => (
              <div
                key={tutor.id}
                className={`admin-verification__item ${selectedId === tutor.id ? 'active' : ''}`}
                onClick={() => setSelectedId(tutor.id)}
              >
                <div 
                  className="admin-verification__item-avatar" 
                  style={{ background: tutor.bg || stringToColor(tutor.name) }}
                >
                  {tutor.name.trim().charAt(tutor.name.trim().lastIndexOf(' ') + 1)}
                </div>
                <div className="admin-verification__item-info">
                  <div className="admin-verification__item-name">{tutor.name}</div>
                  <div className="admin-verification__item-subjects">
                    {tutor.subjects?.map((s) => (
                      <span key={s} className="admin-verification__subject-tag">{s}</span>
                    ))}
                  </div>
                  <div className="admin-verification__item-date">📅 {tutor.date}</div>
                </div>
                <div className="admin-verification__item-status">
                  <span className={`admin-badge admin-badge--${tutor.status.toLowerCase()}`}>
                    {STATUS_LABELS[tutor.status]}
                  </span>
                </div>
              </div>
            ))
          )}
        </div>
      </div>

      {/* Detail Panel */}
      <div className="admin-verification__detail">
        {selected ? (
          <>
            {/* Profile Header */}
            <div className="admin-verification__profile-header">
              <div className="admin-verification__profile-avatar" style={{ background: selected.bg || stringToColor(selected.name) }}>
                {selected.name.trim().charAt(selected.name.trim().lastIndexOf(' ') + 1)}
              </div>
              <div>
                <div className="admin-verification__profile-name">{selected.name}</div>
                <div className="admin-verification__profile-status">
                  <span className={`admin-badge admin-badge--${selected.status.toLowerCase()}`}>
                    {STATUS_LABELS[selected.status]}
                  </span>
                </div>
              </div>
            </div>

            {/* Personal Info */}
            <div className="admin-verification__section">
              <div className="admin-verification__section-title">Thông tin cá nhân</div>
              <div className="admin-verification__info-grid">
                <div className="admin-verification__info-item">
                  <div className="admin-verification__info-label">Họ và tên</div>
                  <div className="admin-verification__info-value">{selected.name}</div>
                </div>
                <div className="admin-verification__info-item">
                  <div className="admin-verification__info-label">Số điện thoại</div>
                  <div className="admin-verification__info-value">{selected.phone}</div>
                </div>
                <div className="admin-verification__info-item">
                  <div className="admin-verification__info-label">Ngày sinh</div>
                  <div className="admin-verification__info-value">{selected.dob || 'Chưa cập nhật'}</div>
                </div>
                <div className="admin-verification__info-item">
                  <div className="admin-verification__info-label">📍 Khu vực dạy</div>
                  <div className="admin-verification__info-value">{selected.location || 'Chưa cập nhật'}</div>
                </div>
              </div>
            </div>

            {/* Education */}
            <div className="admin-verification__section">
              <div className="admin-verification__section-title">Thông tin bổ sung</div>
              <div className="admin-verification__info-grid">
                <div className="admin-verification__info-item">
                  <div className="admin-verification__info-label">Thành tích / Kinh nghiệm</div>
                  <div className="admin-verification__info-value">{selected.university || 'Chưa cập nhật'}</div>
                </div>
                <div className="admin-verification__info-item">
                  <div className="admin-verification__info-label">Loại gia sư</div>
                  <div className="admin-verification__info-value">{selected.degree || 'Chưa cập nhật'}</div>
                </div>
                <div className="admin-verification__info-item">
                  <div className="admin-verification__info-label">Số năm kinh nghiệm</div>
                  <div className="admin-verification__info-value">{selected.experience || 'Chưa cập nhật'}</div>
                </div>
              </div>
            </div>

            {/* Teaching Levels */}
            <div className="admin-verification__section">
              <div className="admin-verification__section-title">Môn dạy & Cấp độ</div>
              <div className="admin-verification__info-grid">
                <div className="admin-verification__info-item">
                  <div className="admin-verification__info-label">Môn dạy</div>
                  <div className="admin-verification__info-value">{selected.subjects?.join(', ') || 'Chưa cập nhật'}</div>
                </div>
                <div className="admin-verification__info-item">
                  <div className="admin-verification__info-label">Cấp dạy</div>
                  <div className="admin-verification__info-value">{selected.levels || 'Chưa cập nhật'}</div>
                </div>
              </div>
            </div>

            {/* Documents — only show when at least one doc has a URL */}
            {selected.docs && selected.docs.some(d => d.url) && (
              <div className="admin-verification__section">
                <div className="admin-verification__section-title">Tài liệu đính kèm</div>
                <div className="admin-verification__docs-grid">
                  {selected.docs.filter(d => d.url).map((doc, idx) => {
                    const imgSrc = doc.url.startsWith('data:') || doc.url.startsWith('http')
                      ? doc.url
                      : `data:image/jpeg;base64,${doc.url}`;
                    return (
                      <div
                        key={idx}
                        onClick={() => setLightboxSrc(imgSrc)}
                        style={{ cursor: 'zoom-in', display: 'block' }}
                        title={`Xem ${doc.name} đầy đủ`}
                      >
                        <div className="admin-verification__doc-thumb" style={{ padding: '8px' }}>
                          <img
                            src={imgSrc}
                            alt={doc.name}
                            style={{
                              width: '100%',
                              maxHeight: '200px',
                              objectFit: 'contain',
                              borderRadius: '8px',
                              display: 'block',
                              marginBottom: '6px',
                            }}
                            onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
                          />
                          <span className="admin-verification__doc-name" style={{ textAlign: 'center', display: 'block', fontSize: '12px' }}>
                            {doc.icon} {doc.name}
                          </span>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {/* Giá dạy 1h */}
            <div className="admin-verification__section">
              <div className="admin-verification__section-title">💰 Giá dạy (VNĐ/giờ)</div>
              <div style={{ display: 'flex', gap: '10px', alignItems: 'center', marginTop: '8px' }}>
                <div style={{ flex: 1, position: 'relative' }}>
                  <input
                    type="text"
                    inputMode="numeric"
                    className="admin-verification__rate-input"
                    value={rateInput.toLocaleString('vi-VN')}
                    onChange={(e) => {
                      const raw = e.target.value.replace(/\./g, '').replace(/\D/g, '');
                      setRateInput(raw === '' ? 0 : Number(raw));
                    }}
                    placeholder="Nhập giá dạy..."
                  />
                  <span style={{
                    position: 'absolute', right: '12px', top: '50%',
                    transform: 'translateY(-50%)',
                    color: 'var(--color-text-muted)', fontSize: '13px',
                    fontWeight: 500, pointerEvents: 'none',
                  }}>VNĐ/h</span>
                </div>
              </div>
            </div>

            {/* Actions */}
            {selected.status === 'PENDING' && (
              <div className="admin-verification__actions">
                <button 
                  className="admin-verification__action-btn admin-verification__action-btn--approve"
                  onClick={() => handleApprove(selected.id)}
                >
                  ✓ Phê duyệt
                </button>
                <button 
                  className="admin-verification__action-btn admin-verification__action-btn--reject"
                  onClick={() => handleReject(selected.id)}
                >
                  ✕ Từ chối
                </button>
              </div>
            )}
          </>
        ) : (
          !loading && (
            <div className="admin-verification__detail-empty">
              Chọn một yêu cầu để xem chi tiết
            </div>
          )
        )}
      </div>

      {/* Lightbox overlay */}
      {lightboxSrc && (
        <div
          onClick={() => setLightboxSrc(null)}
          style={{
            position: 'fixed', inset: 0, zIndex: 9999,
            background: 'rgba(0,0,0,0.85)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'zoom-out',
          }}
        >
          <img
            src={lightboxSrc}
            alt="preview"
            onClick={(e) => e.stopPropagation()}
            style={{
              maxWidth: '90vw', maxHeight: '90vh',
              objectFit: 'contain',
              borderRadius: '12px',
              boxShadow: '0 8px 48px rgba(0,0,0,0.6)',
            }}
          />
          <button
            onClick={() => setLightboxSrc(null)}
            style={{
              position: 'absolute', top: '20px', right: '28px',
              background: 'none', border: 'none',
              color: '#fff', fontSize: '36px', cursor: 'pointer', lineHeight: 1,
            }}
          >×</button>
        </div>
      )}
    </div>
  );
}
