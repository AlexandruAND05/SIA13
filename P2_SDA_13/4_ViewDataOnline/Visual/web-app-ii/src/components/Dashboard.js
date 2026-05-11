import React, { useState, useEffect } from 'react';
import './Dashboard.css'; // Vom pune stilurile aici

const Dashboard = () => {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [status, setStatus] = useState({ text: 'Se conectează...', color: '#7f8c8d' });

    const API_URL = 'http://localhost:8085/api/web/insights/all';

    useEffect(() => {
        const fetchAnalyticsData = async () => {
            try {
                const response = await fetch(API_URL);
                if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
                
                const result = await response.json();
                setData(result);
                setStatus({ text: 'CONECTAT (Live)', color: '#2ecc71' });
            } catch (err) {
                console.error("Eroare API:", err);
                setError('Asigură-te că microserviciul (8085) este pornit și regula CORS este activă.');
                setStatus({ text: 'OFFLINE', color: '#e74c3c' });
            } finally {
                setLoading(false);
            }
        };

        fetchAnalyticsData();
    }, []);

    return (
        <div className="dashboard-container">
            {/* Header */}
            <div className="header">
                <h1>J4DI Analytics Engine</h1>
                <div className="status-badge" style={{ backgroundColor: status.color }}>
                    {status.text}
                </div>
            </div>

            {/* Mesaj de Eroare */}
            {error && <div className="error-msg">{error}</div>}

            {/* Stats Cards */}
            <div className="stats-container">
                <div className="stat-card">
                    <h3>Total Cărți Procesate</h3>
                    <div className="value">{data.length}</div>
                </div>
                <div className="stat-card"><h3>Sursă Structurată</h3><div className="value">Oracle DB</div></div>
                <div className="stat-card"><h3>Sursă Socială</h3><div className="value">MongoDB</div></div>
                <div className="stat-card"><h3>Motor Procesare</h3><div className="value">Spark SQL</div></div>
            </div>

            {/* Table */}
            <div className="table-container">
                <h2>Rezultat Join Federat</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Titlu Carte</th>
                            <th>Pagini</th>
                            <th>Format</th>
                            <th>Rating Social</th>
                            <th>Total Review-uri</th>
                        </tr>
                    </thead>
                    <tbody>
                        {loading ? (
                            <tr><td colSpan="5" style={{ textAlign: 'center' }}>Se descarcă datele...</td></tr>
                        ) : data.length > 0 ? (
                            data.slice(0, 50).map((book, index) => (
                                <tr key={index}>
                                    <td><strong>{book.bookTitle}</strong></td>
                                    <td>{book.pages || 0}</td>
                                    <td>{book.format || <span className="null-value">N/A</span>}</td>
                                    <td>{book.socialRating || <span className="null-value">Lipsă date Mongo</span>}</td>
                                    <td>{book.totalReviews || <span className="null-value">0</span>}</td>
                                </tr>
                            ))
                        ) : (
                            <tr><td colSpan="5" style={{ textAlign: 'center' }}>Nu există date disponibile.</td></tr>
                        )}
                    </tbody>
                </table>
            </div>
        </div>
    );
};

export default Dashboard;