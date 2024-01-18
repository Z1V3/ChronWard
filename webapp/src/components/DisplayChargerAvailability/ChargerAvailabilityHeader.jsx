// ChargerAvailabilityHeader.jsx

import React, { useState, useEffect } from 'react';
import { getChargersStatistics } from '../../api/charger';
import './ChargerAvailabilityHeader.css';

const ChargerAvailabilityHeader = () => {
  const [chargerStatistics, setChargerStatistics] = useState({
    total: 0,
    occupied: 0,
    free: 0,
    deactivated: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchChargerStatistics = async () => {
      try {
        const response = await getChargersStatistics();

        if (response.message === 'Statistics data successfully returned') {
          const { totalNumberOfChargers, numberOfOccupiedChargers, numberOfFreeChargers, numberOfDeactivatedChargers } = response.statistics;

          setChargerStatistics({
            total: totalNumberOfChargers,
            occupied: numberOfOccupiedChargers,
            free: numberOfFreeChargers,
            deactivated: numberOfDeactivatedChargers,
          });

          setLoading(false);
        } else {
          throw new Error('Failed to fetch charger statistics.');
        }
      } catch (error) {
        console.error('Error fetching charger statistics:', error.message);
        setLoading(false);
      }
    };

    fetchChargerStatistics();
  }, []);

  return (
    <div className="charger-header">
      <h1>Charger Status</h1>
      {loading ? (
        <p className="loading-message">Loading...</p>
      ) : (
        <div className="charger-counts">
          <div className="charger-count">
            <strong>Total:</strong> {chargerStatistics.total}
          </div>
          <div className="charger-count">
            <strong>Occupied:</strong> {chargerStatistics.occupied}
          </div>
          <div className="charger-count">
            <strong>Free:</strong> {chargerStatistics.free}
          </div>
          <div className="charger-count">
            <strong>Deactivated:</strong> {chargerStatistics.deactivated}
          </div>
        </div>
      )}
    </div>
  );
};

export default ChargerAvailabilityHeader;
