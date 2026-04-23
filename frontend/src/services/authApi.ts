import apiClient from './apiClient';

export interface TokenResponse {
  accessToken: string;
  refreshToken: string;
  role: 'PARENT' | 'STUDENT' | 'TUTOR' | 'ADMIN';
  fullName: string;
  avatarBase64: string | null;
  isActive: boolean;
  mustChangePassword?: boolean;
  authProvider?: string;
  email?: string;
  hasPassword?: boolean;
  linkedProviders?: string[];
}

/** Payload for registering or authenticating via Firebase */
export interface FirebaseAuthPayload {
  idToken: string;
  fullName?: string;
  password?: string;
  role?: 'PARENT' | 'TUTOR' | 'STUDENT';
}

export interface LoginPayload {
  phone: string;
  password: string;
}

export interface LinkedProvider {
  provider: string;
  providerEmail: string;
  linkedAt: string;
}


const unwrap = <T>(res: { data: { data: T } }): T => res.data.data;

export const loginApi = async (payload: LoginPayload): Promise<TokenResponse> => {
  const res = await apiClient.post('/api/v1/auth/login', payload);
  return unwrap(res);
};

/** Send idToken along with registration info to Backend */
export const firebaseAuthApi = async (payload: FirebaseAuthPayload): Promise<TokenResponse> => {
  const res = await apiClient.post('/api/v1/auth/firebase', payload);
  return unwrap(res);
};

export const initForgotPasswordApi = async (identifier: string): Promise<{ maskedPhone: string; fullPhone: string }> => {
  const res = await apiClient.post('/api/v1/auth/forgot-password/init', { identifier });
  return unwrap(res);
};

export const resetPasswordApi = async (payload: { identifier: string; idToken: string }): Promise<{ newPassword: string }> => {
  const res = await apiClient.post('/api/v1/auth/forgot-password/reset', payload);
  return unwrap(res);
};

export const changePasswordApi = async (payload: { oldPassword: string; newPassword: string }): Promise<void> => {
  await apiClient.put('/api/v1/auth/password', payload);
};

/** Check if phone number already registered — call BEFORE generating OTP */
export const checkPhoneApi = async (phone: string): Promise<boolean> => {
  const res = await apiClient.get('/api/v1/auth/check-phone', { params: { phone } });
  return unwrap<{ exists: boolean }>(res).exists;
};

// ─────────── Account Linking APIs ───────────

/** Link Google/Facebook OAuth provider vào tài khoản hiện tại */
export const linkProviderApi = async (idToken: string): Promise<void> => {
  await apiClient.post('/api/v1/auth/link-provider', { idToken });
};

/** OAuth user thiết lập username + password lần đầu */
export const setPasswordApi = async (username: string, newPassword: string): Promise<void> => {
  await apiClient.post('/api/v1/auth/set-password', { username, newPassword });
};

/** Gỡ liên kết OAuth provider */
export const unlinkProviderApi = async (provider: string): Promise<void> => {
  await apiClient.delete('/api/v1/auth/unlink-provider', { params: { provider } });
};

/** Lấy danh sách providers đã link */
export const getLinkedProvidersApi = async (): Promise<LinkedProvider[]> => {
  const res = await apiClient.get('/api/v1/auth/linked-providers');
  return unwrap(res);
};
