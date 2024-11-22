import axios from 'axios';

// Axios instance for API calls
const api = axios.create({
  baseURL: window?.configs?.apiUrl,
  headers: {
    'Content-Type': 'application/json',
  }
});

// Helper function to refresh token
async function refreshToken() {
  try {
    await axios.post("/auth/refresh");
  } catch (refreshError) {
    if (refreshError.response && refreshError.response.status === 401) {
      // Redirect to login if refresh token is also expired
      window.location.href = "/auth/login";
      return false;
    }
    throw refreshError;
  }
  return true;
}

// Response interceptor to handle 401 Unauthorized globally
api.interceptors.response.use(response => response, async (error) => {
  if (error.response && error.response.status === 401 && !error.config._retry) {
    // Mark the config so we know this request has already tried to be retried
    error.config._retry = true;
    
    // Try to refresh token and retry the original request
    const isTokenRefreshed = await refreshToken();
    if (isTokenRefreshed) {
      return api(error.config); // Retry the original request with new token
    }
  }
  return Promise.reject(error);
});

// Function to book an appointment
export const bookAppointment = async (appointmentDetails) => {
  try {
    const response = await api.post('/create-appointment', appointmentDetails);
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Function to get upcoming appointments
export const getUpcomingAppointments = async (email) => {
  try {
    const response = await api.get('/appointments', {
      params: {
        email: email,
        upcoming: 'true', // Assuming your backend supports this query parameter for filtering upcoming appointments
      }
    });
    return response.data;
  } catch (error) {
    console.error('Error fetching upcoming appointments:', error);
    throw error;
  }
};

// Function to fetch appointment types
export const fetchAppointmentTypes = async () => {
  try {
    const response = await api.get('/appointment-types');
    return response.data; // Returns the list of appointment types
  } catch (error) {
    console.error('Error fetching appointment types:', error);
    throw error;
  }
};
