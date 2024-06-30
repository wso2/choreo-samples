import React, { useContext, useState } from "react";
import {
  Box,
  TextField,
  Typography,
  Button,
  CircularProgress,
} from "@mui/material";
import { useReserveRoom } from "../../hooks/reservations";
import { useLocation, useNavigate } from "react-router-dom";
import { RoomType } from "../../types/generated";
import { Location } from "history";
import { UserContext } from "../../contexts/user";
import { toast } from "react-toastify";
import { formatDate } from "../../utils/utils";

interface RoomState {
  room: RoomType;
}

const ReservationForm = () => {
  const { reservation, loading, error, reserveRoom } = useReserveRoom();

  const user = useContext(UserContext);

  const {
    state: { room },
  } = useLocation() as Location<RoomState>;
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    firstName: "",
    lastName: "",
    mobileNumber: "",
    emailAddress: "",
  });
  const [checkIn, setCheckIn] = React.useState<Date>(new Date());
  const [checkOut, setCheckOut] = React.useState<Date>(new Date());
  const [maxCheckInDate, setMaxCheckInDate] = React.useState<
    string | undefined
  >(undefined);

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

  const handleTextChange = (name: string) => (e: any) => {
    const { value } = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  const handleReserve = async () => {
    const {
      firstName,
      lastName,
      mobileNumber,
      emailAddress,
    } = formData;
    console.log("formData", formData);

    await reserveRoom({
      checkinDate: checkIn.toISOString(),
      checkoutDate: checkOut.toISOString(),
      rate: 100,
      roomType: room.name,
      user: {
        email: emailAddress,
        id: user.id,
        mobileNumber,
        name: `${firstName} ${lastName}`,
      },
    });

    if (error) {
      return;
    }
    toast.success("Reservation placed!");
    navigate("/reservations", { state: { reservation } });
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
        Reserve a room
      </Typography>
      <Typography variant="body1" gutterBottom>
        Enter your details and click "Reserve". You can pay at the check-in.
      </Typography>
      <Box
        mt={3}
        mb={2}
        display="flex"
        justifyContent="space-between"
        alignItems="center"
      >
        <Box width="48%">
          <TextField
            onChange={handleTextChange("firstName")}
            fullWidth
            label="First Name"
            variant="outlined"
          />
        </Box>
        <Box width="48%">
          <TextField
            onChange={handleTextChange("lastName")}
            fullWidth
            label="Last Name"
            variant="outlined"
          />
        </Box>
      </Box>
      <Box mb={2}>
        <TextField
          onChange={handleTextChange("mobileNumber")}
          fullWidth
          label="Mobile Number"
          variant="outlined"
        />
      </Box>
      <Box mb={2}>
        <TextField
          onChange={handleTextChange("emailAddress")}
          fullWidth
          label="Email Address"
          variant="outlined"
        />
      </Box>
      <Box
        display="flex"
        justifyContent="space-between"
        alignItems="center"
        mb={4}
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
        <Button
          style={{ textTransform: "none" }}
          onClick={() => navigate("/rooms")}
          color="secondary"
          variant="outlined"
        >
          Cancel
        </Button>
        <Button
          variant="contained"
          color="primary"
          style={{ marginLeft: "8px", textTransform: "none" }}
          onClick={handleReserve}
          disabled={loading}
        >
          {loading ? <CircularProgress size={24} color="primary" /> : "Reserve"}
        </Button>
      </Box>
    </Box>
  );
};

export default ReservationForm;
