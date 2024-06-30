import { createContext } from "react";
import { User } from "../types/generated";

export const UserContext = createContext<User>({
  email: "",
  id: "",
  name: "",
  mobileNumber: "",
});
