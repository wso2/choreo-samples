const PORT = 8080;

const express = require("express");
const app = express();

const server = require("http").createServer(app);
const bodyParser = require("body-parser");
const path = require("path");
const { WebSocket } = require("ws");

const User = require("./User");
const ChatRoom = require("./ChatRoom");
const { parseSocketData } = require("./utils");

var clientIDs = Array();
var roomIDs = Array();
var wsClients = Array();
var rooms = Array();

app.use(express.static(path.join(__dirname, "public")));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.json());

server.listen(PORT, () => {
  console.log(`listening on port ${PORT}`);
});

const wss = new WebSocket.Server({ server: server });

wss.on("connection", (socket, req) => {
  console.log(`Client websocket connected (${req.socket.remoteAddress})`);

  socket.on("message", (message) => {
    let strMessage = parseSocketData(message);
    let jsonMessage = JSON.parse(strMessage);

    switch (jsonMessage.type) {
      case "Connect":
        let newUser = new User(socket, jsonMessage.username, clientIDs);
        wsClients.push(newUser);

        // Find an available chat room to enter or create a new one
        let availableChatRoom =
          rooms.find(
            (room) =>
              room.users.length < room.maxUsers && room.status === "Online"
          ) || new ChatRoom(newUser, 5, "Online", roomIDs, wsClients);

        if (!rooms.includes(availableChatRoom)) {
          rooms.push(availableChatRoom);
        } else {
          availableChatRoom.addUser(newUser);
        }

        newUser.currentRoom = availableChatRoom;

        const { id, users, maxUsers, status } = availableChatRoom;
        let json = {
          type: "Connect",
          room: id,
          userCount: users.length,
          maxUsers,
          status,
          username: newUser.username,
          totalUsers: wsClients.length,
        };

        availableChatRoom.broadcast(JSON.stringify(json));
        break;

      case "Disconnect":
        break;

      case "Data":
        const sender = wsClients.find((client) => client.socket === socket);
        if (sender) {
          const { username } = sender;
          const json = {
            type: "Data",
            from: username,
            message: jsonMessage.message,
            totalUsers: wsClients.length,
          };
          sender.currentRoom.broadcast(JSON.stringify(json), sender);
        }
        break;
      default:
        break;
    }
  });

  socket.on("error", (error) => {
    console.error("WebSocket error:", error);
  });

  socket.on("close", () => {
    console.log(`Client websocket disconnected (${req.socket.remoteAddress})`);
    const userIndex = wsClients.findIndex((client) => client.socket === socket);

    if (userIndex !== -1) {
      const user = wsClients[userIndex];
      clientIDs.splice(clientIDs.indexOf(user.id), 1);
      user.currentRoom.removeUser(user);

      if (user.currentRoom.users.length < 1) {
        user.currentRoom.removeEmptyRoom(rooms, roomIDs);
      }

      wsClients.splice(userIndex, 1);
    }
  });
});
