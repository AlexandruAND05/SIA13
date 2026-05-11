package oracle.dsa_sql_oracle.repository;

import oracle.dsa_sql_oracle.model.CustomerAddress;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomerAddressRepo extends JpaRepository<CustomerAddress,Long> {
}
