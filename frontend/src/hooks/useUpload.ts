import { useState, useCallback } from 'react';
import { uploadImage } from '../services/storageApi';

export interface UseUploadState {
  uploading: boolean;
  progress: number;       // 0–100
  url: string | null;     // URL public sau khi upload xong
  error: string | null;
}

export interface UseUploadReturn extends UseUploadState {
  upload: (file: File, folder?: string) => Promise<string | null>;
  reset: () => void;
}

/**
 * Hook upload ảnh trực tiếp lên MinIO qua presigned URL.
 *
 * @example
 * const { upload, uploading, progress, url, error } = useUpload();
 *
 * // Trong onChange của <input type="file">:
 * const imageUrl = await upload(file, 'avatars');
 * if (imageUrl) {
 *   // Lưu imageUrl vào state/form để gửi lên server
 * }
 */
export function useUpload(): UseUploadReturn {
  const [state, setState] = useState<UseUploadState>({
    uploading: false,
    progress: 0,
    url: null,
    error: null,
  });

  const upload = useCallback(async (file: File, folder = 'images'): Promise<string | null> => {
    setState({ uploading: true, progress: 0, url: null, error: null });

    try {
      const fileUrl = await uploadImage(file, folder, (percent) => {
        setState((prev) => ({ ...prev, progress: percent }));
      });

      setState({ uploading: false, progress: 100, url: fileUrl, error: null });
      return fileUrl;
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Upload thất bại';
      setState({ uploading: false, progress: 0, url: null, error: message });
      return null;
    }
  }, []);

  const reset = useCallback(() => {
    setState({ uploading: false, progress: 0, url: null, error: null });
  }, []);

  return { ...state, upload, reset };
}
