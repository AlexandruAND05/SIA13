- Invocare date din DSA_SQL_Oracle (Port 8082)
CREATE OR REPLACE TEMPORARY VIEW ora_authors
USING org.apache.spark.sql.json
OPTIONS (path "http://localhost:8082/api/oracle/authors");

CREATE OR REPLACE TEMPORARY VIEW ora_books
USING org.apache.spark.sql.json
OPTIONS (path "http://localhost:8082/api/oracle/books");

CREATE OR REPLACE TEMPORARY VIEW ora_book_author
USING org.apache.spark.sql.json
OPTIONS (path "http://localhost:8082/api/oracle/book_author");

CREATE OR REPLACE TEMPORARY VIEW ora_sales
USING org.apache.spark.sql.json
OPTIONS (path "http://localhost:8082/api/oracle/sales");

CREATE OR REPLACE TEMPORARY VIEW ora_customer_orders
USING org.apache.spark.sql.json
OPTIONS (path "http://localhost:8082/api/oracle/customer_orders");

CREATE OR REPLACE TEMPORARY VIEW ora_address
USING org.apache.spark.sql.json
OPTIONS (path "http://localhost:8082/api/oracle/address");

CREATE OR REPLACE TEMPORARY VIEW ora_country
USING org.apache.spark.sql.json
OPTIONS (path "http://localhost:8082/api/oracle/country");

CREATE OR REPLACE TEMPORARY VIEW ora_publishers
USING org.apache.spark.sql.json
OPTIONS (path "http://localhost:8082/api/oracle/publishers");