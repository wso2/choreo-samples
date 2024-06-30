import axios, { AxiosError, AxiosRequestConfig } from 'axios';


export const performRequestWithRetry = async (url: string, options: AxiosRequestConfig<any> | undefined) => {

  try {
    const response = await axios(url, options);
    return response;
  } catch (error) {
    if (error instanceof AxiosError && error.response && error.response.status === 401) {
      // Access token may be expired. Try to refresh the tokens.
      try {
        await axios.post('/auth/refresh');
        // Token refresh successful. Retry the API call.
        const retryResponse = await axios(url, options);
        return retryResponse;
      } catch (refreshError) {
        if (refreshError instanceof AxiosError && refreshError.response && refreshError.response.status === 401) {
          // Session has expired (i.e., Refresh token has also expired).
          // Redirect to the login page
          console.log('Failed to refresh token. Status: ' + refreshError.response.status);
          window.location.href = '/auth/login';
        } else {
          // We can't refresh the token due to a server error.
          // Hence just throw the original 401 error from the API.
          throw error;
        }
      }
    } else {
      throw error;
    }
  }
};
