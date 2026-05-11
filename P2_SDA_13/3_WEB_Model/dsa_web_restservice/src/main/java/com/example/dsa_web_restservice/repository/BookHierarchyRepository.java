package com.example.dsa_web_restservice.repository;
import com.example.dsa_web_restservice.model.BookHierarchy;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public interface BookHierarchyRepository  extends  JpaRepository<BookHierarchy,Long> {



    @Override
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    List<BookHierarchy> findAll();
}
