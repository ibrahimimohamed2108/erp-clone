import React from 'react';
import './Sidebar.css';

const Sidebar = () => (
  <aside className="sidebar">
    <nav>
      <ul>
        <li><button disabled>Dashboard</button></li>
        <li><button disabled>Students</button></li>
        <li><button disabled>Professors</button></li>
        <li><button disabled>Courses</button></li>
        <li><button disabled>Finance</button></li>
        <li><button disabled>Settings</button></li>
      </ul>
    </nav>
  </aside>
);

export default Sidebar;
