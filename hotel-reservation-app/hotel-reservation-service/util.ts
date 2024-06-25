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
      number: 105,
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
      number: 404,
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
