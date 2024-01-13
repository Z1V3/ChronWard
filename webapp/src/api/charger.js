import apiOrigin from './api';

export const addCharger = async (newChargerData) => {
  try {
    const response = await fetch(`${apiOrigin}/charger/createCharger`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(newChargerData),
    });

    if (!response.ok) {
      let errorMessage = 'Failed to add charger.';
      try {
        const errorResponse = await response.json();
        errorMessage = errorResponse.message || errorMessage;
        if (errorResponse.message === 'Charger with the same name already exists') {
          throw new Error('Charger with the same name already exists.');
        }
      } catch (jsonError) {
        console.error('Error parsing JSON error response:', jsonError);
      }
      throw new Error(errorMessage);
    }

    return await response.json();
  } catch (error) {
    console.error('Error adding charger:', error.message);
    throw error;
  }
};