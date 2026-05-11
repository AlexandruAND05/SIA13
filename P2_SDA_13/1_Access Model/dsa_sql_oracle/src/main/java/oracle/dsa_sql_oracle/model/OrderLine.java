package oracle.dsa_sql_oracle.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "ORDER_LINE")
@Data
public class OrderLine {
    @Id
    @Column(name = "LINE_ID")
    private Long lineId;

    @Column(name = "ORDER_ID")
    private Long orderId;

    @Column(name = "BOOK_ID")
    private Long bookId;

    @Column(name = "PRICE")
    private Double price;
}