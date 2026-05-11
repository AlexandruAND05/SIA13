package com.example.dsa_web_restservice.repository;

import com.example.dsa_web_restservice.model.AuthorPerformance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional(propagation = Propagation.NOT_SUPPORTED) // Dezactivăm tranzacțiile pentru Hive
public interface AuthorPerformanceRepository extends JpaRepository<AuthorPerformance, String> {

    // Suprascriem findAll() ca să nu încerce să facă "commit" pe Spark
    @Override
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    List<AuthorPerformance> findAll();
}