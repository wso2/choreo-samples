import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";

const root = ReactDOM.createRoot(
  document.getElementById("root") as HTMLElement
);
root.render(
  <React.StrictMode>
    <div
      style={{
        backgroundImage: `url(${require("./resources/hotel-room.png")}`,
        minHeight: "100vh",
        backgroundSize: "cover",
        display: "flex",
        flexDirection: "column",
      }}
    >
      <App />
    </div>
  </React.StrictMode>
);
