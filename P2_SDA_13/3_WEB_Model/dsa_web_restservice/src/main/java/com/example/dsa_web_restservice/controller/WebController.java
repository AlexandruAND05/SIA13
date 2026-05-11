package com.example.dsa_web_restservice.controller;

import com.example.dsa_web_restservice.model.*;
import com.example.dsa_web_restservice.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/web/insights")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001"}) // Permite ambele porturi React
public class WebController {

    @Autowired
    private BookInsightRepository insightRepository;

    @Autowired
    private BookEnrichedRepository enrichedRepository;

    @Autowired
    private AuthorRankingRepository authorRankingRepository;

    @Autowired
    private BookHierarchyRepository bookHierarchyRepository;

    @Autowired
    private PublisherDistributionRepository pdfRepository;

    // Endpoint 1: Get all analytics
    @GetMapping("/all")
    public List<BookInsight> getAllInsights() {
        return insightRepository.findAll();
    }

    // Endpoint 2: Get top-rated books for your Dashboard UI
    @GetMapping("/top-rated")
    public List<BookInsight> getTopRatedBooks() {
        return insightRepository.findBySocialRatingGreaterThan(4.0f);
    }

    @GetMapping("/books/enriched")
    public List<BookEnriched> getEnrichedBooks() {
        return enrichedRepository.findAll();
    }
    @GetMapping("/authors/rank")
    public List<AuthorRanking> getAuthorRanking() {
        return authorRankingRepository.findAll();
    }

    @GetMapping("/book/hierarchy")
    public List<BookHierarchy> getBookHierarchy() {return  bookHierarchyRepository.findAll();}

    @GetMapping("/publishers/distribution")
    public List<PublisherDistribution> getPublishers() {return pdfRepository.findAll();}

}