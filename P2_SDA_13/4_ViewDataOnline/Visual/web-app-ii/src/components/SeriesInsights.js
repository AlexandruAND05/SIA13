import React, { useState, useEffect } from 'react';

const SeriesInsights = () => {
    const [books, setBooks] = useState([]);

    useEffect(() => {
        fetch('http://localhost:8085/api/web/insights/books/enriched')
            .then(res => res.json())
            .then(data => setBooks(data));
    }, []);

    return (
        <div style={{ padding: '20px' }}>
            <h2>Colecții și Serii de Cărți</h2>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px' }}>
                {books.map((b, i) => (
                    <div key={i} style={{ border: '1px solid #ccc', padding: '15px', borderRadius: '8px', background: 'white' }}>
                        <h3>{b.bookTitle}</h3>
                        <p><strong>Parte din seria:</strong> {b.seriesName} ({b.seriesWorksCount} volume)</p>
                        <p style={{ fontSize: '0.9rem', color: '#666' }}>{b.seriesDescription}</p>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default SeriesInsights;