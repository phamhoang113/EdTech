import React from 'react';
import { Helmet } from 'react-helmet-async';
import { useLocation } from 'react-router-dom';

const BASE_URL = 'https://giasutinhhoa.com';

interface SEOProps {
  title: string;
  description?: string;
  keywords?: string;
  image?: string;
  url?: string;
  type?: string;
  schema?: Record<string, any>;
}

export const SEO: React.FC<SEOProps> = ({
  title,
  description = 'Nền tảng Gia Sư Tinh Hoa kết nối nhanh chóng, uy tín giữa Phụ huynh, Học sinh và các Gia sư giỏi, sinh viên xuất sắc trên toàn quốc.',
  keywords = 'gia sư, tìm gia sư, gia sư tiếng anh, gia sư toán, học kèm, gia sư tinh hoa, edtech, giáo dục, học thêm, gia sư tại nhà',
  image = '/logo.webp',
  url,
  type = 'website',
  schema,
}) => {
  const { pathname } = useLocation();
  const canonicalUrl = url || `${BASE_URL}${pathname}`;
  const absoluteImage = image.startsWith('http') ? image : `${BASE_URL}${image}`;

  return (
    <Helmet>
      {/* Standard Metadata */}
      <title>{title}</title>
      <meta name="description" content={description} />
      <meta name="keywords" content={keywords} />
      <link rel="canonical" href={canonicalUrl} />

      {/* Open Graph (Facebook, Zalo) */}
      <meta property="og:type" content={type} />
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={absoluteImage} />
      <meta property="og:url" content={canonicalUrl} />
      <meta property="og:site_name" content="Gia Sư Tinh Hoa" />

      {/* Twitter Cards */}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={absoluteImage} />

      {/* JSON-LD Schema */}
      {schema && (
        <script type="application/ld+json">
          {JSON.stringify(schema)}
        </script>
      )}
    </Helmet>
  );
};
