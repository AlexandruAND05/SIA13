package com.example.dsa_nosql_mongo.config; // Create a config package

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoClientDatabaseFactory;

@Configuration
public class MongoConfig {

    @Bean
    public MongoTemplate mongoTemplate() {
        // Force to use BOOKS_JSON DATABASE
        return new MongoTemplate(new SimpleMongoClientDatabaseFactory("mongodb://localhost:27017/Books_JSON"));
    }
}