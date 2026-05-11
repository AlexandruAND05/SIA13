import React, { useState, useEffect } from 'react';
import './BookHierarchy.css';

const BookHierarchy = () => {
    const [data, setData] = useState([]);

    useEffect(() => {
        fetch('http://localhost:8085/api/web/insights/book/hierarchy')
            .then(res => res.json())
            .then(json => setData(json));
    }, []);

    const renderRow = (row, index) => {
        // Identificăm tipul de rând pentru stilizare
        const isTotalGeneral = row.author === '{TOTAL GENERAL}';
        const isSubtotal = row.bookTitle.startsWith('Subtotal:');

        return (
            <tr key={index} className={isTotalGeneral ? 'row-total' : isSubtotal ? 'row-subtotal' : 'row-normal'}>
                <td>{isTotalGeneral ? '---' : row.author}</td>
                <td className="title-cell">{row.bookTitle}</td>
                <td>{row.bookCount}</td>
            </tr>
        );
    };

    return (
        <div className="hierarchy-container">
            <h2>📊 Ierarhie Inventar: Autori și Cărți</h2>
            <table className="hierarchy-table">
                <thead>
                    <tr>
                        <th>Autor</th>
                        <th>Titlu / Nivel Ierarhic</th>
                        <th>Nr. Cărți</th>
                    </tr>
                </thead>
                <tbody>{data.map((row, i) => renderRow(row, i))}</tbody>
            </table>
        </div>
    );
};

export default BookHierarchy;