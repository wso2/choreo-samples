// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

//    http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.


import axios, { AxiosRequestConfig } from 'axios';


export const performRequestWithRetry = async (url: string, options: AxiosRequestConfig<any> | undefined) => {

  try {
    const response = await axios(url, options);
    return response;
  } catch (error) {
    if (error.response && error.response.status === 401) {
      // Access token may be expired. Try to refresh the tokens.
      try {
        await axios.post('/auth/refresh');
        // Token refresh successful. Retry the API call.
        const retryResponse = await axios(url, options);
        return retryResponse;
      } catch (refreshError) {
        if (refreshError.response && refreshError.response.status === 401) {
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
