import React, { useState } from "react";
import AddChargerModal from "./components/AddEditChargerModal/AddChargerModal";
import Navbar from "@/components/Navbar/Navbar";
import Map from "@/components/Map/Map";

function App() {
  const [isAddChargerModalOpen, setIsAddChargerModalOpen] = useState(false);

  const openAddChargerModal = () => {
    setIsAddChargerModalOpen(true);
  };

  const closeAddChargerModal = () => {
    setIsAddChargerModalOpen(false);
  };

  return (
    <div className="App">
      <Navbar />
      <header className="App-header">
        <button onClick={openAddChargerModal}>Add charging station</button>
        {isAddChargerModalOpen && (
          <div className="modal-overlay">
            <AddChargerModal onClose={closeAddChargerModal} />
          </div>
        )}
      </header>
      <div className="map-container">
        <Map />
      </div>
    </div>
  );
}

export default App;
