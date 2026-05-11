package com.example.dsa_nosql_mongo.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "goodreads_reviews_spoiler")
public class ReviewSpoilerMongo {

    @Id
    private String id;

    private String user_id;
    private String timestamp;
    private String book_id;
    private String review_id;

    private Integer rating;
    private Boolean has_spoiler;


}