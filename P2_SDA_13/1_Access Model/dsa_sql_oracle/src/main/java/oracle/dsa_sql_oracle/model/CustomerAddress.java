package oracle.dsa_sql_oracle.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "CUSTOMER_ADDRESS")
public class CustomerAddress {
    @Id
    @Column(name = "CUSTOMER_ID")
    private  Integer CustomerID;

    @Column(name= "ADDRESS_ID")
    private  Integer AddressID;

    @Column(name = "STATUS_ID")
    private  Integer StatusID;
}
