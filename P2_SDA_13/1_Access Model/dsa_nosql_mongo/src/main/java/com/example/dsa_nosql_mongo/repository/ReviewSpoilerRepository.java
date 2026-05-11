package com.example.dsa_nosql_mongo.repository;

import com.example.dsa_nosql_mongo.model.ReviewSpoilerMongo;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReviewSpoilerRepository extends MongoRepository<ReviewSpoilerMongo, String> {
}