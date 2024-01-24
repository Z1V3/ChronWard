import React from "react";
import "./Navbar.css";

const Navbar = () => {
  return (
    <nav className="navbar">
      <ul>
        <li>
          <a href="../App.jsx">Home</a>
        </li>
        <li>
          <a href="../Sample/Map.jsx">Map</a>
        </li>
      </ul>
    </nav>
  );
};

export default Navbar;
