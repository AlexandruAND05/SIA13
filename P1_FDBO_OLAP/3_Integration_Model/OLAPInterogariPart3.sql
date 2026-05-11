


CREATE OR REPLACE VIEW v_author_global_performance AS
SELECT 
    a.author_name,
    COUNT(DISTINCT b.book_id) AS local_book_count,
    SUM(ol.price) AS total_revenue_generated,
    -- Use double quotes for "title" because it was created in lowercase
    MAX(CASE WHEN p."title" IS NOT NULL THEN 'YES' ELSE 'NO' END) AS is_swapped_regularly
FROM author a
JOIN book_author ba ON a.author_id = ba.author_id
JOIN book b ON ba.book_id = b.book_id
LEFT JOIN order_line ol ON b.book_id = ol.book_id
-- Use double quotes for the join condition as well
LEFT JOIN V_SWAPPED_BOOKS_PG p ON UPPER(TRIM(b.title)) = UPPER(TRIM(p."title"))
GROUP BY a.author_name;

SELECT * FROM v_author_global_performance  fETCH FIRST 10 ROWS ONLY  


----VIEW FROM WHAT SERIES THE BOOK MIGHT BE PART OF 
CREATE OR REPLACE VIEW V_BOOKS_ENRICHED AS
SELECT 
    b.BOOK_ID,
    b.TITLE AS BOOK_TITLE,
    s.TITLE AS SERIES_NAME,
    s.SERIES_WORKS_COUNT,
    s.DESCRIPTION AS SERIES_DESCRIPTION
FROM V_MONGO_BOOKS_10K b
INNER JOIN v_mongo_series_2k s 
    -- This matches if 'Sun Wolf' is found inside 'Sun   Wolf and Starhawk'
    ON s.TITLE LIKE '%' || b.TITLE || '%'
    OR b.TITLE LIKE '%' || s.TITLE || '%';
    
    select * from V_BOOKS_ENRICHED FETCH FIRST 10 ROWS ONLY 
    
    
    --WHICH BOOKS FROM JSON DATABASE  HAVE THE HIGHEST AVERAGE RATING
    CREATE OR REPLACE VIEW OLAP_FACTS_BOOK_PERFORMANCE AS
SELECT 
    BOOK_ID,
    COUNT(*) AS TOTAL_REVIEWS,
    AVG(RATING) AS AVG_RATING,
    COUNT(CASE WHEN HAS_SPOILER = 'true' THEN 1 END) AS SPOILER_COUNT
FROM V_MONGO_REVIEWS_10K
GROUP BY BOOK_ID
ORDER BY -AVG_RATING;
---
    SELECT * FROM OLAP_FACTS_BOOK_PERFORMANCE FETCH FIRST 100 ROWS ONLY 
-------------------------------------------------------------------------


CREATE OR REPLACE VIEW OLAP_TOP_10_AUTHORS_BY_COUNTRY AS
SELECT * FROM (
    SELECT 
        country_name,
        author_name,
        total_revenue,
        -- Market share within the country for context
        ROUND(RATIO_TO_REPORT(total_revenue) OVER (PARTITION BY country_name), 4) * 100 as country_market_share,
        -- Ranking: Identifies 1st, 2nd, 3rd, etc., per country
        DENSE_RANK() OVER (PARTITION BY country_name ORDER BY total_revenue DESC) as author_rank
    FROM (
        SELECT 
            cn.country_name,
            a.author_name,
            SUM(ol.price) as total_revenue
        FROM author a
        INNER JOIN book_author ba ON a.author_id = ba.author_id
        INNER JOIN book b          ON ba.book_id = b.book_id
        INNER JOIN order_line ol   ON b.book_id = ol.book_id
        INNER JOIN cust_order co   ON ol.order_id = co.order_id
        INNER JOIN address ad      ON co.dest_address_id = ad.address_id
        INNER JOIN country cn      ON ad.country_id = cn.country_id
        GROUP BY cn.country_name, a.author_name
    )
)
WHERE author_rank <= 10; -- The Top 10 Filter

select * from OLAP_TOP_10_AUTHORS_BY_COUNTRY 


-----------------------------------

CREATE OR REPLACE VIEW V_AUTHOR_SWAP_SUMMARY AS
SELECT 
    a.author_name,
    /* Aggregates the unique inventory count for each author */
    COUNT(DISTINCT b.book_id) AS total_books_owned,
    /* Quantify how often the author's books are swapped (from Postgres) */
    -- Note: Use the alias you defined in the Postgres view (e.g., "book_id")
    COUNT(DISTINCT s.book_id) AS swap_market_volume
FROM author a
JOIN book_author ba 
    ON a.author_id = ba.author_id
JOIN book b 
    ON ba.book_id = b.book_id
/* Establishes a cross-platform join */
LEFT JOIN v_swapped_books_pg s 
    -- Wrap "author" in double quotes because it's lowercase in the source view
    ON UPPER(TRIM(a.author_name)) = UPPER(TRIM(s."author"))
GROUP BY a.author_name;

-- 
SELECT * FROM V_AUTHOR_SWAP_SUMMARY;

--------------------------------------------------

CREATE OR REPLACE VIEW OLAP_VIEW_BOOK_HIERARCHY_PERF AS
SELECT 
  CASE
    WHEN GROUPING(A.AUTHOR_NAME) = 1 THEN '{GLOBAL TOTAL}'
    ELSE A.AUTHOR_NAME END AS AUTHOR,
  CASE 
    WHEN GROUPING(A.AUTHOR_NAME) = 1 THEN ' '
    WHEN GROUPING(B.TITLE) = 1 THEN 'Subtotal Author: ' || A.AUTHOR_NAME
    ELSE B.TITLE END AS BOOK_TITLE,
  -- Since we eliminated the Facts table, we count the number of books per author
  COUNT(B.BOOK_ID) AS BOOK_COUNT
FROM AUTHOR A
JOIN BOOK_AUTHOR BA ON A.AUTHOR_ID = BA.AUTHOR_ID   
JOIN BOOK B ON BA.BOOK_ID = B.BOOK_ID
GROUP BY ROLLUP (A.AUTHOR_NAME, B.TITLE)
ORDER BY A.AUTHOR_NAME, B.TITLE;

select * from OLAP_VIEW_BOOK_HIERARCHY_PERF fetch first 10 rows only;