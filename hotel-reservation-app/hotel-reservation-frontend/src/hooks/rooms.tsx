import { useState } from "react";
import { AxiosResponse } from "axios";
import { RoomType } from "../types/generated";
import { performRequestWithRetry } from "../api/retry";
import { apiUrl } from "../api/config";

export function useGetRooms() {
  const [rooms, setRooms] = useState<RoomType[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error>();

  const fetchRooms = async (
    checkIn: string,
    checkOut: string,
    guestCapacity: number,
  ): Promise<void> => {
    setLoading(true);
    const options = {
      method: "GET",
      params: {
        checkinDate: checkIn,
        checkoutDate: checkOut,
        guestCapacity
      },
    };
    try {
      const response = await performRequestWithRetry(
        `${apiUrl}/roomTypes`,
        options
      );
      const roomList = (response as AxiosResponse<RoomType[]>).data;
      setRooms(roomList);
    } catch (e: any) {
      setError(e);
    }
    setLoading(false);
  };

  return { rooms, loading, error, fetchRooms };
}
