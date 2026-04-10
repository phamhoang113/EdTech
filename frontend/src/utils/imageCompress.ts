/**
 * Tiện ích nén ảnh phía Frontend trước khi gửi lên server.
 * - Resize ảnh xuống kích thước tối đa (giữ tỷ lệ)
 * - Convert sang WebP (hoặc JPEG fallback) với quality tùy chỉnh
 * - Trả về base64 data URL nhỏ hơn nhiều lần so với ảnh gốc
 */

const AVATAR_MAX_SIZE = 400;
const CERT_MAX_SIZE = 1200;
const DEFAULT_QUALITY = 0.8;

interface CompressOptions {
  /** Kích thước cạnh dài nhất (px). Mặc định: 400 */
  maxSize?: number;
  /** Chất lượng nén 0-1. Mặc định: 0.8 */
  quality?: number;
  /** Output format. Mặc định: 'image/webp' */
  outputType?: 'image/webp' | 'image/jpeg';
}

/**
 * Nén ảnh từ File → base64 data URL nhỏ gọn.
 *
 * Quy trình: File → Image → Canvas (resize) → toDataURL (nén) → base64
 *
 * Ví dụ: ảnh 3MB PNG → ~80-150KB WebP (giảm 95%)
 */
export function compressImage(file: File, options: CompressOptions = {}): Promise<string> {
  const {
    maxSize = AVATAR_MAX_SIZE,
    quality = DEFAULT_QUALITY,
    outputType = 'image/webp',
  } = options;

  return new Promise((resolve, reject) => {
    const img = new Image();
    const url = URL.createObjectURL(file);

    img.onload = () => {
      URL.revokeObjectURL(url);

      const { width, height } = calculateResizedDimensions(img.width, img.height, maxSize);
      const base64 = drawToBase64(img, width, height, quality, outputType);

      resolve(base64);
    };

    img.onerror = () => {
      URL.revokeObjectURL(url);
      reject(new Error('Không thể đọc file ảnh.'));
    };

    img.src = url;
  });
}

/** Nén ảnh avatar (400×400, quality 0.8) */
export function compressAvatar(file: File): Promise<string> {
  return compressImage(file, { maxSize: AVATAR_MAX_SIZE, quality: DEFAULT_QUALITY });
}

/** Nén ảnh chứng chỉ (max 1200px, quality 0.85) */
export function compressCertificate(file: File): Promise<string> {
  return compressImage(file, { maxSize: CERT_MAX_SIZE, quality: 0.85 });
}

/** Đọc file ảnh thành base64 KHÔNG nén (giữ nguyên gốc) */
export function fileToBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(reader.result as string);
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
}

// ─── Internal Helpers ──────────────────────────────────────────────────

function calculateResizedDimensions(
  originalWidth: number,
  originalHeight: number,
  maxSize: number
): { width: number; height: number } {
  if (originalWidth <= maxSize && originalHeight <= maxSize) {
    return { width: originalWidth, height: originalHeight };
  }

  const ratio = Math.min(maxSize / originalWidth, maxSize / originalHeight);
  return {
    width: Math.round(originalWidth * ratio),
    height: Math.round(originalHeight * ratio),
  };
}

function drawToBase64(
  img: HTMLImageElement,
  width: number,
  height: number,
  quality: number,
  outputType: string
): string {
  const canvas = document.createElement('canvas');
  canvas.width = width;
  canvas.height = height;

  const ctx = canvas.getContext('2d');
  if (!ctx) throw new Error('Canvas context not available');

  ctx.drawImage(img, 0, 0, width, height);

  // Thử WebP trước, fallback sang JPEG nếu browser không hỗ trợ
  let result = canvas.toDataURL(outputType, quality);
  if (outputType === 'image/webp' && !result.startsWith('data:image/webp')) {
    result = canvas.toDataURL('image/jpeg', quality);
  }

  return result;
}
