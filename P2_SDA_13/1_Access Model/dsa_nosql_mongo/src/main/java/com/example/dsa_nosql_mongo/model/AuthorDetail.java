package com.example.dsa_nosql_mongo.model;

import lombok.Data;

@Data
public class AuthorDetail {
    private String book_id;
    private String title;
    private String publisher;
    private String num_pages;
    private String publication_year;
    private String isbn13;
    private String image_url;
}