package oracle.dsa_sql_oracle.repository;

import oracle.dsa_sql_oracle.model.Customer;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomerRepo  extends JpaRepository<Customer,Long> {
}
