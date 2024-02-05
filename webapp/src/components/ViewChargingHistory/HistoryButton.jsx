import React, { useState, useEffect } from 'react';
import { getChargingSessionsByUserId } from '../../api/event';
import ChargingHistoryList from './ChargingHistoryList';
import './HistoryButton.css';

const HistoryButton = () => {
  const [chargingSessions, setChargingSessions] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [modalIsOpen, setModalIsOpen] = useState(false);

  useEffect(() => {
    const fetchChargingHistory = async () => {
      try {
        setIsLoading(true);
        const userId = 1;
        const sessions = await getChargingSessionsByUserId(userId);
        setChargingSessions(sessions);
        setModalIsOpen(true);
      } catch (error) {
        console.error('Error fetching charging history:', error.message);
      } finally {
        setIsLoading(false);
      }
    };

    if (modalIsOpen) {
      fetchChargingHistory();
    }
  }, [modalIsOpen]);

  const closeModal = () => {
    setModalIsOpen(false);
  };

  return (
    <div>
      <button className="button-style1" onClick={() => setModalIsOpen(true)}>
        View Charging History
      </button>
      {isLoading && <p>Loading...</p>}
      {chargingSessions.length > 0 && (
        <ChargingHistoryList
          chargingSessions={chargingSessions}
          modalIsOpen={modalIsOpen}
          openModal={() => setModalIsOpen(true)}
          closeModal={closeModal}
        />
      )}
    </div>
  );
};

export default HistoryButton;
