package oracle.dsa_sql_oracle.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "BOOK_LANGUAGE")
@Data
public class BookLanguage {

    @Column(name = "LANGUAGE_ID")
    @Id
    private Integer languageId;

    @Column(name = "LANGUAGE_CODE")
    private String languageCode;

    @Column(name = "LANGUAGE_NAME")
    private String languageName;
}