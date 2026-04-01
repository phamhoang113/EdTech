import { create } from 'zustand';

export interface NotificationState {
  unreadNotifs: number;
  unreadMessages: number;
  setUnreadNotifs: (count: number) => void;
  setUnreadMessages: (count: number) => void;
  incrementUnreadMessages: () => void;
  decrementUnreadMessages: () => void;
}

export const useNotificationStore = create<NotificationState>((set) => ({
  unreadNotifs: 0,
  unreadMessages: 0,
  setUnreadNotifs: (count) => set({ unreadNotifs: count }),
  setUnreadMessages: (count) => set({ unreadMessages: count }),
  incrementUnreadMessages: () => set((state) => ({ unreadMessages: state.unreadMessages + 1 })),
  decrementUnreadMessages: () => set((state) => ({ unreadMessages: Math.max(0, state.unreadMessages - 1) })),
}));
