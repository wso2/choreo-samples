import { useAuthContext } from "@asgardeo/auth-react";
import { useNavigate } from "react-router-dom";
import "./styles.css";
import { Button } from "@mui/material";

const Home = () => {
  const { state, signIn, signOut } = useAuthContext();
  const navigate = useNavigate();

  return (
    <>
      <div style={{ marginBottom: "16px" }}>
        {" "}
        {/* Add margin for spacing */}
        <button className="contact-button" onClick={() => navigate("/contact")}>
          Chat Now!
        </button>
      </div>
      <div className="login-button-container" style={{ marginBottom: "16px" }}>
        {" "}
        {/* Add margin for spacing */}
        {
          state.isAuthenticated ? (
            <Button variant="contained" color="error" onClick={() => signOut()}>
              Logout
            </Button> // Use MUI Button
          ) : (
            <Button
              variant="contained"
              color="primary"
              onClick={() => signIn()}
            >
              Login
            </Button>
          ) // Use MUI Button
        }
      </div>
    </>
  );
};

export default Home;
