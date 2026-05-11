package com.example.dsa_web_restservice.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "olap_publisher_distribution")
public class PublisherDistribution {
    @Id
    @Column(name = "publisherName")
    private String publisherName;

    @Column(name = "numarCarti")
    private Long numarCarti;

    public String getPublisherName() {
        return publisherName;
    }

    public void setPublisherName(String publisherName) {
        this.publisherName = publisherName;
    }

    public Long getNumarCarti() {
        return numarCarti;
    }

    public void setNumarCarti(Long numarCarti) {
        this.numarCarti = numarCarti;
    }

    // Getters și Setters
}