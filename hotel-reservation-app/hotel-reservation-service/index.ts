import express, { Express, Request, Response, Router } from "express";
import { getAllRooms, getAvailableRoom, getAvailableRoomTypes } from "./util";
import { v4 as uuidv4 } from "uuid";
import cors from "cors";

const app: Express = express();
const router: Router = express.Router();
const port = 4000;

app.use(cors());
app.use(express.json());

export const rooms: Room[] = getAllRooms();
export const roomReservations: { [id: string]: Reservation } = {};

// POST /reservations
router.post(
  "/",
  (
    req: Request<NewReservationRequest>,
    res: Response<Reservation | NewReservationError>
  ) => {
    const payload = req.body;
    console.log("Request received by POST /reservations", payload);
    // Check if room is available for the given dates
    const availableRoom = getAvailableRoom(
      payload.checkinDate,
      payload.checkoutDate,
      payload.roomType
    );
    if (!availableRoom) {
      return res.status(400).send({
        http: "NotFound",
        body: "No rooms available for the given dates and type",
      });
    }

    // Create a new reservation
    const reservation = {
      id: uuidv4(),
      user: payload.user,
      room: availableRoom,
      checkinDate: payload.checkinDate,
      checkoutDate: payload.checkoutDate,
    };

    // Add reservation to the map
    roomReservations[reservation.id] = reservation;

    res.json(reservation);
  }
);

router.get("/roomTypes", (req: Request, res) => {
  console.log("Request received by GET /reservations/roomTypes", req.query);
  const { checkinDate, checkoutDate, guestCapacity } = req.query;

  // Validate query parameters
  if (!checkinDate || !checkoutDate || !guestCapacity) {
    return res.status(400).json({ error: "Missing required parameters" });
  }

  // Call the function to get available room types
  try {
    const roomTypes = getAvailableRoomTypes(
      checkinDate.toString(),
      checkoutDate.toString(),
      parseInt(guestCapacity.toString(), 10)
    );
    res.json(roomTypes);
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
});

router.get("/users/:userId", (req: Request, res: Response<Reservation[]>) => {
  const userId = req.params.userId;
  const reservations: Reservation[] = Object.values(roomReservations);
  return res.json(reservations.filter((r) => r.user.id === userId));
});

router.put(
  "/:reservationId",
  (req: Request, res: Response<Reservation | UpdateReservationError>) => {
    const reservationId = req.params.reservationId;
    const { checkinDate, checkoutDate }: UpdateReservationRequest = req.body;
    if (!roomReservations[reservationId]) {
      res.json({ http: "NotFound", body: "Reservation not found" });
    }
    const room = getAvailableRoom(
      checkinDate,
      checkoutDate,
      roomReservations[reservationId].room.type.name
    );
    if (!room) {
      res.json({ http: "NotFound", body: "No rooms available" });
    }
    roomReservations[reservationId].checkinDate = checkinDate;
    roomReservations[reservationId].checkoutDate = checkoutDate;
    res.json(roomReservations[reservationId]);
  }
);

router.delete("/:reservationId", (req: Request, res: Response) => {
  const reservationId = req.params.reservationId;
  if (!roomReservations[reservationId]) {
    res.json({ http: "NotFound", body: "Reservation not found" });
  }
  delete roomReservations[reservationId];
  res.sendStatus(200);
});

app.use("/api/reservations", router);

app.listen(port, () => {
  console.log(`[server]: Server is running at http://localhost:${port}`);
});
