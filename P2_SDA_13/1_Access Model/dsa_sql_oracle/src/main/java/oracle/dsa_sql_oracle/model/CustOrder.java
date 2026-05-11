package oracle.dsa_sql_oracle.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table( name = "CUST_ORDER")
@Data
public class CustOrder {

    @Id
    @Column(name = "ORDER_ID")
    private Integer orderId;

    @Column(name = "ORDER_DATE")
    private String orderDate;

    @Column(name = "CUSTOMER_ID")
    private Integer customerId;

    @Column(name = "SHIPPING_METHOD_ID")
    private Integer shippingMethodId;

    @Column(name = "DEST_ADDRESS_ID")
    private Integer destAddressId;
}
