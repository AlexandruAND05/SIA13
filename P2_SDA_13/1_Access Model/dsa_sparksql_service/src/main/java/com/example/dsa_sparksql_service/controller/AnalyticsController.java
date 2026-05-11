package com.example.dsa_sparksql_service.controller;

import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Encoders;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class AnalyticsController {

    //PREPARING THE SPARK SEESION
    @Autowired
    private SparkSession spark;

    //HERE STARST THE QUERRYS

    @GetMapping("/api/analytics/book-insights")
    public String getBookInsights() {
        try {
            RestTemplate restTemplate = new RestTemplate();

            System.out.println("Fetching Oracle Data...");
            String oracleUrl = "http://localhost:8082/api/oracle/books";
            String oracleJson = restTemplate.getForObject(oracleUrl, String.class);

            Dataset<Row> oracleDf = spark.read().json(
                    spark.createDataset(Collections.singletonList(oracleJson), Encoders.STRING())
            );
            // Register as a temporary SQL table
            oracleDf.createOrReplaceTempView("oracle_books");

            //Mongo
            System.out.println("Fetching MongoDB Data...");
            String mongoUrl = "http://localhost:8083/api/mongo/books";
            String mongoJson = restTemplate.getForObject(mongoUrl, String.class);

            Dataset<Row> mongoDf = spark.read().json(
                    spark.createDataset(Collections.singletonList(mongoJson), Encoders.STRING())
            );
            // Register as a temporary SQL table
            mongoDf.createOrReplaceTempView("mongo_books");

            // ==========================================
            // 3. (SPARK SQL)
            // ==========================================
            System.out.println("Executing Federated Spark SQL Query...");

                //Books after the number of pages and the social rating (present in )
            String sql = "SELECT " +
                    "  o.title AS Book_Title, " +
                    "  o.numPages AS Pages, " +
                    "  m.format AS Format, " +
                    "  CAST(m.average_rating AS FLOAT) AS Social_Rating, " +
                    "  CAST(m.text_reviews_count AS INT) AS Total_Reviews " +
                    "FROM oracle_books o " +
                    "LEFT JOIN mongo_books m ON o.isbn13 = m.isbn " + // <-- CHANGED TO LEFT JOIN
                    "ORDER BY Pages DESC"; // <-- Order by Pages since Rating might be null

            Dataset<Row> insightDf = spark.sql(sql);
            insightDf.write().mode("overwrite").saveAsTable("book_insights_view");
            // Print the final joined table to the IntelliJ Console
            insightDf.show(10);

            return "Query:Success check temp the view book_insights_view is there ";

        } catch (Exception e) {
            e.printStackTrace();
            return "Analytics Engine failed: " + e.getMessage();
        }

    }

    @GetMapping("/api/analytics/author-performance")
    public String getAuthorPerformance() {
        try {
            RestTemplate restTemplate = new RestTemplate();
            System.out.println("OLAP PROCESS FOR AUTHOR'S PERFORMANCE...");

            // ==========================================
            // 1. EXTRACT TABLES FROM ORACLE
            // ==========================================
            System.out.println("EXTRACT TABLE FROM ORACLE MICROSERVICE..");

            // Tabela: oracle_author
            String authorsJson = restTemplate.getForObject("http://localhost:8082/api/oracle/authors", String.class);
            Dataset<Row> authorsDf = spark.read().json(spark.createDataset(Collections.singletonList(authorsJson), Encoders.STRING()));
            authorsDf.createOrReplaceTempView("oracle_author");

            // Tabela: oracle_book_author
            String bookAuthorsJson = restTemplate.getForObject("http://localhost:8082/api/oracle/book_author", String.class);
            Dataset<Row> bookAuthorsDf = spark.read().json(spark.createDataset(Collections.singletonList(bookAuthorsJson), Encoders.STRING()));
            bookAuthorsDf.createOrReplaceTempView("oracle_book_author");

            // Tabela: oracle_book
            String booksJson = restTemplate.getForObject("http://localhost:8082/api/oracle/books", String.class);
            Dataset<Row> booksDf = spark.read().json(spark.createDataset(Collections.singletonList(booksJson), Encoders.STRING()));
            booksDf.createOrReplaceTempView("oracle_book");

            // Tabela: oracle_order_line
            String orderLinesJson = restTemplate.getForObject("http://localhost:8082/api/oracle/sales", String.class);
            Dataset<Row> orderLinesDf = spark.read().json(spark.createDataset(Collections.singletonList(orderLinesJson), Encoders.STRING()));
            orderLinesDf.createOrReplaceTempView("oracle_order_line");

            // ==========================================
            // 2. DATA FROM POSTGRESS
            // ==========================================
            System.out.println("SWAP data from Postgres...");

            // Tabela: pg_swapped_books
            String pgSwapsJson = restTemplate.getForObject("http://localhost:8081/api/pg/swapped-books", String.class);
            Dataset<Row> pgSwapsDf = spark.read().json(spark.createDataset(Collections.singletonList(pgSwapsJson), Encoders.STRING()));
            pgSwapsDf.createOrReplaceTempView("pg_swapped_books");

            // ==========================================
            // 3. Executing using SPARK
            // ==========================================
            System.out.println("Executing the SQL Script");

            String sql = "SELECT " +
                    "  a.authorName AS author_name, " + // Folosim authorName din JSON, dar îl redenumim pentru View-ul final
                    "  COUNT(DISTINCT b.bookId) AS local_book_count, " +
                    "  SUM(ol.price) AS total_revenue_generated, " +
                    "  MAX(CASE WHEN p.title IS NOT NULL THEN 'YES' ELSE 'NO' END) AS is_swapped_regularly " +
                    "FROM oracle_author a " +
                    "JOIN oracle_book_author ba ON a.authorId = ba.authorId " + // Corectat la authorId
                    "JOIN oracle_book b ON ba.bookId = b.bookId " + // Corectat la bookId
                    "LEFT JOIN oracle_order_line ol ON b.bookId = ol.bookId " + // Corectat la bookId
                    "LEFT JOIN pg_swapped_books p ON UPPER(TRIM(b.title)) = UPPER(TRIM(p.title)) " +
                    "GROUP BY a.authorName"; // Corectat la authorName

            Dataset<Row> insightDf = spark.sql(sql);

            //print first 20 rows
            insightDf.show();

            // save as view to be used in WEB and REACT
            System.out.println("Salvare rezultat în Thrift Server (v_author_global_performance)...");
            insightDf.write().mode("overwrite").saveAsTable("v_author_global_performance");

            return "Query:Success check temp the view v_author_global_performance";

        } catch (Exception e) {
            e.printStackTrace();
            return "Error " + e.getMessage();
        }
    }

    @GetMapping("/api/analytics/books-enriched")
    public String getBooksEnriched() {
        try {
            RestTemplate restTemplate = new RestTemplate();

            String booksJson = restTemplate.getForObject("http://localhost:8083/api/mongo/books", String.class);
            String seriesJson = restTemplate.getForObject("http://localhost:8083/api/mongo/series", String.class);

            Dataset<Row> booksDf = spark.read().json(spark.createDataset(Collections.singletonList(booksJson), Encoders.STRING()));
            Dataset<Row> seriesDf = spark.read().json(spark.createDataset(Collections.singletonList(seriesJson), Encoders.STRING()));

            booksDf.createOrReplaceTempView("v_mongo_books_10k");
            seriesDf.createOrReplaceTempView("v_mongo_series_2k");


            booksDf.printSchema();
            String sql = "SELECT " +
                    "  b.id AS book_id, " +
                    "  b.authors[0].title AS book_title, " +
                    "  s.title AS series_name, " +
                    "  CAST(s.series_works_count AS INT) AS series_works_count, " +
                    "  s.description AS series_description " +
                    "FROM v_mongo_books_10k b " +
                    "INNER JOIN v_mongo_series_2k s ON " +
                    "  UPPER(s.title) LIKE CONCAT('%', UPPER(b.authors[0].title), '%') " +
                    "  OR UPPER(b.authors[0].title) LIKE CONCAT('%', UPPER(s.title), '%')";

            Dataset<Row> enrichedDf = spark.sql(sql);

            // 3. Save  in Hive Metastore

            enrichedDf.write().mode("overwrite").saveAsTable("v_books_enriched");

            return "Enrichment Complete! View-ul 'v_books_enriched' a fost generat.";
        } catch (Exception e) {
            return "Eroare Enrichment: " + e.getMessage();
        }
    }

    //We redifine the endpoints to have the prefix ora_
    private void loadOracleSources() {
        System.out.println(">>> Start loading data from Oracle Microservice...");
        RestTemplate restTemplate = new RestTemplate();
        String oracleBaseUrl = "http://localhost:8082/api/oracle";

        // 1. Definim maparea tabelelor
        Map<String, String> endpointMap = new HashMap<>();
        endpointMap.put("ora_authors", "/authors");
        endpointMap.put("ora_book_author", "/book_author");
        endpointMap.put("ora_books", "/books");
        endpointMap.put("ora_sales", "/sales");
        endpointMap.put("ora_customer_orders", "/customer_orders");
        endpointMap.put("ora_address", "/address");
        endpointMap.put("ora_country", "/country");
        endpointMap.put("ora_publishers", "/publishers");


        endpointMap.forEach((viewName, path) -> {
            try {
                String json = restTemplate.getForObject(oracleBaseUrl + path, String.class);
                if (json != null && !json.isEmpty()) {
                    Dataset<Row> df = spark.read().json(
                            spark.createDataset(Collections.singletonList(json), Encoders.STRING())
                    );
                    df.createOrReplaceTempView(viewName);
                    System.out.println(" Table is available " + viewName);
                }
            } catch (Exception e) {
                System.err.println("Error at table " + viewName + ": " + e.getMessage());
            }
        });
        System.out.println(">>> All sources are completed ");
    }

    @GetMapping("/api/analytics/top-authors-country")
    public String getTopAuthorsByCountry() {
        try {
            //instead of using the endpoints we use the method created earlier
            loadOracleSources();


            String sql = "SELECT * FROM ( " +
                    "  SELECT " +
                    "    country_name, " +
                    "    author_name, " +
                    "    total_revenue, " +
                    "    ROUND((total_revenue / SUM(total_revenue) OVER (PARTITION BY country_name)) * 100, 2) as country_market_share, " +
                    "    DENSE_RANK() OVER (PARTITION BY country_name ORDER BY total_revenue DESC) as author_rank " +
                    "  FROM ( " +
                    "    SELECT " +
                    "      cn.countryName as country_name, " +
                    "      a.authorName as author_name, " +
                    "      SUM(ol.price) as total_revenue " +
                    "    FROM ora_authors a " +
                    "    JOIN ora_book_author ba ON a.authorId = ba.authorId " +
                    "    JOIN ora_books b ON b.bookId = cast(ba.bookId as long) " +
                    "    JOIN ora_sales ol ON b.bookId = ol.bookId " +
                    "    JOIN ora_customer_orders co ON ol.orderId = co.orderId " +
                    "    JOIN ora_address ad ON co.destAddressId = ad.AddressId " +
                    "    JOIN ora_country cn ON ad.countryID = cn.countryId " +
                    "    GROUP BY cn.countryName, a.authorName " +
                    "  ) " +
                    ") WHERE author_rank <= 10";

            Dataset<Row> resultDf = spark.sql(sql);

            // Save table
            resultDf.write().mode("overwrite").saveAsTable("olap_top_10_authors_by_country");

            // Debug: Show results in consol
            resultDf.show();

            return "Success, table  'olap_top_10_authors_by_country' visible in temp";

        } catch (Exception e) {
            e.printStackTrace();
            return "Eroare la procesarea analitică: " + e.getMessage();
        }
    }
    @GetMapping("/api/analytics/book-hierarchy")
    public String generateHierarchy() {
        try {
            loadOracleSources();
            String sql = "SELECT " +
                    "  CASE WHEN GROUPING(a.authorName) = 1 THEN '{TOTAL GENERAL}' " +
                    "       ELSE a.authorName END AS author, " +
                    "  CASE WHEN GROUPING(a.authorName) = 1 THEN '---' " +
                    "       WHEN GROUPING(b.title) = 1 THEN CONCAT('Subtotal: ', a.authorName) " +
                    "       ELSE b.title END AS bookTitle, " + // Acesta este alias-ul nou
                    "  COUNT(b.bookId) AS bookCount " +
                    "FROM ora_authors a " +
                    "JOIN ora_book_author ba ON a.authorId = ba.authorId " +
                    "JOIN ora_books b ON b.bookId = CAST(ba.bookId AS LONG) " +
                    "GROUP BY ROLLUP (a.authorName, b.title) " +
                    "ORDER BY author, bookTitle"; // MODIFICARE AICI: am scos b.title

            Dataset<Row> hierarchyDf = spark.sql(sql);
            hierarchyDf.write().mode("overwrite").saveAsTable("olap_book_hierarchy_perf");

            return "Ierarhia a fost generată cu succes!";
        } catch (Exception e) {
            return "Eroare Enrichment: " + e.getMessage();
        }
    }

    @GetMapping("/api/analytics/simple-catalog")
    public List<String> getSimpleCatalog() {
        // 1. Încărcăm datele proaspete din Oracle
        loadOracleSources();

        // 2. Executăm interogarea SparkSQL
        String sql = "SELECT b.title, a.authorName " +
                "FROM ora_books b " +
                "JOIN ora_book_author ba ON b.bookId = ba.bookId " +
                "JOIN ora_authors a ON ba.authorId = a.authorId " +
                "ORDER BY b.title";

        Dataset<Row> resultDf = spark.sql(sql);

        // 3. Returnăm rezultatul ca JSON pentru testare rapidă în browser
        return resultDf.toJSON().collectAsList();
    }

    @GetMapping("/api/analytics/publisher-distribution")
    public String generatePublisherDistribution() {
        loadOracleSources();

        String sql = "SELECT " +
                "  p.publisherName as publisherName, " + // Alias clar pentru JPA
                "  COUNT(b.bookId) AS numarCarti " +      // CamelCase pentru mapare usoara
                "FROM ora_publishers p " +
                "LEFT JOIN ora_books b ON p.publisherId = b.publisherId " +
                "GROUP BY p.publisherName " +
                "ORDER BY numarCarti DESC";

        Dataset<Row> resultDf = spark.sql(sql);

        // Salvăm rezultatul ca tabel pentru portul 8085
        resultDf.write().mode("overwrite").saveAsTable("olap_publisher_distribution");

        return "Distribuția pe edituri a fost procesată și salvată!";
    }

}