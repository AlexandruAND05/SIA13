package oracle.dsa_sql_oracle.repository;

import oracle.dsa_sql_oracle.model.OrderStatus;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderStatusRepo  extends JpaRepository<OrderStatus,Long> {
}
