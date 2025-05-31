import React from 'react';
import logo from '../assets/emi-logo.png';
import './Header.css';

const Header = () => (
  <header className="header">
    <img src={logo} alt="EMI Logo" className="header-logo" />
    <h1 className="header-title">EMI ERP Dashboard</h1>
  </header>
);

export default Header;
