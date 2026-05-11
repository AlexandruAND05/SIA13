package com.example.dsa_sparksql_service.controller;

import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Encoders;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;

@RestController
public class SparkTestController {

    @Autowired
    private SparkSession spark;

    @GetMapping("/test-spark")
    public String testSparkConnection() {
        try {
            System.out.println("1. Reaching out to MongoDB Microservice...");
            String mongoApiUrl = "http://localhost:8083/api/mongo/books";

            // Use Spring's RestTemplate to download the JSON text
            RestTemplate restTemplate = new RestTemplate();
            String rawJson = restTemplate.getForObject(mongoApiUrl, String.class);

            if (rawJson == null || rawJson.isEmpty() || rawJson.equals("[]")) {
                return "Error:Error from MongoDB!!!";
            }

            System.out.println("2. Handing JSON over to Spark...");
            // Wrap the raw Java String into a Spark Dataset
            Dataset<String> jsonDataset = spark.createDataset(
                    Collections.singletonList(rawJson),
                    Encoders.STRING()
            );

            // Tell Spark to parse the JSON structure
            Dataset<Row> df = spark.read().json(jsonDataset);

            System.out.println("=== SPARK DATAFRAME SCHEMA ===");
            // This will print the tree structure to your IntelliJ Console!
            df.printSchema();

            // This will print the actual data table to your IntelliJ Console!
            df.show(5);

            return "SUCCESS! Spark loaded " + df.count() + " books. Check IntelliJ console for the Data Table!";

        } catch (Exception e) {
            e.printStackTrace();
            return "Spark failed: " + e.getMessage();
        }
    }
}