package oracle.dsa_sql_oracle.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;

@Entity
@Table(name = "BOOK")
@Data
public class Book {
    @Id
    @Column(name = "BOOK_ID")
    private Long bookId;

    @Column(name = "TITLE")
    private String title;

    @Column(name = "ISBN13")
    private String isbn13;

    @Column(name = "NUM_PAGES")
    private Integer numPages;

    @Column(name = "PUBLICATION_DATE")
    private LocalDate publicationDate;

    @Column(name = "LANGUAGE_ID")
    private Integer languageId;

    @Column(name = "PUBLISHER_ID")
    private Integer publisherId;
}