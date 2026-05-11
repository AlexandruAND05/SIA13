import React, { useState, useEffect } from 'react';
import './AuthorPerformance.css';

const AuthorPerformance = () => {
    const [performances, setPerformances] = useState([]);
    const [loading, setLoading] = useState(true);

    // Endpoint-ul de pe portul 8085 creat pentru acest view
    const API_URL = 'http://localhost:8085/api/web/authors/performance';

    useEffect(() => {
        fetch(API_URL)
            .then(res => res.json())
            .then(data => {
                setPerformances(data);
                setLoading(false);
            })
            .catch(err => console.error("Eroare la preluarea datelor OLAP:", err));
    }, []);

    return (
        <div className="perf-container">
            <div className="perf-header">
                <h2>Analiză Performanță Autori (Federated OLAP)</h2>
                <p>Date combinate din Oracle (Vânzări) și Postgres (Swap Market)</p>
            </div>

            <div className="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Nume Autor</th>
                            <th>Cărți în Inventar</th>
                            <th>Venit Total Generat</th>
                            <th>Popularitate Swap</th>
                        </tr>
                    </thead>
                    <tbody>
                        {loading ? (
                            <tr><td colSpan="4">Se calculează statisticile în Spark...</td></tr>
                        ) : (
                            performances.map((perf, index) => (
                                <tr key={index}>
                                    <td>{perf.authorName}</td>
                                    <td>{perf.localBookCount}</td>
                                    <td className="revenue">
                                        {/* Formatăm prețul frumos */}
                                        {new Intl.NumberFormat('ro-RO', { style: 'currency', currency: 'EUR' }).format(perf.totalRevenueGenerated)}
                                    </td>
                                    <td>
                                        <span className={`badge ${perf.isSwappedRegularly === 'YES' ? 'swapped' : 'not-swapped'}`}>
                                            {perf.isSwappedRegularly === 'YES' ? ' Activ pe Swap' : 'Pasiv'}
                                        </span>
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            </div>
        </div>
    );
};

export default AuthorPerformance;