import { Phone, Briefcase, Calendar, Star, CheckCircle, AlertCircle, Award, GraduationCap, X } from 'lucide-react';
import { useState } from 'react';
import { useEscapeKey } from '../../hooks/useEscapeKey';

import type { TutorApplicant } from '../../services/parentApi';
import '../../pages/dashboard/ApplicantsPage.css';

function fmtBirthYear(iso: string | null | undefined) {
  if (!iso) return '—';
  return iso.split('-')[0] ?? '—';
}

function fmtDate(iso: string | null | undefined) {
  if (!iso) return '—';
  const d = new Date(iso);
  if (isNaN(d.getTime())) return '—';
  return d.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' });
}

function statusLabel(s: string): { label: string; color: string } {
  switch (s) {
    case 'PENDING':   return { label: 'Chờ xem xét', color: '#f59e0b' };
    case 'PROPOSED':  return { label: 'Đề xuất',      color: '#6366f1' };
    case 'APPROVED':  return { label: 'Đề xuất',      color: '#6366f1' }; // for proposed tutors dashboard
    case 'SELECTED':  return { label: 'Đã chọn',      color: '#22c55e' };
    case 'REJECTED':  return { label: 'Từ chối',       color: '#ef4444' };
    default:           return { label: s,              color: '#9ca3af' };
  }
}

function InfoRow({ icon, label, value, highlight }: {
  icon: React.ReactNode; label: string; value: string; highlight?: boolean;
}) {
  return (
    <div className="ap-info-row">
      <div className="ap-info-icon">{icon}</div>
      <div className="ap-info-content">
        <span className="ap-info-label">{label}</span>
        <span className={`ap-info-value${highlight ? ' highlight' : ''}`}>{value}</span>
      </div>
    </div>
  );
}

export function SharedTutorDetailModal({ tutor, onClose, onSelect, classStatus }: {
  tutor: TutorApplicant;
  onClose: () => void;
  onSelect: (id: string, name: string) => Promise<void>;
  classStatus?: string;
}) {
  const [selecting, setSelecting] = useState(false);
  const [error, setError] = useState('');
  const [zoomImg, setZoomImg] = useState<string | null>(null);
  
  const st = statusLabel(tutor.status);
  useEscapeKey(() => zoomImg ? setZoomImg(null) : onClose());

  const handleSelect = async () => {
    setSelecting(true); setError('');
    try {
      await onSelect(tutor.applicationId, tutor.tutorName ?? 'Gia sư');
      onClose();
    } catch (e: unknown) {
      const err = e as { response?: { data?: { message?: string } } };
      setError(err?.response?.data?.message ?? 'Có lỗi xảy ra. Vui lòng thử lại.');
    } finally {
      setSelecting(false);
    }
  };

  const toSrc = (img: string) => {
    if (img.startsWith('http') || img.startsWith('/')) return img;
    return img.startsWith('data:') ? img : `data:image/png;base64,${img}`;
  };

  return (
    <div className="ap-overlay" onClick={onClose} style={{ zIndex: 10000 }}>
      {/* Set explicit zIndex in case it's opened from inside another modal */}
      <div className="ap-modal" onClick={e => e.stopPropagation()}>
        <button className="ap-modal-close" onClick={onClose}><X size={16}/></button>

        {/* Header */}
        <div className="ap-modal-head">
          <div className="ap-modal-avatar">
            {tutor.tutorName?.split(' ').pop()?.charAt(0) ?? '?'}
          </div>
          <div className="ap-modal-meta">
            <h2 className="ap-modal-name">{tutor.tutorName ?? 'Gia sư'}</h2>
            <div className="ap-modal-badge" style={{ background: 'rgba(255,255,255,0.2)', color: '#fff', border: '1px solid rgba(255,255,255,0.3)' }}>
              {st.label}
            </div>
          </div>
        </div>

        {/* Info rows */}
        <div className="ap-modal-body">
          <div className="ap-info-grid">
            <InfoRow icon={<Phone size={15}/>} label="SĐT" value={tutor.tutorPhone ?? '—'}/>
            <InfoRow icon={<Briefcase size={15}/>} label="Loại GS" value={tutor.tutorType ?? '—'}/>
            <InfoRow icon={<Calendar size={15}/>} label="Năm sinh" value={fmtBirthYear(tutor.dateOfBirth)}/>
            <InfoRow icon={<Calendar size={15}/>} label="Ngày ứng tuyển" value={fmtDate(tutor.appliedAt)}/>
          </div>

          {/* ⭐ Star rating */}
          {(() => {
            const hasReviews = tutor.ratingCount != null && tutor.ratingCount > 0;
            const displayRating = hasReviews ? Number(tutor.rating) : 5.0;
            return (
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, margin: '12px 0', padding: '8px 14px', borderRadius: 10, background: 'rgba(251,191,36,0.08)' }}>
                <Star size={16} style={{ color: '#f59e0b', fill: '#f59e0b' }}/>
                <span style={{ fontWeight: 700, color: '#b45309', fontSize: '1rem' }}>{displayRating.toFixed(1)}</span>
                <span style={{ fontSize: '0.8rem', color: '#78716c' }}>/ 5</span>
                {hasReviews ? (
                  <span style={{ fontSize: '0.78rem', color: '#a8a29e', marginLeft: 4 }}>({tutor.ratingCount} đánh giá)</span>
                ) : (
                  <span style={{ fontSize: '0.78rem', color: '#a8a29e', marginLeft: 4 }}>Mới</span>
                )}
                <div style={{ display: 'flex', gap: 2, marginLeft: 'auto' }}>
                  {[1,2,3,4,5].map(s => (
                    <Star key={s} size={14} style={{
                      color: s <= Math.round(displayRating) ? '#f59e0b' : '#d6d3d1',
                      fill: s <= Math.round(displayRating) ? '#f59e0b' : 'none',
                    }}/>
                  ))}
                </div>
              </div>
            );
          })()}

          {tutor.achievements && (
            <div className="ap-note-box" style={{ borderColor: '#a5b4fc', padding: 12, borderRadius: 12, border: '1px solid #a5b4fc', marginTop: 16 }}>
              <div className="ap-note-label" style={{ color: '#6366f1', display: 'flex', alignItems: 'center', gap: 6, fontWeight: 700, fontSize: '0.8rem', marginBottom: 8 }}>
                <GraduationCap size={14}/> BẰNG CẤP / KINH NGHIỆM
              </div>
              <p className="ap-note-text" style={{ margin: 0, fontSize: '0.9rem', color: '#374151', lineHeight: 1.5 }}>{tutor.achievements}</p>
            </div>
          )}

          {tutor.note && (
            <div className="ap-note-box" style={{ borderColor: '#10b981', padding: 12, borderRadius: 12, border: '1px solid #10b981', background: '#ecfdf5', marginTop: 16 }}>
              <div className="ap-note-label" style={{ color: '#059669', display: 'flex', alignItems: 'center', gap: 6, fontWeight: 700, fontSize: '0.8rem', marginBottom: 8 }}>
                Lời nhắn từ Admin trung tâm
              </div>
              <p className="ap-note-text" style={{ margin: 0, fontSize: '0.9rem', color: '#065f46', lineHeight: 1.5 }}>{tutor.note}</p>
            </div>
          )}

          {/* 🖼️ Ảnh bằng cấp */}
          {(() => {
            const validCerts = (tutor.certBase64s || []).filter(img => img && img.trim().length > 50);
            if (validCerts.length === 0) return null;
            return (
              <div style={{ margin: '16px 0' }}>
                <div style={{ fontSize: '0.8rem', fontWeight: 700, color: '#6366f1', marginBottom: 8, display: 'flex', alignItems: 'center', gap: 6 }}>
                  <Award size={14}/> Hình ảnh bằng cấp ({validCerts.length})
                </div>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(120px, 1fr))', gap: 8 }}>
                  {validCerts.map((img, idx) => (
                    <button key={idx} onClick={() => setZoomImg(toSrc(img))}
                      style={{ padding: 0, border: '1.5px solid #e5e7eb', borderRadius: 10, overflow: 'hidden', cursor: 'zoom-in', aspectRatio: '4/3', background: '#f9fafb' }}>
                      <img src={toSrc(img)} alt={`Bằng cấp ${idx + 1}`}
                        style={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}/>
                    </button>
                  ))}
                </div>
              </div>
            );
          })()}

          {error && (
            <div className="ap-error" style={{ display: 'flex', alignItems: 'center', gap: 6, color: '#dc2626', background: '#fef2f2', padding: 10, borderRadius: 8, fontSize: '0.85rem', marginTop: 12 }}>
              <AlertCircle size={14}/> {error}
            </div>
          )}
        </div>

        {/* Actions */}
        <div className="ap-modal-footer">
          <button className="ap-btn-cancel" onClick={onClose}>Đóng</button>
          {(!classStatus || classStatus === 'OPEN') && tutor.status !== 'SELECTED' && tutor.status !== 'REJECTED' && (
            <button className="ap-btn-select" onClick={handleSelect} disabled={selecting}>
              <CheckCircle size={15}/>
              {selecting ? 'Đang chọn...' : 'Chọn gia sư này'}
            </button>
          )}
          {tutor.status === 'SELECTED' && (
            <div className="ap-selected-badge"><CheckCircle size={14}/> Đã chọn</div>
          )}
        </div>

        {/* Lightbox phóng to ảnh bằng cấp */}
        {zoomImg && (
          <div onClick={() => setZoomImg(null)} style={{
            position: 'fixed', inset: 0, zIndex: 10001,
            background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(6px)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'zoom-out', padding: 24,
          }}>
            <button onClick={() => setZoomImg(null)} style={{
              position: 'absolute', top: 16, right: 16, width: 40, height: 40, borderRadius: '50%',
              border: 'none', background: 'rgba(255,255,255,0.9)', color: '#111', cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '1.2rem',
              boxShadow: '0 2px 10px rgba(0,0,0,0.3)',
            }}>✕</button>
            <img src={zoomImg} alt="Phóng to bằng cấp" style={{
              maxWidth: '90vw', maxHeight: '85vh', objectFit: 'contain',
              borderRadius: 12, boxShadow: '0 8px 40px rgba(0,0,0,0.5)',
            }}/>
          </div>
        )}
      </div>
    </div>
  );
}
