package oracle.dsa_sql_oracle.model;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "ADDRESS")
@Data
public class Address {
    @Id
    @Column(name = "ADDRESS_ID")
    public  Integer AddressId;

    @Column(name = "STREET_NUMBER")
    private Integer streetNumber;

    @Column(name = "STREET_NAME")
    private String streetName;

    @Column(name = "CITY")
    private String city;

    @Column(name = "COUNTRY_ID")
    private Integer countryID;

}
