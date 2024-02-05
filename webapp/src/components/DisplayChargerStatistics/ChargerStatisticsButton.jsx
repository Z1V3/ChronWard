// ChargerStatisticsButton.jsx
import React, { useState } from 'react';
import ChargerStatisticsDashboard from './ChargerStatisticsDashboard';
import './ChargerStatisticsButton.css';

const ChargerStatisticsButton = () => {
  const [modalIsOpen, setModalIsOpen] = useState(false);

  const openModal = () => {
    setModalIsOpen(true);
  };

  const closeModal = () => {
    setModalIsOpen(false);
  };

  return (
    <div>
      <button className="button-style2" onClick={openModal}>
        View Charger Statistics
      </button>
      <ChargerStatisticsDashboard modalIsOpen={modalIsOpen} closeModal={closeModal} />
    </div>
  );
};

export default ChargerStatisticsButton;
