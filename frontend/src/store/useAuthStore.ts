import { create } from 'zustand';

interface User {
  id: string;
  phone: string;
  role: 'PARENT' | 'STUDENT' | 'TUTOR' | 'ADMIN';
  name?: string;
}

interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
  redirectUrl: string | null;
  setRedirectUrl: (url: string | null) => void;
  login: (user: User) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  isAuthenticated: false,
  user: null,
  redirectUrl: null,
  setRedirectUrl: (url) => set({ redirectUrl: url }),
  login: (user) => set({ isAuthenticated: true, user }),
  logout: () => set({ isAuthenticated: false, user: null }),
}));
