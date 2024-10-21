import { useAuthContext } from "@asgardeo/auth-react";
import { Button } from "@mui/material";
import { useNavigate } from "react-router-dom";

const Unauthenticated = () => {
  const { signIn } = useAuthContext();
  const navigate = useNavigate();

  return (
    <div>
      <h5>You need to be logged in to access chat room!</h5>
      <div className="button-container">
        <Button className="text-button" onClick={() => navigate("/")}>
          Go Back
        </Button>
        <Button
          onClick={() => {
            signIn();
          }}
        >
          Login
        </Button>
      </div>
    </div>
  );
};

export default Unauthenticated;
