import apiClient from './apiClient';

export interface TokenResponse {
  accessToken: string;
  refreshToken: string;
  role: 'PARENT' | 'STUDENT' | 'TUTOR' | 'ADMIN';
  fullName: string;
  avatarBase64: string | null;
  isActive: boolean;
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
