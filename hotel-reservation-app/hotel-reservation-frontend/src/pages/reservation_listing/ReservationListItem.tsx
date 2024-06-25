import React, { useContext } from "react";
import { Reservation } from "../../types/generated";
import { Box, Button, CircularProgress, Typography } from "@mui/material";
import LuggageOutlinedIcon from "@mui/icons-material/LuggageOutlined";
import { useDeleteReservation } from "../../hooks/reservations";
import { useNavigate } from "react-router-dom";
import { toast } from "react-toastify";
import { UserContext } from "../../contexts/user";
import { formatDateString } from "../../utils/utils";

export default function ReservationListItem(props: {
  reservation: Reservation;
  fetchReservations: (userId: string) => void;
}) {
  const { reservation, fetchReservations } = props;
  const user = useContext(UserContext);
  const {
    deleting,
    error: deleteError,
    deleteReservation,
  } = useDeleteReservation();
  const navigate = useNavigate();

  const handleDeleteReservation = async () => {
    await deleteReservation(reservation.id);
    if (deleteError) {
      toast.error("Error occurred while deleting the reservation");
    } else {
      toast.success("Reservation deleted successfully");
    }
    fetchReservations(user?.id);
  };

  return (
    <Box
      style={{ background: "white" }}
      display="flex"
      justifyContent="space-between"
      width="100%"
      border={1}
      borderRadius={4}
      mb={1}
    >
      <Box
        width="13%"
        p={2}
        pl={4}
        display="flex"
        flexDirection="column"
        justifyContent="center"
        alignItems="flex=start"
      >
        <Box>
          <Typography variant="h6" color="grey">
            {reservation.room.type.name}
          </Typography>
        </Box>
        <Box display="flex" justifyContent="flex-start" alignItems="center">
          <Box>
            <LuggageOutlinedIcon />
          </Box>
          <Box>
            <Typography fontSize={12}>
              {reservation.room.type.guestCapacity} Guests
            </Typography>
          </Box>
        </Box>
      </Box>

      <Box
        width="53%"
        p={2}
        display="flex"
        flexDirection="column"
        justifyContent="center"
      >
        <Typography style={{ color: "grey" }}>
          <span style={{ color: "black" }}>Room:</span> {reservation.room.number}{" "}
          <span style={{ color: "grey", marginLeft: "8px", marginRight: "8px" }}>|</span>{" "}
          <span style={{ color: "black" }}>User:</span> {reservation.user?.id}
        </Typography>
        <Typography style={{ color: "grey" }}>
          <span style={{ color: "black" }}>Check-In:</span> {formatDateString(reservation.checkinDate)}{" "}
          <span style={{ color: "grey", marginLeft: "8px", marginRight: "8px" }}>|</span>{" "}
          <span style={{ color: "black" }}>Check-Out:</span> {formatDateString(reservation.checkoutDate)}
        </Typography>
      </Box>

      <Box
        width="13%"
        p={2}
        display="flex"
        flexDirection="column"
        justifyContent="center"
        alignItems="flex-end"
      >
        <Typography>{reservation.room.type.price}$ /day</Typography>
      </Box>

      <Box
        width="13%"
        p={2}
        pr={4}
        display="flex"
        flexDirection="row"
        justifyContent="flex-end"
        alignItems="center"
      >
        <Button
          onClick={() =>
            navigate("/reservations/change", { state: { reservation } })
          }
          style={{ textTransform: "none", marginRight: "4px", width: "48%" }}
          variant="outlined"
        >
          Change
        </Button>
        <Button
          style={{
            textTransform: "none",
            backgroundColor: "#f0625d",
            width: "48%",
          }}
          variant="contained"
          onClick={handleDeleteReservation}
          disabled={deleting}
        >
          {deleting ? (
            <CircularProgress style={{ height: "32px" }} />
          ) : (
            "Delete"
          )}
        </Button>
      </Box>
    </Box>
  );
}
