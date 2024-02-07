"use client";

import React, { useState, useEffect } from "react";
import Navbar from "@/components/Navbar/Navbar";
import Map from "@/components/Map/Map";
import AddChargerModal from "@/components/AddEditChargerModal/AddChargerModal";
import ChargerAvailabilityHeader from "@/components/DisplayChargerAvailability/ChargerAvailabilityHeader";
import HistoryButton from "@/components/ViewChargingHistory/HistoryButton";
import "@/app/style.css";
import "@/components/button.css";
import ChargerStatisticsButton from "@/components/DisplayChargerStatistics/ChargerStatisticsButton";
import { Button } from "@mui/material";
import { useLocalStorage } from "@uidotdev/usehooks";


function App() {
  const [isAddChargerModalOpen, setIsAddChargerModalOpen] = useState(false);
  const [chargersUpdated, setChargersUpdated] = useState(false);
  const [user, saveUser] = useLocalStorage("user", null);

  const openAddChargerModal = () => {
    setIsAddChargerModalOpen(true);
  };

  const closeAddChargerModal = () => {
    setIsAddChargerModalOpen(false);
  };

  const handleChargersUpdated = () => {
    setChargersUpdated((prev) => !prev);
  };

  useEffect(() => {
    if(!user) {
      window.location.href = "/login"
    }
  }, [user])

  const logout = () => {
    saveUser(null);
  }

  return (
    <div className="App">
      <div className="App-header">
        <h1>EV Charge</h1>
        <Button variant="contained"  className="logout-button" onClick={logout}>Logout</Button>
      </div>
      <ChargerAvailabilityHeader />
      <div className="MapContainer">
        <Map
          chargersUpdated={chargersUpdated}
          chargersUpdatedCallback={handleChargersUpdated}
        />
      </div>
      <div>
        <HistoryButton />
		    <ChargerStatisticsButton />
      </div>
      <div className="AddChargerDiv">
        <button className="button-styleA" onClick={openAddChargerModal}>
          Add charging station
        </button>
        {isAddChargerModalOpen && (
          <div className="modal-overlay">
            <AddChargerModal
              onClose={closeAddChargerModal}
              chargersUpdatedCallback={handleChargersUpdated}
            />
          </div>
        )}
      </div>
    </div>
  );
}

export default App;
