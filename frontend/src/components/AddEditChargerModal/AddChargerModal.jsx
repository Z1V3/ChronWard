import React, { useState } from "react";
import "./AddEditChargerModal.css";
import { addCharger } from "@/api/charger";
import {
  validateChargerName,
  validateLatitude,
  validateLongitude,
} from "@/utils/validation";

const AddChargerModal = ({ onClose }) => {
  const [name, setName] = useState("");
  const [latitude, setLatitude] = useState("");
  const [longitude, setLongitude] = useState("");
  const [nameError, setNameError] = useState("");
  const [latError, setLatError] = useState("");
  const [lonError, setLonError] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [errorMessage, setErrorMessage] = useState("");

  const handleAddCharger = async () => {
    try {
      const nameErrorResult = validateChargerName(name);
      const latErrorResult = validateLatitude(latitude);
      const lonErrorResult = validateLongitude(longitude);

      if (nameErrorResult || latErrorResult || lonErrorResult) {
        setNameError(nameErrorResult);
        setLatError(latErrorResult);
        setLonError(lonErrorResult);
        setSuccessMessage("");
        setErrorMessage("");
        return;
      }

      const roundedLat = parseFloat(latitude).toFixed(4);
      const roundedLon = parseFloat(longitude).toFixed(4);

      const newChargerData = {
        name: name,
        latitude: parseFloat(roundedLat),
        longitude: parseFloat(roundedLon),
        creator: 1,
      };

      await addCharger(newChargerData);
      setName("");
      setLatitude("");
      setLongitude("");
      setNameError("");
      setLatError("");
      setLonError("");
      setErrorMessage("");
      setSuccessMessage("Charger added successfully");
    } catch (error) {
      setSuccessMessage("");
      setErrorMessage("Error adding charger: " + error.message);
    }
  };

  return (
    <div className="add-charger">
      <h2>Add Charger</h2>
      <div className="input-group">
        <label htmlFor="name">Name:</label>
        <input
          type="text"
          id="name"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        {nameError && <p className="error-message">{nameError}</p>}
      </div>
      <div className="input-group">
        <label htmlFor="latitude">Latitude:</label>
        <input
          type="text"
          id="latitude"
          value={latitude}
          onChange={(e) => setLatitude(e.target.value)}
        />
        {latError && <p className="error-message">{latError}</p>}
      </div>
      <div className="input-group">
        <label htmlFor="longitude">Longitude:</label>
        <input
          type="text"
          id="longitude"
          value={longitude}
          onChange={(e) => setLongitude(e.target.value)}
        />
        {lonError && <p className="error-message">{lonError}</p>}
      </div>
      {successMessage && <p className="success-message">{successMessage}</p>}
      {errorMessage && <p className="error-message">{errorMessage}</p>}
      <button onClick={handleAddCharger}>Add</button>
      <button onClick={onClose}>Close</button>
    </div>
  );
};

export default AddChargerModal;
