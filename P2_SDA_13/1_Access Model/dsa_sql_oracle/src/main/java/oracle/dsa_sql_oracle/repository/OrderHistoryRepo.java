package oracle.dsa_sql_oracle.repository;

import oracle.dsa_sql_oracle.model.OrderHistory;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderHistoryRepo extends JpaRepository<OrderHistory,Long> {
}
