BEGIN
  -- 1. Enable the View from Postgres/Oracle
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => 'GRAVITY',
    p_object         => 'V_AUTHOR_SWAP_SUMMARY',
    p_object_type    => 'VIEW',
    p_object_alias   => 'author_summary'
  );

  -- 2. Enable the OLAP Hierarchy View
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => 'GRAVITY',
    p_object         => 'OLAP_VIEW_BOOK_HIERARCHY_PERF',
    p_object_type    => 'VIEW',
    p_object_alias   => 'hierarchy'
  );

  -- 3. Enable the MongoDB View
  ORDS.ENABLE_OBJECT(
    p_enabled        => TRUE,
    p_schema         => 'GRAVITY',
    p_object         => 'BOOKS_MONGO_V',
    p_object_type    => 'VIEW',
    p_object_alias   => 'mongo_books'
  );

  COMMIT;
END;
/

SELECT parsing_schema, object_name, type, status, uri_prefix
FROM user_ords_enabled_objects;