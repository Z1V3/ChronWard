"use client";

import React, { useState } from "react";
import Navbar from "@/components/Navbar/Navbar";
import Map from "@/components/Map/Map";
import AddChargerModal from "@/components/AddEditChargerModal/AddChargerModal";
import ChargerAvailabilityHeader from "@/components/DisplayChargerAvailability/ChargerAvailabilityHeader";
import HistoryButton from "@/components/ViewChargingHistory/HistoryButton";
import "@/app/style.css";
import "@/components/button.css";
import ChargerStatisticsButton from "@/components/DisplayChargerStatistics/ChargerStatisticsButton";

function App() {
  const [isAddChargerModalOpen, setIsAddChargerModalOpen] = useState(false);
  const [chargersUpdated, setChargersUpdated] = useState(false);

  const openAddChargerModal = () => {
    setIsAddChargerModalOpen(true);
  };

  const closeAddChargerModal = () => {
    setIsAddChargerModalOpen(false);
  };

  const handleChargersUpdated = () => {
    setChargersUpdated((prev) => !prev);
  };

  return (
    <div className="App">
      <div className="App-header">
        <h1>EV Charge</h1>
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
