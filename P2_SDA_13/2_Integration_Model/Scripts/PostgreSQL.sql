String pgSwapsJson = restTemplate.getForObject("http://localhost:8081/api/pg/swapped-books", String.class);
            Dataset<Row> pgSwapsDf = spark.read().json(spark.createDataset(Collections.singletonList(pgSwapsJson), Encoders.STRING()));
            pgSwapsDf.createOrReplaceTempView("pg_swapped_books");