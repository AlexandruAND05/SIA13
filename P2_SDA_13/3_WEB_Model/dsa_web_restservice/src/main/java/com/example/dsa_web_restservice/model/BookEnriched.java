package com.example.dsa_web_restservice.model;

import jakarta.persistence.*;

import org.hibernate.annotations.Immutable;
@Entity
@Immutable
@Table(name = "v_books_enriched")
public class BookEnriched {
    @Id
    @Column(name = "book_id")
    private Long bookId;

    @Column(name = "book_title")
    private String bookTitle;

    @Column(name = "series_name")
    private String seriesName;

    @Column(name = "series_works_count")
    private Integer seriesWorksCount;

    @Column(name = "series_description")
    private String seriesDescription;

    public Long getBookId() {
        return bookId;
    }

    public void setBookId(Long bookId) {
        this.bookId = bookId;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getSeriesName() {
        return seriesName;
    }

    public void setSeriesName(String seriesName) {
        this.seriesName = seriesName;
    }

    public Integer getSeriesWorksCount() {
        return seriesWorksCount;
    }

    public void setSeriesWorksCount(Integer seriesWorksCount) {
        this.seriesWorksCount = seriesWorksCount;
    }

    public String getSeriesDescription() {
        return seriesDescription;
    }

    public void setSeriesDescription(String seriesDescription) {
        this.seriesDescription = seriesDescription;
    }
}