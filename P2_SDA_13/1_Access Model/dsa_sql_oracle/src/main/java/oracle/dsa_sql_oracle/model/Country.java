package oracle.dsa_sql_oracle.model;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "COUNTRY")
@Data
public class Country {
        @Id
        @Column(name = "COUNTRY_ID")
        private Integer countryId;

        @Column(name = "COUNTRY_NAME")
        private String countryName;
}
