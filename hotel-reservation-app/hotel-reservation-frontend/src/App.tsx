import { useEffect, useState } from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import RoomListing from "./pages/room_listing";
import Header from "./layout/AppBar";
import ReservationAddingPage from "./pages/reservations_adding";
import ReservationListing from "./pages/reservation_listing";
import { UserContext } from "./contexts/user";
import { User } from "./types/generated";
import ReservationUpdatingPage from "./pages/reservations_updating";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { ThemeProvider } from "@mui/material/styles";
import NotFound from "./pages/not_found";
import LandingPage from "./pages/landing_page";
import theme from "./theme";
import ErrorPage from "./pages/error";

export default function App() {
  const [signedIn, setSignedIn] = useState(false);
  const [user, setUser] = useState<User>({
    email: "",
    id: "",
    name: "",
    mobileNumber: "",
  });
  const [isAuthLoading, setIsAuthLoading] = useState(false);

  if (isAuthLoading) {
    return <div>User authenticating...</div>;
  }

  return (
    <>
      <ThemeProvider theme={theme}>
        <UserContext.Provider value={user}>
          <Header />
          <ToastContainer />
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              flexGrow: 1,
            }}
          >
            <BrowserRouter>
              <Routes>
                {/* rooms */}
                <Route path="/" Component={LandingPage} />
                <Route path="/rooms" Component={RoomListing} />
                {/* reservations */}
                <Route path="/reservations" Component={ReservationListing} />
                {/* new reservation */}
                <Route
                  path="/reservations/new"
                  Component={ReservationAddingPage}
                />
                {/* update reservation */}
                <Route
                  path="/reservations/change"
                  Component={ReservationUpdatingPage}
                />
                <Route path="/error" Component={ErrorPage} />
                {/* Otherwise, show not found page */}
                <Route path="*" Component={NotFound} />
              </Routes>
            </BrowserRouter>
          </div>
        </UserContext.Provider>
      </ThemeProvider>
    </>
  );
}
