import React from 'react';
import './DashboardCard.css';

const DashboardCard = ({ title, description }) => (
  <div className="dashboard-card">
    <h3>{title}</h3>
    <p>{description}</p>
  </div>
);

export default DashboardCard;
