// @ts-nocheck
import { useOutletContext } from 'react-router-dom';
import type { PublicLayoutContext } from '../../components/layout/PublicLayout';
import { Search } from 'lucide-react';
import React, { useState, useEffect } from 'react';
import { TutorCard } from '../../components/home/TutorCard';
import { tutorPublicApi } from '../../services/tutorPublicApi';
import type { TutorPublicResponse } from '../../services/tutorPublicApi';

import './TutorsPage.css';

export const TutorsPage: React.FC = () => {
  const { openLogin, openRegister } = useOutletContext<PublicLayoutContext>();

  const [tutors, setTutors] = useState<TutorPublicResponse[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(1);
  const [searchQuery, setSearchQuery] = useState('');
  const [appliedQuery, setAppliedQuery] = useState('');

  const fetchTutors = async (pageIndex: number) => {
    try {
      setLoading(true);
      const res = await tutorPublicApi.getPublicTutors({ 
        page: pageIndex, 
        size: 12, 
        sort: 'rating,desc',
        keyword: appliedQuery || undefined 
      } as any);
      if (res.data) {
        setTutors(res.data.content);
        setTotalPages(res.data.totalPages);
      }
    } catch (error) {
      console.error('Lỗi khi tải danh sách gia sư:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTutors(page);
  }, [page, appliedQuery]);

  const handleSearch = () => {
    setPage(0);
    setAppliedQuery(searchQuery);
  };

  return (
    <div className="tutors-page">
      <main className="tutors-main">
        <div className="container">
          <div className="tutors-header">
            <h1>Danh Sách Gia Sư</h1>
            <p>Tìm kiếm gia sư phù hợp nhất với nhu cầu học tập của bạn.</p>
          </div>

          {/* Search bar */}
          <div className="tutors-filters" style={{ display: 'flex', justifyContent: 'center', marginBottom: '2rem' }}>
            <div 
              className="search-box" 
              style={{ 
                width: '100%', 
                maxWidth: '600px',
                display: 'flex', 
                alignItems: 'center', 
                background: 'white', 
                borderRadius: '12px', 
                padding: '6px 6px 6px 16px', 
                border: '1px solid #e2e8f0',
                boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03)',
                transition: 'box-shadow 0.2s ease, border-color 0.2s ease'
              }}
            >
              <Search size={22} color="#94a3b8" />
              <input 
                type="text" 
                placeholder="Tìm theo tên hoặc môn học của gia sư..." 
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
                style={{ 
                  flex: 1,
                  border: 'none', 
                  background: 'transparent', 
                  padding: '12px 16px',
                  fontSize: '1rem',
                  outline: 'none',
                  color: '#1e293b'
                }}
              />
              <button 
                className="search-submit-btn" 
                onClick={handleSearch}
                style={{ 
                  padding: '0 24px', 
                  height: '44px',
                  background: 'var(--color-primary, #6366f1)', 
                  color: 'white', 
                  border: 'none', 
                  borderRadius: '8px', 
                  cursor: 'pointer', 
                  fontWeight: 600,
                  fontSize: '0.95rem',
                  transition: 'background-color 0.2s ease, transform 0.1s ease',
                  whiteSpace: 'nowrap'
                }}
                onMouseOver={(e) => e.currentTarget.style.backgroundColor = 'var(--color-primary-dark, #4f46e5)'}
                onMouseOut={(e) => e.currentTarget.style.backgroundColor = 'var(--color-primary, #6366f1)'}
                onMouseDown={(e) => e.currentTarget.style.transform = 'scale(0.97)'}
                onMouseUp={(e) => e.currentTarget.style.transform = 'scale(1)'}
              >
                Tìm kiếm
              </button>
            </div>
          </div>

          {loading ? (
            <div className="loading-state">Đang tải danh sách gia sư...</div>
          ) : tutors.length === 0 ? (
            <div className="empty-state">Không tìm thấy gia sư nào phù hợp.</div>
          ) : (
            <>
              <div className="tutors-grid">
                {tutors.map((tutor) => (
                  <TutorCard 
                    key={tutor.userId} 
                    tutor={{
                      id: tutor.userId,
                      name: tutor.fullName,
                      subjects: tutor.subjects || [],
                      rating: tutor.rating || 0,
                      reviews: tutor.ratingCount || 0,
                      hourlyRate: tutor.hourlyRate || 0,
                      isOnline: false,
                      avatarBase64: tutor.avatarBase64,
                      bio: tutor.bio
                    }} 
                  />
                ))}
              </div>

              {totalPages > 1 && (
                <div className="pagination">
                  <button 
                    disabled={page === 0} 
                    onClick={() => setPage(p => Math.max(0, p - 1))}
                  >
                    Trước
                  </button>
                  <span className="page-info">Trang {page + 1} / {totalPages}</span>
                  <button 
                    disabled={page >= totalPages - 1} 
                    onClick={() => setPage(p => Math.min(totalPages - 1, p + 1))}
                  >
                    Sau
                  </button>
                </div>
              )}
            </>
          )}
        </div>
      </main>

      </div>
  );
};

