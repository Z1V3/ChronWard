import React, { useState, useEffect } from "react";
import { GoogleMap, useLoadScript, Marker } from "@react-google-maps/api";
import apiOrigin from "../api/api";

const libraries = ["places"];
const mapContainerStyle = {
  width: "100vw",
  height: "100vh",
};
const center = {
  lat: 37.835819, // default latitude
  lng: -98.964961, // default longitude
};

const Map = () => {
  const [chargerData, setChargerData] = useState([]);

  useEffect(() => {
    const fetchChargerData = async () => {
      const response = await fetch(`${apiOrigin}/charger/getAllChargers`);
      const data = await response.json();
      setChargerData(data.chargers);
    };

    fetchChargerData();
  }, []);

  const { isLoaded, loadError } = useLoadScript({
    googleMapsApiKey: "AIzaSyB9ut80NdYyNVey4ZWLGbeINVrIFQqoIx4",
    libraries,
  });

  if (loadError) {
    return;

    <div>Error loading maps</div>;
  }

  if (!isLoaded) {
    return;

    <div>Loading maps</div>;
  }

  return (
    <div>
      <GoogleMap mapContainerStyle={mapContainerStyle} zoom={4} center={center}>
        {chargerData.map((charger) => (
          <Marker
            position={{ lat: charger.latitude, lng: charger.longitude }}
            key={charger.chargerId}
          >
            <div>
              <h3>{charger.name}</h3>
              <p>{charger.type}</p>
            </div>
          </Marker>
        ))}
      </GoogleMap>
    </div>
  );
};

export default Map;
