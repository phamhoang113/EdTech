import api from './apiClient';

export interface Province {
  code: string;
  name: string;
}

export interface Ward {
  code: string;
  name: string;
  provinceCode: string;
}
export interface LocationNormalizationRequest {
  rawAddress?: string;
  provinceName?: string;
  districtName?: string;
  wardName?: string;
  latitude?: number;
  longitude?: number;
}

export interface LocationNormalizationResponse {
  normalizedAddress: string;
  provinceCode?: string;
  wardCode?: string;
  oldWardName?: string;
  newWardName?: string;
  latitude?: number;
  longitude?: number;
}

export const locationApi = {
  getProvinces: async (): Promise<Province[]> => {
    const res = await api.get(`/api/v1/locations/provinces`);
    return res.data.data;
  },

  getWardsByProvince: async (provinceCode: string): Promise<Ward[]> => {
    const res = await api.get(`/api/v1/locations/provinces/${provinceCode}/wards`);
    return res.data.data;
  },

  normalizeAddress: async (req: LocationNormalizationRequest): Promise<LocationNormalizationResponse> => {
    const res = await api.post(`/api/v1/locations/normalize`, req);
    return res.data.data;
  }
};
