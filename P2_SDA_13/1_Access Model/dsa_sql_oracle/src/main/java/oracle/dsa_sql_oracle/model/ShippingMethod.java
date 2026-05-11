package oracle.dsa_sql_oracle.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "SHIPPING_METHOD")
public class ShippingMethod {

    @Id
    @Column(name = "METHOD_ID")
    private Integer methodId;

    @Column(name = "METHOD_NAME")
    private String methodName;

    @Column(name = "COST")
    private Double cost;
}
