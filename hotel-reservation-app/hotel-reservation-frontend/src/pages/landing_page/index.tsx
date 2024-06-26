import { Box, Button, Typography } from "@mui/material";
import { useNavigate } from "react-router-dom";

export default function LandingPage() {
  const navigate = useNavigate();
  return (
    <Box
      display="flex"
      flexDirection="column"
      justifyContent="center"
      alignItems="center"
      flexGrow={1}
    >
      <Typography
        mt={-12}
        fontSize={120}
        fontWeight={500}
        textAlign="center"
        variant="h1"
        color="white"
      >
        Reserve a room online
      </Typography>
      <Typography mb={8} textAlign="center" variant="h2" color="white">
        Enjoy convienence
      </Typography>
      <Button
        onClick={() => {
          navigate("/auth/login");
        }}
        variant="contained"
        color="secondary"
        style={{
          borderRadius: 32,
          textTransform: "none",
          height: 64,
          width: 200,
          fontSize: 18,
        }}
      >
        Get Started
      </Button>
    </Box>
  );
}
