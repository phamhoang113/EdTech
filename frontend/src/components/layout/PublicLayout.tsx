import { useState, lazy, Suspense } from 'react';
import { Outlet } from 'react-router-dom';
import { Header } from './Header';
import { Footer } from './Footer';
import { FloatingContact } from './FloatingContact';

const LoginModal = lazy(() => import('../auth/LoginModal').then(module => ({ default: module.LoginModal })));

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
      {authModalState.isOpen && (
        <Suspense fallback={null}>
          <LoginModal onClose={closeAuth} initialMode={authModalState.mode} />
        </Suspense>
      )}
      <FloatingContact />
    </div>
  );
};
