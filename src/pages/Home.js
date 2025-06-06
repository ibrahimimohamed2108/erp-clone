import React from 'react';
import DashboardCard from '../components/DashboardCard';
import './Home.css';

const Home = () => (
  <main className="home">
    <h2>Welcome to EMI ERP</h2>
    <div className="dashboard-grid">
      <DashboardCard title="Students" description="Manage student records, enrollments, and profiles." />
      <DashboardCard title="Professors" description="Handle professor data and schedules." />
      <DashboardCard title="Courses" description="Control course offerings and materials." />
      <DashboardCard title="Finance" description="Track tuition, budgeting, and expenses." />
      <DashboardCard title="webhooktest0" description="Configure system settings and preferences." />
    </div>
  </main>
);

export default Home;
