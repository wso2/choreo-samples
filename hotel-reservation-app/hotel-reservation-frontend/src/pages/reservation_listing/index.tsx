import { Reservation } from "../../types/generated";
import { Box, CircularProgress, Typography } from "@mui/material";
import { useGetReservations } from "../../hooks/reservations";
import ReservationListItem from "./ReservationListItem";
import { useContext, useEffect } from "react";
import { UserContext } from "../../contexts/user";
import { toast } from "react-toastify";

function ReservationListing() {
  const user = useContext(UserContext);
  const { fetchReservations, reservations, loading, error } =
    useGetReservations();

  useEffect(() => {
    fetchReservations(user?.id);
  }, []);

  useEffect(() => {
    if (!!error) {
      toast.error(error.message);
    }
  }, [error]);

  return (
    <div style={{ display: "flex", flexDirection: "column", width: "70%" }}>
      <Box style={{ background: "rgba(0, 0, 0, 0.5)" }} px={8} py={4}>
        {loading && (
          <div
            style={{
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            <CircularProgress />
          </div>
        )}
        {reservations &&
          reservations.map((reservation: Reservation) => (
            <ReservationListItem
              reservation={reservation}
              key={reservation.id}
              fetchReservations={fetchReservations}
            />
          ))}
        {!reservations ||
          (reservations.length === 0 && (
            <Typography variant="h4" color="white" align="center">
              No reservations found
            </Typography>
          ))}
      </Box>
    </div>
  );
}

export default ReservationListing;
