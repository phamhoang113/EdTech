// @ts-nocheck
import React from 'react';
import { useOutletContext } from 'react-router-dom';
import type { PublicLayoutContext } from '../../components/layout/PublicLayout';
import { HeroSection } from '../../components/home/HeroSection';
import { TutorSection } from '../../components/home/TutorSection';
import { OpenClassesSection } from '../../components/home/OpenClassesSection';
import { HowItWorksSection } from '../../components/home/HowItWorksSection';
import { SEO } from '../../components/common/SEO';
import './LandingPage.css';

export const LandingPage: React.FC = () => {
  const { openLogin, openRegister } = useOutletContext<PublicLayoutContext>();

  const schema = {
    '@context': 'https://schema.org',
    '@graph': [
      {
        '@type': 'WebSite',
        '@id': 'https://giasutinhhoa.com/#website',
        name: 'Gia Sư Tinh Hoa',
        url: 'https://giasutinhhoa.com',
        description: 'Nền tảng EdTech kết nối gia sư chất lượng cao với phụ huynh và học sinh trên toàn quốc.',
        inLanguage: 'vi-VN',
        potentialAction: {
          '@type': 'SearchAction',
          target: {
            '@type': 'EntryPoint',
            urlTemplate: 'https://giasutinhhoa.com/tutors?q={search_term_string}',
          },
          'query-input': 'required name=search_term_string',
        },
      },
      {
        '@type': ['Organization', 'EducationalOrganization'],
        '@id': 'https://giasutinhhoa.com/#organization',
        name: 'Gia Sư Tinh Hoa',
        alternateName: 'GSTH - Premium Tutoring & EdTech',
        url: 'https://giasutinhhoa.com',
        logo: {
          '@type': 'ImageObject',
          url: 'https://giasutinhhoa.com/logo.webp',
          width: 512,
          height: 512,
        },
        description: 'Nền tảng kết nối gia sư uy tín hàng đầu Việt Nam. Tìm gia sư giỏi cho mọi môn học, mọi cấp lớp.',
        sameAs: [
          'https://www.facebook.com/giasutinhhoa.vn',
        ],
      },
      {
        '@type': 'WebPage',
        '@id': 'https://giasutinhhoa.com/#webpage',
        url: 'https://giasutinhhoa.com',
        name: 'Trang Chủ | Gia Sư Tinh Hoa - Nền Tảng Kết Nối Gia Sư Hàng Đầu',
        isPartOf: { '@id': 'https://giasutinhhoa.com/#website' },
        about: { '@id': 'https://giasutinhhoa.com/#organization' },
        inLanguage: 'vi-VN',
      },
    ],
  };

  return (
    <div className="landing-page">
      <SEO
        title="Gia Sư Tinh Hoa - Nền Tảng Kết Nối Gia Sư Hàng Đầu Việt Nam"
        description="Tìm gia sư giỏi, uy tín cho mọi môn học. Gia Sư Tinh Hoa kết nối phụ huynh với các gia sư xuất sắc, sinh viên thủ khoa trên toàn quốc. Đăng ký miễn phí ngay!"
        keywords="gia sư, tìm gia sư, gia sư giỏi, gia sư uy tín, gia sư toán, gia sư tiếng anh, gia sư tại nhà, gia sư online, học kèm, gia sư Hà Nội, gia sư TP HCM, gia sư tinh hoa, edtech, nền tảng gia sư"
        schema={schema}
      />
      <main className="landing-main-layout">
        <div className="landing-hero-wrapper"><HeroSection /></div>
        <div className="landing-classes-wrapper"><OpenClassesSection onAuthRequired={openLogin} /></div>
        <div className="landing-tutors-wrapper"><TutorSection onAuthRequired={openLogin} /></div>
        <div className="landing-hiw-wrapper"><HowItWorksSection /></div>
      </main>

    </div>
  );
};
