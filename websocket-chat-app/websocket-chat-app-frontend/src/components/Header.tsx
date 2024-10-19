import { useAuthContext } from "@asgardeo/auth-react";
import { NavLink } from "react-router-dom";

const Header = () => {
  const { state, signIn, signOut } = useAuthContext();

  return (
    <div className="header">
      <ul>
        <li>
          <NavLink
            to="/"
            className={({ isActive }) => (isActive ? "active" : "")}
          >
            Home
          </NavLink>
        </li>
        <li>
          <NavLink
            to="/contact"
            className={({ isActive }) => (isActive ? "active" : "")}
          >
            Chat
          </NavLink>
        </li>
      </ul>
      {state?.isAuthenticated ? (
        <button onClick={() => signOut()}>Logout</button>
      ) : (
        <button onClick={() => signIn()}>Login</button>
      )}
    </div>
  );
};

export default Header;