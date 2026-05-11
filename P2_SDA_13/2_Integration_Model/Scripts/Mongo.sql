System.out.println("Fetching MongoDB Data...");
            String mongoUrl = "http://localhost:8083/api/mongo/books";
            String mongoJson = restTemplate.getForObject(mongoUrl, String.class);

            Dataset<Row> mongoDf = spark.read().json(
                    spark.createDataset(Collections.singletonList(mongoJson), Encoders.STRING())
            );
            // Register as a temporary SQL table
            mongoDf.createOrReplaceTempView("mongo_books");
			
			 String booksJson = restTemplate.getForObject("http://localhost:8083/api/mongo/books", String.class);
            String seriesJson = restTemplate.getForObject("http://localhost:8083/api/mongo/series", String.class);

            Dataset<Row> booksDf = spark.read().json(spark.createDataset(Collections.singletonList(booksJson), Encoders.STRING()));
            Dataset<Row> seriesDf = spark.read().json(spark.createDataset(Collections.singletonList(seriesJson), Encoders.STRING()));

            booksDf.createOrReplaceTempView("v_mongo_books_10k");
            seriesDf.createOrReplaceTempView("v_mongo_series_2k");