package oracle.dsa_sql_oracle.model;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "BOOK_AUTHOR")
@Data
public class BookAuthor {
    @Id
    @Column(name = "BOOK_ID")
    private String bookId;

    @Column(name = "AUTHOR_ID")
    private Integer authorId;

}
