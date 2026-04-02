// @ts-nocheck
import React from 'react';
import { useOutletContext } from 'react-router-dom';
import type { PublicLayoutContext } from '../../components/layout/PublicLayout';
import { HeroSection } from '../../components/home/HeroSection';
import { StatsSection } from '../../components/home/StatsSection';
import { TutorSection } from '../../components/home/TutorSection';
import { OpenClassesSection } from '../../components/home/OpenClassesSection';
import { HowItWorksSection } from '../../components/home/HowItWorksSection';
import './LandingPage.css';

export const LandingPage: React.FC = () => {
  const { openLogin, openRegister } = useOutletContext<PublicLayoutContext>();


  return (
    <div className="landing-page">
      <main>
        <HeroSection />
        <StatsSection />
        <OpenClassesSection onAuthRequired={openLogin} />
        <TutorSection onAuthRequired={openLogin} />
        <HowItWorksSection />
      </main>

      </div>
  );
};
