import apiOrigin from "./api";

export const login = async (userData) => {
  try {
    const response = await fetch(`${apiOrigin}/user/login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(userData),
    });

    if (!response.ok) {
      let errorMessage = "Login failed.";
      const errorResponse = await response.json();
      errorMessage = errorResponse.message || errorMessage;
      throw new Error(errorMessage);
    }

    return await response.json();
  } catch (error) {
    console.error("Login failed: ", error.message);
    return null;
  }
};

export const register = async (userData) => {
  try {
    const response = await fetch(`${apiOrigin}/user/register`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(userData),
    });

    if (!response.ok) {
      let errorMessage = "Registration failed.";
      const errorResponse = await response.json();
      errorMessage = errorResponse.message || errorMessage;
      throw new Error(errorMessage);
    }

    return true;
  } catch (error) {
    console.error("Login failed: ", error.message);
    return false;
  }
};
