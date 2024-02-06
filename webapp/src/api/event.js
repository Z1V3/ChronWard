import apiOrigin from './api';

export const getChargingSessionsByUserId = async (userId) => {
  try {
    const response = await fetch(`${apiOrigin}/event/getEventsByUserID/${userId}`);

    if (!response.ok) {
      let errorMessage = 'Failed to fetch charging sessions.';
      try {
        const errorResponse = await response.json();
        errorMessage = errorResponse.message || errorMessage;
      } catch (jsonError) {
        console.error('Error parsing JSON error response:', jsonError);
      }
      throw new Error(errorMessage);
    }

    return await response.json();
  } catch (error) {
    console.error('Error fetching charging sessions:', error.message);
    throw error;
  }
};

export const getAllEvents = async () => {
  try {
    const response = await fetch(`${apiOrigin}/event/getAllEvents`);

    if (!response.ok) {
      let errorMessage = 'Failed to fetch charging sessions.';
      try {
        const errorResponse = await response.json();
        errorMessage = errorResponse.message || errorMessage;
      } catch (jsonError) {
        console.error('Error parsing JSON error response:', jsonError);
      }
      throw new Error(errorMessage);
    }

    return await response.json();
  } catch (error) {
    console.error('Error fetching charging sessions:', error.message);
    throw error;
  }
};
