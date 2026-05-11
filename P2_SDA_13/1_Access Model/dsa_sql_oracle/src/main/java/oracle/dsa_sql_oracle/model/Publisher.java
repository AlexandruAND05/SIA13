package oracle.dsa_sql_oracle.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "PUBLISHER")

public class Publisher {

    @Id
    @Column(name = "PUBLISHER_ID")
    private Integer publisherId;

    @Column(name = "PUBLISHER_NAME")
    private String publisherName;
}

