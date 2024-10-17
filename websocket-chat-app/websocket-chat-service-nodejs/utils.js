/**
 * Parses a socket data message from an array of character codes into a string.
 * 
 * @param {number[]} message - An array of character codes representing the message.
 * @returns {string} The parsed string message.
 */
function parseSocketData(message) {
  let str = "";
  for (let n = 0; n < message.length; n += 1) {
    str += String.fromCharCode(message[n]);
  }
  return str;
}

module.exports = { parseSocketData };
