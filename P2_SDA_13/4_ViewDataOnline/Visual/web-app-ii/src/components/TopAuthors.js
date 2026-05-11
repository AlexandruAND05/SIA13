import React, { useState, useEffect } from 'react';
import './TopAuthors.css';

const TopAuthors = () => {
    const [rankings, setRankings] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    const API_URL = 'http://localhost:8085/api/web/insights/authors/rank';

    useEffect(() => {
        fetch(API_URL)
            .then(res => {
                if (!res.ok) throw new Error(`Eroare server: ${res.status}`);
                return res.json();
            })
            .then(data => {
                setRankings(data);
                setLoading(false);
            })
            .catch(err => {
                setError(err.message);
                setLoading(false);
            });
    }, []);

    // Grupăm datele după țară (JSON-ul vine ca o listă lungă)
    const groupedByCountry = rankings.reduce((acc, curr) => {
        if (!acc[curr.countryName]) acc[curr.countryName] = [];
        acc[curr.countryName].push(curr);
        return acc;
    }, {});

    if (loading) return <div className="status">Se încarcă datele analitice din Spark...</div>;
    if (error) return <div className="status-error">⚠️ {error}</div>;

    return (
        <div className="market-share-container">
            <h1 className="main-title">Analiză Market Share Autori</h1>
            <p className="subtitle">Top 10 autori per țară (calculat în timp real prin Spark SQL)</p>

            {Object.keys(groupedByCountry).map(country => (
                <section key={country} className="country-block">
                    <h2 className="country-header">🌍 {country}</h2>
                    <table className="analysis-table">
                        <thead>
                            <tr>
                                <th style={{ width: '10%' }}>Loc</th>
                                <th style={{ width: '40%' }}>Autor</th>
                                <th style={{ width: '20%' }}>Venit Total</th>
                                <th style={{ width: '30%' }}>Cota de Piață</th>
                            </tr>
                        </thead>
                        <tbody>
                            {groupedByCountry[country].map((author, index) => (
                                <tr key={author.authorName + index}>
                                    <td className="rank-cell">#{author.rank}</td>
                                    <td className="author-cell"><strong>{author.authorName}</strong></td>
                                    <td className="revenue-cell">
                                        {new Intl.NumberFormat('ro-RO', { style: 'currency', currency: 'EUR' }).format(author.totalRevenue)}
                                    </td>
                                    <td>
                                        <div className="share-bar-wrapper">
                                            <div 
                                                className="share-bar-fill" 
                                                style={{ width: `${author.marketShare}%` }}
                                            ></div>
                                            <span className="share-label">{author.marketShare}%</span>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </section>
            ))}
        </div>
    );
};

export default TopAuthors;