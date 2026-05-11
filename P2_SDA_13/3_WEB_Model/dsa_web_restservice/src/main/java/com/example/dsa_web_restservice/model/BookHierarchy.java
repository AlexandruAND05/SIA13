package com.example.dsa_web_restservice.model;

import jakarta.persistence.*;

@Entity
@Table(name = "olap_book_hierarchy_perf")
public class BookHierarchy {

    @Id
    @Column(name = "bookTitle")
    private String bookTitle;

    @Column(name = "author")
    private String author;

    @Column(name = "bookCount")
    private Long bookCount;

    // Getters și Setters
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public Long getBookCount() { return bookCount; }
    public void setBookCount(Long bookCount) { this.bookCount = bookCount; }
}
