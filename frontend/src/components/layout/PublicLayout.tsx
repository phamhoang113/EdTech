import { useState } from 'react';
import { Outlet } from 'react-router-dom';
import { Header } from './Header';
import { Footer } from './Footer';
import { LoginModal } from '../auth/LoginModal';
import { FloatingContact } from './FloatingContact';

export type PublicLayoutContext = {
  openLogin: () => void;
  openRegister: () => void;
};

export const PublicLayout = () => {
  const [authModalState, setAuthModalState] = useState<{ isOpen: boolean; mode: 'login' | 'register' }>({
    isOpen: false,
    mode: 'login'
  });

  const openLogin = () => setAuthModalState({ isOpen: true, mode: 'login' });
  const openRegister = () => setAuthModalState({ isOpen: true, mode: 'register' });
  const closeAuth = () => setAuthModalState(prev => ({ ...prev, isOpen: false }));

  return (
    <div style={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
      <Header onLoginClick={openLogin} onRegisterClick={openRegister} />
      <div style={{ flex: 1 }}>
        <Outlet context={{ openLogin, openRegister }} />
      </div>
      <Footer />
      {authModalState.isOpen && <LoginModal onClose={closeAuth} initialMode={authModalState.mode} />}
      <FloatingContact />
    </div>
  );
};
