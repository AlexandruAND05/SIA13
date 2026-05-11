package com.example.dsa_nosql_mongo.controller; // or whatever your package is

import org.springframework.boot.CommandLineRunner;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Component;

@Component
public class MongoDebugger implements CommandLineRunner {

    private final MongoTemplate mongoTemplate;

    public MongoDebugger(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println("\n===== MONGO X-RAY DEBUGGER =====");
        System.out.println("1. Connected Database: " + mongoTemplate.getDb().getName());

        System.out.println("2. Collections found here:");
        for (String name : mongoTemplate.getCollectionNames()) {
            System.out.println("   - " + name);
        }

        long count = mongoTemplate.getCollection("goodreadsbooks").countDocuments();
        System.out.println("3. Documents inside 'goodreadsbooks': " + count);
        System.out.println("================================\n");
    }
}