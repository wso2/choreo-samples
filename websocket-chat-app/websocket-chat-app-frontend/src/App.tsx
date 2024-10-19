import { AuthProvider, useAuthContext } from "@asgardeo/auth-react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "./pages/Home";
import PageNotFound from "./pages/PageNotFound";
import "./App.css";
import Unauthenticated from "./pages/Unauthenticated";
import { ReactNode, useEffect, useState } from "react";
import ChatRoom from "./pages/ChatRoom";

const authConfig = {
  signInRedirectURL: window.__RUNTIME_CONFIG__.VITE_APP_SIGN_IN_REDIRECT_URL || "",
  signOutRedirectURL: window.__RUNTIME_CONFIG__.VITE_APP_SIGN_OUT_REDIRECT_URL || "",
  clientID: window.__RUNTIME_CONFIG__.VITE_APP_CLIENT_ID || "",
  baseUrl: window.__RUNTIME_CONFIG__.VITE_APP_AUTH_URL || "",
  scope: ["openid", "profile", "email"],
};

console.log("authconfig", authConfig);

const AppContent = () => {
  const ProtectedRoute = ({ children }: { children: ReactNode }) => {
    const { state } = useAuthContext();

    if (!state.isAuthenticated) {
      return <Unauthenticated />;
    }

    return children;
  };

  const { getBasicUserInfo, getAccessToken } = useAuthContext();
  const [token, setToken] = useState("");
  const [email, setEmail] = useState("");

  useEffect(() => {
    getAccessToken()
      .then((accessToken) => {
        setToken(accessToken);
      })
      .catch((error) => {
        console.log(error, "error");
      });

    getBasicUserInfo()
      .then((basicUserDetails) => {
        console.log(basicUserDetails);
        setEmail(basicUserDetails.email ? basicUserDetails.email : "");
      })
      .catch((error) => {
        console.log(error, "error");
      });
  }, []);

  return (
    <Routes>
      <Route
        path="/contact"
        element={
          <ProtectedRoute>
            <ChatRoom
              bearerAccessToken={token}
              username={email}
            />
          </ProtectedRoute>
        }
      />
      <Route path="/" element={<Home />} />
      <Route path="*" element={<PageNotFound />} />
    </Routes>
  );
};

const App = () => (
  <AuthProvider config={authConfig}>
    <Router>
      <AppContent />
    </Router>
  </AuthProvider>
);

export default App;
