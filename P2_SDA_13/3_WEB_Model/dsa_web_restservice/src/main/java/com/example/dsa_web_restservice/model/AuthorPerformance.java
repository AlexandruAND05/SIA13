package com.example.dsa_web_restservice.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "v_author_global_performance") // Numele exact al view-ului salvat în Spark
public class AuthorPerformance {

    @Id // Deși view-urile nu au Primary Key real, JPA cere unul. Folosim numele autorului.
    @Column(name = "author_name")
    private String authorName;

    @Column(name = "local_book_count")
    private Long localBookCount;

    @Column(name = "total_revenue_generated")
    private Double totalRevenueGenerated;

    @Column(name = "is_swapped_regularly")
    private String isSwappedRegularly;

    // --- Getters și Setters ---
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }

    public Long getLocalBookCount() { return localBookCount; }
    public void setLocalBookCount(Long localBookCount) { this.localBookCount = localBookCount; }

    public Double getTotalRevenueGenerated() { return totalRevenueGenerated; }
    public void setTotalRevenueGenerated(Double totalRevenueGenerated) { this.totalRevenueGenerated = totalRevenueGenerated; }

    public String getIsSwappedRegularly() { return isSwappedRegularly; }
    public void setIsSwappedRegularly(String isSwappedRegularly) { this.isSwappedRegularly = isSwappedRegularly; }
}