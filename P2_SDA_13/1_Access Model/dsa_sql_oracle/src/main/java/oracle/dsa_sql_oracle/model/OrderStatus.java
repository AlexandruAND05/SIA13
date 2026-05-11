package oracle.dsa_sql_oracle.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table (name = "ORDER_STATUS")
public class OrderStatus {
    @Id
    @Column(name = "STATUS_ID")
    private Integer StatusID;

    @Column(name = "STATUS_VALUE")
    private String StatusValue;
}
