import { useState, useEffect, useCallback } from 'react';
import { useLocation } from 'react-router-dom';
import apiClient from '../services/apiClient';

const POLL_INTERVAL = 30_000; // 30 giây

/**
 * Hook lấy badge counts từ backend — tự poll mỗi 30s + re-fetch khi chuyển trang.
 * Returns object {[key]: count} tuỳ role:
 *   Admin  → pendingApplications, pendingVerifications, pendingClassRequests
 *   Parent → proposedApplicants
 *   Tutor  → openClasses
 */
export function useBadgeCounts(): Record<string, number> {
  const [counts, setCounts] = useState<Record<string, number>>({});
  const location = useLocation();

  const fetchCounts = useCallback(async () => {
    try {
      const res = await apiClient.get('/api/v1/badge-counts');
      setCounts(res.data?.data ?? {});
    } catch { /* silent */ }
  }, []);

  useEffect(() => {
    fetchCounts();
    const timer = setInterval(fetchCounts, POLL_INTERVAL);
    
    // Lắng nghe event từ các component khác để refetch ngay lập tức
    const handleRefetch = () => fetchCounts();
    window.addEventListener('refetchBadgeCounts', handleRefetch);
    
    return () => {
      clearInterval(timer);
      window.removeEventListener('refetchBadgeCounts', handleRefetch);
    };
  }, [fetchCounts]);

  // Re-fetch khi chuyển trang (vừa duyệt xong → badge giảm)
  useEffect(() => { fetchCounts(); }, [location.pathname, fetchCounts]);

  return counts;
}
