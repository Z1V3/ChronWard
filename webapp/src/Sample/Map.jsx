import React, { useState, useEffect } from "react";
import { GoogleMap, useLoadScript, Marker } from "@react-google-maps/api";
import apiOrigin from "../api/api";
import EditChargerModal from "../components/AddEditChargerModal/EditChargerModal";
import './Map.css';

const libraries = ["places"];
const mapContainerStyle = {
  width: "80%",
  height: "75vh",
  position: "relative",
  zIndex: 1,
};
const center = {
  lat: 46.308849,
  lng: 16.33885,
};

const Map = ({ chargersUpdated, chargersUpdatedCallback }) => {
  const [chargerData, setChargerData] = useState([]);
  const [selectedCharger, setSelectedCharger] = useState(null);
  const [isEditButtonEnabled, setEditButtonEnabled] = useState(false);
  const [isEditChargerModalOpen, setIsEditChargerModalOpen] = useState(false);
  const [clickedMarker, setClickedMarker] = useState(null);

  const openEditChargerModal = () => {
    if (selectedCharger) {
      setIsEditChargerModalOpen(true);
    }
  };

  const closeEditChargerModal = () => {
    setIsEditChargerModalOpen(false);
  };

  useEffect(() => {
    const fetchChargerData = async () => {
      const response = await fetch(`${apiOrigin}/charger/getAllChargers`);
      const data = await response.json();
      setChargerData(data.chargers);
    };

    fetchChargerData();
  }, [chargersUpdated]);

  const handleMarkerClick = (charger) => {
    setSelectedCharger(charger);
    setEditButtonEnabled(true);
    setClickedMarker(charger);
  };

  const { isLoaded, loadError } = useLoadScript({
    googleMapsApiKey: "AIzaSyB9ut80NdYyNVey4ZWLGbeINVrIFQqoIx4",
    libraries,
  });

  if (loadError) {
    return <div>Error loading maps</div>;
  }

  if (!isLoaded) {
    return <div>Loading maps</div>;
  }

  return (
    <div>
        <GoogleMap mapContainerStyle={mapContainerStyle} zoom={12} center={center}>
          {chargerData.map((charger) => (
            <Marker
              key={charger.chargerId}
              position={{ lat: charger.latitude, lng: charger.longitude }}
              onClick={() => handleMarkerClick(charger)}
              options={{
                icon: {
                  path: window.google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
                  scale: 5,
                  fillColor: clickedMarker && clickedMarker.chargerId === charger.chargerId ? "red" : "blue",
                  fillOpacity: 1,
                  strokeColor: "black",
                  strokeWeight: 1,
                  rotation: 0,
                },
              }}
            />
          ))}
        </GoogleMap>   
      <button class="button-styleA" onClick={openEditChargerModal} disabled={!isEditButtonEnabled}>
        Edit Charger Station
      </button>
      {isEditChargerModalOpen && (
        <div className="modal-overlay">
          <EditChargerModal charger={selectedCharger} onClose={closeEditChargerModal} chargersUpdatedCallback={chargersUpdatedCallback} />
        </div>
      )}
    </div>
  );
};

export default Map;
