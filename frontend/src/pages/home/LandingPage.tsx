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
    '@type': 'WebSite',
    name: 'Gia Sư Tinh Hoa',
    url: 'https://giasutinhhoa.com',
  };

  return (
    <div className="landing-page">
      <SEO title="Trang Chủ | Gia Sư Tinh Hoa" schema={schema} />
      <main className="landing-main-layout">
        <div className="landing-hero-wrapper"><HeroSection /></div>
        <div className="landing-classes-wrapper"><OpenClassesSection onAuthRequired={openLogin} /></div>
        <div className="landing-tutors-wrapper"><TutorSection onAuthRequired={openLogin} /></div>
        <div className="landing-hiw-wrapper"><HowItWorksSection /></div>
      </main>

    </div>
  );
};
