import { useState, useEffect } from 'react';
import { useAuthStore } from '../../store/useAuthStore';
import { classApi } from '../../services/classApi';
import apiClient from '../../services/apiClient';
import './VerificationModal.css';

interface VerificationModalProps {
  onSuccess: () => void;
}


const MAX_SELECT = 5;

export const TutorVerificationModal = ({ onSuccess }: VerificationModalProps) => {
  const { user } = useAuthStore();
  const [tutorType, setTutorType] = useState('STUDENT');
  const [dateOfBirth, setDateOfBirth] = useState('');
  const [idCardNumber, setIdCardNumber] = useState('');
  const [degree, setDegree] = useState<File | null>(null);
  const [subjects, setSubjects] = useState<string[]>([]);
  const [teachingLevels, setTeachingLevels] = useState<string[]>([]);
  const [achievements, setAchievements] = useState('');
  const [experienceYears, setExperienceYears] = useState(0);
  const [location, setLocation] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const [availableSubjects, setAvailableSubjects] = useState<string[]>([]);
  const [availableGradeLevels, setAvailableGradeLevels] = useState<string[]>([]);

  useEffect(() => {
    classApi.getClassFilters().then(data => {
      if (data?.subjects) {
        setAvailableSubjects(data.subjects.filter((s: string) => s !== 'Khác'));
      }
      if (data?.levels) {
        // Filter out 'Khác' — tutors select concrete grade levels
        setAvailableGradeLevels(data.levels.filter((l: string) => l !== 'Khác'));
      }
    }).catch(() => {
      setAvailableSubjects(['Toán', 'Vật Lý', 'Hóa Học', 'Sinh Học', 'Ngữ Văn', 'Tiếng Anh', 'Tin Học']);
      setAvailableGradeLevels(['Mầm non','Lớp 1','Lớp 2','Lớp 3','Lớp 4','Lớp 5','Lớp 6','Lớp 7','Lớp 8','Lớp 9','Lớp 10','Lớp 11','Lớp 12','Đại học']);
    });
  }, []);

  const toggleSelection = (
    item: string,
    list: string[],
    setList: (val: string[]) => void
  ) => {
    if (list.includes(item)) {
      setList(list.filter(v => v !== item));
    } else if (list.length < MAX_SELECT) {
      setList([...list, item]);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!idCardNumber.trim()) {
      setError('Vui lòng nhập số CCCD / CMND.');
      return;
    }
    if (!degree) {
      setError('Vui lòng tải lên ảnh chứng từ phù hợp.');
      return;
    }
    if (subjects.length === 0) {
      setError('Vui lòng chọn ít nhất 1 môn học sở trường.');
      return;
    }
    if (teachingLevels.length === 0) {
      setError('Vui lòng chọn ít nhất 1 lớp giảng dạy.');
      return;
    }

    setIsSubmitting(true);
    setError('');

    try {
      const formData = new FormData();
      formData.append('tutorType', tutorType);
      formData.append('dateOfBirth', dateOfBirth);
      formData.append('idCardNumber', idCardNumber);
      formData.append('degree', degree);
      subjects.forEach(s => formData.append('subjects', s));
      teachingLevels.forEach(l => formData.append('teachingLevels', l));
      formData.append('achievements', achievements);
      formData.append('experienceYears', String(experienceYears));
      if (location.trim()) formData.append('location', location.trim().substring(0, 500));

      // apiClient tự động đính token từ interceptor và dùng base URL http://localhost:8080
      await apiClient.post('/api/v1/tutors/profile/verify', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });

      setSubmitted(true);
      // Tự đóng modal sau 2 giây
      setTimeout(() => onSuccess(), 2000);
    } catch (err: any) {
      const msg = err.response?.data?.message || err.message || 'Có lỗi xảy ra khi gửi xác thực.';
      setError(msg);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="verification-overlay">
      <div className="verification-modal">

        {submitted ? (
          <div className="verify-success-screen">
            <div className="verify-success-icon">✅</div>
            <h2>Gửi xác thực thành công!</h2>
            <p>Hồ sơ của bạn đã được gửi. Vui lòng chờ Quản trị viên phê duyệt.</p>
            <p className="verify-success-note">Đang đóng tự động...</p>
          </div>
        ) : (
          <>
        <div className="modal-header">
          <h2>Xác thực thông tin Gia sư</h2>
          <p>
            Xin chào <strong>{user?.fullName}</strong>! Để bắt đầu nhận lớp, bạn cần hoàn thành xác thực hồ sơ.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="verification-form">

          {/* 1. Loại gia sư */}
          <div className="form-group">
            <label>Loại gia sư</label>
            <select
              value={tutorType}
              onChange={(e) => { setTutorType(e.target.value); setDegree(null); }}
              className="v-input"
            >
              <option value="STUDENT">Sinh viên</option>
              <option value="TEACHER">Giáo viên</option>
              <option value="GRADUATED">Gia sư Tốt nghiệp</option>
            </select>
          </div>

          {/* 2. Ngày tháng năm sinh */}
          <div className="form-group">
            <label className="required">
              Ngày tháng năm sinh <span className="info-text">(Bắt buộc)</span>
            </label>
            <input
              type="date"
              value={dateOfBirth}
              max={new Date(new Date().setFullYear(new Date().getFullYear() - 18)).toISOString().split('T')[0]}
              onChange={(e) => setDateOfBirth(e.target.value)}
              required
              className="v-input"
            />
          </div>

          {/* 2. Số CCCD / CMND */}
          <div className="form-group">
            <label className="required">
              Số CCCD / CMND <span className="info-text">(Bắt buộc)</span>
            </label>
            <input
              type="text"
              value={idCardNumber}
              onChange={(e) => setIdCardNumber(e.target.value)}
              placeholder="Nhập số CCCD/CMND (12 số)"
              className="v-input"
            />
          </div>

          {/* 3. Ảnh chứng từ */}
          <div className="form-group">
            <label className="required">
              {tutorType === 'STUDENT' && 'Ảnh thẻ sinh viên'}
              {tutorType === 'TEACHER' && 'Chứng chỉ nghiệp vụ / sư phạm'}
              {tutorType === 'GRADUATED' && 'Bằng / Chứng nhận tốt nghiệp'}
              <span className="info-text"> (Bắt buộc)</span>
            </label>
            <div className="file-upload-box">
              <input
                type="file"
                accept="image/*"
                onChange={(e) => setDegree(e.target.files?.[0] || null)}
                id="degreeInput"
              />
              <label htmlFor="degreeInput" className="file-label">
                {degree ? degree.name : 'Chọn file ảnh'}
              </label>
            </div>
          </div>

          {/* 4. Môn học sở trường (max 5) */}
          <div className="form-group">
            <label className="required">
              Môn học sở trường <span className="info-text">(Tối đa 5 môn)</span>
            </label>
            <div className="chip-grid">
              {availableSubjects.map(s => (
                <button
                  key={s}
                  type="button"
                  className={`chip ${subjects.includes(s) ? 'chip-selected' : ''}`}
                  onClick={() => toggleSelection(s, subjects, setSubjects)}
                  disabled={!subjects.includes(s) && subjects.length >= MAX_SELECT}
                >
                  {s}
                </button>
              ))}
            </div>
            <p className="chip-count">{subjects.length}/{MAX_SELECT} đã chọn</p>
          </div>

          {/* 6. Lớp giảng dạy (max 5) */}
          <div className="form-group">
            <label className="required">
              Lớp giảng dạy <span className="info-text">(Tối đa 5 cấp)</span>
            </label>
            <div className="chip-grid">
              {availableGradeLevels.map(l => (
                <button
                  key={l}
                  type="button"
                  className={`chip ${teachingLevels.includes(l) ? 'chip-selected' : ''}`}
                  onClick={() => toggleSelection(l, teachingLevels, setTeachingLevels)}
                  disabled={!teachingLevels.includes(l) && teachingLevels.length >= MAX_SELECT}
                >
                  {l}
                </button>
              ))}
            </div>
            <p className="chip-count">{teachingLevels.length}/{MAX_SELECT} đã chọn</p>
          </div>

          {/* 6. Số năm kinh nghiệm */}
          <div className="form-group">
            <label>Số năm kinh nghiệm giảng dạy</label>
            <input
              type="number"
              min={0}
              max={50}
              value={experienceYears}
              onChange={(e) => setExperienceYears(Number(e.target.value))}
              className="v-input"
              placeholder="0"
            />
          </div>

          {/* 7. Khu vực dạy */}
          <div className="form-group">
            <label>Khu vực dạy <span className="info-text">(Tối đa 500 ký tự)</span></label>
            <textarea
              value={location}
              onChange={(e) => setLocation(e.target.value.slice(0, 500))}
              className="v-input v-textarea"
              rows={2}
              maxLength={500}
              placeholder="VD: Quận 1, Quận 3, TP.HCM / Cầu Giấy, Đống Đa, Hà Nội..."
            />
            <span style={{ fontSize: '12px', color: '#888' }}>{location.length}/500</span>
          </div>

          {/* 8. Thành tích / Kinh nghiệm */}
          <div className="form-group">
            <label>Thành tích &amp; Kinh nghiệm dạy học <span className="info-text">(Tối đa 500 ký tự)</span></label>
            <textarea
              value={achievements}
              onChange={(e) => setAchievements(e.target.value.slice(0, 500))}
              className="v-input v-textarea"
              rows={4}
              maxLength={500}
              placeholder="Mô tả thành tích nổi bật, giải thưởng, kinh nghiệm... (không bắt buộc)"
            />
            <span style={{ fontSize: '12px', color: '#888' }}>{achievements.length}/500</span>
          </div>

          {error && <div className="error-message">{error}</div>}

          <div className="form-actions">
            <button type="submit" className="btn btn-primary" disabled={isSubmitting}>
              {isSubmitting ? 'Đang gửi...' : 'Gửi xác thực'}
            </button>
          </div>
        </form>
          </>
        )}
      </div>
    </div>
  );
};
