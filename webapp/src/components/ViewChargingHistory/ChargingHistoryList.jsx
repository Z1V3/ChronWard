// ChargingHistoryList.js
import React from 'react';
import Modal from 'react-modal';
import './ChargingHistoryList.css';

const ChargingHistoryList = ({ chargingSessions, modalIsOpen, openModal, closeModal }) => {
  const formatDateTime = (dateTimeString) => {
    const options = { year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: true };
    return new Date(dateTimeString).toLocaleString('en-US', options);
  };

  return (
    <Modal
      isOpen={modalIsOpen}
      onRequestClose={closeModal}
      className="modal-styles"
      contentLabel="Charging History Modal"
    >
      <button className="close-button" onClick={closeModal}>
        Close
      </button>
      <div className="list-container">
        <ul className="list">
          {chargingSessions.map((session) => (
            <li key={session.id} className="item">
              <div className="details">
                <div className="detail-item">
                  <strong>Start Time:</strong> {formatDateTime(session.startTime)}
                </div>
                <div className="detail-item">
                  <strong>End Time:</strong> {formatDateTime(session.endTime)}
                </div>
                <div className="detail-item">
                  <strong>Charge Time:</strong> {session.chargeTime} hours
                </div>
                <div className="detail-item">
                  <strong>Volume:</strong> {session.volume} kWh
                </div>
                <div className="detail-item">
                  <strong>Price:</strong> ${session.price}
                </div>
                {/*<div className="detail-item">
                  <strong>Charger ID:</strong> {session.chargerID}
                </div>*/}
              </div>
            </li>
          ))}
        </ul>
      </div>
    </Modal>
  );
};

export default ChargingHistoryList;
