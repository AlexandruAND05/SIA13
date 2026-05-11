package com.example.dsa_web_restservice.controller;

import com.example.dsa_web_restservice.model.AuthorPerformance;
import com.example.dsa_web_restservice.repository.AuthorPerformanceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/web/authors")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001"}) // Permite ambele porturi React
public class AuthorPerformanceController {

    @Autowired
    private AuthorPerformanceRepository repository;

    @GetMapping("/performance")
    public List<AuthorPerformance> getAuthorPerformance() {
        return repository.findAll();
    }
}