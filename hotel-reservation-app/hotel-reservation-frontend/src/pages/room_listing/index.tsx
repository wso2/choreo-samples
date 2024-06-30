import React from "react";
import { useGetRooms } from "../../hooks/rooms";
import { RoomType } from "../../types/generated";
import { RoomSearchBar } from "./RoomSearchBar";
import RoomListItem from "./RoomListItem";
import { Box, Typography } from "@mui/material";

function RoomListing() {
  const { fetchRooms, rooms: roomList, loading, error } = useGetRooms();

  return (
    <div style={{ display: "flex", flexDirection: "column", width: "70%" }}>
      <RoomSearchBar searchRooms={fetchRooms} error={error} loading={loading} />
      <Box style={{ background: "rgba(0, 0, 0, 0.5)" }} px={8} py={4}>
        {roomList &&
          roomList.map((room: RoomType) => (
            <RoomListItem room={room} key={room.id} />
          ))}
          {!roomList || roomList.length === 0 && (
            <Typography textAlign="center" variant="h4" color="white">
              No rooms found
            </Typography>
          )}
      </Box>
    </div>
  );
}

export default RoomListing;
