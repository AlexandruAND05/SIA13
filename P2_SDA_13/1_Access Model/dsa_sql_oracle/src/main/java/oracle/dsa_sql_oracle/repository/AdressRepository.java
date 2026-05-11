package oracle.dsa_sql_oracle.repository;

import oracle.dsa_sql_oracle.model.Address;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdressRepository  extends JpaRepository<Address, Long>
{
}
