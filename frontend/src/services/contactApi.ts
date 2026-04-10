import apiClient from './apiClient';

export interface ContactMessage {
  id: string;
  name: string;
  email: string;
  subject: string;
  message: string;
  isRead: boolean;
  createdAt: string;
}

export interface ContactMessagePayload {
  name: string;
  email: string;
  subject: string;
  message: string;
}

export const submitContactMessage = async (payload: ContactMessagePayload) => {
  const response = await apiClient.post('/api/v1/contact-messages', payload);
  return response.data;
};

export const getAdminContactMessages = async () => {
  const response = await apiClient.get<ContactMessage[]>('/api/v1/contact-messages/admin');
  return response.data;
};

export const toggleContactMessageRead = async (id: string) => {
  const response = await apiClient.patch<ContactMessage>(`/api/v1/contact-messages/admin/${id}/read`);
  return response.data;
};
