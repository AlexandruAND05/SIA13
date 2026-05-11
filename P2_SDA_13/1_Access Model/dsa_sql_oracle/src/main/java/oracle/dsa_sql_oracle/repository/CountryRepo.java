package oracle.dsa_sql_oracle.repository;

import oracle.dsa_sql_oracle.model.Country;
import org.springframework.data.jpa.repository.JpaRepository;

import javax.security.auth.callback.LanguageCallback;

public interface CountryRepo extends JpaRepository<Country, Long> {
}
