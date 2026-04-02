// @ts-nocheck
import { useOutletContext } from 'react-router-dom';
import type { PublicLayoutContext } from '../../components/layout/PublicLayout';

import { Search, MapPin, BookOpen, GraduationCap, DollarSign, Hash, ChevronLeft, ChevronRight, User, Award, ChevronDown, ArrowUp, Loader2, Clock, Users } from 'lucide-react';
import { useState, useMemo, useRef, useEffect } from 'react';

import { Button } from '../../components/ui/Button';
import { ClassDetailModal } from '../../components/class/ClassDetailModal';
import './ClassesPage.css';

import { classApi } from '../../services/classApi';
import type { OpenClassResponse, LevelFeeItem } from '../../services/classApi';
import { tutorApi } from '../../services/tutorApi';
import { locationApi } from '../../services/locationApi';
import type { Province, Ward } from '../../services/locationApi';
import { useAuthStore } from '../../store/useAuthStore';

const ITEMS_PER_PAGE = 9;

function MultiSelectFilter({
  label,
  icon: Icon,
  options,
  selectedValues,
  onChange,
  placeholder = "Tất cả"
}: {
  label: string;
  icon: any;
  options: { label: string; value: string }[];
  selectedValues: string[];
  onChange: (values: string[]) => void;
  placeholder?: string;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const wrapperRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (wrapperRef.current && !wrapperRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

  return (
    <div className="filter-group multi-select-wrapper" ref={wrapperRef}>
      <label><Icon size={16} /> {label}</label>
      <div 
        className={`filter-select multi-select-display ${isOpen ? 'open' : ''}`}
        onClick={() => setIsOpen(!isOpen)}
      >
        <span className="multi-select-text">
          {selectedValues.length === 0 ? placeholder : `${selectedValues.length} đã chọn`}
        </span>
        <ChevronDown size={14} className="multi-select-arrow" />
      </div>
      
      {isOpen && (
        <div className="multi-select-dropdown">
          <div className="multi-select-actions">
            <button 
              className="text-btn" 
              onClick={() => onChange(options.map(o => o.value))}
            >
              Chọn tất cả
            </button>
            <span className="separator">|</span>
            <button 
              className="text-btn" 
              onClick={() => onChange([])}
            >
              Bỏ chọn
            </button>
          </div>
          <div className="multi-select-items-container">
            {options.map(opt => (
            <label key={opt.value} className="multi-select-item">
              <input 
                type="checkbox" 
                checked={selectedValues.includes(opt.value)}
                onChange={(e) => {
                  if (e.target.checked) {
                    onChange([...selectedValues, opt.value]);
                  } else {
                    onChange(selectedValues.filter(v => v !== opt.value));
                  }
                }}
              />
              <span>{opt.label}</span>
            </label>
          ))}
          </div>
        </div>
      )}
    </div>
  );
}

const normalizeLocationString = (str: string) => {
  if (!str) return '';
  let s = str.toLowerCase();
  
  // Xóa dấu tiếng việt
  s = s.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
  s = s.replace(/đ/g, "d");

  // Chuẩn hóa viết tắt phổ biến
  s = s.replace(/\btp\s/g, "thanh pho ")
       .replace(/\btp\./g, "thanh pho ")
       .replace(/\bhcm\b/g, "ho chi minh")
       .replace(/\bhn\b/g, "ha noi")
       .replace(/\btt\s/g, "thi tran ")
       .replace(/\btt\./g, "thi tran ")
       .replace(/\bq\.\s*/g, "quan ")
       .replace(/\bh\.\s*/g, "huyen ");

  // Xóa khoảng trắng thừa
  return s.replace(/\s+/g, ' ').trim();
};

export function ClassesPage() {
  const [filterClassCode, setFilterClassCode] = useState('');
  const [filterLocation, setFilterLocation] = useState('All');
  const [filterProvince, setFilterProvince] = useState('');
  const [filterWard, setFilterWard] = useState('');
  const [showAdvanced, setShowAdvanced] = useState(false);
  
  const [filterSubjects, setFilterSubjects] = useState<string[]>([]);
  const [filterLevels, setFilterLevels] = useState<string[]>([]);
  const [filterGenders, setFilterGenders] = useState<string[]>([]);
  const [filterTutorLevels, setFilterTutorLevels] = useState<string[]>([]);

  const [provinces, setProvinces] = useState<Province[]>([]);
  const [wards, setWards] = useState<Ward[]>([]);

  const [appliedFilters, setAppliedFilters] = useState({
    classCode: '',
    location: 'All',
    provinceName: '',
    wardName: '',
    subjects: [] as string[],
    levels: [] as string[],
    genders: [] as string[],
    tutorLevels: [] as string[]
  });

  const [currentPage, setCurrentPage] = useState(1);
  const loadingRef = useRef<boolean>(false); // Prevent multiple load more calls

  // Auto-hide filter bar on scroll & mobile scroll features
  const [showFilterBar, setShowFilterBar] = useState(true);
  const [showBackToTop, setShowBackToTop] = useState(false);

  // Responsive mode tracking
  const [isMobile, setIsMobile] = useState(window.innerWidth <= 768);
  
  const { isAuthenticated, user, setRedirectUrl } = useAuthStore();

  // Login modal state
  /**
   * Mở modal login.
   * forced=true: user bị bắt buộc login (từ một action) → sau khi login sẽ ở lại trang này.
   * forced=false: user chủ động login → sau khi login redirect về dashboard.
   */
  const openLogin = (forced = false) => {
    if (forced) {
      // Lưu lại URL hiện tại để quay lại sau khi login
      setRedirectUrl(window.location.pathname + window.location.search);
    } else {
      setRedirectUrl(null);
    }
    setAuthModalState({ isOpen: true, mode: 'login' });
  };

  const [dbClasses, setDbClasses] = useState<any[]>([]);
  const [appliedIds, setAppliedIds] = useState<Set<string>>(new Set());
  const [toast, setToast] = useState<{ type: 'success' | 'error'; msg: string } | null>(null);

  // Modal state
  const [selectedClass, setSelectedClass] = useState<OpenClassResponse | null>(null);
  const [tutorFeeForLevel, setTutorFeeForLevel] = useState<number | null>(null);
  const [isEligible, setIsEligible] = useState(false);
  const [loadingDetail, setLoadingDetail] = useState(false);
  const [tutorType, setTutorType] = useState<string | null>(null);

  const [filterOptions, setFilterOptions] = useState({
    subjects: [] as string[],
    levels: [] as string[],
    genders: [] as string[],
    tutorLevels: [] as string[]
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [filtersData, classData, provincesData] = await Promise.all([
           classApi.getClassFilters().catch(() => null),
           classApi.getOpenClasses().catch(() => []),
           locationApi.getProvinces().catch(() => [])
        ]);
        
        if (provincesData) {
            setProvinces(provincesData);
        }
        
        if (filtersData) {
            setFilterOptions(filtersData);
            // Auto-apply all backend filters when loaded initially so that the page doesn't start empty
            setAppliedFilters({
              classCode: '',
              location: 'All',
              provinceName: '',
              wardName: '',
              subjects: filtersData.subjects || [],
              levels: filtersData.levels || [],
              genders: filtersData.genders || [],
              tutorLevels: filtersData.tutorLevels || []
            });
            // Also sync the visual dropdowns
            setFilterSubjects(filtersData.subjects || []);
            setFilterLevels(filtersData.levels || []);
            setFilterGenders(filtersData.genders || []);
            setFilterTutorLevels(filtersData.tutorLevels || []);
        }

        const mapped = classData.map((c: any) => {
          let sessions = [2];
          const scheduleStr = c.schedule || '';
          
          if (typeof scheduleStr === 'string' && scheduleStr.includes("3 buổi")) sessions = [3];
          if (typeof scheduleStr === 'string' && scheduleStr.includes("1 buổi")) sessions = [1];
          
          let formattedTimeSlot = scheduleStr;
          try {
            if (typeof scheduleStr === 'string' && scheduleStr.startsWith('[')) {
                const slots = JSON.parse(scheduleStr);
                if (Array.isArray(slots) && slots.length > 0) {
                   sessions = [slots.length];
                   formattedTimeSlot = slots.map((s:any) => {
                      const day = s.dayOfWeek.charAt(0).toUpperCase() + s.dayOfWeek.slice(1).toLowerCase();
                      const start = s.startTime.substring(0, 5);
                      const end = s.endTime.substring(0, 5);
                      return `${day} ${start}-${end}`;
                   }).join(', ');
                } else {
                   formattedTimeSlot = 'Chưa xếp lịch';
                }
            }
          } catch (e) {
             console.error("Format schedule failed", e);
          }

          return {
            id: c.classCode || c.id.substring(0, 6).toUpperCase(),
            classId: c.id, // UUID thực để gọi API apply
            subject: c.subject,
            level: c.grade,
            location: c.location,
            minTutorFee: c.minTutorFee,
            maxTutorFee: c.maxTutorFee,
            sessionsPerWeek: sessions,
            availableDays: c.timeFrame || 'Chưa rõ',
            timeSlot: formattedTimeSlot,
            studentCount: c.studentCount || 1,
            hoursPerSession: c.sessionDurationMin ? c.sessionDurationMin / 60 : 2,
            description: c.title,
            genderRequirement: c.genderRequirement ? [c.genderRequirement] : ['Không yêu cầu'],
            tutorLevelRequirement: c.tutorLevelRequirement || ['Sinh viên', 'Giáo viên'],
            provinceCode: c.provinceCode,
            wardCode: c.wardCode,
            feePercentage: c.feePercentage || 30,
            postedAt: new Date().toLocaleDateString('vi-VN'),
            _raw: c as OpenClassResponse, // giữ ngêyn bản gốc cho ClassDetailModal
          };
        });
        setDbClasses(mapped);

        // Load trạng thái đã apply (chỉ khi là TUTOR)
        if (isAuthenticated && user?.role === 'TUTOR') {
          try {
            const myApps = await classApi.getMyApplications();
            setAppliedIds(new Set(myApps.map(a => a.classId)));
          } catch {
            // Bỏ qua nếu không lấy được
          }
        }
      } catch (err) {
        console.error(err);
      }
    };
    fetchData();

    const handleResize = () => setIsMobile(window.innerWidth <= 768);
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  useEffect(() => {
    if (filterProvince) {
      locationApi.getWardsByProvince(filterProvince)
        .then(setWards)
        .catch(console.error);
    } else {
      setWards([]);
    }
    setFilterWard('');
  }, [filterProvince]);

  const lastScrollYRef = useRef(0);
  
  useEffect(() => {
    const handleScroll = () => {
      const currentScrollY = window.scrollY;
      
      // Filter Bar Logic
      if (showAdvanced) {
        // NEVER auto-hide if the user has intentionally opened the advanced filters menu
        setShowFilterBar(true);
        lastScrollYRef.current = currentScrollY;
      } else if (currentScrollY < 100) {
        setShowFilterBar(true);
        lastScrollYRef.current = currentScrollY;
      } else {
        // Accumulate scroll delta to avoid 1px trackpad jitters dropping the filter bar
        if (currentScrollY > lastScrollYRef.current + 20) {
          setShowFilterBar(false);
          lastScrollYRef.current = currentScrollY;
        } else if (currentScrollY < lastScrollYRef.current - 20) {
          setShowFilterBar(true);
          lastScrollYRef.current = currentScrollY;
        }
      }
      
      // Back to top button logic
      if (currentScrollY > 400) {
        setShowBackToTop(true);
      } else {
        setShowBackToTop(false);
      }

      // Infinite scroll logic for Mobile
      if (isMobile) {
        const scrolledToBottom = window.innerHeight + window.scrollY >= document.body.offsetHeight - 200;
        if (scrolledToBottom && !loadingRef.current) {
          handleLoadMore();
        }
      }
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, [isMobile, showAdvanced]);

  const showToast = (type: 'success' | 'error', msg: string) => {
    setToast({ type, msg });
    setTimeout(() => setToast(null), 3000);
  };

  /** Mở modal chi tiết lớp. Ai cũng xem được, chỉ TUTOR mới check eligibility & fee */
  const handleViewDetail = async (rawClass: any) => {
    const originalClass: OpenClassResponse = rawClass._raw;
    setSelectedClass(originalClass);
    setIsEligible(false);
    setTutorFeeForLevel(null);

    // Chỉ load thêm thông tin TUTOR khi là TUTOR
    if (isAuthenticated && user?.role === 'TUTOR') {
      setLoadingDetail(true);
      try {
        // Load tutor profile nếu chưa có
        let currentTutorType = tutorType;
        if (!currentTutorType) {
          const profile = await tutorApi.getMyProfile();
          currentTutorType = profile.tutorType;
          setTutorType(currentTutorType);
        }

        // Check eligibility
        const requirements = originalClass.tutorLevelRequirement;
        const eligible = currentTutorType != null && requirements.includes(currentTutorType);
        setIsEligible(eligible);

        // Tính học phí đúng level
        let fee: number | null = null;
        if (currentTutorType && originalClass.levelFees) {
          try {
            const levels: LevelFeeItem[] = JSON.parse(originalClass.levelFees);
            const match = levels.find(l => l.level === currentTutorType);
            if (match) fee = match.tutor_fee;
          } catch { /* ignore */ }
        }
        if (fee === null) fee = originalClass.minTutorFee;
        setTutorFeeForLevel(fee);
      } catch (err) {
        console.error('Lỗi load tutor profile', err);
      } finally {
        setLoadingDetail(false);
      }
    }
  };

  const handleApplyFromModal = async (note: string) => {
    if (!selectedClass) return;
    try {
      await classApi.applyForClass(selectedClass.id, note);
      setAppliedIds(prev => new Set([...prev, selectedClass.id]));
      showToast('success', 'Đã đăng ký nhận lớp! Admin sẽ xem xét và liên hệ sớm.');
    } catch (err: any) {
      throw err; // re-throw để modal xử lý error display
    }
  };

  // Lọc dữ liệu
  const filteredClasses = useMemo(() => {
    return dbClasses.filter((c) => {
      // Clean up the applied filters for classCode matching
      const lcCode = appliedFilters.classCode.trim().toLowerCase();
      const matchCode = lcCode === '' || c.id.toLowerCase().includes(lcCode);
      
      const isOnline = c.location === 'Online';
      let matchLocationAndAddress = true;
      
      if (appliedFilters.location === 'Online') {
         matchLocationAndAddress = isOnline;
      } else if (appliedFilters.location === 'Offline') {
         if (isOnline) {
             matchLocationAndAddress = false;
         } else {
             const addr = normalizeLocationString(c.location);
             const pFilter = normalizeLocationString(appliedFilters.provinceName);
             const wFilter = normalizeLocationString(appliedFilters.wardName);
             const matchP = pFilter === '' || addr.includes(pFilter);
             const matchW = wFilter === '' || addr.includes(wFilter);
             matchLocationAndAddress = matchP && matchW;
         }
      } else {
         // All
         if (isOnline) {
            matchLocationAndAddress = true;
         } else {
             const addr = normalizeLocationString(c.location);
             const pFilter = normalizeLocationString(appliedFilters.provinceName);
             const wFilter = normalizeLocationString(appliedFilters.wardName);
             const matchP = pFilter === '' || addr.includes(pFilter);
             const matchW = wFilter === '' || addr.includes(wFilter);
             matchLocationAndAddress = matchP && matchW;
         }
      }
      
      const matchSubject = appliedFilters.subjects.length === 0 || 
                           appliedFilters.subjects.includes(c.subject) ||
                           (appliedFilters.subjects.includes('Khác') && !filterOptions.subjects.includes(c.subject));
      const matchLevel = appliedFilters.levels.length === 0 || appliedFilters.levels.includes(c.level);
      const matchGender = appliedFilters.genders.length === 0 || c.genderRequirement.includes('Không yêu cầu') || c.genderRequirement.some((g: string) => appliedFilters.genders.includes(g));
      const matchTutorLevel = appliedFilters.tutorLevels.length === 0 || c.tutorLevelRequirement.some((t: string) => appliedFilters.tutorLevels.includes(t));
      
      return matchCode && matchSubject && matchLevel && matchLocationAndAddress && matchGender && matchTutorLevel;
    });
  }, [appliedFilters, dbClasses, filterOptions]);

  const handleSearch = () => {
    const pName = provinces.find(p => p.code === filterProvince)?.name || '';
    const wName = wards.find(w => w.code === filterWard)?.name || '';
    
    setAppliedFilters({
      classCode: filterClassCode,
      location: filterLocation,
      provinceName: pName,
      wardName: wName,
      subjects: filterSubjects,
      levels: filterLevels,
      genders: filterGenders,
      tutorLevels: filterTutorLevels
    });
    setCurrentPage(1);
  };

  // Phân trang & Load More
  const totalPages = Math.ceil(filteredClasses.length / ITEMS_PER_PAGE);
  
  // Custom slice based on device: Mobile accumulates, Desktop single page
  const currentClasses = isMobile 
    ? filteredClasses.slice(0, currentPage * ITEMS_PER_PAGE) 
    : filteredClasses.slice((currentPage - 1) * ITEMS_PER_PAGE, currentPage * ITEMS_PER_PAGE);

  const handlePageChange = (page: number) => {
    if (page >= 1 && page <= totalPages) {
      setCurrentPage(page);
      if (!isMobile) {
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    }
  };
  
  const handleLoadMore = () => {
    if (currentPage < totalPages) {
      loadingRef.current = true;
      // Simulate slight network delay for loader to show
      setTimeout(() => {
        setCurrentPage(prev => prev + 1);
        loadingRef.current = false;
      }, 500);
    }
  };

  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <div className="classes-page">
      {/* Hero Header */}
      <section className="classes-hero">
        <div className="container">
          <h1 className="hero-title">
            Tìm Lớp Dạy <span className="highlight">Phù Hợp</span>
          </h1>
          <p className="hero-subtitle">
            Hàng trăm lớp học mới được cập nhật mỗi ngày. Hãy chọn lớp phù hợp với chuyên môn của bạn.
          </p>
        </div>
      </section>

      {/* Main Content */}
      <section className="classes-main container">
        {/* Tiêu chí lọc (Sticky Top Bar) */}
        <div className={`search-filter-bar ${showFilterBar ? '' : 'hide'}`}>
          <div className="filters-grid">
            <div className="filter-group">
              <label><Hash size={16} /> Mã Lớp Tìm Kiếm</label>
              <input 
                type="text" 
                placeholder="Ví dụ: 8Y2K1A"
                value={filterClassCode}
                onChange={(e) => setFilterClassCode(e.target.value)}
                className="filter-input"
                maxLength={6}
              />
            </div>
            
            <MultiSelectFilter
              label="Môn học"
              icon={BookOpen}
              options={filterOptions.subjects.map(s => ({ label: s, value: s }))}
              selectedValues={filterSubjects}
              onChange={setFilterSubjects}
              placeholder="Tất cả môn"
            />

            <MultiSelectFilter
              label="Cấp độ"
              icon={GraduationCap}
              options={filterOptions.levels.map(l => ({ label: l, value: l }))}
              selectedValues={filterLevels}
              onChange={setFilterLevels}
              placeholder="Tất cả cấp độ"
            />

            <div className="filter-group">
              <label><MapPin size={16} /> Hình thức</label>
              <select 
                value={filterLocation} 
                onChange={(e) => setFilterLocation(e.target.value)} 
                className="filter-select"
              >
                <option value="All">Tất cả</option>
                <option value="Offline">Offline</option>
                <option value="Online">Online</option>
              </select>
            </div>
          </div>
          
          {showAdvanced && (
            <div className="filters-advanced-grid filters-grid">
              
              <div className="filter-group">
                <label><MapPin size={16} /> Tỉnh / Thành phố</label>
                <select 
                  value={filterProvince} 
                  onChange={(e) => setFilterProvince(e.target.value)} 
                  className="filter-select"
                  disabled={filterLocation === 'Online'}
                >
                  <option value="">Tất cả tỉnh thành</option>
                  {provinces.map(p => (
                    <option key={p.code} value={p.code}>{p.name}</option>
                  ))}
                </select>
              </div>

              <div className="filter-group">
                <label><MapPin size={16} /> Quận / Huyện / Xã</label>
                <select 
                  value={filterWard} 
                  onChange={(e) => setFilterWard(e.target.value)} 
                  className="filter-select"
                  disabled={!filterProvince || filterLocation === 'Online'}
                >
                  <option value="">Tất cả khu vực</option>
                  {wards.map(w => (
                    <option key={w.code} value={w.code}>{w.name}</option>
                  ))}
                </select>
              </div>

              <MultiSelectFilter
                label="Giới tính"
                icon={User}
                options={filterOptions.genders.map(g => ({ label: g, value: g }))}
                selectedValues={filterGenders}
                onChange={setFilterGenders}
                placeholder="Tất cả giới tính"
              />

              <MultiSelectFilter
                label="Trình độ"
                icon={Award}
                options={filterOptions.tutorLevels.map(t => ({ label: t, value: t }))}
                selectedValues={filterTutorLevels}
                onChange={setFilterTutorLevels}
                placeholder="Tất cả trình độ"
              />

            </div>
          )}

          <div className="filter-actions-row">
            <div className="filter-actions-left">
              <Button variant="ghost" onClick={() => setShowAdvanced(!showAdvanced)} className="advanced-filter-btn">
                {showAdvanced ? 'Thu gọn nâng cao' : 'Mở rộng nâng cao'}
              </Button>
            </div>
            
            <div className="filter-actions-right">
            <Button variant="ghost" onClick={() => {
              setFilterClassCode(''); setFilterLocation('All');
              setFilterProvince(''); setFilterWard('');
              setFilterSubjects([]); setFilterLevels([]); setFilterGenders([]); setFilterTutorLevels([]);
            }} className="clear-filter-btn">
              Xóa bộ lọc
            </Button>
            <Button variant="primary" onClick={handleSearch} className="search-btn">
              Tìm kiếm
            </Button>
            </div>
          </div>
        </div>

        {/* Danh sách lớp học */}
        <div className="classes-content">
          <div className="classes-header-info">
            <p>Tìm thấy <strong>{filteredClasses.length}</strong> lớp học phù hợp</p>
          </div>

          <div className="classes-grid">
            {currentClasses.length > 0 ? (
              currentClasses.map((cls) => {
                const minFee = cls.minTutorFee;
                const maxFee = cls.maxTutorFee;
                const isRange = minFee !== maxFee;

                return (
                  <div key={cls.id} className="class-card group">
                    <div className="card-header">
                      <span className="class-id"><Hash size={14} /> {cls.id}</span>
                      <span className="class-badge fee">Phí nhận lớp: {cls.feePercentage}%</span>
                    </div>
                    
                    <h3 className="class-title">{cls.subject} - {cls.level}</h3>
                    
                    <div className="class-details">
                      <div className="detail-item highlight-fee-box">
                        <DollarSign size={18} className="icon-money" />
                        <span>
                          <strong className="fee-amount">
                             {isRange 
                               ? `${minFee.toLocaleString('vi-VN')}đ - ${maxFee.toLocaleString('vi-VN')}đ` 
                               : `${minFee.toLocaleString('vi-VN')}đ`}
                          </strong> / tháng
                        </span>
                      </div>
                      
                      <div className="detail-item">
                        <MapPin size={16} className="icon-location" />
                        {cls.location === 'Online' ? (
                          <span>Online (Trực tuyến)</span>
                        ) : (
                          <a 
                            href={`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(cls.location)}`} 
                            target="_blank" 
                            rel="noopener noreferrer"
                            className="map-link hover:underline text-blue-600"
                          >
                            {cls.location}
                          </a>
                        )}
                      </div>
                      
                      <div className="details-grid">
                        <div className="detail-item">
                          <Users size={16} className="icon-student" />
                          <span><strong>{cls.studentCount}</strong> học sinh</span>
                        </div>
                        <div className="detail-item">
                          <BookOpen size={16} className="icon-session" />
                          <span><strong>{cls.sessionsPerWeek.join(' hoặc ')}</strong> buổi/tuần ({cls.hoursPerSession}h)</span>
                        </div>
                        <div className="detail-item">
                          <Clock size={16} className="icon-time" />
                          <span>Lịch học: {cls.availableDays} ({cls.timeSlot})</span>
                        </div>
                      </div>
                    </div>

                    <div className="class-requirement">
                      <p><strong>Yêu cầu:</strong> {cls.tutorLevelRequirement.join(', ')} {cls.genderRequirement.includes('Không yêu cầu') ? '' : `(${cls.genderRequirement.join(', ')})`}</p>
                      <p><strong>Mô tả:</strong> {cls.description}</p>
                    </div>

                    <div className="card-actions">
                      {(() => {
                        const isApplied = appliedIds.has(cls.classId);
                        if (isApplied) {
                          return (
                            <button disabled style={{
                              width: '100%', padding: '12px', borderRadius: '10px',
                              background: 'rgba(16,185,129,0.1)', color: '#10b981',
                              border: '1.5px solid #10b981', fontWeight: 600,
                              fontSize: '0.95rem', cursor: 'not-allowed', fontFamily: 'inherit',
                            }}>
                              ✓ Đã đăng ký
                            </button>
                          );
                        }
                        return (
                          <Button
                            variant="primary"
                            className="btn-apply w-full"
                            onClick={() => handleViewDetail(cls)}
                            disabled={loadingDetail}
                          >
                            {loadingDetail ? '⏳ Đang tải...' : 'Xem Chi Tiết'}
                          </Button>
                        );
                      })()}
                    </div>
                  </div>
                );
              })
            ) : (
              <div className="no-results">
                <Search size={48} />
                <p>Không tìm thấy lớp học nào phù hợp với bộ lọc của bạn.</p>
                <div style={{ marginTop: '16px' }}>
                  <Button variant="ghost" onClick={() => {
                    setFilterClassCode(''); setFilterLocation('All');
                    setFilterProvince(''); setFilterWard('');
                    setFilterSubjects([]); setFilterLevels([]); setFilterGenders([]); setFilterTutorLevels([]);
                    setAppliedFilters({ classCode: '', location: 'All', provinceName: '', wardName: '', subjects: [], levels: [], genders: [], tutorLevels: [] });
                    setCurrentPage(1);
                  }}>Xóa bộ lọc và thử lại</Button>
                </div>
              </div>
            )}
          </div>

          {/* Pagination / Load More */}
          {totalPages > 1 && (
            <div className="pagination">
              {isMobile ? (
                currentPage < totalPages && (
                  <div style={{ display: 'flex', justifyContent: 'center', padding: '20px 0', width: '100%' }}>
                    <Loader2 size={24} className="infinite-loader-icon" />
                  </div>
                )
              ) : (
                <>
                  <button 
                    className="page-btn" 
                    onClick={() => handlePageChange(currentPage - 1)}
                    disabled={currentPage === 1}
                  >
                    <ChevronLeft size={20} />
                  </button>
                  
                  {Array.from({ length: totalPages }).map((_, i) => (
                    <button 
                      key={i}
                      className={`page-btn ${currentPage === i + 1 ? 'active' : ''}`}
                      onClick={() => handlePageChange(i + 1)}
                    >
                      {i + 1}
                    </button>
                  ))}

                  <button 
                    className="page-btn" 
                    onClick={() => handlePageChange(currentPage + 1)}
                    disabled={currentPage === totalPages}
                  >
                    <ChevronRight size={20} />
                  </button>
                </>
              )}
            </div>
          )}
        </div>
      </section>

      {/* Back to Top Button */}
      <button 
        className={`back-to-top-btn ${showBackToTop ? 'visible' : ''}`} 
        onClick={scrollToTop}
        aria-label="Back to top"
      >
        <ArrowUp size={24} />
      </button>

      {/* Class Detail Modal */}
      {selectedClass && (
        <ClassDetailModal
          cls={selectedClass}
          tutorType={tutorType}
          tutorFeeForLevel={tutorFeeForLevel}
          isEligible={isEligible}
          isApplied={appliedIds.has(selectedClass.id)}
          onApply={handleApplyFromModal}
          onClose={() => setSelectedClass(null)}
        />
      )}

      {/* Toast notification */}
      {toast && (
        <div style={{
          position: 'fixed', bottom: '24px', right: '24px', zIndex: 9999,
          background: toast.type === 'success' ? '#10b981' : '#ef4444',
          color: '#fff', padding: '12px 20px', borderRadius: '10px',
          boxShadow: '0 4px 16px rgba(0,0,0,0.2)',
          fontSize: '14px', fontWeight: 500, maxWidth: '360px',
        }}>
          {toast.type === 'success' ? '✓ ' : '✕ '}{toast.msg}
        </div>
      )}
    </div>
  );
}
