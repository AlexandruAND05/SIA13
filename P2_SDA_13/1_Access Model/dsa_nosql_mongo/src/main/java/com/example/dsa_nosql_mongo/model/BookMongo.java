package com.example.dsa_nosql_mongo.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.List;

@Data
@Document(collection = "goodreadsbooks")
public class BookMongo {

    @Id
    private String id;

    private String isbn;
    private String text_reviews_count;
    private String country_code;
    private String average_rating;
    private String format;
    private String link;

    private List<Shelf> popular_shelves;
    private List<AuthorDetail> authors;
}