import apiOrigin from "./api";

const fetchChargerData = async () => {
  const response = await fetch(`${apiOrigin}/charger/getAllChargers`);
  const data = await response.json();
  return data.chargers.map((charger) => ({
    ...charger,
    lastsync: new Date(charger.lastsync),
  }));
};

export { fetchChargerData };
