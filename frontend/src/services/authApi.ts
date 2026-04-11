import apiClient from './apiClient';

export interface TokenResponse {
  accessToken: string;
  refreshToken: string;
  role: 'PARENT' | 'STUDENT' | 'TUTOR' | 'ADMIN';
  fullName: string;
  avatarBase64: string | null;
  isActive: boolean;
  mustChangePassword?: boolean;
}

/** Payload for registering or authenticating via Firebase */
export interface FirebaseAuthPayload {
  idToken: string;
  fullName: string;
  password?: string;
  role: 'PARENT' | 'TUTOR' | 'STUDENT';
}

export interface LoginPayload {
  phone: string;
  password: string;
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
  return unwrap(res).exists;
};
