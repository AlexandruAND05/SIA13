package oracle.dsa_sql_oracle.repository;

import oracle.dsa_sql_oracle.model.Author;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AuthorRepository extends JpaRepository<Author, Long> {}
