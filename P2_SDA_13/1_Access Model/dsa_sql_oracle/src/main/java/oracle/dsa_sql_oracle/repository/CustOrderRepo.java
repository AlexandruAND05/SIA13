package oracle.dsa_sql_oracle.repository;

import oracle.dsa_sql_oracle.model.CustOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;

public interface CustOrderRepo extends JpaRepository<CustOrder, Integer> {
}
