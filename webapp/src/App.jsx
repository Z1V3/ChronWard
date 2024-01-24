import React, { useState } from "react";
import "./App.css";
import AddChargerModal from "./components/AddEditChargerModal/AddChargerModal";
import Map from "./Sample/Map";
import HistoryButton from './components/ViewChargingHistory/HistoryButton';
import ChargerAvailabilityHeader from './components/DisplayChargerAvailability/ChargerAvailabilityHeader';
import "./Sample/Map.css";
import "./components/button.css";

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
        <Map chargersUpdated={chargersUpdated} chargersUpdatedCallback={handleChargersUpdated} />
      </div>
      <div>
        <HistoryButton />
      </div>
      <div className="AddChargerDiv">
        <button className="button-styleA" onClick={openAddChargerModal}>Add charging station</button>
        {isAddChargerModalOpen && (
          <div className="modal-overlay">
            <AddChargerModal onClose={closeAddChargerModal} chargersUpdatedCallback={handleChargersUpdated} />
          </div>
        )}
      </div>
    </div>
  );
  
}

export default App;
