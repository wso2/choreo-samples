import React from "react";
import { Box } from "@mui/material";
import ReservationForm from "./ReservationForm";

function ReservationAddingPage() {
  return (
    <div
      style={{ display: "flex", flexDirection: "column", alignItems: "center" }}
    >
      <Box style={{ background: "rgba(0, 0, 0, 0.5)" }} px={8} py={4}>
        <ReservationForm />
      </Box>
    </div>
  );
}

export default ReservationAddingPage;
