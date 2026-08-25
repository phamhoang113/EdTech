import React from 'react';
import { Helmet } from 'react-helmet-async';
import { useLocation } from 'react-router-dom';

const BASE_URL = 'https://giasutinhhoa.com';
const DEFAULT_OG_IMAGE_WIDTH = 1200;
const DEFAULT_OG_IMAGE_HEIGHT = 630;

const ORGANIZATION_SCHEMA = {
  '@context': 'https://schema.org',
  '@type': 'Organization',
  name: 'Gia Sư Tinh Hoa',
  alternateName: 'GSTH',
  url: BASE_URL,
  logo: `${BASE_URL}/logo.webp`,
  description: 'Nền tảng EdTech kết nối gia sư chất lượng cao với phụ huynh và học sinh trên toàn quốc.',
  sameAs: [
    'https://www.facebook.com/giasutinhhoa.vn',
  ],
  contactPoint: {
    '@type': 'ContactPoint',
    contactType: 'customer service',
    availableLanguage: 'Vietnamese',
  },
};

interface SEOProps {
  title: string;
  description?: string;
  keywords?: string;
  image?: string;
  imageWidth?: number;
  imageHeight?: number;
  url?: string;
  type?: string;
  schema?: Record<string, any>;
  noIndex?: boolean;
}

/**
 * Ensures URL has trailing slash for non-root paths.
 * Nginx auto-redirects directory URLs (from prerender) with 308,
 * so canonical must match the final served URL to avoid SEO errors.
 */
function normalizeTrailingSlash(rawUrl: string): string {
  try {
    const parsed = new URL(rawUrl);
    if (parsed.pathname !== '/' && !parsed.pathname.endsWith('/')) {
      parsed.pathname += '/';
    }
    return parsed.toString();
  } catch {
    return rawUrl;
  }
}

export const SEO: React.FC<SEOProps> = ({
  title,
  description = 'Nền tảng Gia Sư Tinh Hoa kết nối nhanh chóng, uy tín giữa Phụ huynh, Học sinh và các Gia sư giỏi, sinh viên xuất sắc trên toàn quốc. Trải nghiệm học tập thông minh với lịch học linh hoạt.',
  keywords = 'gia sư, tìm gia sư, gia sư tiếng anh, gia sư toán, gia sư lý, gia sư hóa, gia sư văn, học kèm, gia sư tinh hoa, edtech, giáo dục, học thêm, gia sư tại nhà, gia sư online, tìm gia sư giỏi, gia sư uy tín, gia sư Hà Nội, gia sư TP HCM',
  image = '/logo.webp',
  imageWidth = DEFAULT_OG_IMAGE_WIDTH,
  imageHeight = DEFAULT_OG_IMAGE_HEIGHT,
  url,
  type = 'website',
  schema,
  noIndex = false,
}) => {
  const { pathname } = useLocation();
  const rawCanonical = url || `${BASE_URL}${pathname}`;
  const canonicalUrl = normalizeTrailingSlash(rawCanonical);
  const absoluteImage = image.startsWith('http') ? image : `${BASE_URL}${image}`;
  const fullTitle = title.includes('Gia Sư Tinh Hoa') ? title : `${title} | Gia Sư Tinh Hoa`;

  const schemaData = schema || ORGANIZATION_SCHEMA;

  return (
    <Helmet>
      {/* Standard Metadata */}
      <title>{fullTitle}</title>
      <meta name="description" content={description} />
      <meta name="keywords" content={keywords} />
      <link rel="canonical" href={canonicalUrl} />
      <meta name="robots" content={noIndex ? 'noindex, nofollow' : 'index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1'} />

      {/* Geo Targeting (Việt Nam) */}
      <meta name="geo.region" content="VN" />
      <meta name="geo.placename" content="Vietnam" />
      <meta name="language" content="vi" />
      <meta httpEquiv="content-language" content="vi-VN" />

      {/* Open Graph (Facebook, Zalo) */}
      <meta property="og:type" content={type} />
      <meta property="og:title" content={fullTitle} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={absoluteImage} />
      <meta property="og:image:width" content={String(imageWidth)} />
      <meta property="og:image:height" content={String(imageHeight)} />
      <meta property="og:image:alt" content={fullTitle} />
      <meta property="og:url" content={canonicalUrl} />
      <meta property="og:site_name" content="Gia Sư Tinh Hoa" />
      <meta property="og:locale" content="vi_VN" />

      {/* Twitter Cards */}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={fullTitle} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={absoluteImage} />
      <meta name="twitter:image:alt" content={fullTitle} />

      {/* JSON-LD Structured Data */}
      <script type="application/ld+json">
        {JSON.stringify(schemaData)}
      </script>
    </Helmet>
  );
};
