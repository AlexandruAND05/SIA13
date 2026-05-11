package com.example.dsa_nosql_mongo.controller;


import com.example.dsa_nosql_mongo.model.BookMongo;
import com.example.dsa_nosql_mongo.model.ReviewSpoilerMongo;
import com.example.dsa_nosql_mongo.model.SeriesMongo;
import com.example.dsa_nosql_mongo.repository.BookMongoRepository;
import com.example.dsa_nosql_mongo.repository.ReviewSpoilerRepository;
import com.example.dsa_nosql_mongo.repository.SeriesMongoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/mongo")
public class MongoDataController {

    @Autowired
    private BookMongoRepository Booksrepository;

    @Autowired
    private SeriesMongoRepository seriesRepository;

    @Autowired
    private ReviewSpoilerRepository spoilerRepository;


    @GetMapping("/books")
    public List<BookMongo> getAllMongoBooks() {
        return Booksrepository.findAll(PageRequest.of(0, 10000)).getContent();    }

    @GetMapping("/series")
    public List<SeriesMongo> getAllMongoSeries() {
        // Fetching the first 100 series
        return seriesRepository.findAll(PageRequest.of(0, 10000)).getContent();
    }
    @GetMapping("/spoilers")
    public List<ReviewSpoilerMongo> getAllMongoSpoilers() {
        return spoilerRepository.findAll(PageRequest.of(0, 10000)).getContent();
    }

}