import React, { useState, useEffect } from 'react';
import './PublisherStats.css';

const PublisherStats = () => {
    const [stats, setStats] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetch('http://localhost:8085/api/web/insights/publishers/distribution')
            .then(res => res.json())
            .then(data => {
                setStats(data);
                setLoading(false);
            });
    }, []);

    if (loading) return <div className="loader">Încărcăm datele editurilor...</div>;

    const maxBooks = Math.max(...stats.map(s => s.numarCarti));

    return (
        <div className="pub-container">
            <h3>📈 Distribuție Titluri pe Edituri</h3>
            <div className="pub-list">
                {stats.map((pub, index) => (
                    <div key={index} className="pub-row">
                        <div className="pub-info">
                            <span className="pub-name">{pub.publisherName}</span>
                            <span className="pub-count">{pub.numarCarti} cărți</span>
                        </div>
                        <div className="pub-bar-bg">
                            <div 
                                className="pub-bar-fill" 
                                style={{ width: `${(pub.numarCarti / maxBooks) * 100}%` }}
                            ></div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default PublisherStats;