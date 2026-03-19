import apiClient from './apiClient';

/**
 * Upload file qua backend để nhận chuỗi Base64
 *
 * @param file        File cần upload
 * @param folder      Tên thư mục (không dùng cho Base64 nữa, nhưng giữ API parameter signature)
 * @param onProgress  Callback % tiến độ (0–100)
 */
export async function uploadImage(
  file: File,
  folder = 'images',
  onProgress?: (percent: number) => void
): Promise<string> {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('folder', folder);

  const { data } = await apiClient.post('/api/v1/upload/image', formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
    onUploadProgress: (event) => {
      if (onProgress && event.total) {
        const percent = Math.round((event.loaded * 100) / event.total);
        onProgress(percent);
      }
    },
  });

  // Backend hiện tại sẽ trả về Base64 String trong data.data.url
  return data.data.url as string;
}

