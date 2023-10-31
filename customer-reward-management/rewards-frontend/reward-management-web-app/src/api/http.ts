import { AsgardeoSPAClient, HttpRequestConfig } from '@asgardeo/auth-react';

const apiBaseUrl = window.config.apiUrl;

const auth = AsgardeoSPAClient.getInstance();

const getConfig = (config: any): HttpRequestConfig => ({
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json',
  },
  attachToken: true,
  ...config,
});

export const get = (
  path: string,
  params?: any,
  overrideBaseUrl = false,
  headers?: any,
  responseType?: string
) => {
  const url: string = overrideBaseUrl ? path : `${apiBaseUrl}/${path}`;
  return auth?.httpRequest(
    getConfig({ method: 'GET', headers, responseType, url, params })
  );
};

export const post = (
  path: string,
  params?: any,
  data?: any,
  overrideBaseUrl = false,
  shouldEncodeToFormData?: boolean,
  headers?: any,
  responseType?: string
) => {
  const url: string = overrideBaseUrl ? path : `${apiBaseUrl}/${path}`;
  return auth?.httpRequest(
    getConfig({
      method: 'POST',
      url,
      params,
      headers,
      data,
      shouldEncodeToFormData,
      responseType,
    })
  );
};