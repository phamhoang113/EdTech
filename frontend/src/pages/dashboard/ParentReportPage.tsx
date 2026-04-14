import { BarChart3, BookOpen, FileQuestion, Clock, TrendingUp, CheckCircle, AlertCircle, Award } from 'lucide-react';
import { useState, useEffect, useRef, useCallback } from 'react';
import type { Student } from '../../services/parentApi';
import { parentApi, type ParentClass } from '../../services/parentApi';
import { teachingApi, type ProgressSummaryDTO, type StudentProgressDTO } from '../../services/teachingApi';

import './Dashboard.css';

/* ── Constants ───────────────────────────────────────────────────── */

const STATUS_CONFIG: Record<string, { label: string; color: string; bg: string; icon: string }> = {
  PENDING:   { label: 'Chưa nộp', color: '#ef4444', bg: 'rgba(239, 68, 68, 0.1)', icon: '🔴' },
  SUBMITTED: { label: 'Đã nộp',   color: '#f59e0b', bg: 'rgba(245, 158, 11, 0.1)', icon: '🟡' },
  GRADED:    { label: 'Đã chấm',  color: '#10b981', bg: 'rgba(16, 185, 129, 0.1)', icon: '🟢' },
  COMPLETED: { label: 'Hoàn thành', color: '#6366f1', bg: 'rgba(99, 102, 241, 0.1)', icon: '✅' },
};

const SCORE_GRADE_LABEL = (score: number): { label: string; color: string } => {
  if (score >= 9) return { label: 'Xuất sắc', color: '#059669' };
  if (score >= 8) return { label: 'Giỏi', color: '#10b981' };
  if (score >= 6.5) return { label: 'Khá', color: '#f59e0b' };
  if (score >= 5) return { label: 'Trung bình', color: '#f97316' };
  return { label: 'Yếu', color: '#ef4444' };
};

/* ── Score Chart (Canvas) ────────────────────────────────────────── */

interface ScoreChartProps {
  details: StudentProgressDTO[];
}

function ScoreChart({ details }: ScoreChartProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  const gradedItems = details
    .filter(d => d.score !== null && (d.status === 'GRADED' || d.status === 'COMPLETED'))
    .reverse(); // oldest first

  const draw = useCallback(() => {
    const canvas = canvasRef.current;
    if (!canvas || gradedItems.length === 0) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const dpr = window.devicePixelRatio || 1;
    const rect = canvas.getBoundingClientRect();
    canvas.width = rect.width * dpr;
    canvas.height = rect.height * dpr;
    ctx.scale(dpr, dpr);

    const width = rect.width;
    const height = rect.height;
    const padding = { top: 30, right: 30, bottom: 50, left: 50 };
    const chartW = width - padding.left - padding.right;
    const chartH = height - padding.top - padding.bottom;

    // Clear
    ctx.clearRect(0, 0, width, height);

    // Grid lines
    ctx.strokeStyle = 'rgba(148, 163, 184, 0.15)';
    ctx.lineWidth = 1;
    for (let i = 0; i <= 10; i += 2) {
      const y = padding.top + chartH - (i / 10) * chartH;
      ctx.beginPath();
      ctx.moveTo(padding.left, y);
      ctx.lineTo(width - padding.right, y);
      ctx.stroke();

      // Y axis labels
      ctx.fillStyle = '#94a3b8';
      ctx.font = '11px Inter, sans-serif';
      ctx.textAlign = 'right';
      ctx.fillText(String(i), padding.left - 8, y + 4);
    }

    // Separate BT and KT
    const homeworks = gradedItems.filter(d => d.type === 'HOMEWORK');
    const exams = gradedItems.filter(d => d.type === 'EXAM');

    const drawLine = (items: StudentProgressDTO[], color: string, dashPattern: number[] = []) => {
      if (items.length === 0) return;

      const stepX = items.length === 1 ? chartW / 2 : chartW / (items.length - 1);

      // Draw line
      ctx.beginPath();
      ctx.strokeStyle = color;
      ctx.lineWidth = 2.5;
      ctx.setLineDash(dashPattern);
      ctx.lineJoin = 'round';

      items.forEach((item, i) => {
        const x = padding.left + (items.length === 1 ? chartW / 2 : i * stepX);
        const y = padding.top + chartH - ((item.score || 0) / 10) * chartH;
        if (i === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
      });
      ctx.stroke();
      ctx.setLineDash([]);

      // Draw dots
      items.forEach((item, i) => {
        const x = padding.left + (items.length === 1 ? chartW / 2 : i * stepX);
        const y = padding.top + chartH - ((item.score || 0) / 10) * chartH;

        ctx.beginPath();
        ctx.arc(x, y, 5, 0, Math.PI * 2);
        ctx.fillStyle = '#fff';
        ctx.fill();
        ctx.strokeStyle = color;
        ctx.lineWidth = 2.5;
        ctx.stroke();

        // Score label
        ctx.fillStyle = color;
        ctx.font = 'bold 11px Inter, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(String(item.score), x, y - 12);
      });

      // X axis labels
      ctx.fillStyle = '#94a3b8';
      ctx.font = '10px Inter, sans-serif';
      ctx.textAlign = 'center';
      items.forEach((item, i) => {
        const x = padding.left + (items.length === 1 ? chartW / 2 : i * stepX);
        const title = item.assessmentTitle.length > 8
          ? item.assessmentTitle.substring(0, 8) + '…'
          : item.assessmentTitle;
        ctx.fillText(title, x, height - padding.bottom + 18);
      });
    };

    drawLine(homeworks, '#6366f1');
    drawLine(exams, '#f59e0b', [6, 3]);

    // Legend
    const legendY = 14;
    ctx.font = '12px Inter, sans-serif';

    ctx.setLineDash([]);
    ctx.beginPath();
    ctx.moveTo(padding.left, legendY);
    ctx.lineTo(padding.left + 24, legendY);
    ctx.strokeStyle = '#6366f1';
    ctx.lineWidth = 2.5;
    ctx.stroke();
    ctx.fillStyle = '#64748b';
    ctx.textAlign = 'left';
    ctx.fillText('Bài tập', padding.left + 30, legendY + 4);

    ctx.setLineDash([6, 3]);
    ctx.beginPath();
    ctx.moveTo(padding.left + 100, legendY);
    ctx.lineTo(padding.left + 124, legendY);
    ctx.strokeStyle = '#f59e0b';
    ctx.lineWidth = 2.5;
    ctx.stroke();
    ctx.setLineDash([]);
    ctx.fillStyle = '#64748b';
    ctx.fillText('Kiểm tra', padding.left + 130, legendY + 4);
  }, [gradedItems]);

  useEffect(() => {
    draw();
    const handleResize = () => draw();
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, [draw]);

  if (gradedItems.length === 0) {
    return (
      <div style={{ textAlign: 'center', padding: '40px 20px', color: 'var(--color-text-muted)' }}>
        <TrendingUp size={36} style={{ opacity: 0.2, marginBottom: 8 }} />
        <p>Chưa có điểm số nào để hiển thị biểu đồ.</p>
      </div>
    );
  }

  return (
    <canvas
      ref={canvasRef}
      style={{ width: '100%', height: 260, display: 'block' }}
    />
  );
}

/* ── Summary Card Component ──────────────────────────────────────── */

interface SummaryCardProps {
  icon: React.ReactNode;
  label: string;
  value: string | number;
  subtext?: string;
  color: string;
  bgColor: string;
}

function SummaryCard({ icon, label, value, subtext, color, bgColor }: SummaryCardProps) {
  return (
    <div style={{
      background: bgColor,
      borderRadius: 14,
      padding: '18px 16px',
      display: 'flex',
      flexDirection: 'column',
      gap: 8,
      border: `1px solid ${color}20`,
      transition: 'transform 0.2s, box-shadow 0.2s',
      cursor: 'default',
    }}
    onMouseEnter={e => {
      (e.currentTarget as HTMLElement).style.transform = 'translateY(-2px)';
      (e.currentTarget as HTMLElement).style.boxShadow = `0 8px 25px ${color}15`;
    }}
    onMouseLeave={e => {
      (e.currentTarget as HTMLElement).style.transform = 'translateY(0)';
      (e.currentTarget as HTMLElement).style.boxShadow = 'none';
    }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <div style={{ color, opacity: 0.8 }}>{icon}</div>
        <span style={{ fontSize: '0.78rem', fontWeight: 600, color: 'var(--color-text-muted)', textTransform: 'uppercase', letterSpacing: '0.5px' }}>{label}</span>
      </div>
      <div style={{ fontSize: '1.6rem', fontWeight: 800, color, lineHeight: 1.1 }}>{value}</div>
      {subtext && <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>{subtext}</span>}
    </div>
  );
}

/* ── Assessment Row ──────────────────────────────────────────────── */

function AssessmentRow({ item }: { item: StudentProgressDTO }) {
  const statusCfg = STATUS_CONFIG[item.status] || STATUS_CONFIG.PENDING;
  const gradeInfo = item.score !== null ? SCORE_GRADE_LABEL(item.score) : null;

  const formatDate = (iso: string | null) => {
    if (!iso) return '—';
    try {
      return new Date(iso).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' });
    } catch { return '—'; }
  };

  const isOverdue = item.status === 'PENDING' && item.closesAt && new Date(item.closesAt) < new Date();

  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: '1fr auto auto auto',
      gap: 12,
      alignItems: 'center',
      padding: '12px 16px',
      borderBottom: '1px solid var(--color-border)',
      transition: 'background 0.15s',
    }}
    onMouseEnter={e => (e.currentTarget.style.background = 'var(--color-surface-hover)')}
    onMouseLeave={e => (e.currentTarget.style.background = 'transparent')}
    >
      {/* Title */}
      <div>
        <div style={{ fontWeight: 600, fontSize: '0.9rem', color: 'var(--color-text)' }}>
          {item.assessmentTitle}
        </div>
        <div style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)', marginTop: 2 }}>
          {item.closesAt ? (
            <>
              {isOverdue ? '⚠️ Quá hạn' : '📅 Hạn nộp'}: {formatDate(item.closesAt)}
            </>
          ) : '—'}
        </div>
      </div>

      {/* Status badge */}
      <span style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: 4,
        padding: '4px 10px',
        borderRadius: 20,
        fontSize: '0.75rem',
        fontWeight: 600,
        color: statusCfg.color,
        background: statusCfg.bg,
        whiteSpace: 'nowrap',
      }}>
        {statusCfg.icon} {statusCfg.label}
      </span>

      {/* Score */}
      <div style={{ textAlign: 'right', minWidth: 60 }}>
        {item.score !== null ? (
          <span style={{ fontWeight: 700, fontSize: '1rem', color: gradeInfo!.color }}>
            {item.score}/{item.totalScore || 10}
          </span>
        ) : (
          <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>—</span>
        )}
      </div>

      {/* Grade label */}
      <div style={{ minWidth: 60, textAlign: 'right' }}>
        {gradeInfo ? (
          <span style={{
            fontSize: '0.72rem',
            fontWeight: 600,
            color: gradeInfo.color,
            padding: '2px 8px',
            borderRadius: 6,
            background: `${gradeInfo.color}15`,
          }}>
            {gradeInfo.label}
          </span>
        ) : null}
      </div>
    </div>
  );
}

/* ══════════════════════════════════════════════════════════════════
   MAIN: ParentReportPage
   ══════════════════════════════════════════════════════════════════ */

export const ParentReportPage = () => {
  const [students, setStudents] = useState<Student[]>([]);
  const [selectedStudentId, setSelectedStudentId] = useState<string>('');
  const [classes, setClasses] = useState<ParentClass[]>([]);
  const [selectedClassId, setSelectedClassId] = useState<string>('');
  const [summary, setSummary] = useState<ProgressSummaryDTO | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Load children
  useEffect(() => {
    parentApi.getMyChildren().then(res => {
      setStudents(res.data ?? []);
    }).catch(() => {});
  }, []);

  // Load active classes
  useEffect(() => {
    parentApi.getMyClasses().then(res => {
      const active = (res.data || []).filter(c =>
        c.status === 'ACTIVE' || c.status === 'MATCHED'
      );
      setClasses(active);
      if (active.length > 0) setSelectedClassId(active[0].id);
    }).catch(() => {});
  }, []);

  // Load progress summary when class changes
  useEffect(() => {
    if (!selectedClassId) {
      setSummary(null);
      setLoading(false);
      return;
    }

    setLoading(true);
    setError(null);
    teachingApi.getProgressSummary(selectedClassId)
      .then(data => setSummary(data))
      .catch(e => {
        setError(e?.response?.data?.message ?? 'Lỗi khi tải tiến độ học tập');
        setSummary(null);
      })
      .finally(() => setLoading(false));
  }, [selectedClassId]);

  // Derived data
  const homeworks = summary?.details.filter(d => d.type === 'HOMEWORK') ?? [];
  const exams = summary?.details.filter(d => d.type === 'EXAM') ?? [];
  const upcomingExams = exams.filter(e => e.closesAt && new Date(e.closesAt) > new Date());
  const pastExams = exams.filter(e => !e.closesAt || new Date(e.closesAt) <= new Date());

  const selectedClassName = classes.find(c => c.id === selectedClassId)?.title || '';

  return (
    <>
      {/* Header */}
      <div className="dash-section-head">
        <h1 className="dash-section-title" style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: '1.4rem' }}>
          <BarChart3 size={24} className="text-indigo" />
          Báo cáo tiến độ học tập
        </h1>
      </div>

      {/* Filters */}
      <div className="dash-panel" style={{ marginBottom: 20 }}>
        <div style={{ display: 'flex', gap: 16, alignItems: 'flex-end', flexWrap: 'wrap' }}>
          <div style={{ flex: 1, minWidth: 200 }}>
            <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 600, color: 'var(--color-text-muted)', marginBottom: 6 }}>
              Chọn lớp
            </label>
            <select
              value={selectedClassId}
              onChange={e => setSelectedClassId(e.target.value)}
              style={{
                width: '100%', padding: '10px 14px', borderRadius: 8,
                border: '1px solid var(--color-border)', outline: 'none',
                background: 'var(--color-surface)', color: 'var(--color-text)',
                fontFamily: 'inherit', fontSize: '0.95rem',
              }}
            >
              {classes.length === 0 && <option value="">-- Chưa có lớp --</option>}
              {classes.map(c => (
                <option key={c.id} value={c.id}>{c.title} ({c.subject})</option>
              ))}
            </select>
          </div>
          <div style={{ flex: 1, minWidth: 200 }}>
            <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 600, color: 'var(--color-text-muted)', marginBottom: 6 }}>
              Lọc theo con em
            </label>
            <select
              value={selectedStudentId}
              onChange={e => setSelectedStudentId(e.target.value)}
              style={{
                width: '100%', padding: '10px 14px', borderRadius: 8,
                border: '1px solid var(--color-border)', outline: 'none',
                background: 'var(--color-surface)', color: 'var(--color-text)',
                fontFamily: 'inherit', fontSize: '0.95rem',
              }}
            >
              <option value="">-- Tất cả con em --</option>
              {students.map(s => (
                <option key={s.id} value={s.userId}>{s.fullName}</option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {/* Loading / Error */}
      {loading ? (
        <div className="dash-panel" style={{ textAlign: 'center', padding: 50 }}>
          <div className="spinner" style={{ margin: '0 auto 12px', width: 32, height: 32, border: '3px solid var(--color-border)', borderTopColor: '#6366f1', borderRadius: '50%', animation: 'spin 0.6s linear infinite' }} />
          <p style={{ color: 'var(--color-text-muted)' }}>Đang tải dữ liệu...</p>
        </div>
      ) : error ? (
        <div className="dash-panel" style={{ textAlign: 'center', padding: 40 }}>
          <AlertCircle size={40} style={{ color: '#ef4444', opacity: 0.5, marginBottom: 8 }} />
          <p style={{ color: '#ef4444' }}>{error}</p>
        </div>
      ) : !summary || summary.details.length === 0 ? (
        <div className="dash-panel" style={{ textAlign: 'center', padding: 50 }}>
          <Award size={48} style={{ color: 'var(--color-text-muted)', opacity: 0.2, marginBottom: 12 }} />
          <p style={{ color: 'var(--color-text-muted)', fontSize: '1rem' }}>
            {classes.length === 0
              ? 'Chưa có lớp học nào đang hoạt động.'
              : `Chưa có bài tập hoặc kiểm tra nào trong lớp "${selectedClassName}".`}
          </p>
        </div>
      ) : (
        <>
          {/* Summary Cards */}
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(170px, 1fr))', gap: 14, marginBottom: 20 }}>
            <SummaryCard
              icon={<BookOpen size={20} />}
              label="Điểm TB Bài tập"
              value={summary.homeworkAvgScore > 0 ? `${summary.homeworkAvgScore}` : '—'}
              subtext={`${summary.totalHomework} bài tập`}
              color="#6366f1"
              bgColor="rgba(99, 102, 241, 0.08)"
            />
            <SummaryCard
              icon={<FileQuestion size={20} />}
              label="Điểm TB Kiểm tra"
              value={summary.examAvgScore > 0 ? `${summary.examAvgScore}` : '—'}
              subtext={`${summary.totalExam} bài kiểm tra`}
              color="#f59e0b"
              bgColor="rgba(245, 158, 11, 0.08)"
            />
            <SummaryCard
              icon={<AlertCircle size={20} />}
              label="BT Chưa nộp"
              value={summary.pendingHomeworkCount}
              subtext={summary.pendingHomeworkCount > 0 ? 'Cần hoàn thành!' : 'Tốt lắm! 👏'}
              color={summary.pendingHomeworkCount > 0 ? '#ef4444' : '#10b981'}
              bgColor={summary.pendingHomeworkCount > 0 ? 'rgba(239, 68, 68, 0.08)' : 'rgba(16, 185, 129, 0.08)'}
            />
            <SummaryCard
              icon={<Clock size={20} />}
              label="KT Sắp tới"
              value={summary.upcomingExamCount}
              subtext={summary.upcomingExamCount > 0 ? 'Chuẩn bị ôn tập' : 'Không có KT sắp tới'}
              color="#8b5cf6"
              bgColor="rgba(139, 92, 246, 0.08)"
            />
          </div>

          {/* Score Chart */}
          <div className="dash-panel" style={{ marginBottom: 20 }}>
            <h3 style={{ fontSize: '1.05rem', marginBottom: 14, display: 'flex', alignItems: 'center', gap: 8 }}>
              <TrendingUp size={18} className="text-indigo" />
              Biểu đồ điểm số
            </h3>
            <ScoreChart details={summary.details} />
          </div>

          {/* Homework List */}
          <div className="dash-panel" style={{ marginBottom: 20 }}>
            <h3 style={{ fontSize: '1.05rem', marginBottom: 10, display: 'flex', alignItems: 'center', gap: 8 }}>
              <BookOpen size={18} style={{ color: '#6366f1' }} />
              Bài tập ({homeworks.length})
            </h3>
            {homeworks.length === 0 ? (
              <p style={{ color: 'var(--color-text-muted)', textAlign: 'center', padding: 20 }}>Chưa có bài tập nào.</p>
            ) : (
              <div style={{ borderRadius: 10, overflow: 'hidden', border: '1px solid var(--color-border)' }}>
                {homeworks.map(hw => (
                  <AssessmentRow key={hw.assessmentId} item={hw} />
                ))}
              </div>
            )}
          </div>

          {/* Exam List */}
          <div className="dash-panel" style={{ marginBottom: 20 }}>
            <h3 style={{ fontSize: '1.05rem', marginBottom: 10, display: 'flex', alignItems: 'center', gap: 8 }}>
              <FileQuestion size={18} style={{ color: '#f59e0b' }} />
              Bài kiểm tra ({exams.length})
            </h3>

            {/* Upcoming */}
            {upcomingExams.length > 0 && (
              <>
                <div style={{
                  display: 'flex', alignItems: 'center', gap: 6, marginBottom: 8,
                  padding: '6px 12px', borderRadius: 8,
                  background: 'rgba(139, 92, 246, 0.08)', width: 'fit-content',
                }}>
                  <Clock size={14} style={{ color: '#8b5cf6' }} />
                  <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#8b5cf6', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                    Sắp tới
                  </span>
                </div>
                <div style={{ borderRadius: 10, overflow: 'hidden', border: '1px solid var(--color-border)', marginBottom: 16 }}>
                  {upcomingExams.map(exam => (
                    <AssessmentRow key={exam.assessmentId} item={exam} />
                  ))}
                </div>
              </>
            )}

            {/* Past */}
            {pastExams.length > 0 && (
              <>
                <div style={{
                  display: 'flex', alignItems: 'center', gap: 6, marginBottom: 8,
                  padding: '6px 12px', borderRadius: 8,
                  background: 'rgba(16, 185, 129, 0.08)', width: 'fit-content',
                }}>
                  <CheckCircle size={14} style={{ color: '#10b981' }} />
                  <span style={{ fontSize: '0.8rem', fontWeight: 700, color: '#10b981', textTransform: 'uppercase', letterSpacing: '0.5px' }}>
                    Đã qua
                  </span>
                </div>
                <div style={{ borderRadius: 10, overflow: 'hidden', border: '1px solid var(--color-border)' }}>
                  {pastExams.map(exam => (
                    <AssessmentRow key={exam.assessmentId} item={exam} />
                  ))}
                </div>
              </>
            )}

            {exams.length === 0 && (
              <p style={{ color: 'var(--color-text-muted)', textAlign: 'center', padding: 20 }}>Chưa có bài kiểm tra nào.</p>
            )}
          </div>
        </>
      )}

      {/* Spinner keyframe */}
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </>
  );
};
