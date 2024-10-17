class User {
  /**
   * Creates an instance of a User.
   * 
   * @param {Object} socket - The WebSocket connection for the user.
   * @param {string} username - The username of the user.
   * @param {Array} clientIDs - An array to keep track of existing user IDs.
   */
  constructor(socket, username, clientIDs) {
    this.socket = socket;
    this.username = username;
    this.currentRoom = null;

    this.id = 0;
    while (this.id == 0 || clientIDs.includes(this.id)) {
      this.id = Math.floor(Math.random() * 1000000000);
    }
    clientIDs.push(this.id);
  }
}

module.exports = User;
