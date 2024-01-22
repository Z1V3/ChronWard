import React, { useState } from "react";
import "./App.css";
import AddChargerModal from "./components/AddEditChargerModal/AddChargerModal";
import Map from "./Sample/Map";

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
      <header className="App-header"></header>
      <div className="map-container">
        <Map chargersUpdated={chargersUpdated} chargersUpdatedCallback={handleChargersUpdated} />
      </div>
      <div>
        <button onClick={openAddChargerModal}>Add charging station</button>
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
