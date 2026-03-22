import apiClient from './apiClient';

export interface TokenResponse {
  accessToken: string;
  refreshToken: string;
  role: 'PARENT' | 'STUDENT' | 'TUTOR' | 'ADMIN';
  fullName: string;
  avatarBase64: string | null;
  isActive: boolean;
}

/** Trả về từ backend sau khi register thành công */
export interface RegisterResponse {
  otpToken: string; // UUID để verify OTP (gửi kèm code)
  message: string;
}

export interface LoginPayload {
  phone: string;
  password: string;
}

export interface RegisterPayload {
  phone: string;
  password: string;
  fullName: string;
  role: 'PARENT' | 'TUTOR' | 'STUDENT';
}

export interface VerifyOtpPayload {
  otpToken: string; // UUID nhận được sau register — KHÔNG gửi phone
  code: string;
}

const unwrap = <T>(res: { data: { data: T } }): T => res.data.data;

export const loginApi = async (payload: LoginPayload): Promise<TokenResponse> => {
  const res = await apiClient.post('/api/v1/auth/login', payload);
  return unwrap(res);
};

/** Returns RegisterResponse { otpToken, message } */
export const registerApi = async (payload: RegisterPayload): Promise<RegisterResponse> => {
  const res = await apiClient.post('/api/v1/auth/register', payload);
  return unwrap(res);
};

/** Gửi otpToken (UUID) + code — backend không cần phone nữa */
export const verifyOtpApi = async (payload: VerifyOtpPayload): Promise<TokenResponse> => {
  const res = await apiClient.post('/api/v1/auth/verify-otp', payload);
  return unwrap(res);
};
