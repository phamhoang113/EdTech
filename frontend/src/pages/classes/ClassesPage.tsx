import { useState, useMemo, useRef, useEffect } from 'react';
import { Search, MapPin, BookOpen, GraduationCap, DollarSign, Hash, ChevronLeft, ChevronRight, User, Award, Compass, ChevronDown, ArrowUp, Loader2, Clock, Users } from 'lucide-react';
import { Button } from '../../components/ui/Button';
import { Header } from '../../components/layout/Header';
import { Footer } from '../../components/layout/Footer';
import { LoginModal } from '../../components/auth/LoginModal';
import './ClassesPage.css';

import { classApi } from '../../services/classApi';



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

export function ClassesPage() {
  const [filterClassCode, setFilterClassCode] = useState('');
  const [filterLocation, setFilterLocation] = useState('All');
  const [filterDistance, setFilterDistance] = useState('All');
  const [showAdvanced, setShowAdvanced] = useState(false);
  
  const [filterSubjects, setFilterSubjects] = useState<string[]>([]);
  const [filterLevels, setFilterLevels] = useState<string[]>([]);
  const [filterGenders, setFilterGenders] = useState<string[]>([]);
  const [filterTutorLevels, setFilterTutorLevels] = useState<string[]>([]);

  const [appliedFilters, setAppliedFilters] = useState({
    classCode: '',
    location: 'All',
    distance: 'All',
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
  
  const [dbClasses, setDbClasses] = useState<any[]>([]);
  const [filterOptions, setFilterOptions] = useState({
    subjects: [] as string[],
    levels: [] as string[],
    genders: [] as string[],
    tutorLevels: [] as string[]
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [filtersData, classData] = await Promise.all([
           classApi.getClassFilters(),
           classApi.getOpenClasses()
        ]);
        
        if (filtersData) {
            setFilterOptions(filtersData);
            // Auto-apply all backend filters when loaded initially so that the page doesn't start empty
            setAppliedFilters({
              classCode: '',
              location: 'All',
              distance: 'All',
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

        // Ánh xạ dữ liệu trả về từ API sang format mà ClassesPage đang cần
        const mapped = classData.map((c: any) => {
          let sessions = [2];
          let scheduleStr = c.schedule || '';
          
          if (typeof scheduleStr === 'string' && scheduleStr.includes("3 buổi")) sessions = [3];
          if (typeof scheduleStr === 'string' && scheduleStr.includes("1 buổi")) sessions = [1];
          
          let formattedTimeSlot = scheduleStr;
          try {
            if (typeof scheduleStr === 'string' && scheduleStr.startsWith('[')) {
                const slots = JSON.parse(scheduleStr);
                if (Array.isArray(slots) && slots.length > 0) {
                   sessions = [slots.length]; // Base runtime sessions on physical DB slots count
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
            id: c.classCode || c.id.substring(0, 6).toUpperCase(), // Use 6-digit code
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
            distance: 5,
            feePercentage: c.feePercentage || 30,
            postedAt: new Date().toLocaleDateString('vi-VN')
          };
        });
        setDbClasses(mapped);
      } catch (err) {
        console.error(err);
      }
    };
    fetchData();

    const handleResize = () => setIsMobile(window.innerWidth <= 768);
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

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

  const openLogin = () => setAuthModalState({ isOpen: true, mode: 'login' });
  const openRegister = () => setAuthModalState({ isOpen: true, mode: 'register' });
  const closeAuth = () => setAuthModalState((prev) => ({ ...prev, isOpen: false }));

  // Lọc dữ liệu
  const filteredClasses = useMemo(() => {
    return dbClasses.filter((c) => {
      // Clean up the applied filters for classCode matching
      const lcCode = appliedFilters.classCode.trim().toLowerCase();
      const matchCode = lcCode === '' || c.id.toLowerCase().includes(lcCode);
      
      const matchLocation = appliedFilters.location === 'All' || (appliedFilters.location === 'Online' ? c.location === 'Online' : c.location !== 'Online');
      const matchDistance = appliedFilters.distance === 'All' || c.distance <= parseInt(appliedFilters.distance);
      
      const matchSubject = appliedFilters.subjects.length === 0 || 
                           appliedFilters.subjects.includes(c.subject) ||
                           (appliedFilters.subjects.includes('Khác') && !filterOptions.subjects.includes(c.subject));
      const matchLevel = appliedFilters.levels.length === 0 || appliedFilters.levels.includes(c.level);
      const matchGender = appliedFilters.genders.length === 0 || c.genderRequirement.includes('Không yêu cầu') || c.genderRequirement.some((g: string) => appliedFilters.genders.includes(g));
      const matchTutorLevel = appliedFilters.tutorLevels.length === 0 || c.tutorLevelRequirement.some((t: string) => appliedFilters.tutorLevels.includes(t));
      
      return matchCode && matchSubject && matchLevel && matchLocation && matchDistance && matchGender && matchTutorLevel;
    });
  }, [appliedFilters]);

  const handleSearch = () => {
    setAppliedFilters({
      classCode: filterClassCode,
      location: filterLocation,
      distance: filterDistance,
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

  const [authModalState, setAuthModalState] = useState<{ isOpen: boolean; mode: 'login' | 'register' }>({
    isOpen: false,
    mode: 'login'
  });

  return (
    <div className="classes-page">
      <Header onLoginClick={openLogin} onRegisterClick={openRegister} />

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

              <div className="filter-group">
                <label><Compass size={16} /> Khoảng cách</label>
                <select 
                  value={filterDistance} 
                  onChange={(e) => setFilterDistance(e.target.value)} 
                  className="filter-select"
                >
                  <option value="All">Tất cả</option>
                  <option value="5">Dưới 5 km</option>
                  <option value="10">Dưới 10 km</option>
                  <option value="20">Dưới 20 km</option>
                </select>
              </div>
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
              setFilterClassCode(''); setFilterLocation('All'); setFilterDistance('All');
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
                      <Button variant="primary" className="btn-apply w-full">
                        Nhận Lớp Ngay
                      </Button>
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
                    setFilterClassCode(''); setFilterLocation('All'); setFilterDistance('All');
                    setFilterSubjects([]); setFilterLevels([]); setFilterGenders([]); setFilterTutorLevels([]);
                    setAppliedFilters({ classCode: '', location: 'All', distance: 'All', subjects: [], levels: [], genders: [], tutorLevels: [] });
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

      <Footer />

      {/* Back to Top Button */}
      <button 
        className={`back-to-top-btn ${showBackToTop ? 'visible' : ''}`} 
        onClick={scrollToTop}
        aria-label="Back to top"
      >
        <ArrowUp size={24} />
      </button>

      {authModalState.isOpen && <LoginModal onClose={closeAuth} initialMode={authModalState.mode} />}
    </div>
  );
}
