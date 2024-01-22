import React, { useState, useEffect } from 'react';
import './AddEditChargerModal.css';
import { editCharger } from '../../api/charger';
import { validateChargerName, validateLatitude, validateLongitude } from '../../utils/validation';

const EditChargerModal = ({ charger, onClose, chargersUpdatedCallback }) => {
  const [name, setName] = useState(charger.name);
  const [latitude, setLatitude] = useState(charger.latitude.toString());
  const [longitude, setLongitude] = useState(charger.longitude.toString());
  const [nameError, setNameError] = useState('');
  const [latError, setLatError] = useState('');
  const [lonError, setLonError] = useState('');
  const [successMessage, setSuccessMessage] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const [status, setStatus] = useState(charger.active ? 'Active' : 'Inactive');

  useEffect(() => {
    setStatus(charger.active ? 'Active' : 'Inactive');
  }, [charger]);

  const handleUpdateCharger = async () => {
    try {
      const nameErrorResult = validateChargerName(name);
      const latErrorResult = validateLatitude(latitude);
      const lonErrorResult = validateLongitude(longitude);

      if (nameErrorResult || latErrorResult || lonErrorResult) {
        setNameError(nameErrorResult);
        setLatError(latErrorResult);
        setLonError(lonErrorResult);
        setSuccessMessage('');
        setErrorMessage('');
        return;
      }

      const roundedLat = parseFloat(latitude).toFixed(4);
      const roundedLon = parseFloat(longitude).toFixed(4);

      const editedChargerData = {
        ...charger,
        chargerID: charger.chargerID,
        name: name,
        latitude: parseFloat(roundedLat),
        longitude: parseFloat(roundedLon),
        active: status === 'Active',
      };

      await editCharger(editedChargerData);
      setNameError('');
      setLatError('');
      setLonError('');
      setErrorMessage('');
      setSuccessMessage('Charger updated successfully');
      chargersUpdatedCallback();
    } catch (error) {
      setSuccessMessage('');
      setErrorMessage('Error updating charger: ' + error.message);
    }
  };

  return (
    <div className="edit-charger">
      <h2>Edit Charger</h2>
      <div className="input-group">
        <label htmlFor="name">Name:</label>
        <input type="text" id="name" value={name} onChange={(e) => setName(e.target.value)} />
        {nameError && <p className="error-message">{nameError}</p>}
      </div>
      <div className="input-group">
        <label htmlFor="latitude">Latitude:</label>
        <input type="text" id="latitude" value={latitude} onChange={(e) => setLatitude(e.target.value)} />
        {latError && <p className="error-message">{latError}</p>}
      </div>
      <div className="input-group">
        <label htmlFor="longitude">Longitude:</label>
        <input type="text" id="longitude" value={longitude} onChange={(e) => setLongitude(e.target.value)} />
        {lonError && <p className="error-message">{lonError}</p>}
      </div>
      <div className="input-group">
        <label htmlFor="status">Status:</label>
        <select id="status" value={status} onChange={(e) => setStatus(e.target.value)}>
          <option value="Active">Active</option>
          <option value="Inactive">Inactive</option>
        </select>
      </div>
      {successMessage && <p className="success-message">{successMessage}</p>}
      {errorMessage && <p className="error-message">{errorMessage}</p>}
      <button onClick={handleUpdateCharger}>Update</button>
      <button onClick={onClose}>Close</button>
    </div>
  );
};

export default EditChargerModal;
