import apiClient from './apiClient';

export interface Lead {
  id: string;
  name: string;
  phone: string;
  isContacted: boolean;
  createdAt: string;
}

export const submitLead = async (name: string, phone: string) => {
  const response = await apiClient.post('/api/v1/leads', { name, phone });
  return response.data;
};

export const getAdminLeads = async () => {
  const response = await apiClient.get<Lead[]>('/api/v1/leads/admin');
  return response.data;
};

export const toggleLeadContactStatus = async (id: string) => {
  const response = await apiClient.patch<Lead>(`/api/v1/leads/admin/${id}/contact`);
  return response.data;
};
