import React, { useContext, useState } from "react";
import {
  Box,
  TextField,
  Typography,
  Button,
  CircularProgress,
} from "@mui/material";
import { useUpdateReservation } from "../../hooks/reservations";
import { useLocation, useNavigate } from "react-router-dom";
import { Reservation } from "../../types/generated";
import { Location } from "history";
import {toast} from "react-toastify";
import { formatDate } from "../../utils/utils";

interface ReservationState {
  reservation: Reservation;
}

const ReservationUpdateForm = () => {
  const { updateReservation, updated, updating, error } =
    useUpdateReservation();

  const {
    state: { reservation },
  } = useLocation() as Location<ReservationState>;
  const navigate = useNavigate();

  const [checkIn, setCheckIn] = React.useState<Date>(new Date());
  const [checkOut, setCheckOut] = React.useState<Date>(new Date());
  const [maxCheckInDate, setMaxCheckInDate] = React.useState<string | undefined>(
    undefined
  );

  const handleCheckInChange = (e: any) => {
    const { value } = e.target;
    const checkInDate = new Date(value);
    setCheckIn(checkInDate);
    if (checkOut < checkInDate) setCheckOut(checkInDate);
  };

  const handleCheckOutChange = (e: any) => {
    const { value } = e.target;
    const checkOutDate = new Date(value);
    setCheckOut(checkOutDate);
    setMaxCheckInDate(formatDate(checkOutDate));
  };

  const handleReserve = async () => {
    await updateReservation(reservation.id, {
      checkinDate: checkIn.toISOString(),
      checkoutDate: checkOut.toISOString(),
    });
    if (error) {
      toast.error("Error occurred while updating the reservation");
      return;
    }
    toast.success("Reservation updated successfully");
    navigate("/reservations");
  };

  return (
    <Box
      style={{ background: "white" }}
      display="flex"
      flexDirection="column"
      py={4}
      px={8}
    >
      <Typography variant="h4" gutterBottom>
        Update Reservation
      </Typography>
      <Typography variant="body1" gutterBottom>
        You can update the check-in and check-out dates
      </Typography>
      <Box
        display="flex"
        justifyContent="space-between"
        alignItems="center"
        my={4}
      >
        <Box width="48%">
          <TextField
            onChange={handleCheckInChange}
            fullWidth
            label="Check In Date"
            variant="outlined"
            type="date"
            InputLabelProps={{ shrink: true }}
            value={formatDate(checkIn)}
            inputProps={{
              min: formatDate(new Date()),
              max: maxCheckInDate,
            }}
          />
        </Box>
        <Box width="48%">
          <TextField
            onChange={handleCheckOutChange}
            fullWidth
            label="Check Out Date"
            variant="outlined"
            type="date"
            InputLabelProps={{ shrink: true }}
            value={formatDate(checkOut)}
            inputProps={{ min: formatDate(checkIn) }}
          />
        </Box>
      </Box>

      {/* Action buttons */}
      <Box display="flex" justifyContent="flex-end">
        <Button variant="outlined" style={{ textTransform: "none" }} onClick={() => navigate("/reservations")} color="secondary">
          Cancel
        </Button>
        <Button
          variant="contained"
          color="primary"
          style={{ marginLeft: "8px", textTransform: "none" }}
          onClick={handleReserve}
          disabled={updating}
        >
          {updating ? <CircularProgress size={24} color="primary" /> : "Update"}
        </Button>
      </Box>
    </Box>
  );
};

export default ReservationUpdateForm;
