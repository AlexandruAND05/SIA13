package com.example.dsa_nosql_mongo.repository;

import com.example.dsa_nosql_mongo.model.BookMongo;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface BookMongoRepository extends MongoRepository<BookMongo, String> {
}
