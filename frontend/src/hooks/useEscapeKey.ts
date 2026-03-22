import { useEffect } from 'react';

/**
 * Hook đóng popup/modal khi nhấn phím Escape.
 * @param onClose Hàm callback đóng popup
 * @param enabled Có bật listener hay không (mặc định true)
 */
export function useEscapeKey(onClose: () => void, enabled = true) {
  useEffect(() => {
    if (!enabled) return;
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Escape') {
        e.stopPropagation();
        onClose();
      }
    };
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [onClose, enabled]);
}
