import React from "react";
import ReactDOM from "react-dom/client";
import "./index.css";
import App from "./App";
import reportWebVitals from "./reportWebVitals";
import { BrowserRouter } from "react-router-dom";
import { AuthProvider } from "@asgardeo/auth-react";

interface Config {
  redirectUrl: string;
  asgardeoClientId: string;
  asgardeoBaseUrl: string;
  apiUrl: string;
}

declare global {
  interface Window {
    config: Config;
  }
}

const authConfig = {
  signInRedirectURL: window.config.redirectUrl,
  signOutRedirectURL: window.config.redirectUrl,
  clientID: window.config.asgardeoClientId,
  baseUrl: window.config.asgardeoBaseUrl,
  scope: ["openid", "profile", "email"],
  resourceServerURLs: [window.config.apiUrl],
  endpoints: {
    authorizationEndpoint: `${window.config.asgardeoBaseUrl}/oauth2/authorize`,
    tokenEndpoint: `${window.config.asgardeoBaseUrl}/oauth2/token`,
    endSessionEndpoint: `${window.config.asgardeoBaseUrl}/oidc/logout`,
  },
};

const root = ReactDOM.createRoot(
  document.getElementById("root") as HTMLElement
);
root.render(
  <React.StrictMode>
    <BrowserRouter>
      <AuthProvider config={authConfig}>
        <App />
      </AuthProvider>
    </BrowserRouter>
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
