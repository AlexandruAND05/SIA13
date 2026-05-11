package oracle.dsa_sql_oracle.repository;

import oracle.dsa_sql_oracle.model.ShippingMethod;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ShippingMethodRepo extends JpaRepository<ShippingMethod, Long> {
}
