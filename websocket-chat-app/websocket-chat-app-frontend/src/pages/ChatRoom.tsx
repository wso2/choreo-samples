import "./styles.css";
import { Button, TextField, Box, Grid, Typography, AppBar, Toolbar, createTheme, ThemeProvider, Avatar } from "@mui/material";
import { useState } from "react";

const SERVER = window.__RUNTIME_CONFIG__.VITE_APP_SERVER_URL;

const MESSAGE_TYPE_CONNECTION = "Connect";
const MESSAGE_TYPE_DISCONNECTION = "Disconnect";
const MESSAGE_TYPE_CHAT = "Data";

const theme = createTheme({
  palette: {
    primary: {
      main: '#3d1a6d',
    },
    secondary: {
      main: '#f3e5f5',
    },
    background: {
      default: '#ffffff',
    },
  },
});

const getColorFromUsername = (username: string): string => {
  const hash = Array.from(username).reduce(
    (acc, char: string) => acc + char.charCodeAt(3),
    0
  );
  const hue = 240 + (hash % 31);
  return `hsl(${hue}, 70%, 50%)`;
};

interface ChatMessage {
  message: string;
  sender: string;
  color: string;
}

const ChatRoom = ({
  bearerAccessToken,
  username,
}: {
  bearerAccessToken: string;
  username: string;
}) => {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState<string>("");
  const [ws, setWs] = useState<WebSocket | null>(null);
  const [accessToken] = useState(bearerAccessToken);

  const sendMessage = (message: string) => {
    if (ws && message) {
      const json = { type: MESSAGE_TYPE_CHAT, message };
      ws?.send(JSON.stringify(json));
      setInput("");
      addMessage(message, `${username} (You)`, getColorFromUsername(username));
    }
  };
  const addMessage = (
    message: string,
    sender: string = "",
    color: string = "black"
  ) => {
    setMessages((prevMessages) => [
      ...prevMessages,
      { message, sender, color },
    ]);
  };

  const createConnection = () => {
    if (accessToken == undefined || accessToken == "") {
        window.location.reload();
    }
    const socket = new WebSocket(`${SERVER}`, ["choreo-oauth2-key", accessToken]);
    setWs(socket);

    socket.onopen = () => {
      const message = {
        type: MESSAGE_TYPE_CONNECTION,
        username,
        message: "Successfully connected!",
      };
      socket.send(JSON.stringify(message));
    };

    socket.onmessage = ({ data }) => {
      const message = JSON.parse(data);
      switch (message.type) {
        case MESSAGE_TYPE_CONNECTION:
          addMessage(
            `${message.username} joined.`,
            message.username,
            getColorFromUsername(message.username)
          );
          break;
        case MESSAGE_TYPE_DISCONNECTION:
          addMessage(
            `${message.username} left.`,
            message.username,
            getColorFromUsername(message.username)
          );
          break;
        case MESSAGE_TYPE_CHAT:
          addMessage(
            message.message,
            message.from,
            getColorFromUsername(message.from)
          );
          break;
        default:
          break;
      }
    };

    socket.onclose = () => {
      setWs(null);
      addMessage("You Left the chat");
    };
  };

  const closeConnection = () => {
    if (ws) {
      ws.close();
      setWs(null);
    }
  };
  console.log(messages, username);

  return (
    <ThemeProvider theme={theme}>
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            Group Chat!
          </Typography>
        </Toolbar>
      </AppBar>
      <Box sx={{ padding: 2 }}>
        <Grid container spacing={2} sx={{ marginBottom: 2, justifyContent: 'center' }}>
          <Grid item xs={12} md={6}>
            <Button
              variant="outlined"
              onClick={ws ? closeConnection : createConnection}
              fullWidth
              sx={{ height: '56px', borderColor: theme.palette.primary.main }}
            >
              {ws ? "Leave Chat" : "Connect"}
            </Button>
          </Grid>
        </Grid>
        <Box
          sx={{
            height: 400,
            overflowY: "auto",
            border: "1px solid #ddd",
            borderRadius: 1,
            padding: 2,
            marginBottom: 2,
            backgroundColor: theme.palette.secondary.main, // Light purple background
          }}
        >
          {messages.map((msg, index) => (
            <Box
              key={index}
              sx={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: msg.sender.endsWith("(You)") || msg.sender === username ? 'flex-end' : 'flex-start',
                marginBottom: 1,
              }}
            >
              {msg.sender !== username && (
                <Avatar alt={msg.sender} sx={{ marginRight: 1 }}> {msg.sender[0]?.toUpperCase() || "U"} </Avatar>
              )}
              <Typography variant="body1" sx={{ color: msg.color, maxWidth: '70%', wordWrap: 'break-word' }}>
                <strong>{msg.sender}:</strong> {msg.message}
              </Typography>
              {msg.sender === username && (
                <Avatar alt="You" sx={{ marginLeft: 1 }}> {msg.sender[0]?.toUpperCase() || "U"} </Avatar>
              )}
            </Box>
          ))}
        </Box>
        <Grid container spacing={2}>
          <Grid item xs={12} md={8}>
            <TextField
              fullWidth
              variant="outlined"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Type a message"
              sx={{ marginBottom: 2 }}
            />
          </Grid>
          <Grid item xs={12} md={4}>
            <Button
              variant="contained"
              color="primary"
              onClick={() => sendMessage(input)}
              fullWidth
              sx={{ height: '56px' }}
            >
              Send
            </Button>
          </Grid>
        </Grid>
      </Box>
    </Box>
  </ThemeProvider>
  );
};

export default ChatRoom;
