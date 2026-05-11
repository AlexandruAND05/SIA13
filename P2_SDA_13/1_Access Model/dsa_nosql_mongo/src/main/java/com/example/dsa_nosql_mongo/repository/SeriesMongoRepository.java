package com.example.dsa_nosql_mongo.repository;

import com.example.dsa_nosql_mongo.model.SeriesMongo;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SeriesMongoRepository extends MongoRepository<SeriesMongo, String> {
}