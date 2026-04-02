// @ts-nocheck
import React from 'react';
import { useOutletContext } from 'react-router-dom';
import type { PublicLayoutContext } from '../../components/layout/PublicLayout';
import { HeroSection } from '../../components/home/HeroSection';
import { TutorSection } from '../../components/home/TutorSection';
import { OpenClassesSection } from '../../components/home/OpenClassesSection';
import { HowItWorksSection } from '../../components/home/HowItWorksSection';
import './LandingPage.css';

export const LandingPage: React.FC = () => {
  const { openLogin, openRegister } = useOutletContext<PublicLayoutContext>();


  return (
    <div className="landing-page">
      <main className="landing-main-layout">
        <div className="landing-hero-wrapper"><HeroSection /></div>
        <div className="landing-classes-wrapper"><OpenClassesSection onAuthRequired={openLogin} /></div>
        <div className="landing-tutors-wrapper"><TutorSection onAuthRequired={openLogin} /></div>
        <div className="landing-hiw-wrapper"><HowItWorksSection /></div>
      </main>

      </div>
  );
};
