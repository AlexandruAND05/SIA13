--Function that creates the  connection between the restheart(mongodb) and the OracleDB(SQL Developer)

create or replace FUNCTION get_restheart_data_media(pURL VARCHAR2, pUserPass VARCHAR2) 
RETURN CLOB IS
  l_req    UTL_HTTP.req;
  l_resp   UTL_HTTP.resp;
  l_buffer CLOB; 
BEGIN
  l_req  := UTL_HTTP.begin_request(pURL);

  -- This line sends the "admin:secret" password RESTHeart is asking for
  UTL_HTTP.set_header(l_req, 'Authorization', 'Basic ' || 
    UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_I18N.string_to_raw(pUserPass, 'AL32UTF8')))); 

  l_resp := UTL_HTTP.get_response(l_req);
  UTL_HTTP.read_text(l_resp, l_buffer);
  UTL_HTTP.end_response(l_resp);

  RETURN l_buffer;
EXCEPTION
  WHEN OTHERS THEN
    RETURN 'Error: ' || SQLERRM;
END;

-- Access View for MongoDB: Goodreads Metadata
CREATE OR REPLACE VIEW v_mongo_metadata AS
SELECT *
FROM JSON_TABLE(
    -- Accessing RESTHeart with a safety limit of 100 records
    get_restheart_data_media(
        'http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=100', 
        'admin:secret'
    ), 
    '$[*]' 
    COLUMNS (
        mongo_book_id    NUMBER         PATH '$.book_id',
        title            VARCHAR2(500)  PATH '$.title',
        avg_rating       NUMBER         PATH '$.average_rating',
        publisher        VARCHAR2(200)  PATH '$.publisher',
        country_code     VARCHAR2(10)   PATH '$.country_code',
        popular_shelves  FORMAT JSON    PATH '$.popular_shelves'
    )
);
select * from v_mongo_metadata

CREATE OR REPLACE VIEW v_mongo_reviews AS
SELECT *
FROM JSON_TABLE(
    -- Fetching the reviews collection from MongoDB
    get_restheart_data_media(
        'http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=100', 
        'admin:secret'
    ), 
    '$[*]' 
    COLUMNS (
        mongo_book_id    NUMBER         PATH '$.book_id',
        user_id          VARCHAR2(100)  PATH '$.user_id',
        review_rating    NUMBER         PATH '$.rating',
        has_spoilers     VARCHAR2(10)   PATH '$.has_spoiler',
        review_text      CLOB           PATH '$.review_text'
    )
);

COMMENT ON TABLE v_mongo_reviews IS 'Access view for MongoDB spoiler reviews via RESTHeart';

-- Create View 
CREATE OR REPLACE VIEW v_mongo_reviews_100k AS
SELECT *
FROM JSON_TABLE(
    get_restheart_data_media(
        -- We only pull the fields we need to save memory
        'http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=100000&keys={"book_id":1,"user_id":1,"rating":1,"has_spoiler":1,"review_sentences":1,"_id":0}', 
        'admin:secret'
    ), 
    '$[*]' 
    COLUMNS (
        mongo_book_id    VARCHAR2(50)   PATH '$.book_id',
        user_id          VARCHAR2(100)  PATH '$.user_id',
        review_rating    NUMBER         PATH '$.rating',
        has_spoilers     VARCHAR2(10)   PATH '$.has_spoiler',
        -- This is the magic part: it flattens the array of sentences
        NESTED PATH '$.review_sentences[*]'
        COLUMNS (
            sentence     VARCHAR2(4000) PATH '$'
        )
    )
);

--  
SET DEFINE OFF; -- Crucial to prevent the "Enter value for keys" popup

 
 
CREATE OR REPLACE VIEW v_mongo_books_10k AS
-- Page 1 (0 to 1000)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page=1&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))
UNION ALL
-- Page 2 (1001 to 2000)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page=2&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))
UNION ALL
-- Page 3)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page=3&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))
UNION ALL
-- Page 4)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page=4&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))

UNION ALL
-- Page 5)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page=5&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))

UNION ALL
-- Page 6)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page=6&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))

UNION ALL
-- Page 7)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page7&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))

UNION ALL
-- Page 8)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page=8&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))
UNION ALL
-- Page 9)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page=9&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))
UNION ALL
-- Page 10)
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreadsbooks?pagesize=1000&page=10&keys=%7B%22title%22:1,%22book_id%22:1,%22average_rating%22:1,%22publisher%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' COLUMNS (book_id NUMBER PATH '$.book_id', title VARCHAR2(500) PATH '$.title', avg_rating NUMBER PATH '$.average_rating', publisher VARCHAR2(200) PATH '$.publisher'))




SELECT * FROM  v_mongo_books_10k FETCH FIRST 1000 ROWS ONLY;


-- Select 10k reviews 
SET DEFINE OFF;

CREATE OR REPLACE VIEW v_mongo_reviews_10k AS
-- Page 1
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=1&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')))
UNION ALL
-- Page 2
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=2&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')))
UNION ALL
-- Page 3
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=3&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')))
UNION ALL
-- Page 4
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=4&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')))
UNION ALL
-- Page 5
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=5&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')))
UNION ALL
-- Page 6
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=6&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')))
UNION ALL
-- Page 7
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=7&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')))
UNION ALL
-- Page 8
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=8&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')))
UNION ALL
-- Page 9
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=9&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')))
UNION ALL
-- Page 10
SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=10&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
COLUMNS (book_id VARCHAR2(50) PATH '$.book_id', user_id VARCHAR2(100) PATH '$.user_id', rating NUMBER PATH '$.rating', has_spoiler VARCHAR2(10) PATH '$.has_spoiler', NESTED PATH '$.review_sentences[*]' COLUMNS (sentence VARCHAR2(4000) PATH '$')));


SET DEFINE OFF;

CREATE OR REPLACE VIEW v_mongo_reviews_10k AS
WITH raw_data AS (
    -- PAGE 1
    SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=1&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
    COLUMNS (
        book_id VARCHAR2(50) PATH '$.book_id', 
        user_id VARCHAR2(100) PATH '$.user_id', 
        rating NUMBER PATH '$.rating', 
        has_spoiler VARCHAR2(10) PATH '$.has_spoiler', 
        NESTED PATH '$.review_sentences[*]' COLUMNS (
            sentence VARCHAR2(4000) PATH '$[1]' -- < FIX IS HERE ($[1] instead of $)
        )
    ))
    UNION ALL
    -- PAGE 2 (Repeat this pattern for all 10 pages)
    SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=2&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
    COLUMNS (
        book_id VARCHAR2(50) PATH '$.book_id', 
        user_id VARCHAR2(100) PATH '$.user_id', 
        rating NUMBER PATH '$.rating', 
        has_spoiler VARCHAR2(10) PATH '$.has_spoiler', 
        NESTED PATH '$.review_sentences[*]' COLUMNS (
            sentence VARCHAR2(4000) PATH '$[1]' 
        )
    ))
    UNION ALL
    -- PAGE 4
    SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=4&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
    COLUMNS (
        book_id VARCHAR2(50) PATH '$.book_id', 
        user_id VARCHAR2(100) PATH '$.user_id', 
        rating NUMBER PATH '$.rating', 
        has_spoiler VARCHAR2(10) PATH '$.has_spoiler', 
        NESTED PATH '$.review_sentences[*]' COLUMNS (
            sentence VARCHAR2(4000) PATH '$[1]' 
        )
    ))
    UNION ALL
    -- PAGE 5
    SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=5&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
    COLUMNS (
        book_id VARCHAR2(50) PATH '$.book_id', 
        user_id VARCHAR2(100) PATH '$.user_id', 
        rating NUMBER PATH '$.rating', 
        has_spoiler VARCHAR2(10) PATH '$.has_spoiler', 
        NESTED PATH '$.review_sentences[*]' COLUMNS (
            sentence VARCHAR2(4000) PATH '$[1]' 
        )
    ))
    UNION ALL
    -- PAGE 6
    SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=6&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
    COLUMNS (
        book_id VARCHAR2(50) PATH '$.book_id', 
        user_id VARCHAR2(100) PATH '$.user_id', 
        rating NUMBER PATH '$.rating', 
        has_spoiler VARCHAR2(10) PATH '$.has_spoiler', 
        NESTED PATH '$.review_sentences[*]' COLUMNS (
            sentence VARCHAR2(4000) PATH '$[1]' 
        )
    ))
    UNION ALL
    -- PAGE 7
    SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=7&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
    COLUMNS (
        book_id VARCHAR2(50) PATH '$.book_id', 
        user_id VARCHAR2(100) PATH '$.user_id', 
        rating NUMBER PATH '$.rating', 
        has_spoiler VARCHAR2(10) PATH '$.has_spoiler', 
        NESTED PATH '$.review_sentences[*]' COLUMNS (
            sentence VARCHAR2(4000) PATH '$[1]' 
        )
    ))
    UNION ALL
    -- PAGE 8
    SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=8&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
    COLUMNS (
        book_id VARCHAR2(50) PATH '$.book_id', 
        user_id VARCHAR2(100) PATH '$.user_id', 
        rating NUMBER PATH '$.rating', 
        has_spoiler VARCHAR2(10) PATH '$.has_spoiler', 
        NESTED PATH '$.review_sentences[*]' COLUMNS (
            sentence VARCHAR2(4000) PATH '$[1]' 
        )
    ))
    UNION ALL
    -- PAGE 9
    SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=9&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
    COLUMNS (
        book_id VARCHAR2(50) PATH '$.book_id', 
        user_id VARCHAR2(100) PATH '$.user_id', 
        rating NUMBER PATH '$.rating', 
        has_spoiler VARCHAR2(10) PATH '$.has_spoiler', 
        NESTED PATH '$.review_sentences[*]' COLUMNS (
            sentence VARCHAR2(4000) PATH '$[1]' 
        )
    ))
    UNION ALL
    -- PAGE 10
    SELECT * FROM JSON_TABLE(get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/goodreads_reviews_spoiler?pagesize=1000&page=10&keys=%7B%22book_id%22:1,%22user_id%22:1,%22rating%22:1,%22has_spoiler%22:1,%22review_sentences%22:1,%22_id%22:0%7D', 'admin:secret'), '$[*]' 
    COLUMNS (
        book_id VARCHAR2(50) PATH '$.book_id', 
        user_id VARCHAR2(100) PATH '$.user_id', 
        rating NUMBER PATH '$.rating', 
        has_spoiler VARCHAR2(10) PATH '$.has_spoiler', 
        NESTED PATH '$.review_sentences[*]' COLUMNS (
            sentence VARCHAR2(4000) PATH '$[1]' 
        )
    ))
   
)



SELECT book_id, user_id, rating, has_spoiler, sentence
FROM (
    SELECT 
        r.*, 
        ROW_NUMBER() OVER (PARTITION BY book_id ORDER BY user_id) as review_rank
    FROM raw_data r
    WHERE sentence IS NOT NULL -- Filters out any empty sentences
)
WHERE review_rank <= 3; -- Limits results to 3 reviews per book
--check
select * from V_MONGO_REVIEWS_10K ;


--series
CREATE OR REPLACE VIEW v_mongo_series_2k AS
( 
    SELECT * FROM JSON_TABLE(
        get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/series?pagesize=1000&page=1', 'admin:secret'), 
        '$[*]' 
        COLUMNS (
            series_id          VARCHAR2(50)  PATH '$.series_id',
            title              VARCHAR2(255) PATH '$.title',
            series_works_count NUMBER        PATH '$.series_works_count',
            primary_work_count NUMBER        PATH '$.primary_work_count',
            numbered           VARCHAR2(10)  PATH '$.numbered',
            note               VARCHAR2(1000) PATH '$.note',
            description        VARCHAR2(4000) PATH '$.description'
        )   
    )
    UNION ALL
    SELECT * FROM JSON_TABLE(
        get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/series?pagesize=1000&page=2', 'admin:secret'), 
        '$[*]' 
        COLUMNS (
            series_id          VARCHAR2(50)  PATH '$.series_id',
            title              VARCHAR2(255) PATH '$.title',
            series_works_count NUMBER        PATH '$.series_works_count',
            primary_work_count NUMBER        PATH '$.primary_work_count',
            numbered           VARCHAR2(10)  PATH '$.numbered',
            note               VARCHAR2(1000) PATH '$.note',
            description        VARCHAR2(4000) PATH '$.description'
        )   
    )
    UNION ALL
    SELECT * FROM JSON_TABLE(
        get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/series?pagesize=1000&page=3', 'admin:secret'), 
        '$[*]' 
        COLUMNS (
            series_id          VARCHAR2(50)  PATH '$.series_id',
            title              VARCHAR2(255) PATH '$.title',
            series_works_count NUMBER        PATH '$.series_works_count',
            primary_work_count NUMBER        PATH '$.primary_work_count',
            numbered           VARCHAR2(10)  PATH '$.numbered',
            note               VARCHAR2(1000) PATH '$.note',
            description        VARCHAR2(4000) PATH '$.description'
        )   
    )
    UNION ALL
    SELECT * FROM JSON_TABLE(
        get_restheart_data_media('http://127.0.0.1:8081/Books_JSON/series?pagesize=1000&page=4', 'admin:secret'), 
        '$[*]' 
        COLUMNS (
            series_id          VARCHAR2(50)  PATH '$.series_id',
            title              VARCHAR2(255) PATH '$.title',
            series_works_count NUMBER        PATH '$.series_works_count',
            primary_work_count NUMBER        PATH '$.primary_work_count',
            numbered           VARCHAR2(10)  PATH '$.numbered',
            note               VARCHAR2(1000) PATH '$.note',
            description        VARCHAR2(4000) PATH '$.description'
        )   
    )
); 

--Check series 
select * from v_mongo_series_2k  FETCH FIRST 1000 ROWS ONLY