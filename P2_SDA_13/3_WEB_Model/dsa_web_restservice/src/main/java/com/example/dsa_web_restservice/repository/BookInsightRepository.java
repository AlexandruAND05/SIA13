package com.example.dsa_web_restservice.repository;

import com.example.dsa_web_restservice.model.BookInsight;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public interface BookInsightRepository extends JpaRepository<BookInsight, String> {

    // Spring JPA magic: Automatically generates a query to find highly rated books!
    List<BookInsight> findBySocialRatingGreaterThan(Float rating);

    @Override
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    List<BookInsight> findAll();
}