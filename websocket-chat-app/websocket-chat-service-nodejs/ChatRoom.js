class ChatRoom {
  /**
   * Creates an instance of ChatRoom.
   *
   * @param {Object} user - The user joining the chat room (optional).
   * @param {number} maxUsers - The maximum number of users allowed in the room.
   * @param {string} status - The current status of the room (default is "Online").
   * @param {Array} roomIDs - An array to keep track of existing room IDs.
   * @param {Array} wsClients - An array of connected WebSocket clients.
   */
  constructor(user = null, maxUsers = 5, status = "Online", roomIDs, wsClients) {
    this.users = Array();
    this.maxUsers = maxUsers;
    this.status = status;
    this.wsClients = wsClients;
    if (user != null) {
      this.users.push(user);
    }

    this.id = 0;
    while (this.id == 0 || roomIDs.includes(this.id)) {
      this.id = Math.floor(Math.random() * 1000000000);
    }
    roomIDs.push(this.id);
  }

  /**
   * Adds a user to the chat room.
   *
   * @param {Object} user - The user to be added to the room.
   */
  addUser(user) {
    this.users.push(user);
  }

  /**
   * Removes a user from the chat room and broadcasts their disconnection.
   *
   * @param {Object} user - The user to be removed from the room.
   */
  removeUser(user) {
    let index = this.users.indexOf(user);
    this.users.splice(index, 1);
    let json = {
      type: "Disconnect",
      room: this.id,
      userCount: this.users.length,
      maxUsers: this.maxUsers,
      status: this.status,
      username: user.username,
      totalUsers: this.wsClients.length,
    };
    this.broadcast(JSON.stringify(json));
  }

  /**
   * Broadcasts a message to all users in the chat room, except the sender.
   *
   * @param {string} message - The message to be sent to the users.
   * @param {Object} sender - The user who sent the message (optional).
   */
  broadcast(message, sender = null) {
    for (let i = 0; i < this.users.length; i++) {
      let user = this.users[i];
      if (user !== sender) {
        user.socket.send(message);
      }
    }
  }

  /**
   * Removes the chat room from the list of rooms if it is empty.
   *
   * @param {Array} rooms - The array of existing chat rooms.
   * @param {Array} roomIDs - The array of existing room IDs.
   */
  removeEmptyRoom(rooms, roomIDs) {
    const roomIndex = rooms.indexOf(this.room);
    if (roomIndex !== -1) {
      rooms.splice(roomIndex, 1);
      roomIDs.splice(roomIDs.indexOf(room.id), 1);
    }
  }

}

module.exports = ChatRoom;
