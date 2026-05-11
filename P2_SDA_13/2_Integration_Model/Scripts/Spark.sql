-- 1. ANALIZA MARKET SHARE (TOP 10 AUTORI PER TARA)
CREATE OR REPLACE TABLE olap_top_10_authors_by_country AS
SELECT * FROM (
  SELECT 
    country_name, author_name, total_revenue,
    ROUND((total_revenue / SUM(total_revenue) OVER (PARTITION BY country_name)) * 100, 2) as country_market_share,
    DENSE_RANK() OVER (PARTITION BY country_name ORDER BY total_revenue DESC) as author_rank
  FROM (
    SELECT 
      cn.countryName as country_name, a.authorName as author_name, SUM(ol.price) as total_revenue
    FROM ora_authors a
    JOIN ora_book_author ba ON a.authorId = ba.authorId
    JOIN ora_books b ON b.bookId = cast(ba.bookId as long)
    JOIN ora_sales ol ON b.bookId = ol.bookId
    JOIN ora_customer_orders co ON ol.orderId = co.orderId
    JOIN ora_address ad ON co.destAddressId = ad.AddressId
    JOIN ora_country cn ON ad.countryID = cn.countryId
    GROUP BY cn.countryName, a.authorName
  )
) WHERE author_rank <= 10;

-- 2. IERARHIA DE INVENTAR (ROLLUP)
CREATE OR REPLACE TABLE olap_book_hierarchy_perf AS
SELECT 
  CASE WHEN GROUPING(a.authorName) = 1 THEN '{TOTAL GENERAL}' ELSE a.authorName END AS author,
  CASE WHEN GROUPING(a.authorName) = 1 THEN '---' 
       WHEN GROUPING(b.title) = 1 THEN CONCAT('Subtotal: ', a.authorName) 
       ELSE b.title END AS bookTitle,
  COUNT(b.bookId) AS bookCount
FROM ora_authors a
JOIN ora_book_author ba ON a.authorId = ba.authorId
JOIN ora_books b ON b.bookId = CAST(ba.bookId AS LONG)
GROUP BY ROLLUP (a.authorName, b.title);

-- 3. DISTRIBUTIA PE EDITURI (PARETO)
CREATE OR REPLACE TABLE olap_publisher_distribution AS
SELECT 
  p.publisherName as publisherName,
  COUNT(b.bookId) AS numarCarti
FROM ora_publishers p
LEFT JOIN ora_books b ON p.publisherId = b.publisherId
GROUP BY p.publisherName;

-- 4. ENRICHMENT FEDERAT (ORACLE + MONGO + POSTGRES)
CREATE OR REPLACE TABLE v_author_global_performance AS
SELECT 
  a.authorName AS author_name,
  COUNT(DISTINCT b.bookId) AS local_book_count,
  SUM(ol.price) AS total_revenue_generated,
  MAX(CASE WHEN p.title IS NOT NULL THEN 'YES' ELSE 'NO' END) AS is_swapped_regularly
FROM ora_authors a
JOIN ora_book_author ba ON a.authorId = ba.authorId
JOIN ora_books b ON ba.bookId = b.bookId
LEFT JOIN ora_sales ol ON b.bookId = ol.bookId
LEFT JOIN pg_swapped_books p ON UPPER(TRIM(b.title)) = UPPER(TRIM(p.title))
GROUP BY a.authorName;

-- 5.Books and authors

SELECT b.title, a.authorName " +
                "FROM ora_books b " +
                "JOIN ora_book_author ba ON b.bookId = ba.bookId " +
                "JOIN ora_authors a ON ba.authorId = a.authorId " +
                "ORDER BY b.title
				
-- 5.Count books by publisher
SELECT " +
                "  p.publisherName as publisherName, " + // Alias clar pentru JPA
                "  COUNT(b.bookId) AS numarCarti " +      // CamelCase pentru mapare usoara
                "FROM ora_publishers p " +
                "LEFT JOIN ora_books b ON p.publisherId = b.publisherId " +
                "GROUP BY p.publisherName " +
                "ORDER BY numarCarti DESC"				