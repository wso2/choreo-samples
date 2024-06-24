import * as React from "react";
import Box from "@mui/material/Box";
import IconButton from "@mui/material/IconButton";
import Typography from "@mui/material/Typography";
import Menu from "@mui/material/Menu";
import Avatar from "@mui/material/Avatar";
import MenuItem from "@mui/material/MenuItem";
import AppBar from "@mui/material/AppBar";
import AutoAwesomeIcon from "@mui/icons-material/AutoAwesome";
import { Home } from "@mui/icons-material";
import { Button, Icon } from "@mui/material";
import { UserContext } from "../contexts/user";
import Cookies from "js-cookie";

function UserMenu() {
  const user = React.useContext(UserContext);
  const [anchorElUser, setAnchorElUser] = React.useState<null | HTMLElement>(
    null
  );
  const handleOpenUserMenu = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorElUser(event.currentTarget);
  };
  const handleCloseUserMenu = () => {
    setAnchorElUser(null);
  };
  if (user.id === "") {
    return null;
  }
  return (
    <Box sx={{ flexGrow: 0 }}>
      <IconButton onClick={handleOpenUserMenu} sx={{ p: 0 }}>
        <Avatar>
          {user.id.length > 0 ? user.id.substring(0, 1).toUpperCase() : ""}
        </Avatar>
      </IconButton>
      <Menu
        sx={{ mt: "45px" }}
        id="menu-appbar"
        anchorEl={anchorElUser}
        anchorOrigin={{
          vertical: "top",
          horizontal: "right",
        }}
        keepMounted
        transformOrigin={{
          vertical: "top",
          horizontal: "right",
        }}
        open={Boolean(anchorElUser)}
        onClose={handleCloseUserMenu}
      >
        <MenuItem onClick={() => (window.location.pathname = "/reservations")}>
          <Button style={{ textTransform: "none" }}>
            <Typography textAlign="center">My Reservations</Typography>
          </Button>
        </MenuItem>
        <MenuItem
          onClick={() => {
            sessionStorage.removeItem("userInfo");
            window.location.href = `/auth/logout?session_hint=${Cookies.get("session_hint")}`;
          }}
        >
          <Button style={{ textTransform: "none" }}>
            <Typography textAlign="center">Logout</Typography>
          </Button>
        </MenuItem>
      </Menu>
    </Box>
  );
}

function Header() {
  return (
    <AppBar
      position="static"
      color="primary"
      style={{
        display: "flex",
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between",
        padding: "8px",
        paddingLeft: "16px",
        paddingRight: "16px",
        marginBottom: "64px",
      }}
    >
      <div style={{ display: "flex", alignItems: "center" }}>
        <AutoAwesomeIcon style={{ marginRight: 8 }} />
        <Typography variant="h6" noWrap>
          Luxury Hotels
        </Typography>
        <IconButton
          onClick={() => {
            window.location.pathname = "/rooms";
          }}
          style={{ color: "white" }}
        >
          <Home />
        </IconButton>
      </div>
      <UserMenu />
    </AppBar>
  );
}
export default Header;
