import apiClient from './apiClient';

export interface Lead {
  id: string;
  name: string;
  phone: string;
  isContacted: boolean;
  createdAt: string;
}

export const submitLead = async (name: string, phone: string) => {
  const response = await apiClient.post('/leads', { name, phone });
  return response.data;
};

export const getAdminLeads = async () => {
  const response = await apiClient.get<Lead[]>('/leads/admin');
  return response.data;
};

export const toggleLeadContactStatus = async (id: string) => {
  const response = await apiClient.patch<Lead>(`/leads/admin/${id}/contact`);
  return response.data;
};
