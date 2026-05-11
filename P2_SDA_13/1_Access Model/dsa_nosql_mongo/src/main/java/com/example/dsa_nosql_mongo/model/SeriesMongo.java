package com.example.dsa_nosql_mongo.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "series")
public class SeriesMongo {

    @Id
    private String id;

    private String numbered;
    private String note;
    private String description;
    private String title;
    private String series_works_count;
    private String series_id;
    private String primary_work_count;
}