import React from 'react';
import { Link } from 'react-router-dom';
import './Navbar.css';

const Navbar = () => {
    return (
        <nav className="navbar">
            <div className="navbar-brand">Dashboard Cărți</div>
            <ul className="navbar-links">
                <li>
                    <Link to="/"> Dashboard Cărți</Link>
                </li>
                <li>
                    {/* Analiza inițială: Oracle + Postgres (Swap) */}
                    <Link to="/authors"> Performanță Socială</Link>
                </li>
                <li>
                    <Link to="/publishers">Distribuție Edituri</Link>
                </li>
                <li>
                    <Link to="/hierarchy"> Ierarhie Cărți</Link>    
                </li>
                <li>
                    {/* Noua analiză complexă: Oracle OLAP (Market Share) */}
                    <Link to="/market-share"> Market Share</Link>
                </li>
            </ul>
        </nav>
    );
};

export default Navbar;