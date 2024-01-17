import React, { useState } from 'react';
import './App.css';
import AddChargerModal from './components/AddEditChargerModal/AddChargerModal';

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
      <header className="App-header">
        <button onClick={openAddChargerModal}>Add charging station</button>
        {isAddChargerModalOpen && (
          <div className="modal-overlay">
            <AddChargerModal onClose={closeAddChargerModal} />
          </div>
        )}
      </header>
    </div>
  );
}

export default App;
