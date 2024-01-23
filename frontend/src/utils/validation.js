export const validateChargerName = (name) => {
    return name.length >= 3 ? '' : 'Charging station name must be at least 3 characters long.';
  };
  
  export const validateLatitude = (latitude) => {
    const lat = parseFloat(latitude);
    return isNaN(lat) || lat < -90 || lat > 90 ? 'Invalid latitude. Latitude must be between -90 and 90.' : '';
  };
  
  export const validateLongitude = (longitude) => {
    const lon = parseFloat(longitude);
    return isNaN(lon) || lon < -180 || lon > 180 ? 'Invalid longitude. Longitude must be between -180 and 180.' : '';
  };
  