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
            <h1>Danh Sách <span style={{ color: 'var(--color-primary)' }}>Gia Sư</span></h1>
            <p>Tìm kiếm gia sư phù hợp nhất với nhu cầu học tập của bạn.</p>
          </div>

          <div className="tutors-filters">
            <div className="search-box">
              <Search size={20} color="#94a3b8" />
              <input 
                type="text" 
                placeholder="Tìm theo tên hoặc môn học..." 
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
              />
              <button className="search-submit-btn" onClick={handleSearch}>
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
