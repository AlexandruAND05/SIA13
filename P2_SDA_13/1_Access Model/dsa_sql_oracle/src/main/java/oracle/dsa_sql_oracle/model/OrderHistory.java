package oracle.dsa_sql_oracle.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "ORDER_HISTORY")
public class OrderHistory {

    @Id
    @Column(name = "HISTORY_ID")
    private Integer historyId;

    @Column(name = "ORDER_ID")
    private Integer orderId;

    @Column(name = "STATUS_ID")
    private Integer stausId;

    @Column(name = "STATUS_DATE")
    private String statusDate;
}
