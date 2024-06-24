type Reservation = {
  id: string;
  room: Room;
  checkinDate: string;
  checkoutDate: string;
  user: User;
};

type Room = {
  number: number;
  type: RoomType;
};

type RoomType = {
  id: number;
  name: string;
  guestCapacity: number;
  price: number;
};

type User = {
  id: string;
  name: string;
  email: string;
  mobileNumber: string;
};

type NewReservationRequest = {
  checkinDate: string;
  checkoutDate: string;
  user: User;
  roomType: string;
};

type UpdateReservationRequest = {
  checkinDate: string;
  checkoutDate: string;
};

type NewReservationError = {
  http: "NotFound";
  body: string;
};

type UpdateReservationError = {
  http: "NotFound";
  body: string;
};
