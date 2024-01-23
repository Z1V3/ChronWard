// Navbar.js
import React from "react";
import "./Navbar.css";
import Link from "next/link";

const Navbar = () => {
  return (
    <nav className="navbar">
      <ul>
        <li>
          <Link href="/">Home</Link>
        </li>
      </ul>
    </nav>
  );
};

export default Navbar;
