package com.example.dsa_web_restservice.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "book_insights_view") // This must match the View name saved in Spark/Hive!
public class BookInsight {

    @Id
    @Column(name = "book_title")
    private String bookTitle;

    @Column(name = "pages")
    private Integer pages;

    @Column(name = "format")
    private String format;

    @Column(name = "social_rating")
    private Float socialRating;

    @Column(name = "total_reviews")
    private Integer totalReviews;

    // Standard Getters and Setters (or use Lombok @Data if you added it!)
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public Integer getPages() { return pages; }
    public void setPages(Integer pages) { this.pages = pages; }

    public String getFormat() { return format; }
    public void setFormat(String format) { this.format = format; }

    public Float getSocialRating() { return socialRating; }
    public void setSocialRating(Float socialRating) { this.socialRating = socialRating; }

    public Integer getTotalReviews() { return totalReviews; }
    public void setTotalReviews(Integer totalReviews) { this.totalReviews = totalReviews; }
}