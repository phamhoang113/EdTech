import { create } from 'zustand';

export type UserRole = 'PARENT' | 'STUDENT' | 'TUTOR' | 'ADMIN';

export interface User {
  phone: string;
  role: UserRole;
  fullName: string;
  avatarBase64?: string;
}

interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
  redirectUrl: string | null;
  setRedirectUrl: (url: string | null) => void;
  login: (user: User, accessToken: string, refreshToken: string) => void;
  updateUser: (patch: Partial<User>) => void;
  logout: () => void;
}

/** Khởi tạo user từ localStorage để persist qua page reload */
const loadUserFromStorage = (): { isAuthenticated: boolean; user: User | null } => {
  try {
    const token = localStorage.getItem('accessToken');
    const raw = localStorage.getItem('authUser');
    if (token && raw) {
      const user = JSON.parse(raw) as User;
      return { isAuthenticated: true, user };
    }
  } catch {
    // ignore parse error
  }
  return { isAuthenticated: false, user: null };
};

const initial = loadUserFromStorage();

export const useAuthStore = create<AuthState>((set) => ({
  isAuthenticated: initial.isAuthenticated,
  user: initial.user,
  redirectUrl: null,
  setRedirectUrl: (url) => set({ redirectUrl: url }),

  login: (user, accessToken, refreshToken) => {
    localStorage.setItem('accessToken', accessToken);
    localStorage.setItem('refreshToken', refreshToken);
    localStorage.setItem('authUser', JSON.stringify(user));
    set({ isAuthenticated: true, user });
  },

  updateUser: (patch) => set((state) => {
    const updated = state.user ? { ...state.user, ...patch } : state.user;
    if (updated) localStorage.setItem('authUser', JSON.stringify(updated));
    return { user: updated };
  }),

  logout: () => {
    localStorage.removeItem('accessToken');
    localStorage.removeItem('refreshToken');
    localStorage.removeItem('authUser');
    set({ isAuthenticated: false, user: null });
  },
}));
