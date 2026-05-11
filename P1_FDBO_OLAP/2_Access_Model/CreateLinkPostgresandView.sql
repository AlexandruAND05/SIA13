-- Creare link către Postgres (necesită configurare preralabilă în tnsnames.ora și gateway)
CREATE DATABASE LINK PG_BRIDGE CONNECT TO "postgres_user" IDENTIFIED BY "password" USING 'dg4odbc';

    -- Definire View de mediere (gestionare case-sensitivity Postgres)
CREATE OR REPLACE VIEW V_SWAPPED_BOOKS_PG AS
SELECT 
    "id" AS book_id,
    "title",
    "author",
    "genre",
    "language",
    "publication_year",
    "publisher",
    "rating_average",
    "isbn",
    "bestseller_status",
    "adapted_to_movie"
FROM "top_1000_most_swapped_books"@PG_BRIDGE;