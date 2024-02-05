import apiOrigin from "./api";

export const addCharger = async (newChargerData) => {
  try {
    const response = await fetch(`${apiOrigin}/charger/createCharger`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(newChargerData),
    });

    if (!response.ok) {
      let errorMessage = "Failed to add charger.";
      try {
        const errorResponse = await response.json();
        errorMessage = errorResponse.message || errorMessage;
        if (
          errorResponse.message === "Charger with the same name already exists"
        ) {
          throw new Error("Charger with the same name already exists.");
        }
      } catch (jsonError) {
        console.error("Error parsing JSON error response:", jsonError);
      }
      throw new Error(errorMessage);
    }

    return await response.json();
  } catch (error) {
    console.error("Error adding charger:", error.message);
    throw error;
  }
};

export const editCharger = async (editedChargerData) => {
  try {
    const response = await fetch(`${apiOrigin}/charger/updateCharger`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(editedChargerData),
    });

    if (!response.ok) {
      let errorMessage = "Failed to edit charger.";
      try {
        const errorResponse = await response.json();
        errorMessage = errorResponse.message || errorMessage;
        if (
          errorResponse.message === "Charger with the same name already exists"
        ) {
          throw new Error("Charger with the same name already exists.");
        }
      } catch (jsonError) {
        console.error("Error parsing JSON error response:", jsonError);
      }
      throw new Error(errorMessage);
    }

    return await response.json();
  } catch (error) {
    console.error("Error editing charger:", error.message);
    throw error;
  }
};

export const getChargersStatistics = async () => {
  try {
    const response = await fetch(`${apiOrigin}/charger/getChargersStatistics`);

    if (!response.ok) {
      let errorMessage = "Failed to fetch charger statistics.";
      try {
        const errorResponse = await response.json();
        errorMessage = errorResponse.message || errorMessage;
      } catch (jsonError) {
        console.error("Error parsing JSON error response:", jsonError);
      }
      throw new Error(errorMessage);
    }

    return await response.json();
  } catch (error) {
    console.error("Error fetching charger statistics:", error.message);
    throw error;
  }
};

export const deleteChargerData = async (chargerID) => {
  try {
    const response = await fetch(`${apiOrigin}/charger/deleteCharger/${chargerID}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
      },
    });

    if (!response.ok) {
      let errorMessage = "Failed to delete charger.";
      try {
        const errorResponse = await response.json();
        errorMessage = errorResponse.message || errorMessage;
      } catch (jsonError) {
        console.error("Error parsing JSON error response:", jsonError);
      }
      throw new Error(errorMessage);
    }

    return await response.json(); // You can adjust this based on the server's response after successful deletion
  } catch (error) {
    console.error("Error deleting charger:", error.message);
    throw error;
  }
};
