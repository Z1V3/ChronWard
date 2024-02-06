// ChargerStatisticsDashboard.js
import React, { useState, useEffect } from 'react';
import Modal from 'react-modal';
import './ChargerStatisticsDashboard.css';
import { getAllChargers } from '../../api/charger';
import { getAllEvents } from '../../api/event';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  Legend,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from 'recharts';

const ChargerStatisticsDashboard = ({ modalIsOpen, closeModal }) => {
  const [chargers, setChargers] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const chargersData = await getAllChargers();
        setChargers(chargersData.chargers);
      } catch (error) {
        console.error('Error fetching chargers:', error.message);
      }
    };

    fetchData();
  }, []);

  const calculateActiveInactiveCount = () => {
    const activeChargers = chargers.filter((charger) => charger.active);
    const inactiveChargers = chargers.filter((charger) => !charger.active);
    return {
      active: activeChargers.length,
      inactive: inactiveChargers.length,
    };
  };

  const activeInactiveCount = calculateActiveInactiveCount();

  const data = [
    { name: 'Active', value: activeInactiveCount.active },
    { name: 'Inactive', value: activeInactiveCount.inactive },
  ];

  const COLORS = ['#82ca9d', '#ff4d4f'];

  const [chargingSessions, setChargingSessions] = useState([]);

  useEffect(() => {
    const fetchChargingSessions = async () => {
      try {
        const eventsData = await getAllEvents();
        setChargingSessions(eventsData);
      } catch (error) {
        console.error('Error fetching charging sessions:', error.message);
      }
    };

    fetchChargingSessions();
  }, []);

  const calculateAverageMetricsPerCharger = () => {
    const averageMetricsPerCharger = {};

    chargingSessions.forEach((session) => {
      const chargerId = session.chargerId;
      const price = session.price;
      const volume = session.volume;

      if (averageMetricsPerCharger[chargerId]) {
        averageMetricsPerCharger[chargerId].totalPrice += price;
        averageMetricsPerCharger[chargerId].totalVolume += volume;
        averageMetricsPerCharger[chargerId].count += 1;
      } else {
        averageMetricsPerCharger[chargerId] = {
          totalPrice: price,
          totalVolume: volume,
          count: 1,
        };
      }
    });

    return Object.keys(averageMetricsPerCharger).map((chargerId) => ({
      chargerId: parseInt(chargerId),
      averagePrice: averageMetricsPerCharger[chargerId].totalPrice / averageMetricsPerCharger[chargerId].count,
      averageVolume: averageMetricsPerCharger[chargerId].totalVolume / averageMetricsPerCharger[chargerId].count,
    }));
  };

  const averageMetricsPerCharger = calculateAverageMetricsPerCharger();

  // Calculate overall average price and average volume
  const overallAveragePrice = chargingSessions.length
    ? chargingSessions.reduce((total, session) => total + session.price, 0) / chargingSessions.length
    : 0;

  const overallAverageVolume = chargingSessions.length
    ? chargingSessions.reduce((total, session) => total + session.volume, 0) / chargingSessions.length
    : 0;

  return (
    <Modal
      isOpen={modalIsOpen}
      onRequestClose={closeModal}
      className="modal-styles-dashboard charger-statistics-modal"
      contentLabel="Charger Statistics Dashboard Modal"
    >
      <button className="close-button" onClick={closeModal}>
        Close
      </button>
      <div className="charger-statistics-container">
        <h2 className="dashboard-title">Charger Statistics</h2>

        {/* Display a Doughnut chart of active and inactive chargers */}
        <div className="chart-container">
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie
                dataKey="value"
                isAnimationActive={false}
                data={data}
                cx="50%"
                cy="50%"
                outerRadius={80}
                fill="#8884d8"
                label
              >
                {data.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip />
              <Legend />
            </PieChart>
          </ResponsiveContainer>

          <div className="dashboard-metrics">
            <div className="dashboard-metric">
              <p className="highlight">Active Chargers Percentage:</p>
              <div className="metric-value">${((activeInactiveCount.active / chargers.length) * 100).toFixed(2)}%</div>
            </div>
          </div>
        </div>

        {/* Display a list of chargers with green and red visual representation */}
        <div className="charger-list">
          {chargers.map((charger) => (
            <div key={charger.chargerId} className={`charger-list-element ${charger.active ? 'active' : 'inactive'}`}>
              Charger {charger.chargerId} - {charger.active ? 'Active' : 'Inactive'}
            </div>
          ))}
        </div>
        <br></br>
        <hr></hr>
        <br></br>

        {/* Display average price and average volume per charger */}
        <div className="chart-container">
          <h3>Average Price and Volume per Charger</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={averageMetricsPerCharger}>
              <XAxis
                dataKey="chargerId"
                tickFormatter={(value) => `Charger ${value}`} // Custom formatter for XAxis ticks
              />
              <YAxis />
              <Tooltip
                formatter={(value) => `$${value.toFixed(2)}`} // Format tooltip values to 2 decimal places
              />
              <Legend />
              <Bar dataKey="averagePrice" fill="#82ca9d" name="Average Price" />
              <Bar dataKey="averageVolume" fill="#8884d8" name="Average Volume" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <br></br>
        <hr></hr>
        <br></br>

        {/* Display overall average price and overall average volume */}
        <div className="dashboard-metrics">
          <div className="dashboard-metric">
            <p className="highlight">Overall Average Price:</p>
            <div className="metric-value">${overallAveragePrice.toFixed(2)}</div>
          </div>
          <div className="dashboard-metric">
            <p className="highlight">Overall Average Volume:</p>
            <div className="metric-value">{overallAverageVolume.toFixed(2)} kWh</div>
          </div>
        </div>



      </div>
    </Modal>
  );
};

export default ChargerStatisticsDashboard;
