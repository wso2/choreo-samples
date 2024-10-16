const PORT = 8080;

const express = require("express");
const http = require("http");
const WebSocket = require("ws");
const path = require("path");
const bodyParser = require("body-parser");

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

app.use(express.static(path.join(__dirname, "public")));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

let clients = [];
let rooms = [];

class ChatClient {
  constructor(socket, nickname) {
    this.socket = socket;
    this.nickname = nickname;
    this.room = null;
  }
}

class ChatRoom {
  constructor() {
    this.clients = [];
  }

  addClient(client) {
    this.clients.push(client);
    client.room = this;
    this.broadcast(`${client.nickname} has joined the room.`);
  }

  removeClient(client) {
    this.clients = this.clients.filter(c => c !== client);
    this.broadcast(`${client.nickname} has left the room.`);
  }

  broadcast(message) {
    this.clients.forEach(client => {
      client.socket.send(message);
    });
  }
}

// Start the server
server.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

// Handle WebSocket connections
wss.on("connection", (socket) => {
  let currentClient;

  socket.on("message", (data) => {
    const message = JSON.parse(data);

    switch (message.type) {
      case "connect":
        currentClient = new ChatClient(socket, message.nickname);
        clients.push(currentClient);
        let room = rooms.find(r => r.clients.length < 5);
        if (!room) {
          room = new ChatRoom();
          rooms.push(room);
        }
        room.addClient(currentClient);
        break;

      case "chat":
        if (currentClient && currentClient.room) {
          currentClient.room.broadcast(`${currentClient.nickname}: ${message.content}`);
        }
        break;

      case "disconnect":
        if (currentClient && currentClient.room) {
          currentClient.room.removeClient(currentClient);
          clients = clients.filter(c => c !== currentClient);
        }
        break;

      default:
        break;
    }
  });

  socket.on("close", () => {
    if (currentClient && currentClient.room) {
      currentClient.room.removeClient(currentClient);
      clients = clients.filter(c => c !== currentClient);
    }
  });

  socket.on("error", (error) => {
    console.error("WebSocket error:", error);
  });
});
