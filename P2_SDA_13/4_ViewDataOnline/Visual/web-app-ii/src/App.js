import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Dashboard from './components/Dashboard'; // Primul dashboard (Book Insights)
import AuthorPerformance from './components/AuthorPerformance'; // 
import TopAuthors from './components/TopAuthors'; // Noua componentă pentru top autori
import BookHierarchy from './components/BookHierarchy.js';
import PublisherStats from './components/PublisherStats.js';


function App() {
  return (
    <Router>
      <div className="App">
        <Navbar />
        <div className="content-container">
          <Routes>
            {/* Pagina principală (Cărți) */}
            <Route path="/" element={<Dashboard />} />  
            {/* Pagina de performanță autori */}
            <Route path="/authors" element={<AuthorPerformance />} />           
            {/* Pagina de ierarhie cărți */}
            <Route path="/hierarchy" element={<BookHierarchy />} />
            {/* Pagina de market share (top autori) */}
            <Route path="/market-share" element={<TopAuthors />} />
            {/* Pagina de distribuție edituri */}
            <Route path="/publishers" element={<PublisherStats />} />
          
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;