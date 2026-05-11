package oracle.dsa_sql_oracle.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "ADDRESS_STATUS")
@Data
public class Address_Status {

    @Id
    @Column(name = "STATUS_ID")
    public  Integer statusId;

    @Column(name = "ADDRESS_STATUS")
    public  String  addressStatus;
}
