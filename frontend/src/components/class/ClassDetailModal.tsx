import { X, MapPin, BookOpen, Clock, Users, Hash, GraduationCap, User, CheckCircle, AlertCircle, Calendar } from 'lucide-react';
import { useState, useMemo } from 'react';

import type { OpenClassResponse } from '../../services/classApi';
import { useEscapeKey } from '../../hooks/useEscapeKey';
import './ClassDetailModal.css';

interface ClassDetailModalProps {
  cls: OpenClassResponse;
  tutorType: string | null;
  tutorFeeForLevel: number | null;
  isEligible: boolean;
  isApplied: boolean;
  onApply: (note: string) => Promise<void>;
  onClose: () => void;
}

function parseSchedule(scheduleStr: string): string {
  try {
    if (scheduleStr.startsWith('[')) {
      const slots = JSON.parse(scheduleStr);
      if (Array.isArray(slots) && slots.length > 0) {
        return slots.map((s: any) => {
          const day = s.dayOfWeek.charAt(0).toUpperCase() + s.dayOfWeek.slice(1).toLowerCase();
          const start = s.startTime.substring(0, 5);
          const end = s.endTime.substring(0, 5);
          return `${day} ${start}–${end}`;
        }).join(' • ');
      }
    }
  } catch {
    // ignore
  }
  return '';
}

function formatVnd(amount: number): string {
  return amount.toLocaleString('vi-VN') + 'đ';
}

export function ClassDetailModal({
  cls,
  tutorType,
  tutorFeeForLevel,
  isEligible,
  isApplied,
  onApply,
  onClose,
}: ClassDetailModalProps) {
  const [applying, setApplying] = useState(false);
  const [note, setNote] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);
  useEscapeKey(onClose);

  const levelFees: { level: string; fee: number }[] = useMemo(() => {
    if (!cls?.levelFees) return [];
    try { return JSON.parse(cls.levelFees) as { level: string; fee: number }[]; }
    catch { return []; }
  }, [cls]);
  const scheduleDisplay = parseSchedule(cls.schedule);
  const durationHours = cls.sessionDurationMin
    ? (cls.sessionDurationMin / 60).toFixed(1).replace('.0', '')
    : '?';

  const handleApply = async () => {
    setApplying(true);
    setError(null);
    try {
      await onApply(note.trim());
      setSuccess(true);
    } catch (err: any) {
      setError(err?.response?.data?.message || 'Đăng ký thất bại, vui lòng thử lại!');
    } finally {
      setApplying(false);
    }
  };

  return (
    <div className="cdm-overlay" onClick={onClose}>
      <div className="cdm-modal" onClick={e => e.stopPropagation()}>

        {/* Header */}
        <div className="cdm-header">
          <div className="cdm-header-left">
            <span className="cdm-class-code"><Hash size={14} />{cls.classCode}</span>
            <h2 className="cdm-title">{cls.title}</h2>
          </div>
          <button className="cdm-close" onClick={onClose}><X size={20} /></button>
        </div>

        {/* Eligibility Banner */}
        {!isEligible ? (
          <div className="cdm-banner cdm-banner--error">
            <AlertCircle size={18} />
            <span>
              Lớp này yêu cầu <strong>{cls.tutorLevelRequirement.join(', ')}</strong>.
              Hồ sơ của bạn ({tutorType || 'chưa xác thực'}) không đủ điều kiện.
            </span>
          </div>
        ) : (success || isApplied) ? (
          <div className="cdm-banner cdm-banner--success">
            <CheckCircle size={18} />
            <span>Bạn đã đăng ký nhận lớp này. Admin sẽ xem xét và liên hệ sớm!</span>
          </div>
        ) : null}

        {/* Body */}
        <div className="cdm-body">

          {/* Info grid */}
          <div className="cdm-section">
            <h3 className="cdm-section-title">📋 Thông tin lớp học</h3>
            <div className="cdm-info-grid">
              <div className="cdm-info-item">
                <BookOpen size={15} className="cdm-icon" />
                <div>
                  <span className="cdm-info-label">Môn học</span>
                  <span className="cdm-info-value">{cls.subject}</span>
                </div>
              </div>
              <div className="cdm-info-item">
                <GraduationCap size={15} className="cdm-icon" />
                <div>
                  <span className="cdm-info-label">Cấp độ</span>
                  <span className="cdm-info-value">{cls.grade}</span>
                </div>
              </div>
              <div className="cdm-info-item">
                <MapPin size={15} className="cdm-icon" />
                <div>
                  <span className="cdm-info-label">Địa điểm</span>
                  <span className="cdm-info-value">{cls.location}</span>
                </div>
              </div>
              <div className="cdm-info-item">
                <Calendar size={15} className="cdm-icon" />
                <div>
                  <span className="cdm-info-label">Khung giờ</span>
                  <span className="cdm-info-value">{cls.timeFrame || 'Linh hoạt'}</span>
                </div>
              </div>
              {scheduleDisplay && (
                <div className="cdm-info-item cdm-info-item--wide">
                  <Clock size={15} className="cdm-icon" />
                  <div>
                    <span className="cdm-info-label">Lịch học</span>
                    <span className="cdm-info-value">{scheduleDisplay}</span>
                  </div>
                </div>
              )}
              <div className="cdm-info-item">
                <Clock size={15} className="cdm-icon" />
                <div>
                  <span className="cdm-info-label">Buổi/tuần</span>
                  <span className="cdm-info-value">{cls.sessionsPerWeek} buổi ({durationHours}h/buổi)</span>
                </div>
              </div>
              <div className="cdm-info-item">
                <Users size={15} className="cdm-icon" />
                <div>
                  <span className="cdm-info-label">Số học sinh</span>
                  <span className="cdm-info-value">{cls.studentCount} em</span>
                </div>
              </div>
              <div className="cdm-info-item">
                <User size={15} className="cdm-icon" />
                <div>
                  <span className="cdm-info-label">Yêu cầu giới tính</span>
                  <span className="cdm-info-value">{cls.genderRequirement || 'Không yêu cầu'}</span>
                </div>
              </div>
            </div>
          </div>

          {/* Fee section */}
          <div className="cdm-section">
            <h3 className="cdm-section-title">💰 Học phí</h3>

            {/* Level fees table — chỉ hiển thị lương và phí nhận lớp */}
            {levelFees.length > 0 ? (
              <div className="cdm-level-fees">
                <div className="cdm-level-fees-header">
                  <span>Trình độ</span>
                  <span>Lương nhận</span>
                  <span>Phí nhận lớp</span>
                </div>
                {levelFees.map((item, idx) => {
                  const isMyLevel = tutorType != null && item.level === tutorType;
                  const admissionFee = Math.round(item.fee * cls.feePercentage / 100);
                  return (
                    <div key={idx} className={`cdm-level-fee-row ${isMyLevel ? 'my-level' : ''}`}>
                      <span className="cdm-level-badge">
                        {item.level}
                        {isMyLevel && <span className="cdm-my-level-tag">✦ Bạn</span>}
                      </span>
                      <span className="cdm-level-amount">
                        {formatVnd(item.fee)}<span className="cdm-fee-unit">/tháng</span>
                      </span>
                      <span className="cdm-admission-fee">
                        {formatVnd(admissionFee)}
                        <span className="cdm-fee-unit"> (1 lần)</span>
                      </span>
                    </div>
                  );
                })}
              </div>
            ) : tutorFeeForLevel !== null ? (
              <>
                <div className="cdm-fee-row cdm-fee-tutor">
                  <span className="cdm-fee-label">Lương nhận</span>
                  <span className="cdm-fee-amount highlight">
                    {formatVnd(tutorFeeForLevel)}<span className="cdm-fee-unit">/tháng</span>
                  </span>
                </div>
                <div className="cdm-fee-row" style={{ borderColor: 'rgba(245,158,11,0.35)' }}>
                  <span className="cdm-fee-label">Phí nhận lớp <span style={{ fontWeight: 400, fontSize: '0.78rem', color: 'var(--color-text-muted)' }}>({cls.feePercentage}% × lương, đóng 1 lần)</span></span>
                  <span style={{ fontSize: '1rem', fontWeight: 800, color: '#f59e0b' }}>
                    {formatVnd(Math.round(tutorFeeForLevel * cls.feePercentage / 100))}
                  </span>
                </div>
              </>
            ) : null}

            {/* Phí nhận lớp giải thích — chỉ hiện khi levelFees table đã show (đã có số ở table) */}
            {levelFees.length > 0 && (
              <div className="cdm-fee-note">
                ℹ️ Phí nhận lớp = {cls.feePercentage}% × lương, đóng 1 lần khi được duyệt
              </div>
            )}

            {/* Requirement tags */}
            <div className="cdm-req-tags">
              {cls.tutorLevelRequirement.map(r => (
                <span key={r} className={`cdm-req-tag ${tutorType === r ? 'active' : ''}`}>{r}</span>
              ))}
            </div>
          </div>

          {/* Note field */}
          {isEligible && !success && !isApplied && (
            <div className="cdm-section">
              <h3 className="cdm-section-title">📝 Ghi chú của bạn</h3>
              <textarea
                className="cdm-note-input"
                placeholder="Nhập lời giới thiệu hoặc ghi chú cho admin (không bắt buộc)..."
                value={note}
                onChange={e => setNote(e.target.value)}
                maxLength={500}
                rows={3}
              />
              <span className="cdm-note-count">{note.length}/500</span>
            </div>
          )}

          {/* Error message */}
          {error && (
            <div className="cdm-error"><AlertCircle size={15} /> {error}</div>
          )}
        </div>

        {/* Footer */}
        <div className="cdm-footer">
          <button className="cdm-btn-cancel" onClick={onClose}>Đóng</button>
          {isEligible && !success && !isApplied && (
            <button className="cdm-btn-apply" onClick={handleApply} disabled={applying}>
              {applying ? '⏳ Đang xử lý...' : '📝 Đăng Ký Nhận Lớp'}
            </button>
          )}
        </div>

      </div>
    </div>
  );
}
