package oracle.dsa_sql_oracle.controller;

import oracle.dsa_sql_oracle.model.*;
import oracle.dsa_sql_oracle.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/oracle")
public class OracleDataController {

    @Autowired
    private BookRepository bookRepo;

    @Autowired
    private AuthorRepository authorRepo;

    @Autowired
    private OrderLineRepository orderLineRepo;

    @Autowired
    private Adress_StatusRepository addressStatus;

    @Autowired
    private  AdressRepository address;

    @Autowired
    private Book_AuthorRepository book_author;

    @Autowired
    private  BookLanguageRepo bookLanguage;

    @Autowired
    private  CountryRepo country;

    @Autowired
    private CustOrderRepo custOrderRepo;

    @Autowired
    private CustomerRepo customerRepo;

    @Autowired
    private CustomerAddressRepo customerAddressRepo;

    @Autowired
    private OrderHistoryRepo orderHistoryRepo;

    @Autowired
    private OrderStatusRepo orderStatusRepo;

    @Autowired
    private  PublisherRepo publisherRepo;

    @Autowired
    private  ShippingMethodRepo shippingMethodRepo;

    @GetMapping("/books")
    public List<Book> getAllBooks() {
        return bookRepo.findAll();
    }

    @GetMapping("/authors")
    public List<Author> getAllAuthors() {
        return authorRepo.findAll();
    }

    @GetMapping("/sales")
    public List<OrderLine> getAllSales() {
        return orderLineRepo.findAll();
    }

    @GetMapping("/address")
    public List<Address> getAllAddress() {
        return address.findAll();
    }

    @GetMapping("/adress_status")
    public List<Address_Status> getAllAdressStatus() {
        return addressStatus.findAll();
    }

    @GetMapping("/book_author")
    public List<BookAuthor> getAllBookAuthor() {
        return book_author.findAll();
    }

    @GetMapping("/book_language")
    public List<BookLanguage> getAllBookLanguage() {return bookLanguage.findAll();
    }

    @GetMapping("/country")
    public List<Country> getAllCountries() {return country.findAll();
    }

    @GetMapping("/customer_orders")
    public List<CustOrder> getAllCustOrders() {return custOrderRepo.findAll();
    }

    @GetMapping("/customeraddress")
    public List<CustomerAddress> getAllCustomersAddresses() {return customerAddressRepo.findAll();
    }

    @GetMapping("/customer")
    public List<Customer> getAllCustomers() {return customerRepo.findAll();
    }

    @GetMapping("/order_history")
    public List<OrderHistory> getAllOrderHistory() {return orderHistoryRepo.findAll();
    }

    @GetMapping("/order_status")
    public List<OrderStatus> getallOrderStatus() {return orderStatusRepo.findAll();
    }

    @GetMapping("/publishers")
    public List<Publisher> getAllPublishers() {return publisherRepo.findAll();
    }

    @GetMapping("/shippinh_methods")
    public List<ShippingMethod> getAllShippingMetods() {return shippingMethodRepo.findAll();
    }
}