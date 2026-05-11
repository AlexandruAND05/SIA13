package com.example.dsa_web_restservice.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.Immutable;

@Entity
@Immutable
@Table(name = "olap_top_10_authors_by_country")
public class AuthorRanking {
    @Id
    @Column(name = "author_name") // Folosim numele ca ID
    private String authorName;

    @Column(name = "country_name")
    private String countryName;

    @Column(name = "total_revenue")
    private Double totalRevenue;

    @Column(name = "country_market_share")
    private Double marketShare;

    @Column(name = "author_rank")
    private Integer rank;

    public String getAuthorName() {
        return authorName;
    }

    public String getCountryName() {
        return countryName;
    }

    public Double getTotalRevenue() {
        return totalRevenue;
    }

    public Double getMarketShare() {
        return marketShare;
    }

    public Integer getRank() {
        return rank;
    }

    // Getters...
}