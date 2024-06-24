import { roomReservations, rooms } from ".";

export function getAllRooms(): Room[] {
  return [
    {
      number: 101,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 102,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 103,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 104,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 105,
      type: {
        id: 1,
        name: "Double",
        guestCapacity: 2,
        price: 120,
      },
    },
    {
      number: 106,
      type: {
        id: 1,
        name: "Double",
        guestCapacity: 2,
        price: 120,
      },
    },
    {
      number: 201,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 202,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 203,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 204,
      type: {
        id: 1,
        name: "Double",
        guestCapacity: 2,
        price: 120,
      },
    },
    {
      number: 205,
      type: {
        id: 1,
        name: "Double",
        guestCapacity: 2,
        price: 120,
      },
    },
    {
      number: 206,
      type: {
        id: 1,
        name: "Double",
        guestCapacity: 2,
        price: 120,
      },
    },
    {
      number: 301,
      type: {
        id: 1,
        name: "Double",
        guestCapacity: 2,
        price: 120,
      },
    },
    {
      number: 302,
      type: {
        id: 1,
        name: "Double",
        guestCapacity: 2,
        price: 120,
      },
    },
    {
      number: 303,
      type: {
        id: 2,
        name: "Family",
        guestCapacity: 4,
        price: 200,
      },
    },
    {
      number: 304,
      type: {
        id: 3,
        name: "Suite",
        guestCapacity: 4,
        price: 300,
      },
    },
    {
      number: 305,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 306,
      type: {
        id: 1,
        name: "Double",
        guestCapacity: 2,
        price: 120,
      },
    },
    {
      number: 401,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 402,
      type: {
        id: 1,
        name: "Double",
        guestCapacity: 2,
        price: 120,
      },
    },
    {
      number: 403,
      type: {
        id: 2,
        name: "Family",
        guestCapacity: 4,
        price: 200,
      },
    },
    {
      number: 404,
      type: {
        id: 3,
        name: "Suite",
        guestCapacity: 4,
        price: 300,
      },
    },
    {
      number: 405,
      type: {
        id: 0,
        name: "Single",
        guestCapacity: 1,
        price: 80,
      },
    },
    {
      number: 406,
      type: {
        id: 3,
        name: "Suite",
        guestCapacity: 4,
        price: 300,
      },
    },
    // Add other room objects here
  ];
}

export function getAllocatedRooms(
  checkinDate: string,
  checkoutDate: string
): { [number: number]: Room } {
  const userCheckinUTC: Date = new Date(checkinDate);
  const userCheckoutUTC: Date = new Date(checkoutDate);

  const allocatedRooms: { [number: number]: Room } = {};

  for (const reservation of Object.values(roomReservations)) {
    const rCheckin: Date = new Date(reservation.checkinDate);
    const rCheckout: Date = new Date(reservation.checkoutDate);

    if (userCheckinUTC <= rCheckin && userCheckoutUTC >= rCheckout) {
      allocatedRooms[reservation.room.number] = reservation.room;
    }
  }

  return allocatedRooms;
}

export function getAvailableRoom(
  checkinDate: string,
  checkoutDate: string,
  roomType: string
): Room | null {
  const allocatedRooms = getAllocatedRooms(checkinDate, checkoutDate);

  for (const room of rooms) {
    if (
      room.type.name === roomType &&
      (!allocatedRooms || !(room.number in allocatedRooms))
    ) {
      return room;
    }
  }
  return null;
}

export function getAvailableRoomTypes(
  checkinDate: string,
  checkoutDate: string,
  guestCapacity: number
) {
  try {
    // Call the function to get allocated rooms
    const allocatedRooms = getAllocatedRooms(checkinDate, checkoutDate);
    console.log("allocatedRooms", allocatedRooms);
    console.log("rooms", rooms);
    // Filter available room types based on guest capacity and allocated rooms
    const availableRoomTypes = rooms
      .filter((room) => {
        return (
          room.type.guestCapacity >= guestCapacity &&
          !allocatedRooms[room.number]
        );
      })
      .map((room) => room.type);
    console.log("availableRoomTypes", availableRoomTypes);
    return availableRoomTypes;
  } catch (error) {
    throw new Error("Error occurred while fetching available room types");
  }
}
