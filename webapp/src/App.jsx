import React, { useState } from "react";
import "./App.css";
import AddChargerModal from "./components/AddEditChargerModal/AddChargerModal";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Navbar from "./Sample/Navbar";
import Map from "./Sample/Map";

function App() {
  const [isAddChargerModalOpen, setIsAddChargerModalOpen] = useState(false);

  const openAddChargerModal = () => {
    setIsAddChargerModalOpen(true);
  };

  const closeAddChargerModal = () => {
    setIsAddChargerModalOpen(false);
  };

  return (
    <Router>
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
    </Router>
  );
}

export default App;
