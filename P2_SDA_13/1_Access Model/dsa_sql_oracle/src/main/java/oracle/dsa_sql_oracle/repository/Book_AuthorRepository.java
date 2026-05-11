package oracle.dsa_sql_oracle.repository;
import oracle.dsa_sql_oracle.model.BookAuthor;

import org.springframework.data.jpa.repository.JpaRepository;

public interface Book_AuthorRepository  extends JpaRepository<BookAuthor, Long> {
}
