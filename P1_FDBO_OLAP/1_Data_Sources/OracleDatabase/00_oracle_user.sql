-- 1. Move into your specific project "room"
ALTER SESSION SET CONTAINER = XEPDB1;

-- 2. Create the user (no C## needed here!)
CREATE USER gravity IDENTIFIED BY mypassword;

-- 3. Give the user administrative power for your project
GRANT CONNECT, RESOURCE, DBA TO gravity;

-- 4. Ensure the user can actually store data
GRANT UNLIMITED TABLESPACE TO gravity;