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