import React from 'react';
import { Helmet } from 'react-helmet-async';

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
  image = '/logo.png',
  url = 'https://giasutinhhoa.com',
  type = 'website',
  schema,
}) => {
  return (
    <Helmet>
      {/* Standard Metadata */}
      <title>{title}</title>
      <meta name="description" content={description} />
      <meta name="keywords" content={keywords} />

      {/* Open Graph (Facebook, Zalo) */}
      <meta property="og:type" content={type} />
      <meta property="og:title" content={title} />
      <meta property="og:description" content={description} />
      <meta property="og:image" content={image} />
      <meta property="og:url" content={url} />
      <meta property="og:site_name" content="Gia Sư Tinh Hoa" />

      {/* Twitter Cards */}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content={title} />
      <meta name="twitter:description" content={description} />
      <meta name="twitter:image" content={image} />

      {/* JSON-LD Schema */}
      {schema && (
        <script type="application/ld+json">
          {JSON.stringify(schema)}
        </script>
      )}
    </Helmet>
  );
};
