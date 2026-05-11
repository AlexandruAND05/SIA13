package com.example.dsa_web_restservice.repository;

import com.example.dsa_web_restservice.model.BookEnriched;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public interface BookEnrichedRepository extends JpaRepository<BookEnriched, Long> {
    @Override
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    List<BookEnriched> findAll();
}
