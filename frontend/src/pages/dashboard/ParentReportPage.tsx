import { BarChart3, Award, Calendar, ChevronDown, ChevronLeft, ChevronRight } from 'lucide-react';
import { useState, useEffect } from 'react';
import type { Student } from '../../services/parentApi';
import { parentApi } from '../../services/parentApi';
import { ParentSidebar } from '../../components/parent/ParentSidebar';
import { DashboardHeader } from '../../components/layout/DashboardHeader';

import './Dashboard.css';

const AVAILABLE_MONTHS = [
  { value: '01', label: 'Tháng 1' }, { value: '02', label: 'Tháng 2' },
  { value: '03', label: 'Tháng 3' }, { value: '04', label: 'Tháng 4' },
  { value: '05', label: 'Tháng 5' }, { value: '06', label: 'Tháng 6' },
  { value: '07', label: 'Tháng 7' }, { value: '08', label: 'Tháng 8' },
  { value: '09', label: 'Tháng 9' }, { value: '10', label: 'Tháng 10' },
  { value: '11', label: 'Tháng 11' }, { value: '12', label: 'Tháng 12' },
];

const MonthPicker = ({ value, onChange }: { value: string, onChange: (val: string) => void }) => {
  const [open, setOpen] = useState(false);
  const [year, month] = value.split('-');
  const selectedLabel = `Tháng ${parseInt(month, 10)} năm ${year}`;

  return (
    <div style={{ position: 'relative', width: '100%' }}>
      <button 
        type="button"
        onClick={() => setOpen(!open)}
        style={{ 
          width: '100%', padding: '10px 14px', borderRadius: 8, 
          border: '1px solid var(--color-border)', background: 'var(--color-surface)',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
          cursor: 'pointer', outline: 'none', color: 'var(--color-text)',
          fontWeight: 500, fontFamily: 'inherit', fontSize: '0.95rem'
        }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <Calendar size={18} className="text-indigo" />
          {selectedLabel}
        </div>
        <ChevronDown size={18} style={{ color: 'var(--color-text-muted)', transform: open ? 'rotate(180deg)' : 'none', transition: '0.2s' }} />
      </button>

      {open && (
        <>
          <div style={{ position: 'fixed', inset: 0, zIndex: 9 }} onClick={() => setOpen(false)} />
          <div style={{ 
            position: 'absolute', top: '100%', left: 0, minWidth: 260, marginTop: 8, 
            background: 'var(--color-surface)', border: '1px solid var(--color-border)', 
            borderRadius: 12, boxShadow: '0 10px 25px rgba(0,0,0,0.1)', zIndex: 10,
            padding: '16px 12px'
          }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
              <button 
                type="button"
                className="hover-bg-muted"
                onClick={() => onChange(`${parseInt(year) - 1}-${month}`)}
                style={{ background: 'transparent', border: '1px solid var(--color-border)', borderRadius: 6, padding: '4px 8px', cursor: 'pointer', color: 'var(--color-text)' }}
              >
                <ChevronLeft size={16} />
              </button>
              <div style={{ fontWeight: 600, fontSize: '1.05rem', color: 'var(--color-text)' }}>Năm {year}</div>
              <button 
                type="button"
                className="hover-bg-muted"
                onClick={() => onChange(`${parseInt(year) + 1}-${month}`)}
                style={{ background: 'transparent', border: '1px solid var(--color-border)', borderRadius: 6, padding: '4px 8px', cursor: 'pointer', color: 'var(--color-text)' }}
              >
                <ChevronRight size={16} />
              </button>
            </div>
            
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 6 }}>
              {AVAILABLE_MONTHS.map(m => {
                const isActive = m.value === month;
                return (
                  <button
                    key={m.value}
                    type="button"
                    onClick={() => {
                      onChange(`${year}-${m.value}`);
                      setOpen(false);
                    }}
                    style={{
                      padding: '8px 4px', borderRadius: 8, border: 'none',
                      background: isActive ? '#6366f1' : 'transparent',
                      color: isActive ? '#fff' : 'var(--color-text)',
                      fontWeight: isActive ? 600 : 500,
                      cursor: 'pointer', transition: 'all 0.2s',
                    }}
                    onMouseEnter={(e) => {
                      if(!isActive) (e.target as HTMLElement).style.background = 'var(--color-surface-hover)';
                    }}
                    onMouseLeave={(e) => {
                      if(!isActive) (e.target as HTMLElement).style.background = 'transparent';
                    }}
                  >
                    Thg {parseInt(m.value, 10)}
                  </button>
                )
              })}
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export const ParentReportPage = () => {
  const [students, setStudents] = useState<Student[]>([]);
  const [selectedStudentId, setSelectedStudentId] = useState<string>('');
  const [selectedMonth, setSelectedMonth] = useState<string>(() => {
    const now = new Date();
    return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
  });
  const [reportData, setReportData] = useState<any[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);

  useEffect(() => {
    parentApi.getMyChildren().then(res => {
      setStudents(res.data ?? []);
    }).catch(() => {});
  }, []);

  useEffect(() => {
    setLoading(true);
    parentApi.getLearningReport(selectedMonth, selectedStudentId || null)
      .then(res => {
        setReportData(res.data ?? []);
      })
      .catch((e: any) => {
        showToast('error', e?.response?.data?.message ?? 'Lỗi khi tải báo cáo học tập');
      })
      .finally(() => setLoading(false));
  }, [selectedMonth, selectedStudentId]);

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3500);
  };

  return (
    <div className="dash-page">
      <ParentSidebar active="report" />

      <main className="dash-main">
        <DashboardHeader />

        <div className="dash-body">
          <div className="dash-section-head">
            <h1 className="dash-section-title" style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: '1.4rem' }}>
              <BarChart3 size={24} className="text-indigo" />
              Báo cáo học tập
            </h1>
          </div>

          <div className="dash-panel" style={{ marginBottom: 20 }}>
            <div style={{ display: 'flex', gap: 16, alignItems: 'flex-end', flexWrap: 'wrap' }}>
              <div style={{ flex: 1, minWidth: 200 }}>
                <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 600, color: 'var(--color-text-muted)', marginBottom: 6 }}>
                  Chọn Tháng báo cáo
                </label>
                <MonthPicker 
                  value={selectedMonth}
                  onChange={val => setSelectedMonth(val)}
                />
              </div>
              <div style={{ flex: 2, minWidth: 250 }}>
                <label style={{ display: 'block', fontSize: '0.85rem', fontWeight: 600, color: 'var(--color-text-muted)', marginBottom: 6 }}>
                  Lọc theo Học sinh
                </label>
                <select 
                  value={selectedStudentId}
                  onChange={e => setSelectedStudentId(e.target.value)}
                  style={{ width: '100%', padding: '10px 14px', borderRadius: 8, border: '1px solid var(--color-border)', outline: 'none', background: 'var(--color-surface)', color: 'var(--color-text)' }}
                >
                  <option value="">-- Tất cả con em --</option>
                  {students.map(s => (
                    <option key={s.id} value={s.userId}>{s.fullName}</option>
                  ))}
                </select>
              </div>
            </div>
          </div>

          <div className="dash-panel">
            <h3 style={{ fontSize: '1.1rem', marginBottom: 16 }}>Thống kê chi tiết ({selectedMonth})</h3>
            
            {loading ? (
              <p style={{ textAlign: 'center', color: 'var(--color-text-muted)', padding: 30 }}>Đang tải dữ liệu báo cáo...</p>
            ) : reportData.length === 0 ? (
              <div style={{ textAlign: 'center', color: 'var(--color-text-muted)', padding: 40, background: 'var(--color-surface)', borderRadius: 12, border: '1px dashed var(--color-border)' }}>
                <Award size={40} style={{ opacity: 0.2, marginBottom: 10 }} />
                <p>Không có dữ liệu báo cáo học tập trong tháng này.</p>
              </div>
            ) : (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
                {reportData.map((report, idx) => (
                  <div key={idx} style={{ padding: 16, border: '1px solid var(--color-border)', borderRadius: 12, background: 'var(--color-surface)' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 12, flexWrap: 'wrap', gap: 10 }}>
                      <div>
                        <h4 style={{ fontSize: '1.05rem', color: 'var(--color-indigo)', marginBottom: 4 }}>
                          {report.classCode} - {report.classTitle}
                        </h4>
                        <div style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)', display: 'flex', gap: 10, alignItems: 'center' }}>
                          <span>👨‍🏫 GS: {report.tutorName || 'Chưa gán'}</span>
                          <span style={{ width: 4, height: 4, borderRadius: '50%', background: 'currentColor' }}></span>
                          <span>👶 HS: {report.studentName || 'Chưa gán'}</span>
                        </div>
                      </div>
                      <div style={{ textAlign: 'right' }}>
                        <div style={{ fontSize: '0.85rem', fontWeight: 600, color: 'var(--color-text)' }}>
                          Học phí tạm tính: <span style={{ color: 'var(--color-amber)', fontSize: '1.05rem' }}>{report.estimatedFeeMonth?.toLocaleString('vi-VN')} ₫</span>
                        </div>
                      </div>
                    </div>
                    
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(130px, 1fr))', gap: 12, borderTop: '1px solid var(--color-border)', paddingTop: 12 }}>
                      <div style={{ background: 'rgba(16, 185, 129, 0.1)', padding: '10px', borderRadius: 8, textAlign: 'center' }}>
                        <p style={{ fontSize: '0.75rem', color: 'var(--color-emerald)', fontWeight: 600, marginBottom: 4 }}>Hoàn thành</p>
                        <p style={{ fontSize: '1.2rem', fontWeight: 700, color: 'var(--color-emerald)' }}>{report.completedSessionsMonth || 0}</p>
                      </div>
                      <div style={{ background: 'rgba(239, 68, 68, 0.1)', padding: '10px', borderRadius: 8, textAlign: 'center' }}>
                        <p style={{ fontSize: '0.75rem', color: '#ef4444', fontWeight: 600, marginBottom: 4 }}>Huỷ</p>
                        <p style={{ fontSize: '1.2rem', fontWeight: 700, color: '#ef4444' }}>{report.cancelledSessionsMonth || 0}</p>
                      </div>
                      <div style={{ background: 'rgba(245, 158, 11, 0.1)', padding: '10px', borderRadius: 8, textAlign: 'center' }}>
                        <p style={{ fontSize: '0.75rem', color: '#f59e0b', fontWeight: 600, marginBottom: 4 }}>Chưa diễn ra</p>
                        <p style={{ fontSize: '1.2rem', fontWeight: 700, color: '#f59e0b' }}>{(report.totalSessionsMonth || 0) - (report.completedSessionsMonth || 0) - (report.cancelledSessionsMonth || 0)}</p>
                      </div>
                      <div style={{ background: 'rgba(99, 102, 241, 0.1)', padding: '10px', borderRadius: 8, textAlign: 'center' }}>
                        <p style={{ fontSize: '0.75rem', color: '#6366f1', fontWeight: 600, marginBottom: 4 }}>Tổng số buổi</p>
                        <p style={{ fontSize: '1.2rem', fontWeight: 700, color: '#6366f1' }}>{report.totalSessionsMonth || 0}</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </main>

      {/* Toast */}
      {toast && (
        <div style={{
          position: 'fixed', bottom: 24, right: 24, zIndex: 9999,
          padding: '10px 20px', borderRadius: 12, fontWeight: 600, fontSize: '0.88rem',
          background: toast.type === 'success' ? '#ecfdf5' : '#fef2f2',
          color: toast.type === 'success' ? '#065f46' : '#b91c1c',
          border: `1px solid ${toast.type === 'success' ? 'rgba(5,150,105,0.3)' : 'rgba(239,68,68,0.3)'}`,
          boxShadow: '0 4px 20px rgba(0,0,0,0.12)',
        }}>
          {toast.type === 'success' ? '✓ ' : '✕ '}{toast.msg}
        </div>
      )}
    </div>
  );
};
