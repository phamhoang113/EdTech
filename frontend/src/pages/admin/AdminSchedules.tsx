import { CalendarIcon, AlertCircle, DollarSign, BookOpen, Clock, ChevronLeft, ChevronRight, X, Search } from 'lucide-react';
import React, { useState, useEffect, useMemo, useRef, useCallback } from 'react';
import { getDisplayStatus } from '../../utils/sessionStatus';
import { adminScheduleApi } from '../../services/adminScheduleApi';
import type { AdminScheduleAnalyticsDTO, QuotaShortfallItem, TutorSuggestion, ClassSuggestion } from '../../services/adminScheduleApi';
import type { SessionDTO } from '../../services/sessionApi';

import './AdminSchedules.css';

function fmtDate(iso: string | null | undefined) {
  if (!iso) return '—';
  const d = new Date(iso);
  return `${String(d.getDate()).padStart(2, '0')}/${String(d.getMonth() + 1).padStart(2, '0')}/${d.getFullYear()}`;
}

/** Debounce hook */
function useDebounce<T>(value: T, delay: number): T {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);
  return debounced;
}

const AdminSchedules = () => {
  const [sessions, setSessions] = useState<SessionDTO[]>([]);
  const [analytics, setAnalytics] = useState<AdminScheduleAnalyticsDTO | null>(null);
  const [loading, setLoading] = useState(false);
  const [statusUpdating, setStatusUpdating] = useState<string | null>(null);
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);

  // Filters State
  const [currentMonth, setCurrentMonth] = useState(new Date());
  const [classCode, setClassCode] = useState('');
  const [tutorName, setTutorName] = useState('');
  const [tutorId, setTutorId] = useState('');

  // Suggest State
  const [suggestKeyword, setSuggestKeyword] = useState('');
  const [tutorSuggestions, setTutorSuggestions] = useState<TutorSuggestion[]>([]);
  const [classSuggestions, setClassSuggestions] = useState<ClassSuggestion[]>([]);
  const [showSuggest, setShowSuggest] = useState(false);
  const [, setActiveSuggestField] = useState<'classCode' | 'tutorName' | 'tutorId' | null>(null);
  const suggestRef = useRef<HTMLDivElement>(null);

  const debouncedKeyword = useDebounce(suggestKeyword, 300);

  // Fetch suggestions when keyword changes
  useEffect(() => {
    if (!debouncedKeyword || debouncedKeyword.length < 1) {
      setTutorSuggestions([]);
      setClassSuggestions([]);
      return;
    }
    let cancelled = false;
    adminScheduleApi.suggest(debouncedKeyword).then(res => {
      if (!cancelled && res.data) {
        setTutorSuggestions(res.data.tutors || []);
        setClassSuggestions(res.data.classes || []);
        setShowSuggest(true);
      }
    }).catch(() => { /* ignore */ });
    return () => { cancelled = true; };
  }, [debouncedKeyword]);

  // Close dropdown on outside click
  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (suggestRef.current && !suggestRef.current.contains(e.target as Node)) {
        setShowSuggest(false);
      }
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, []);

  const handleFilterInput = useCallback((field: 'classCode' | 'tutorName' | 'tutorId', value: string) => {
    if (field === 'classCode') setClassCode(value);
    else if (field === 'tutorName') setTutorName(value);
    else setTutorId(value);
    setSuggestKeyword(value);
    setActiveSuggestField(field);
    if (!value) setShowSuggest(false);
  }, []);

  const selectTutor = useCallback((tutor: TutorSuggestion) => {
    setTutorName(tutor.fullName);
    setTutorId(tutor.id);
    setShowSuggest(false);
    setSuggestKeyword('');
  }, []);

  const selectClass = useCallback((cls: ClassSuggestion) => {
    setClassCode(cls.classCode);
    setShowSuggest(false);
    setSuggestKeyword('');
  }, []);

  // Detail View State
  const [selectedDateStr, setSelectedDateStr] = useState<string | null>(null);
  const [expandedId, setExpandedId] = useState<string | null>(null);
  const [statDetail, setStatDetail] = useState<'MAKEUP' | 'EXTRA' | null>(null);
  const [quotaDetails, setQuotaDetails] = useState<QuotaShortfallItem[]>([]);
  const [loadingQuota, setLoadingQuota] = useState(false);

  // Derived dates for the grid
  const { gridDays, startDateStr, endDateStr, monthStartStr, monthEndStr } = useMemo(() => {
    const year = currentMonth.getFullYear();
    const month = currentMonth.getMonth();
    
    // First and last day of the ACTUAL current month (used for API)
    const firstDay = new Date(year, month, 1);
    const lastDay = new Date(year, month + 1, 0);
    
    const formatIso = (d: Date) => {
      return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
    };

    // JS getDay(): 0 = Sunday, 1 = Monday. We want Monday = 0
    let startDayOfWeek = firstDay.getDay() - 1;
    if (startDayOfWeek === -1) startDayOfWeek = 6; // Sunday

    const days = [];
    
    // Previous month padding (display only)
    for (let i = startDayOfWeek - 1; i >= 0; i--) {
      days.push({ date: new Date(year, month, -i), isCurrentMonth: false });
    }
    // Current month
    for (let i = 1; i <= lastDay.getDate(); i++) {
      days.push({ date: new Date(year, month, i), isCurrentMonth: true });
    }
    // Next month padding (total 42 cells = 6 weeks, display only)
    let nextPad = 1;
    while (days.length < 42) {
      days.push({ date: new Date(year, month + 1, nextPad++), isCurrentMonth: false });
    }

    return { 
      gridDays: days, 
      // Grid range (includes padding, for session dot rendering on all visible cells)
      startDateStr: formatIso(days[0].date), 
      endDateStr: formatIso(days[days.length - 1].date),
      // Actual month range (used for API queries and analytics — to avoid cross-month contamination)
      monthStartStr: formatIso(firstDay),
      monthEndStr: formatIso(lastDay),
    };
  }, [currentMonth]);

  useEffect(() => {
    fetchData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [monthStartStr, monthEndStr]);

  const fetchData = async () => {
    try {
      setLoading(true);
      // Sessions: fetch full grid range so dots appear on padding-days too
      // Analytics: fetch only actual month range so totals aren't polluted by adjacent months
      const [schedRes, statsRes] = await Promise.all([
        adminScheduleApi.getSchedules(startDateStr, endDateStr, tutorId || undefined, classCode || undefined, tutorName || undefined),
        adminScheduleApi.getAnalytics(monthStartStr, monthEndStr, tutorId || undefined, classCode || undefined, tutorName || undefined)
      ]);
      setSessions(schedRes.data || []);
      setAnalytics(statsRes.data || null);
    } catch (error) {
      console.error('Lỗi khi tải dữ liệu lịch:', error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusLabel = (status: string, sessionDate?: string, endTime?: string) => {
    const displayStatus = (sessionDate && endTime) ? getDisplayStatus(status, sessionDate, endTime) : status;
    switch(displayStatus) {
      case 'SCHEDULED': return <span className="admin-sched-tag info">Sắp tới</span>;
      case 'LIVE': return <span className="admin-sched-tag primary">Đang diễn ra</span>;
      case 'COMPLETED': return <span className="admin-sched-tag success">Hoàn thành</span>;
      case 'CANCELLED': return <span className="admin-sched-tag danger">Huỷ / Nghỉ</span>;
      default: return <span className="admin-sched-tag">{displayStatus}</span>;
    }
  };

  const SESSION_STATUS_OPTIONS = [
    { value: 'SCHEDULED', label: 'Sắp tới', color: '#6366f1' },
    { value: 'COMPLETED', label: 'Đã hoàn thành', color: '#10b981' },
    { value: 'CANCELLED', label: 'Đã huỷ', color: '#ef4444' },
    { value: 'CANCELLED_BY_TUTOR', label: 'GS nghỉ (không phép)', color: '#ef4444' },
    { value: 'CANCELLED_BY_STUDENT', label: 'HS nghỉ', color: '#f59e0b' },
  ] as const;

  const handleStatusChange = async (sessionId: string, newStatus: string) => {
    try {
      setStatusUpdating(sessionId);
      await adminScheduleApi.updateSessionStatus(sessionId, newStatus);
      setSessions(prev => prev.map(s => s.id === sessionId ? { ...s, status: newStatus as SessionDTO['status'] } : s));
      setToast({ type: 'success', msg: 'Đã cập nhật trạng thái thành công.' });
      setTimeout(() => setToast(null), 3000);
    } catch (e: any) {
      setToast({ type: 'error', msg: e?.response?.data?.message || 'Lỗi cập nhật trạng thái' });
      setTimeout(() => setToast(null), 3000);
    } finally {
      setStatusUpdating(null);
    }
  };

  const formatCurrency = (val: number | undefined) => {
    if (val === undefined || val === null) return '0 đ';
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val);
  };

  const filteredSessions = sessions;

  // Group sessions by Date string (yyyy-mm-dd)
  const sessionsByDate = useMemo(() => {
    const map = new Map<string, SessionDTO[]>();
    filteredSessions.forEach(s => {
      if (!s.sessionDate) return;
      const dateKey = s.sessionDate; // assumes format is "YYYY-MM-DD"
      if (!map.has(dateKey)) map.set(dateKey, []);
      map.get(dateKey)!.push(s);
    });
    return map;
  }, [filteredSessions]);

  const handlePrevMonth = () => {
    setCurrentMonth(new Date(currentMonth.getFullYear(), currentMonth.getMonth() - 1, 1));
    setSelectedDateStr(null);
  };

  const handleNextMonth = () => {
    setCurrentMonth(new Date(currentMonth.getFullYear(), currentMonth.getMonth() + 1, 1));
    setSelectedDateStr(null);
  };

  const handleToday = () => {
    setCurrentMonth(new Date());
    setSelectedDateStr(null);
  };

  const selectedSessions = selectedDateStr ? (sessionsByDate.get(selectedDateStr) || []) : [];

  const filteredQuotaDetails = useMemo(() => {
    if (!statDetail || quotaDetails.length === 0) return [];
    if (statDetail === 'MAKEUP') return quotaDetails.filter(q => q.missingCount > 0);
    if (statDetail === 'EXTRA') return quotaDetails.filter(q => q.extraCount > 0);
    return [];
  }, [quotaDetails, statDetail]);

  const handleStatClick = async (type: 'MAKEUP' | 'EXTRA') => {
    setStatDetail(type);
    setSelectedDateStr(null);
    try {
      setLoadingQuota(true);
      const res = await adminScheduleApi.getQuotaDetails(tutorId || undefined);
      setQuotaDetails(res.data || []);
    } catch (error) {
      console.error('Lỗi khi tải chi tiết quota:', error);
      setQuotaDetails([]);
    } finally {
      setLoadingQuota(false);
    }
  };

  return (
    <div className="admin-schedules">
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
      <div className="admin-main-content">
        <div className="admin-sched-header">
          <h2>Quản lý Lịch dạy & Thu nhập</h2>
          
          <div className="admin-sched-filters custom-filters" ref={suggestRef} style={{ position: 'relative' }}>
            <input 
              type="text" 
              placeholder="Mã lớp (VD: C001)..." 
              value={classCode}
              onChange={e => handleFilterInput('classCode', e.target.value)}
              onFocus={() => { if (classCode) { setSuggestKeyword(classCode); setActiveSuggestField('classCode'); } }}
              className="admin-sched-input"
              autoComplete="off"
            />
            <input 
              type="text" 
              placeholder="Tên gia sư..." 
              value={tutorName}
              onChange={e => handleFilterInput('tutorName', e.target.value)}
              onFocus={() => { if (tutorName) { setSuggestKeyword(tutorName); setActiveSuggestField('tutorName'); } }}
              className="admin-sched-input"
              autoComplete="off"
            />
            <input 
              type="text" 
              placeholder="ID Gia sư..." 
              value={tutorId}
              onChange={e => handleFilterInput('tutorId', e.target.value)}
              onFocus={() => { if (tutorId) { setSuggestKeyword(tutorId); setActiveSuggestField('tutorId'); } }}
              className="admin-sched-input"
              autoComplete="off"
            />
            <button 
              onClick={fetchData} 
              style={{ display: 'flex', alignItems: 'center', gap: '6px', padding: '8px 16px', background: '#6366f1', color: '#fff', border: 'none', borderRadius: '8px', cursor: 'pointer', fontWeight: 600, transition: 'background 0.2s', height: '40px' }}
              onMouseOver={e => e.currentTarget.style.background = '#4f46e5'}
              onMouseOut={e => e.currentTarget.style.background = '#6366f1'}
            >
              <Search size={16} /> Tìm kiếm
            </button>

            {/* Autocomplete Dropdown */}
            {showSuggest && (tutorSuggestions.length > 0 || classSuggestions.length > 0) && (
              <div className="suggest-dropdown">
                {tutorSuggestions.length > 0 && (
                  <>
                    <div className="suggest-section-title">🎓 Gia sư</div>
                    {tutorSuggestions.map(t => (
                      <div key={t.id} className="suggest-item" onClick={() => selectTutor(t)}>
                        <div className="suggest-item-main">{t.fullName}</div>
                        <div className="suggest-item-sub">
                          <span>📞 {t.phone}</span>
                          <code>{t.id.substring(0, 8)}...</code>
                        </div>
                      </div>
                    ))}
                  </>
                )}
                {classSuggestions.length > 0 && (
                  <>
                    <div className="suggest-section-title">📚 Lớp học</div>
                    {classSuggestions.map(c => (
                      <div key={c.id} className="suggest-item" onClick={() => selectClass(c)}>
                        <div className="suggest-item-main">{c.classCode} — {c.title}</div>
                        <div className="suggest-item-sub">{c.subject}</div>
                      </div>
                    ))}
                  </>
                )}
              </div>
            )}
          </div>
        </div>

        {/* Analytics Dashboard */}
        <div className="admin-sched-metrics">
          <div className="metric-card">
            <div className="metric-header">
              <BookOpen size={18} color="#6366F1" />
              <span>Tổng Buổi / Tháng</span>
            </div>
            <h3>{analytics?.totalSessions ?? 0}</h3>
          </div>

          <div 
            className="metric-card danger" 
            style={{ cursor: 'pointer', opacity: statDetail === 'MAKEUP' ? 0.8 : 1 }}
            onClick={() => handleStatClick('MAKEUP')}
          >
            <div className="metric-header">
              <AlertCircle size={18} color="#EF4444" />
              <span>Buổi Thiếu (cần bù)</span>
            </div>
            <h3>{analytics?.makeupNeededSessions ?? 0}</h3>
          </div>

          <div 
            className="metric-card info" 
            style={{ cursor: 'pointer', opacity: statDetail === 'EXTRA' ? 0.8 : 1 }}
            onClick={() => handleStatClick('EXTRA')}
          >
            <div className="metric-header">
              <CalendarIcon size={18} color="#8B5CF6" />
              <span>Buổi Tăng Cường</span>
            </div>
            <h3>{analytics?.extraSessions ?? 0}</h3>
          </div>

          <div className="metric-card success">
            <div className="metric-header">
              <DollarSign size={18} color="#10B981" />
              <span>Chi Phí PH (hoàn thành)</span>
            </div>
            <h3>{formatCurrency(analytics?.totalParentRevenue ?? 0)}</h3>
          </div>

          <div className="metric-card warning">
            <div className="metric-header">
              <DollarSign size={18} color="#F59E0B" />
              <span>Lương Gia Sư (hoàn thành)</span>
            </div>
            <h3>{formatCurrency(analytics?.totalTutorSalary ?? 0)}</h3>
          </div>
        </div>

        <div className="admin-calendar-container">
          <div className="admin-calendar-header">
            <button className="nav-btn" onClick={handlePrevMonth}><ChevronLeft size={20}/></button>
            <h3 className="month-title">
              Tháng {currentMonth.getMonth() + 1}, {currentMonth.getFullYear()}
            </h3>
            <button className="nav-btn" onClick={handleNextMonth}><ChevronRight size={20}/></button>
            <button className="today-btn" onClick={handleToday}>Hôm nay</button>
            {loading && <span className="loading-spinner">Đang tải...</span>}
          </div>

          <div className="admin-calendar-grid">
            {['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'].map(d => (
              <div key={d} className="calendar-dow">{d}</div>
            ))}
            
            {gridDays.map((dayObj, i) => {
              const d = dayObj.date;
              const dateIso = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
              const hasSessions = sessionsByDate.has(dateIso);
              const sessionCount = hasSessions ? sessionsByDate.get(dateIso)!.length : 0;
              const isSelected = selectedDateStr === dateIso;
              
              const isToday = new Date().toDateString() === d.toDateString();

              return (
                <div 
                  key={i} 
                  className={`calendar-cell ${dayObj.isCurrentMonth ? 'current-month' : 'other-month'} ${isSelected ? 'selected' : ''} ${isToday ? 'today' : ''}`}
                  onClick={() => {
                    if (!dayObj.isCurrentMonth) return;
                    setSelectedDateStr(isSelected ? null : dateIso);
                  }}
                >
                  <div className="cell-date">{d.getDate()}</div>
                  {sessionCount > 0 && (
                    <div className="session-indicator">
                      {sessionCount} ca
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>

        {/* Selected Date Details */}
        {selectedDateStr && (
          <div className="admin-sched-card detail-view mt-6">
            <div className="detail-header">
              <h3>Chi tiết lịch ngày {fmtDate(selectedDateStr)}</h3>
              <button className="close-btn" onClick={() => setSelectedDateStr(null)}><X size={20}/></button>
            </div>
            
            {selectedSessions.length === 0 ? (
              <div className="admin-sched-empty">
                <CalendarIcon size={32} opacity={0.3} />
                <p>Không có buổi học nào trong ngày này.</p>
              </div>
            ) : (
              <table className="admin-sched-table">
                <thead>
                  <tr>
                    <th>Giờ</th>
                    <th>Lớp / Môn</th>
                    <th>Gia sư</th>
                    <th>Phí (Thu / Chi)</th>
                    <th>Trạng thái</th>
                  </tr>
                </thead>
                <tbody>
                  {selectedSessions.map(s => {
                    const pFee = s.parentFee || 0;
                    const tFee = s.tutorFee || 0;
                    const profit = pFee - tFee;
                    const isExpanded = expandedId === s.id;

                    return (
                      <React.Fragment key={s.id}>
                        <tr 
                          className={`sched-row ${isExpanded ? 'expanded' : ''} ${s.status.includes('CANCELLED') && s.requiresMakeup ? 'gap-warning' : ''}`}
                          onClick={() => setExpandedId(isExpanded ? null : s.id)}
                        >
                          <td>
                            <div className="sched-cell-date">
                              <span><Clock size={12}/> {s.startTime.substring(0,5)} - {s.endTime.substring(0,5)}</span>
                            </div>
                          </td>
                          <td>
                            <div className="sched-cell-title">{s.classTitle || s.classId?.substring(0,8)}</div>
                            <div className="sched-cell-sub">Mã: {s.classCode || 'N/A'} - {s.subject}</div>
                          </td>
                          <td>
                            <span className="sched-tutor-id">{s.tutorName || 'N/A'}</span>
                          </td>
                          <td>
                            <div className="sched-cell-fees" title="Thu từ KH / Trả Gia Sư">
                              <span className="fee-in">{formatCurrency(pFee)}</span>
                              {' / '}
                              <span className="fee-out">{formatCurrency(tFee)}</span>
                            </div>
                          </td>
                          <td>
                            {getStatusLabel(s.status, s.sessionDate, s.endTime)}
                            {s.status.includes('CANCELLED') && s.requiresMakeup && (
                              <div className="sched-gap-badge">⚠️ Cần xếp bù</div>
                            )}
                          </td>
                        </tr>
                        {isExpanded && (
                          <tr className="sched-expanded-row">
                            <td colSpan={5}>
                              <div className="sched-expanded-content">
                                <div className="sec-finance">
                                  <h4>Phân tích Doanh thu (Mỗi buổi)</h4>
                                  <ul>
                                    <li>Thu từ KH: <strong>{formatCurrency(pFee)}</strong></li>
                                    <li>Trả Gia sư: <strong className="fee-out">{formatCurrency(tFee)}</strong></li>
                                    <li>Lợi nhuận (Nền tảng): <strong className="fee-in">{formatCurrency(profit)}</strong></li>
                                  </ul>
                                </div>
                                <div className="sec-info">
                                  <h4>Chi tiết</h4>
                                  <p><strong>ID Buổi học:</strong> {s.id}</p>
                                  <p><strong>Ghi chú:</strong> {s.tutorNote || 'Không có'}</p>
                                </div>
                                <div className="sec-status-change" style={{ marginTop: 12, padding: '12px 16px', background: 'rgba(99,102,241,0.04)', borderRadius: 10, border: '1px solid rgba(99,102,241,0.12)' }}>
                                  <h4 style={{ margin: '0 0 8px', fontSize: '0.85rem', color: '#374151' }}>⚡ Đổi trạng thái</h4>
                                  <div style={{ display: 'flex', gap: 6, flexWrap: 'wrap' }}>
                                    {SESSION_STATUS_OPTIONS.map(opt => {
                                      const isActive = s.status === opt.value;
                                      return (
                                        <button
                                          key={opt.value}
                                          disabled={isActive || statusUpdating === s.id}
                                          onClick={(e) => { e.stopPropagation(); handleStatusChange(s.id, opt.value); }}
                                          style={{
                                            padding: '5px 12px', borderRadius: 8, fontSize: '0.78rem', fontWeight: 600,
                                            cursor: isActive ? 'default' : 'pointer', fontFamily: 'inherit',
                                            border: isActive ? `2px solid ${opt.color}` : '1px solid #d1d5db',
                                            background: isActive ? `${opt.color}15` : '#fff',
                                            color: isActive ? opt.color : '#6b7280',
                                            opacity: statusUpdating === s.id ? 0.5 : 1,
                                            transition: 'all 0.15s',
                                          }}
                                        >
                                          {isActive ? '✓ ' : ''}{opt.label}
                                        </button>
                                      );
                                    })}
                                  </div>
                                </div>
                              </div>
                            </td>
                          </tr>
                        )}
                      </React.Fragment>
                    );
                  })}
                </tbody>
              </table>
            )}
          </div>
        )}

        {/* Selected Stat Details — Class-level Quota */}
        {statDetail && (
          <div className="admin-sched-card detail-view mt-6" style={{ borderTop: statDetail === 'MAKEUP' ? '4px solid #ef4444' : '4px solid #8B5CF6' }}>
            <div className="detail-header">
              <h3>{statDetail === 'MAKEUP' ? 'Chi tiết Lớp Thiếu buổi trong tuần' : 'Chi tiết Lớp Dư buổi trong tuần'}</h3>
              <button className="close-btn" onClick={() => setStatDetail(null)}><X size={20}/></button>
            </div>
            
            {loadingQuota ? (
              <div className="admin-sched-empty">
                <span className="loading-spinner">Đang tải...</span>
              </div>
            ) : filteredQuotaDetails.length === 0 ? (
              <div className="admin-sched-empty">
                <CalendarIcon size={32} opacity={0.3} />
                <p>Không có lớp nào {statDetail === 'MAKEUP' ? 'thiếu' : 'dư'} buổi trong tuần này.</p>
              </div>
            ) : (
              <table className="admin-sched-table">
                <thead>
                  <tr>
                    <th>Mã lớp</th>
                    <th>Tên lớp / Môn</th>
                    <th>Gia sư</th>
                    <th>ID Gia sư</th>
                    <th>Buổi/tuần</th>
                    <th>Đã có</th>
                    <th>{statDetail === 'MAKEUP' ? 'Thiếu' : 'Dư'}</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredQuotaDetails.map(q => (
                    <tr key={q.classId} className="sched-row gap-warning">
                      <td><strong>{q.classCode || 'N/A'}</strong></td>
                      <td>
                        <div className="sched-cell-title">{q.classTitle}</div>
                        <div className="sched-cell-sub">{q.subject}</div>
                      </td>
                      <td><span className="sched-tutor-id">{q.tutorName}</span></td>
                      <td>
                        {q.tutorId ? (
                          <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                            <code style={{ fontSize: '0.72rem', color: '#6b7280', wordBreak: 'break-all' }}>{q.tutorId}</code>
                            <button
                              title="Copy ID"
                              style={{ background: 'none', border: '1px solid #d1d5db', borderRadius: '4px', cursor: 'pointer', padding: '2px 5px', fontSize: '0.7rem', color: '#6366f1', flexShrink: 0 }}
                              onClick={(e) => { e.stopPropagation(); navigator.clipboard.writeText(q.tutorId); const btn = e.currentTarget; btn.textContent = '✓'; setTimeout(() => btn.textContent = '📋', 1000); }}
                            >📋</button>
                          </span>
                        ) : 'N/A'}
                      </td>
                      <td style={{ textAlign: 'center' }}>{q.sessionsPerWeek}</td>
                      <td style={{ textAlign: 'center' }}>{q.activeThisWeek}</td>
                      <td style={{ textAlign: 'center', fontWeight: 700, color: statDetail === 'MAKEUP' ? '#ef4444' : '#8B5CF6' }}>
                        {statDetail === 'MAKEUP' ? q.missingCount : q.extraCount}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default AdminSchedules;
