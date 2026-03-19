import React, { useState } from 'react';
import { Header } from '../../components/layout/Header';
import { Footer } from '../../components/layout/Footer';
import { HeroSection } from '../../components/home/HeroSection';
import { StatsSection } from '../../components/home/StatsSection';
import { TutorSection } from '../../components/home/TutorSection';
import { OpenClassesSection } from '../../components/home/OpenClassesSection';
import { HowItWorksSection } from '../../components/home/HowItWorksSection';
import { LoginModal } from '../../components/auth/LoginModal';
import './LandingPage.css';

export const LandingPage: React.FC = () => {

  const [authModalState, setAuthModalState] = useState<{ isOpen: boolean; mode: 'login' | 'register' }>({
    isOpen: false,
    mode: 'login'
  });

  const openLogin = () => setAuthModalState({ isOpen: true, mode: 'login' });
  const openRegister = () => setAuthModalState({ isOpen: true, mode: 'register' });
  const closeAuth = () => setAuthModalState((prev) => ({ ...prev, isOpen: false }));

  return (
    <div className="landing-page">
      <Header onLoginClick={openLogin} onRegisterClick={openRegister} />



      <main>
        <HeroSection onRegisterClick={openRegister} />
        <StatsSection />
        <OpenClassesSection onAuthRequired={openLogin} />
        <TutorSection onAuthRequired={openLogin} />
        <HowItWorksSection />
      </main>

      <Footer />

      {authModalState.isOpen && <LoginModal onClose={closeAuth} initialMode={authModalState.mode} />}
    </div>
  );
};
