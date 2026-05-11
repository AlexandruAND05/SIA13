package oracle.dsa_sql_oracle.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "AUTHOR")
@Data
public class Author {
    @Id
    @Column(name = "AUTHOR_ID")
    private Long authorId;

    @Column(name = "AUTHOR_NAME")
    private String authorName;
}